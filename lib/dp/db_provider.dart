import 'package:daily_task_list_app/model/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../model/task_model.dart';

class DBProvider {
  DBProvider._(); //constructor class
  static final DBProvider dataBase = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'daily_task_dp.db'),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, creationDate TEXT )
          ''');
    }, version: 1);
  }

  addNewTask(Task newTask) async {
    final db = await database;

    db.insert("tasks", newTask.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
 
  Future<dynamic> getTask() async {
    final db = await database;
    var res = await db.query("tasks");
    if (res.length == 0) {
      return Null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }
}
