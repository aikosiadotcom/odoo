import 'dart:async';
import 'dart:convert';

import 'package:universal_io/io.dart';
import 'package:yao_core/yao_core.dart';

import 'model/connection.dart';
import 'model/credential.dart';
import 'model/user_logged_in.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import 'model/session.dart';

enum _OdooMethod { create, read, update, delete }

const _uuid = Uuid();

abstract class IDatabaseOperation {
  Future<int> insert(String tableName, Map<String, dynamic> args);
  Future<bool> update(String tableName, int id, Map<String, dynamic> args);
  Future<bool> delete(String tableName, int id);
  Future<List<dynamic>> query(
      {required String from,
      List<String> select = const [],
      List<dynamic> where = const [],
      String orderBy = "",
      int offset = 0,
      bool count = false,
      int limit = 50});
  Future<Map<String, dynamic>?> read(String tableName, int id,
      [List<String> columns = const []]);
}

abstract class IConnection {
  SessionController get session;
  Future<UserLoggedIn> connect(Credential credential);
  void disconnect();
}

class SessionController {
  final Dio _dio;
  final _controller = StreamController<Session?>();
  Stream<Session?> get stream => _controller.stream;
  String? get id => _id;
  bool get isNull => !_authenticated;
  String? _id;
  bool _authenticated = false;

  SessionController(this._dio);

  void update(Session? session) {
    _dio.options.headers["Cookie"] = "session_id=${session?.id}";
    _controller.add(session);
    if (session != null) {
      _id = session.id;
      _authenticated = true;
    } else {
      _id = null;
      _authenticated = false;
    }
  }
}

class YaoOdooService extends YaoService
    implements IDatabaseOperation, IConnection {
  final Connection connection;
  late final Dio _dio;
  late final SessionController session;

  YaoOdooService(this.connection) {
    this._dio = Dio(BaseOptions(baseUrl: connection.url.toString()));
    this.session = SessionController(_dio);
  }

  Future<UserLoggedIn> connect(Credential credential) async {
    try {
      Response resp = await _dio.post("/web/session/authenticate",
          data: _withDefaultParams({
            "db": connection.db,
            "login": credential.username,
            "password": credential.password
          }));
      Map<String, dynamic> _resp = _transformResponse(resp);

      if (resp.headers['set-cookie'] == null) {
        throw Exception(
            "header 'set-cookie' tidak ditemukan. Saat ini tidak bisa running di web, karena https://github.com/flutterchina/dio/issues/1027");
      }
      String sessionId = _getSessionId(resp.headers['set-cookie']!.first);
      UserLoggedIn _user = UserLoggedIn.fromJson(_resp);

      session.update(Session(sessionId, _user));

      return UserLoggedIn.fromJson(_resp);
    } catch (e) {
      if (e is DioError) {
        throw Exception(this._transformDioError(e));
      }

      throw e;
    }
  }

  Future<dynamic> _crud(String tableName, _OdooMethod method, dynamic args,
      [dynamic kwargs]) async {
    try {
      String _method = "";
      if (method == _OdooMethod.delete) {
        _method = "unlink";
      } else if (method == _OdooMethod.update) {
        _method = "write";
      } else if (method == _OdooMethod.create) {
        _method = "create";
      } else if (method == _OdooMethod.read) {
        _method = "read";
      }

      Response resp = await _dio.post("/web/dataset/call_kw",
          data: _withDefaultParams({
            "args": args,
            "kwargs": {"context": {}},
            "method": _method,
            "model": tableName
          }));

      return _transformResponse(resp);
    } catch (e) {
      if (e is DioError) {
        throw Exception(this._transformDioError(e));
      }

      throw e;
    }
  }

  Future<int> insert(String tableName, Map<String, dynamic> args) async {
    int resp = await _crud(tableName, _OdooMethod.create, [args]);
    return resp;
  }

  Future<Map<String, dynamic>?> read(String tableName, int id,
      [List<String> columns = const []]) async {
    List resp = await _crud(tableName, _OdooMethod.read, [
      [id],
      columns
    ]) as List;

    if (resp.isEmpty) {
      return null;
    }

    return resp[0];
  }

  Future<bool> update(
      String tableName, int id, Map<String, dynamic> args) async {
    bool resp = await _crud(tableName, _OdooMethod.update, [
      [id],
      args
    ]);

    return resp;
  }

  Future<bool> delete(String tableName, int id) async {
    bool resp = await _crud(tableName, _OdooMethod.delete, [
      [id]
    ]);

    return resp;
  }

  Future<List<dynamic>> query(
      {required String from,
      List<String> select = const [],
      List<dynamic> where = const [],
      String orderBy = "",
      int offset = 0,
      bool count = false,
      int limit = 50}) async {
    final resp =
        _transformResponseQuery(await _dio.post("/web/dataset/search_read",
            data: _withDefaultParams({
              "context": {},
              "domain": where,
              "fields": select,
              "limit": limit,
              "model": from,
              "sort": orderBy,
              "offset": offset,
              "count": count
            })));
    return resp;
  }

  List _transformResponseQuery(Response resp) {
    Map<String, dynamic> _resp = _transformResponse(resp);
    if (_resp['length'] == 0) {
      return [];
    }

    return _resp['records'];
  }

  dynamic _transformResponse(Response resp) {
    if (resp.statusCode != 200) {
      throw Exception(resp.statusMessage);
    }

    Map _resp = jsonDecode(resp.toString());
    if (_resp.containsKey("error")) {
      if (_resp["error"]["data"]["name"] == "odoo.exceptions.AccessDenied") {
        throw Exception("username or password wrong");
      } else if (_resp["error"]["data"]["name"] ==
          "odoo.http.SessionExpiredException") {
        session.update(null);
        throw Exception("Session expired");
      }
      throw Exception(_resp['error'].toString());
    }

    return _resp['result'];
  }

  Map<String, dynamic> _withDefaultParams(Map<String, dynamic> params) {
    return {
      "id": _uuid.v4(),
      "jsonrpc": "2.0",
      "method": "call",
      "params": params
    };
  }

  String _getSessionId(String cookies) {
    return (Cookie.fromSetCookieValue(cookies)).value;
  }

  void disconnect() {
    session.update(null);
  }

  String _transformDioError(DioError e) {
    return e.message;
  }

  @override
  Future<YaoOdooService> run() async {
    return this;
  }
}
