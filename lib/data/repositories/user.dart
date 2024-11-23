// import '../datasources/remote/user.dart';
// import '../../domain/entities/user.dart';
// import '../../domain/mappers/user.dart';

// class UserRepository {
//   final UserRemoteDataSource remoteDataSource;

//   UserRepository({required this.remoteDataSource});

//   Future<User> fetchUser(String userId) async {
//     final userModel = await remoteDataSource.fetchUser(userId);
//     return UserMapper.toEntity(userModel);
//   }

//   Future<void> saveUser(User user) async {
//     final userModel = UserMapper.toModel(user);
//     await remoteDataSource.saveUser(userModel);
//   }

//   Future<void> deleteUser(String userId) async {
//     await remoteDataSource.deleteUser(userId);
//   }
// }
