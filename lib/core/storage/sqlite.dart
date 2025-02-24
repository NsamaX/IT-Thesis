import 'package:sqflite/sqflite.dart';
import 'database.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class SQLiteService {
  late final DatabaseService _databaseService;

  SQLiteService(this._databaseService);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<Database> getDatabase() async => await _databaseService.database;

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final Database db = await getDatabase();
      await _ensureTableExists(db, table);
      return await db.query(
        table,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to query table "$table": ${e.toString()}');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      final Database db = await getDatabase();
      await _ensureTableExists(db, table);
      await db.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to insert data into "$table": ${e.toString()}');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> insertBatch(String table, List<Map<String, dynamic>> dataList) async {
    const int chunkSize = 500;
    try {
      final Database db = await getDatabase();
      await db.transaction((txn) async {
        for (int i = 0; i < dataList.length; i += chunkSize) {
          final chunk = dataList.skip(i).take(chunkSize);
          final batch = txn.batch();
          for (final data in chunk) {
            batch.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
          }
          await batch.commit(noResult: true, continueOnError: true);
        }
      });
    } catch (e) {
      throw Exception('Failed to insert batch into "$table": ${e.toString()}');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> update(
    String table, 
    Map<String, dynamic> data, {
    required String where, 
    required List<dynamic> whereArgs,
  }) async {
    try {
      final Database db = await getDatabase();
      await _ensureTableExists(db, table);
      await db.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      throw Exception('Failed to update data in "$table": ${e.toString()}');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> delete(String table, String column, dynamic value) async {
    try {
      final Database db = await getDatabase();
      await _ensureTableExists(db, table);
      await db.delete(table, where: '$column = ?', whereArgs: [value]);
    } catch (e) {
      throw Exception('Failed to delete data from "$table": ${e.toString()}');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> _ensureTableExists(Database db, String table) async {
    final int? count = Sqflite.firstIntValue(await db.rawQuery(
      "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name=?",
      [table],
    ));
    if (count == null || count == 0) {
      throw Exception('Table "$table" does not exist.');
    }
  }
}
