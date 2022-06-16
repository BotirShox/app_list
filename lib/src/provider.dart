import 'package:api_list/model/events_model.dart';
import 'package:sqflite/sqflite.dart';

class Provider {

  static Database _database;
  static final Provider db = Provider._();
  Provider._();

  Future<Database> get database async {

    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {

    final String path ='event_manager.db';
    print('Insert database to: \n $path');
    return openDatabase(path, version: 1, onOpen: (db) {
      print("is open $db");
      },
        onCreate: (Database db, int version) {
          print('Table is created in : \n $path');
         return db.execute('CREATE TABLE Event(id INTEGER PRIMARY KEY, url TEXT, endDate TEXT, name TEXT, icon TEXT)');
    });
  }

  createEvents(Events newEvent) async {

    await deleteAllEvents();
    final Database db = await database;
    final res = await db.insert('Event', newEvent.toJson());
    print("Inserting data: \n $res");
    return res;
  }

  Future<int> deleteAllEvents() async {

    final db = await database;
    final res = await db.rawDelete('DELETE FROM Event');
    return res;
  }

  Future<List<Events>> getAllEvents() async {

    final db = await database;
    final res = await db.rawQuery('SELECT * FROM Event');
    List<Events> list = res.isNotEmpty ? res.map((c) => Events.fromJson(c)).toList() : [];
    return list;
  }
}