import 'package:sqflite/sqflite.dart';
import 'database.dart';

class SQLiteService {
  late final DatabaseService _databaseService;

  SQLiteService(this._databaseService);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน getDatabase
   |
   |  วัตถุประสงค์:
   |      คืนค่า Database ที่เปิดใช้งานอยู่
   |
   |  ค่าที่คืนกลับ:
   |      - Future<Database> ที่เปิดใช้งานแล้ว
   *--------------------------------------------------------------------------*/
  Future<Database> getDatabase() async => await _databaseService.database;

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน query
   |
   |  วัตถุประสงค์:
   |      ค้นหาข้อมูลจาก Table ใน Database
   |
   |  พารามิเตอร์:
   |      table (IN) -- ชื่อ Table ที่ต้องการค้นหา
   |      where (IN) -- เงื่อนไขสำหรับการกรองข้อมูล (Optional)
   |      whereArgs (IN) -- ค่าที่ใช้แทนที่ตัวแปรใน `where` (Optional)
   |      orderBy (IN) -- ลำดับของผลลัพธ์ (Optional)
   |      limit (IN) -- จำกัดจำนวนผลลัพธ์ที่คืนกลับ (Optional)
   |
   |  ค่าที่คืนกลับ:
   |      - List<Map<String, dynamic>> ที่มีข้อมูลจาก Table
   *--------------------------------------------------------------------------*/
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

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน insert
   |
   |  วัตถุประสงค์:
   |      เพิ่มข้อมูลลงใน Table
   |
   |  พารามิเตอร์:
   |      table (IN) -- ชื่อ Table ที่ต้องการเพิ่มข้อมูล
   |      data (IN) -- ข้อมูลที่ต้องการเพิ่มในรูปแบบ Map<String, dynamic>
   *--------------------------------------------------------------------------*/
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

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน insertBatch
   |
   |  วัตถุประสงค์:
   |      เพิ่มข้อมูลแบบกลุ่มลงใน Table โดยใช้ batch processing
   |
   |  พารามิเตอร์:
   |      table (IN) -- ชื่อ Table ที่ต้องการเพิ่มข้อมูล
   |      dataList (IN) -- รายการข้อมูลที่ต้องการเพิ่มในรูปแบบ List<Map<String, dynamic>>
   *--------------------------------------------------------------------------*/
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

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน update
   |
   |  วัตถุประสงค์:
   |      อัปเดตข้อมูลใน Table
   |
   |  พารามิเตอร์:
   |      table (IN) -- ชื่อ Table ที่ต้องการอัปเดตข้อมูล
   |      data (IN) -- ข้อมูลที่ต้องการอัปเดต
   |      where (IN) -- เงื่อนไขสำหรับเลือกข้อมูลที่ต้องการอัปเดต
   |      whereArgs (IN) -- ค่าที่ใช้แทนที่ตัวแปรใน `where`
   *--------------------------------------------------------------------------*/
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

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน delete
   |
   |  วัตถุประสงค์:
   |      ลบข้อมูลจาก Table ตามคีย์ที่กำหนด
   |
   |  พารามิเตอร์:
   |      table (IN) -- ชื่อ Table ที่ต้องการลบข้อมูล
   |      column (IN) -- คอลัมน์ที่ใช้เป็นเงื่อนไขสำหรับการลบ
   |      value (IN) -- ค่าของคอลัมน์ที่ต้องการลบ
   *--------------------------------------------------------------------------*/
  Future<void> delete(String table, String column, dynamic value) async {
    try {
      final Database db = await getDatabase();
      await _ensureTableExists(db, table);
      await db.delete(table, where: '$column = ?', whereArgs: [value]);
    } catch (e) {
      throw Exception('Failed to delete data from "$table": ${e.toString()}');
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _ensureTableExists
   |
   |  วัตถุประสงค์:
   |      ตรวจสอบว่า Table มีอยู่จริงใน Database
   |
   |  พารามิเตอร์:
   |      db (IN) -- Instance ของ Database ที่ใช้ตรวจสอบ
   |      table (IN) -- ชื่อ Table ที่ต้องการตรวจสอบ
   *--------------------------------------------------------------------------*/
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
