import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = "User";
  static final _dbVersion = 1;
  static final _tableName = "student";

  static final studentName = "name";
  static final studentSn = "sn";
  static final studentId = "id";


  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initializeDatabase();
    return _database;
  }

  _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $_tableName (
      $studentSn INTEGER PRIMARY KEY,
      $studentName TEXT NOT NULL,
      $studentId INTEGER
      )
      ''');
    db.insert(_tableName, {studentName:"Makrand Bhonde",studentId:"18007038"},);
    db.insert(_tableName, {studentName:"Anurag Shrirao",studentId:"18007052"},);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future querryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int sn = row[studentSn];
    return await db
        .update(_tableName, row, where: "$studentSn = ?", whereArgs: [sn]);
  }

  Future<int> delete(int sn) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: "$studentSn = ?", whereArgs: [sn]);
  }
}
