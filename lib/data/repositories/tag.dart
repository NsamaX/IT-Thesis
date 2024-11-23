// import '../datasources/remote/tag.dart';
// import '../../domain/entities/tag.dart';
// import '../../domain/mappers/tag.dart';

// class TagRepository {
//   final TagRemoteDataSource remoteDataSource;

//   TagRepository({required this.remoteDataSource});

//   Future<Tag> fetchTag(String tagId) async {
//     final tagModel = await remoteDataSource.fetchTag(tagId);
//     return TagMapper.toEntity(tagModel);
//   }

//   Future<void> saveTag(Tag tag) async {
//     final tagModel = TagMapper.toModel(tag);
//     await remoteDataSource.saveTag(tagModel);
//   }

//   Future<void> deleteTag(String tagId) async {
//     await remoteDataSource.deleteTag(tagId);
//   }
// }
