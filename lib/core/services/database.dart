import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  static const int _dbVersion = 2; // เปลี่ยน version เมื่อมีการเพิ่ม Table

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final String dbPath = await getDatabasesPath();
      final String path = join(dbPath, 'nfc_project.db');
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

  /// สร้าง Table เริ่มต้นเมื่อ Database ถูกสร้างครั้งแรก
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        userId TEXT PRIMARY KEY,
        email TEXT,
        deckIds TEXT,
        recordIds TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS decks (
        deckId TEXT PRIMARY KEY,
        deckName TEXT NOT NULL,
        cards TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS records (
        recordId TEXT PRIMARY KEY,
        createdAt DATETIME NOT NULL,
        data TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS collections (
        collectId TEXT PRIMARY KEY,
        card TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cards (
        id TEXT PRIMARY KEY,
        game TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        additionalData TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pages (
        game TEXT PRIMARY KEY REFERENCES cards(game),
        page INTEGER NOT NULL
      )
    ''');
  }

  /// ฟังก์ชันสำหรับอัปเกรด Database โดยไม่ลบข้อมูลเก่า
  Future<void> _migrate(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      print('Migrating database from v$oldVersion to v$newVersion...');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          userId TEXT PRIMARY KEY,
          email TEXT,
          deckIds TEXT,
          recordIds TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS records (
          recordId TEXT PRIMARY KEY,
          createdAt DATETIME NOT NULL,
          data TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS collections (
          collectId TEXT PRIMARY KEY,
          card TEXT NOT NULL
        )
      ''');
    }
  }

  /// ปรับแต่งค่า Database เพื่อเพิ่มประสิทธิภาพ
  Future<void> _configureDatabase(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.rawQuery('PRAGMA synchronous = NORMAL');
    await db.rawQuery('PRAGMA journal_mode = MEMORY');
    await db.rawQuery('PRAGMA cache_size = -8000');
    await db.rawQuery('PRAGMA temp_store = MEMORY');
  }

  /// ฟังก์ชันสำหรับตรวจสอบว่า Table มีอะไรบ้าง
  Future<void> printTables() async {
    final Database db = await database;
    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'"
    );
    print('Existing Tables in Database:');
    for (var table in tables) {
      print('Table: ${table['name']}');
    }
  }
}
