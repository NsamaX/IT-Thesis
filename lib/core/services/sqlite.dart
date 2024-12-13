import 'package:sqflite/sqflite.dart';
import 'database.dart';
import '../utils/exceptions.dart';

class SQLiteService {
  final DatabaseService _databaseService;

  SQLiteService({required DatabaseService databaseService}) : _databaseService = databaseService;

  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await _databaseService.database;
      await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw LocalDataException('Failed to insert data into $table', details: e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    try {
      final db = await _databaseService.database;
      return await db.query(table);
    } catch (e) {
      throw LocalDataException('Failed to query table $table', details: e.toString());
    }
  }

  Future<void> delete(String table, String column, dynamic value) async {
    try {
      final db = await _databaseService.database;
      await db.delete(table, where: '$column = ?', whereArgs: [value]);
    } catch (e) {
      throw LocalDataException('Failed to delete data from $table', details: e.toString());
    }
  }

  Future<void> clear(String table) async {
    try {
      final db = await _databaseService.database;
      await db.delete(table);
    } catch (e) {
      throw LocalDataException('Failed to clear table $table', details: e.toString());
    }
  }
}
