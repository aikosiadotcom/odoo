# Odoo

odoo api using endpoint /web/dataset/call_kw

# Usage

## Initialize

```
import 'package:odoo/odoo.dart';
final odoo = Odoo(Connection(url: Url(Protocol.http, "localhost", 8069), db: 'odoo'));
```
## Connection Operation

### Connect

```
UserLoggedIn user = await odoo.connect(Credential("admin", "admin"));
```

### Disconnect

```
await odoo.disconnect();
```

### Session Change
```
odoo.session.stream.listen((Session? session) {
    print('session changed ${session?.toJson()}');
});
```

## Database Operation

### Insert

```
String tableName = "res.users";
Map<String,dynamic> args = {"login":"tester",name:"tester"};
await odoo.insert(tableName, args);
```

### Update

```
String tableName = "res.users";
int id = 999;
Map<String,dynamic> args = {"login":"tester",name:"tester"};
await odoo.update(tableName, id, args);
```

### Delete

```
String tableName = "res.users";
int id = 999;
await odoo.delete(tableName, id);
```

### Query

```
String from = "res.users";
List<String> select = ["id","login","name"];
List<dynamic> where = ["id","=",999];
String orderBy = "login ASC";
await odoo.query(from: from, select: select, where: where, orderBy: orderBy, limit: 10, offset: 0);
```

### Read

```
String tableName = "res.users";
int id = 999;
await odoo.read(tableName,id);
```

# Developer

Before publish to pub.dev, make sure you run following command:

```
#generate model file
flutter pub run build_runner build 

#testing
flutter test 
```

and dont forget to uncomment #Generate File at .gitignore