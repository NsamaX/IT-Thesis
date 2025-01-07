import 'package:sqflite/sqflite.dart';
import 'database.dart';

class SQLiteService {
  final DatabaseService _databaseService;

  SQLiteService(DatabaseService databaseService) : _databaseService = databaseService;

  Future<Database> getDatabase() async {
    return await _databaseService.database;
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final db = await _databaseService.database;
      final tableExists = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [table],
      );
      if (tableExists.isEmpty) {
        throw Exception('Table $table does not exist in the database.');
      }
      final result = await db.query(
        table,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );
      return result.isNotEmpty ? result : [];
    } catch (e) {
      throw Exception('Failed to query table $table ${e.toString()}');
    }
  }

  Future<void> insertBatch(String table, List<Map<String, dynamic>> dataList) async {
    const chunkSize = 500;
    final db = await _databaseService.database;
    await db.transaction((txn) async {
      for (int i = 0; i < dataList.length; i += chunkSize) {
        final chunk = dataList.skip(i).take(chunkSize).toList();
        final batch = txn.batch();
        for (final data in chunk) {
          batch.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
        }
        await batch.commit(noResult: false, continueOnError: true);
      }
    });
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await _databaseService.database;
      await _ensureTableExists(db, table);
      await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception('Failed to insert data into $table ${e.toString()}');
    }
  }

  Future<void> _ensureTableExists(Database db, String table) async {
    final tableExists = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [table],
    );
    if (tableExists.isEmpty) {
      throw Exception('Table $table does not exist.');
    }
  }

  Future<void> delete(String table, String column, dynamic value) async {
    try {
      final db = await _databaseService.database;
      await db.delete(table, where: '$column = ?', whereArgs: [value]);
    } catch (e) {
      throw Exception('Failed to delete data from $table ${e.toString()}');
    }
  }

  Future<void> clear(String table) async {
    try {
      final db = await _databaseService.database;
      await db.delete(table);
    } catch (e) {
      throw Exception('Failed to clear table $table ${e.toString()}');
    }
  }
}
