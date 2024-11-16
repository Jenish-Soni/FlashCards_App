import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = 'quizApp.db';
  static const _databaseVersion = 1;

  static const table = 'quiz_questions'; 
  static const columnId = '_id';
  static const columnQuestion = 'question';
  static const columnAnswer = 'answer';

  
  static Database? _database;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnQuestion TEXT NOT NULL,
        $columnAnswer TEXT NOT NULL
      )
    ''');

    
    await _insertInitialData(db);
  }

  
  Future _insertInitialData(Database db) async {
    List<Map<String, dynamic>> initialData = [
      {'question': 'What is the capital of France?', 'answer': 'Paris'},
      {'question': 'Who wrote "1984"?', 'answer': 'George Orwell'},
      {'question': 'What is 2 + 2?', 'answer': '4'},
    ];

    for (var data in initialData) {
      await db.insert(table, data);
    }
  }

  
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      table, 
      where: '$columnId = ?', 
      whereArgs: [id],
    );
  }

  
  Future<int> update(Map<String, dynamic> quiz) async {
    final db = await database;
    return await db.update(
      table, 
      quiz,
      where: '$columnId = ?', 
      whereArgs: [quiz[columnId]],
    );
  }
}
