import '../datasources/local/record.dart';
import '../models/record.dart';

abstract class RecordRepository {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveRecord
   |
   |  วัตถุประสงค์:
   |      บันทึกข้อมูล Record ลงใน local storage
   |
   |  พารามิเตอร์:
   |      record (IN) -- RecordModel ที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ: Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> saveRecord(RecordModel record);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน removeRecord
   |
   |  วัตถุประสงค์:
   |      ลบข้อมูล Record ตาม recordId ที่ระบุ
   |
   |  พารามิเตอร์:
   |      recordId (IN) -- ID ของ Record ที่ต้องการลบ
   |
   |  ค่าที่คืนกลับ: Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> removeRecord(String recordId);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchRecord
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูล Record ทั้งหมดจาก local storage
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<List<RecordModel>> ที่มีรายการ Record ทั้งหมด
   *--------------------------------------------------------------------------*/
  Future<List<RecordModel>> fetchRecord();
}

class RecordRepositoryImpl implements RecordRepository {
  final RecordLocalDataSource datasource;

  RecordRepositoryImpl(this.datasource);

  @override
  Future<void> saveRecord(RecordModel record) async {
    await datasource.saveRecord(record);
  }

  @override
  Future<void> removeRecord(String recordId) async {
    await datasource.removeRecord(recordId);
  }

  @override
  Future<List<RecordModel>> fetchRecord() async {
    return datasource.fetchRecord();
  }
}
