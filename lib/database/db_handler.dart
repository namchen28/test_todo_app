import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_test/model/todo_model.dart';

class DBhelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'TodoApp.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    await db.execute(
      "CREATE TABLE todotest(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, duedate TEXT NOT NULL, status INTEGER )",
    );
  }

  Future<ToDoModel> insert(ToDoModel toDoModel) async {
    var dbClient = await db;
    await dbClient?.insert('todotest', toDoModel.toMap());
    return toDoModel;
  }

  Future<List<ToDoModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> QueryResult =
        await _db!.rawQuery('SELECT * FROM todotest');
    return QueryResult.map((e) => ToDoModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('todotest', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(ToDoModel toDoModel) async {
    var dbClient = await db;
    bool statusInt = toDoModel.status!;
    return await dbClient!.update(
      'todotest',
      {
        'title': toDoModel.title,
        'description': toDoModel.description,
        'duedate': toDoModel.dueDate,
        'status': statusInt,
      },
      where: 'id = ?',
      whereArgs: [toDoModel.id],
    );
  }
}
