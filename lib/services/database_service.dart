// lib/services/database_service.dart

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../core/models/test_record.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'test_records.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE test_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        phone TEXT NOT NULL,
        gender TEXT NOT NULL,
        testDate TEXT NOT NULL,
        overallScore REAL NOT NULL,
        status TEXT NOT NULL,
        categoryScores TEXT NOT NULL,
        strengths TEXT NOT NULL,
        weaknesses TEXT NOT NULL,
        advice TEXT NOT NULL,
        answers TEXT NOT NULL,
        questions TEXT NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_userId ON test_records(userId)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      await db.execute('DROP TABLE IF EXISTS test_records');
      await _onCreate(db, newVersion);
    }
  }

  Future<int> insertRecord(TestRecord record) async {
    Database db = await database;
    return await db.insert('test_records', record.toMap());
  }

  Future<List<TestRecord>> getRecordsByUserId(String userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'test_records',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'testDate DESC',
    );
    return List.generate(maps.length, (i) => TestRecord.fromMap(maps[i]));
  }

  Future<List<TestRecord>> getAllRecords() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'test_records',
      orderBy: 'testDate DESC',
    );
    return List.generate(maps.length, (i) => TestRecord.fromMap(maps[i]));
  }

  Future<List<TestRecord>> searchRecordsByUserIdAndName(String userId, String name) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'test_records',
      where: 'userId = ? AND name LIKE ?',
      whereArgs: [userId, '%$name%'],
      orderBy: 'testDate DESC',
    );
    return List.generate(maps.length, (i) => TestRecord.fromMap(maps[i]));
  }

  Future<TestRecord?> getRecordByIdAndUserId(int id, String userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'test_records',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
    if (maps.isNotEmpty) {
      return TestRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteRecord(int id, String userId) async {
    Database db = await database;
    return await db.delete(
      'test_records',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  Future<void> deleteAllRecordsByUserId(String userId) async {
    Database db = await database;
    await db.delete(
      'test_records',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> getRecordsCountByUserId(String userId) async {
    Database db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM test_records WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<TestRecord>> getRecordsByUserIdBetweenDates(
      String userId,
      DateTime startDate,
      DateTime endDate,
      ) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'test_records',
      where: 'userId = ? AND testDate BETWEEN ? AND ?',
      whereArgs: [userId, startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'testDate DESC',
    );
    return List.generate(maps.length, (i) => TestRecord.fromMap(maps[i]));
  }
}