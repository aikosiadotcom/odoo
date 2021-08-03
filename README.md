# Odoo

odoo api using endpoint /web/dataset/call_kw

# Usage

## initialize

```
import 'package:odoo/odoo.dart';
final odoo = Odoo(Connection(url: Url(Protocol.http, "localhost", 8069), db: 'odoo'));
```

## insert

insert new record

```
String tableName = "res.users";
Map<String,dynamic> args = {"login":"tester",name:"tester"};
await odoo.insert(tableName, args);
```

## update

update record by id

```
String tableName = "res.users";
int id = 999;
Map<String,dynamic> args = {"login":"tester",name:"tester"};
await odoo.update(tableName, id, args);
```

## delete

delete record by id

```
String tableName = "res.users";
int id = 999;
await odoo.delete(tableName, id);
```

## query

query record
```
String from = "res.users";
List<String> select = ["id","login","name"];
List<dynamic> where = ["id","=",999];
String orderBy = "login ASC";
await odoo.query(from: from, select: select, where: where, orderBy: orderBy, limit: 10, offset: 0);
```

# Developer

Before publish to pub.dev, make sure you run following command:

#generate model file
flutter pub run build_runner build 

#testing
flutter test 