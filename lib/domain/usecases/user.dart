// import 'package:nfc_project/data/repositories/user.dart';
// import '../entities/user.dart';
// import '../mappers/user.dart';

// class CreateUserUseCase {
//   final UserRepository userRepository;

//   CreateUserUseCase(this.userRepository);

//   Future<void> call(String userId, String email) async {
//     await userRepository.createUser(userId, email);
//   }
// }

// class GetUserByIdUseCase {
//   final UserRepository userRepository;

//   GetUserByIdUseCase(this.userRepository);

//   Future<UserEntity?> call(String userId) async {
//     final userModel = await userRepository.getUserById(userId);
//     return userModel != null ? UserMapper.toEntity(userModel) : null;
//   }
// }

// class DeleteUserUseCase {
//   final UserRepository userRepository;

//   DeleteUserUseCase(this.userRepository);

//   Future<void> call(String userId) async {
//     await userRepository.deleteUser(userId);
//   }
// }

// class UpdateUserEmailUseCase {
//   final UserRepository userRepository;

//   UpdateUserEmailUseCase(this.userRepository);

//   Future<void> call(String userId, String email) async {
//     await userRepository.updateEmail(userId, email);
//   }
// }

// class AddDeckUseCase {
//   final UserRepository userRepository;

//   AddDeckUseCase(this.userRepository);

//   Future<void> call(String userId, String deckId) async {
//     await userRepository.addDeck(userId, deckId);
//   }
// }

// class AddRecordUseCase {
//   final UserRepository userRepository;

//   AddRecordUseCase(this.userRepository);

//   Future<void> call(String userId, String recordId) async {
//     await userRepository.addRecord(userId, recordId);
//   }
// }

// class DeleteUserDeckUseCase {
//   final UserRepository userRepository;

//   DeleteUserDeckUseCase(this.userRepository);

//   Future<void> call(String userId, String deckId) async {
//     await userRepository.deleteUserDeck(userId, deckId);
//   }
// }

// class DeleteUserRecordUseCase {
//   final UserRepository userRepository;

//   DeleteUserRecordUseCase(this.userRepository);

//   Future<void> call(String userId, String recordId) async {
//     await userRepository.deleteUserRecord(userId, recordId);
//   }
// }
