import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Future<Database>? _database;
  static const int _dbVersion = 2;

  static const String _dbName = 'nfc_project.db';

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<Database> get database async {
    _database ??= _initDatabase();
    return _database!;
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<Database> _initDatabase() async {
    try {
      final String dbPath = await getDatabasesPath();
      final String path = join(dbPath, _dbName);
      final Database db = await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _createTables,
        onUpgrade: _migrate,
        onDowngrade: onDatabaseDowngradeDelete,
      );
      await _configureDatabase(db);
      return db;
    } catch (e) {
      throw Exception('Failed to initialize the database: ${e.toString()}');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> _createTables(Database db, int version) async {
    final List<String> tables = [
      '''
      CREATE TABLE IF NOT EXISTS users (
        userId TEXT PRIMARY KEY,
        email TEXT,
        deckIds TEXT,
        recordIds TEXT
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS decks (
        deckId TEXT PRIMARY KEY,
        deckName TEXT NOT NULL,
        cards TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS records (
        recordId TEXT PRIMARY KEY,
        createdAt DATETIME NOT NULL,
        data TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS collections (
        collectId TEXT PRIMARY KEY,
        card TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS cards (
        id TEXT PRIMARY KEY,
        game TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        additionalData TEXT
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS pages (
        game TEXT PRIMARY KEY REFERENCES cards(game),
        page INTEGER NOT NULL
      )
      '''
    ];

    final Batch batch = db.batch();
    for (String query in tables) {
      batch.execute(query);
    }
    await batch.commit();
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> _migrate(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      debugPrint('Migrating database from v$oldVersion to v$newVersion...');

      final List<String> migrations = [
        '''
        CREATE TABLE IF NOT EXISTS users (
          userId TEXT PRIMARY KEY,
          email TEXT,
          deckIds TEXT,
          recordIds TEXT
        )
        ''',
        '''
        CREATE TABLE IF NOT EXISTS records (
          recordId TEXT PRIMARY KEY,
          createdAt DATETIME NOT NULL,
          data TEXT NOT NULL
        )
        ''',
        '''
        CREATE TABLE IF NOT EXISTS collections (
          collectId TEXT PRIMARY KEY,
          card TEXT NOT NULL
        )
        '''
      ];

      final Batch batch = db.batch();
      for (String query in migrations) {
        batch.execute(query);
      }
      await batch.commit();
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> _configureDatabase(Database db) async {
    try {
      await db.rawQuery('PRAGMA foreign_keys = ON');
      await db.rawQuery('PRAGMA synchronous = NORMAL');
      await db.rawQuery('PRAGMA journal_mode = MEMORY');
      await db.rawQuery('PRAGMA cache_size = -8000');
      await db.rawQuery('PRAGMA temp_store = MEMORY');
    } catch (e) {
      throw Exception('Failed to configure database: ${e.toString()}');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> printTables() async {
    final Database db = await database;
    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'"
    );

    debugPrint('Existing Tables in Database:');
    for (var table in tables) {
      debugPrint('Table: ${table['name']}');
    }
  }
}
