import 'package:flutter_test/flutter_test.dart';
import 'package:odoo/odoo.dart';

Future<UserLoggedIn> connect(Odoo odoo) async {
  return await odoo.connect(Credential("admin", "admin"));
}

void main() async {
  final odoo =
      Odoo(Connection(url: Url(Protocol.http, "localhost", 8069), db: 'odoo'));
  odoo.session.stream.listen((event) {
    print('session changed ${event?.toJson()}');
  });

  test("query", () async {
    await connect(odoo);
    final tmp = await odoo.query(
        from: "res.users",
        select: ["id", "name"],
        where: [
          "|",
          ["id", "=", 7],
          ["id", "=", 6]
        ],
        orderBy: "id desc",
        limit: 10);
    print(tmp);
  });

  group("complete", () {
    late final id;
    final String tableName = "res.users";
    final Map<String, dynamic> args = {"login": "tester", "name": "tester"};

    test('connect', () async {
      final user = await connect(odoo);
      expect(user.uid, equals(2));
    });

    test('create', () async {
      id = await odoo.insert(tableName, args);
      print("created id : $id");
      expect(id, isNonNegative);
    });

    test('read', () async {
      final res = await odoo.read(tableName, id);
      expect(res, isNotNull);
    });

    test('read - certain fields', () async {
      bool isSuccess = false;
      final res = await odoo.read(tableName, id, ["id"]);
      // print(res);
      isSuccess = res!["id"] == id;
      expect(isSuccess, isTrue);
    });

    test('update', () async {
      final res = await odoo.update(tableName, id, args);
      expect(res, isTrue);
    });

    test('delete', () async {
      bool isSuccess = false;
      final res = await odoo.delete(tableName, id);
      if (res == true) {
        isSuccess = await odoo.read(tableName, id) == null;
      }
      expect(isSuccess, isTrue);
    });

    test('disconnect', () async {
      odoo.disconnect();
      try {
        await odoo.insert(tableName, args);
      } catch (err) {
        expect(err.toString(), contains("Session expired"));
      }
    });
  });
}
