// import '../datasources/remote/data.dart';
// import '../../domain/entities/data.dart';
// import '../../domain/mappers/data.dart';

// class DataRepository {
//   final DataRemoteDataSource remoteDataSource;

//   DataRepository({required this.remoteDataSource});

//   Future<Data> fetchData(String tagId) async {
//     final dataModel = await remoteDataSource.fetchData(tagId);
//     return DataMapper.toEntity(dataModel);
//   }

//   Future<void> saveData(Data data) async {
//     final dataModel = DataMapper.toModel(data);
//     await remoteDataSource.saveData(dataModel);
//   }

//   Future<void> deleteData(String tagId) async {
//     await remoteDataSource.deleteData(tagId);
//   }
// }
