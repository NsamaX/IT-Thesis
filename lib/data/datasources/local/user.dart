// import 'package:nfc_project/core/services/sqlite.dart';
// import '../../models/user.dart';

// abstract class UserLocalDataSource {
//   Future<void> createUser(String userId, String? email);
//   Future<UserModel?> getUserById(String userId);
//   Future<void> deleteUser(String userId);
//   Future<void> updateEmail(String userId, String email);
//   Future<void> addDeck(String userId, String deckId);
//   Future<void> addRecord(String userId, String recordId);
//   Future<void> deleteUserDeck(String userId, String deckId);
//   Future<void> deleteUserRecord(String userId, String recordId);
// }

// class UserLocalDataSourceImpl implements UserLocalDataSource {
//   final SQLiteService _sqliteService;

//   static const String usersTable = 'users';
//   static const String decksTable = 'decks';
//   static const String recordsTable = 'records';

//   UserLocalDataSourceImpl(this._sqliteService);

//   @override
//   Future<void> createUser(String userId, String? email) async {
//     await _sqliteService.insert(
//       usersTable,
//       UserModel(
//         userId: userId,
//         email: email ?? '',
//         deckIds: [],
//         recordIds: [],
//       ).toJson(),
//     );
//   }

//   @override
//   Future<UserModel?> getUserById(String userId) async {
//     final result = await _sqliteService.query(
//       usersTable,
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//     return result.isNotEmpty ? UserModel.fromJson(result.first) : null;
//   }

//   @override
//   Future<void> deleteUser(String userId) async {
//     final user = await getUserById(userId);
//     if (user == null) return;
//     await Future.wait([
//       _deleteRelatedItems(decksTable, 'deckId', user.deckIds),
//       _deleteRelatedItems(recordsTable, 'recordId', user.recordIds),
//       _sqliteService.delete(usersTable, 'userId', userId),
//     ]);
//   }

//   @override
//   Future<void> updateEmail(String userId, String email) async {
//     await _sqliteService.update(
//       usersTable,
//       {'email': email},
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//   }

//   @override
//   Future<void> addDeck(String userId, String deckId) async {
//     await _updateUserField(userId, (user) => user.deckIds, deckId);
//   }

//   @override
//   Future<void> addRecord(String userId, String recordId) async {
//     await _updateUserField(userId, (user) => user.recordIds, recordId);
//   }

//   @override
//   Future<void> deleteUserDeck(String userId, String deckId) async {
//     await _removeUserField(userId, (user) => user.deckIds, deckId);
//   }

//   @override
//   Future<void> deleteUserRecord(String userId, String recordId) async {
//     await _removeUserField(userId, (user) => user.recordIds, recordId);
//   }

//   Future<void> _deleteRelatedItems(String table, String column, List<String> ids) async {
//     await Future.wait(ids.map((id) => _sqliteService.delete(table, column, id)));
//   }

//   Future<void> _updateUserField(String userId, List<String> Function(UserModel) getField, String newId) async {
//     final user = await getUserById(userId);
//     if (user == null) return;
//     List<String> newList = {...getField(user), newId}.toList();
//     await _sqliteService.update(
//       usersTable,
//       {
//         if (getField(user) == user.deckIds) 'deckIds': newList,
//         if (getField(user) == user.recordIds) 'recordIds': newList,
//       },
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//   }

//   Future<void> _removeUserField(String userId, List<String> Function(UserModel) getField, String removeId) async {
//     final user = await getUserById(userId);
//     if (user == null) return;
//     List<String> updatedList = getField(user)..remove(removeId);
//     await _sqliteService.update(
//       usersTable,
//       {
//         if (getField(user) == user.deckIds) 'deckIds': updatedList,
//         if (getField(user) == user.recordIds) 'recordIds': updatedList,
//       },
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//   }
// }
