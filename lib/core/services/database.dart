import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'nfc_project.db');
      // Option for deleting the database (for debugging)
      // await deleteDatabase(path);
      final db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE decks (
              deckId TEXT PRIMARY KEY,
              deckName TEXT NOT NULL,
              cards TEXT NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE cards (
              id TEXT PRIMARY KEY,
              game TEXT NOT NULL,
              name TEXT NOT NULL,
              description TEXT,
              imageUrl TEXT,
              additionalData TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE pages (
              game TEXT PRIMARY KEY REFERENCES cards(game),
              page INTEGER NOT NULL
            )
          ''');
        },
      );
      await db.rawQuery('PRAGMA synchronous = NORMAL');
      await db.rawQuery('PRAGMA journal_mode = MEMORY');
      await db.rawQuery('PRAGMA cache_size = -8000');
      await db.rawQuery('PRAGMA temp_store = MEMORY');
      return db;
    } catch (e) {
      throw Exception('Failed to initialize the database ${e.toString()}');
    }
  }
}
