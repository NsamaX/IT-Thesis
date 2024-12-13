import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../utils/exceptions.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    try {
      if (_database != null) return _database!;
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      throw LocalDataException('Failed to initialize database', details: e.toString());
    }
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      return await openDatabase(
        join(dbPath, 'nfc_project.db'),
        version: 1,
        onCreate: (db, version) async {
          try {
            await db.execute('''
              CREATE TABLE decks (
                deckId TEXT PRIMARY KEY,
                deckName TEXT NOT NULL,
                cards TEXT NOT NULL
              )
            ''');
          } catch (e) {
            throw LocalDataException('Failed to create table', details: e.toString());
          }
        },
      );
    } catch (e) {
      throw LocalDataException('Failed to get database path or open database', details: e.toString());
    }
  }
}
