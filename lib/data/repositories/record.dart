// import '../datasources/remote/record.dart';
// import '../../domain/entities/record.dart';
// import '../../domain/mappers/record.dart';

// class RecordRepository {
//   final RecordRemoteDataSource remoteDataSource;

//   RecordRepository({required this.remoteDataSource});

//   Future<Record> fetchRecord(String recordId) async {
//     final recordModel = await remoteDataSource.fetchRecord(recordId);
//     return RecordMapper.toEntity(recordModel);
//   }

//   Future<void> saveRecord(Record record) async {
//     final recordModel = RecordMapper.toModel(record);
//     await remoteDataSource.saveRecord(recordModel);
//   }

//   Future<void> deleteRecord(String recordId) async {
//     await remoteDataSource.deleteRecord(recordId);
//   }
// }
