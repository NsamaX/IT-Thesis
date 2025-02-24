import 'package:nfc_project/data/repositories/record.dart';
import '../entities/record.dart';
import '../mappers/record.dart';

/*------------------------------------------------------------------------------
 |  คลาส SaveRecordUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับบันทึกข้อมูล Record ลงใน Repository
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ RecordRepository ที่ใช้ในการบันทึกข้อมูล
 *----------------------------------------------------------------------------*/
class SaveRecordUseCase {
  final RecordRepository repository;

  SaveRecordUseCase(this.repository);

  Future<void> call(RecordEntity record) async {
    final recordModel = RecordMapper.toModel(record);
    await repository.saveRecord(recordModel);
  }
}

/*------------------------------------------------------------------------------
 |  คลาส RemoveRecordUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับลบข้อมูล Record ออกจาก Repository
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ RecordRepository ที่ใช้ในการลบข้อมูล
 *----------------------------------------------------------------------------*/
class RemoveRecordUseCase {
  final RecordRepository repository;

  RemoveRecordUseCase(this.repository);

  Future<void> call(String recordId) async {
    await repository.removeRecord(recordId);
  }
}

/*------------------------------------------------------------------------------
 |  คลาส FetchRecordUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับดึงข้อมูล Record ทั้งหมดจาก Repository
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ RecordRepository ที่ใช้ในการดึงข้อมูล
 *----------------------------------------------------------------------------*/
class FetchRecordUseCase {
  final RecordRepository repository;

  FetchRecordUseCase(this.repository);

  Future<List<RecordEntity>> call() async {
    final recordModels = await repository.fetchRecord();
    return recordModels.map(RecordMapper.toEntity).toList();
  }
}
