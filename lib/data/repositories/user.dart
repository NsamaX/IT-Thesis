import 'package:nfc_project/data/datasources/local/user.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<void> createUser(String userId, String? email);
  Future<UserModel?> getUserById(String userId);
  Future<void> deleteUser(String userId);
  Future<void> updateEmail(String userId, String email);
  Future<void> addDeck(String userId, String deckId);
  Future<void> addRecord(String userId, String recordId);
  Future<void> deleteUserDeck(String userId, String deckId);
  Future<void> deleteUserRecord(String userId, String recordId);
}

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl(this.userLocalDataSource);

  @override
  Future<void> createUser(String userId, String? email) async {
    await userLocalDataSource.createUser(userId, email);
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    return await userLocalDataSource.getUserById(userId);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await userLocalDataSource.deleteUser(userId);
  }

  @override
  Future<void> updateEmail(String userId, String email) async {
    await userLocalDataSource.updateEmail(userId, email);
  }

  @override
  Future<void> addDeck(String userId, String deckId) async {
    await userLocalDataSource.addDeck(userId, deckId);
  }

  @override
  Future<void> addRecord(String userId, String recordId) async {
    await userLocalDataSource.addRecord(userId, recordId);
  }

  @override
  Future<void> deleteUserDeck(String userId, String deckId) async {
    await userLocalDataSource.deleteUserDeck(userId, deckId);
  }

  @override
  Future<void> deleteUserRecord(String userId, String recordId) async {
    await userLocalDataSource.deleteUserRecord(userId, recordId);
  }
}
