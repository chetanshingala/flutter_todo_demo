import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_todo_demo/models/todo.dart';

class DBHelper {
  String tblTodo = "todo";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colDate = "date";
  String colStatus = "status";
  String colPriority = "priority";
  static Database _db;

  // static final DBHelper _dbHelper = DBHelper._internal();
  // DBHelper._internal();
  // factory DBHelper() {
  //   return _dbHelper;
  // }

  static final DBHelper instance = DBHelper._instance();

  DBHelper._instance();

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDB();
    }
    return _db;
  }

  Future<Database> initializeDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todo.db";
    var todoDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return todoDB;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colStatus INTEGER, $colDate TEXT, $colPriority TEXT)");
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    int result = await db.insert(tblTodo, todo.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblTodo");
    return result;
  }

  Future<List<Todo>> getTodoList() async {
    List<Map<String, dynamic>> maplist = await getTodoMapList();
    List<Todo> todolist = [];
    maplist.forEach((ob) {
      todolist.add(Todo.fromObject(ob));
    });
    return todolist;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = await Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tblTodo"));
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.update(tblTodo, todo.toMap(),
        where: "$colId = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete("DELETE FROM $tblTodo WHERE $colId = $id");
    return result;
  }
}
