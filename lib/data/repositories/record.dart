import '../datasources/local/record.dart';
import '../models/record.dart';

abstract class RecordRepository {
  Future<void> saveRecord(RecordModel record);
  Future<void> removeRecord(String recordId);
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
