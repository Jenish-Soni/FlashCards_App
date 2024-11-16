import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = 'quizApp.db';
  static const _databaseVersion = 1;

  static const table = 'quiz_questions'; // Use 'quiz_questions' as table name
  static const columnId = '_id';
  static const columnQuestion = 'question';
  static const columnAnswer = 'answer';

  // Singleton instance
  static Database? _database;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open or create the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the database schema
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnQuestion TEXT NOT NULL,
        $columnAnswer TEXT NOT NULL
      )
    ''');

    // Add initial data when the database is created
    await _insertInitialData(db);
  }

  // Insert initial data into the table
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

  // Insert a new quiz question into the database
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Get all quiz questions from the database
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Delete a quiz item by ID
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      table, // Use the correct table name here
      where: '$columnId = ?', // Use the correct column name for ID
      whereArgs: [id],
    );
  }

  // Update a quiz item by ID
  Future<int> update(Map<String, dynamic> quiz) async {
    final db = await database;
    return await db.update(
      table, // Use the correct table name here
      quiz,
      where: '$columnId = ?', // Use the correct column name for ID
      whereArgs: [quiz[columnId]],
    );
  }
}
