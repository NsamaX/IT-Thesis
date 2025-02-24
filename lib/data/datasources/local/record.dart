import 'dart:convert';
import 'package:nfc_project/core/storage/sqlite.dart';
import '../../models/data.dart';
import '../../models/record.dart';

abstract class RecordLocalDataSource {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveRecord
   |
   |  วัตถุประสงค์:
   |      บันทึกข้อมูล Record ลงในฐานข้อมูล
   |
   |  พารามิเตอร์:
   |      record (IN) -- RecordModel ที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ: ไม่มีค่าคืนกลับ (เป็น Future<void>)
   *--------------------------------------------------------------------------*/
  Future<void> saveRecord(RecordModel record);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน removeRecord
   |
   |  วัตถุประสงค์:
   |      ลบข้อมูล Record ออกจากฐานข้อมูลโดยใช้ recordId
   |
   |  พารามิเตอร์:
   |      recordId (IN) -- ID ของ Record ที่ต้องการลบ
   |
   |  ค่าที่คืนกลับ: ไม่มีค่าคืนกลับ (เป็น Future<void>)
   *--------------------------------------------------------------------------*/
  Future<void> removeRecord(String recordId);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchRecord
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูล Record ทั้งหมดจากฐานข้อมูล
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<List<RecordModel>> ที่มีรายการ Record ทั้งหมด
   *--------------------------------------------------------------------------*/
  Future<List<RecordModel>> fetchRecord();
}

class RecordLocalDataSourceImpl implements RecordLocalDataSource {
  final SQLiteService _sqliteService;

  static const String _recordTable = 'records';
  static const String _columnRecordId = 'recordId';
  static const String _columnCreatedAt = 'createdAt';
  static const String _columnData = 'data';

  RecordLocalDataSourceImpl(this._sqliteService);

  @override
  Future<void> saveRecord(RecordModel record) async {
    await _sqliteService.insert(
      _recordTable,
      {
        _columnRecordId: record.recordId,
        _columnCreatedAt: record.createdAt.toIso8601String(),
        _columnData: json.encode(record.data),
      },
    );
  }

  @override
  Future<void> removeRecord(String recordId) async {
    await _sqliteService.delete(
      _recordTable,
      _columnRecordId,
      recordId,
    );
  }

  @override
  Future<List<RecordModel>> fetchRecord() async {
    final result = await _sqliteService.query(_recordTable);
    return result.map((row) {
      final List<dynamic> recordDataList = json.decode(row[_columnData]);
      return RecordModel(
        recordId: row[_columnRecordId],
        createdAt: DateTime.parse(row[_columnCreatedAt]),
        data: recordDataList.map((e) => DataModel.fromJson(e)).toList(),
      );
    }).toList();
  }
}
