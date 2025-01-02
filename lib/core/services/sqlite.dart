import 'package:sqflite/sqflite.dart';
import 'database.dart';
import '../exceptions/local_data.dart';

/// บริการสำหรับจัดการการทำงานของ SQLite
class SQLiteService {
  /// อินสแตนซ์ของ `DatabaseService`
  final DatabaseService _databaseService;

  /// สร้างออบเจ็กต์ `SQLiteService` ด้วย `DatabaseService`
  SQLiteService(DatabaseService databaseService) : _databaseService = databaseService;

  //----------------------------- การจัดการฐานข้อมูล ----------------------------//
  /// ดึงออบเจ็กต์ฐานข้อมูล SQLite
  Future<Database> getDatabase() async {
    return await _databaseService.database;
  }

  //----------------------------- การ Query ข้อมูล -----------------------------//
  /// Query ข้อมูลจากตารางที่ระบุ
  /// - [table]: ชื่อตาราง
  /// - [where]: เงื่อนไขสำหรับการ query
  /// - [whereArgs]: ค่า argument สำหรับเงื่อนไข
  /// - [orderBy]: การจัดเรียงข้อมูล
  /// - [limit]: จำนวนข้อมูลสูงสุดที่จะดึง
  /// - หากตารางไม่มีอยู่ในฐานข้อมูล จะโยนข้อยกเว้น [LocalDataException]
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
        throw LocalDataException('Table $table does not exist in the database.');
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
      throw LocalDataException('Failed to query table $table', details: e.toString());
    }
  }

  //----------------------------- การ Insert ข้อมูล ----------------------------//
  /// Insert ข้อมูลแบบ Batch (ครั้งละหลายรายการ)
  /// - [table]: ชื่อตาราง
  /// - [dataList]: รายการข้อมูลที่ต้องการเพิ่ม
  /// - ใช้ Batch เพื่อเพิ่มประสิทธิภาพการเขียนข้อมูล
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

  /// Insert ข้อมูลลงในตารางที่ระบุ
  /// - [table]: ชื่อตาราง
  /// - [data]: ข้อมูลที่ต้องการเพิ่ม
  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await _databaseService.database;
      await _ensureTableExists(db, table);
      await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw LocalDataException('Failed to insert data into $table', details: e.toString());
    }
  }

  //-------------------------------- การลบข้อมูล -------------------------------//
  /// ลบข้อมูลจากตารางโดยใช้เงื่อนไข
  /// - [table]: ชื่อตาราง
  /// - [column]: คอลัมน์ที่ใช้เป็นเงื่อนไข
  /// - [value]: ค่าของเงื่อนไข
  Future<void> delete(String table, String column, dynamic value) async {
    try {
      final db = await _databaseService.database;
      await db.delete(table, where: '$column = ?', whereArgs: [value]);
    } catch (e) {
      throw LocalDataException('Failed to delete data from $table', details: e.toString());
    }
  }

  /// ลบข้อมูลทั้งหมดในตาราง
  /// - [table]: ชื่อตาราง
  Future<void> clear(String table) async {
    try {
      final db = await _databaseService.database;
      await db.delete(table);
    } catch (e) {
      throw LocalDataException('Failed to clear table $table', details: e.toString());
    }
  }

  //----------------------------- การตรวจสอบตาราง -----------------------------//
  /// ตรวจสอบว่าตารางมีอยู่ในฐานข้อมูลหรือไม่
  /// - [db]: ออบเจ็กต์ฐานข้อมูล
  /// - [table]: ชื่อตาราง
  Future<void> _ensureTableExists(Database db, String table) async {
    final tableExists = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [table],
    );
    if (tableExists.isEmpty) {
      throw LocalDataException('Table $table does not exist.');
    }
  }
}
