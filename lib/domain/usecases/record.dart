import 'package:nfc_project/data/repositories/record.dart';
import '../entities/record.dart';
import '../mappers/record.dart';

class SaveRecordUseCase {
  final RecordRepository repository;

  SaveRecordUseCase(this.repository);

  Future<void> call(RecordEntity record) async {
    final recordModel = RecordMapper.toModel(record);
    await repository.saveRecord(recordModel);
  }
}

class RemoveRecordUseCase {
  final RecordRepository repository;

  RemoveRecordUseCase(this.repository);

  Future<void> call(String recordId) async {
    await repository.removeRecord(recordId);
  }
}

class FetchRecordUseCase {
  final RecordRepository repository;

  FetchRecordUseCase(this.repository);

  Future<List<RecordEntity>> call() async {
    final recordModels = await repository.fetchRecord();
    return recordModels.map(RecordMapper.toEntity).toList();
  }
}
