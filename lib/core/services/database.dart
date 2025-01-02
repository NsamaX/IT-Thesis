import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../exceptions/local_data.dart';

/// จัดการฐานข้อมูล SQLite สำหรับแอปพลิเคชัน
class DatabaseService {
  /// อินสแตนซ์เดียวของ `DatabaseService` (Singleton Pattern)
  static final DatabaseService _instance = DatabaseService._internal();

  /// สร้างอินสแตนซ์ใหม่หรือดึงอินสแตนซ์เดิม
  factory DatabaseService() => _instance;

  /// คอนสตรักเตอร์ภายในสำหรับ Singleton Pattern
  DatabaseService._internal();

  /// ออบเจ็กต์ฐานข้อมูล
  static Database? _database;

  //-------------------------------- ดึงฐานข้อมูล -------------------------------//
  /// คืนค่าออบเจ็กต์ฐานข้อมูล (ถ้าไม่มี จะทำการสร้างฐานข้อมูล)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //------------------------------ เริ่มต้นฐานข้อมูล ------------------------------//
  /// สร้างและกำหนดค่าเริ่มต้นสำหรับฐานข้อมูล
  Future<Database> _initDatabase() async {
    try {
      // ดึง path สำหรับจัดเก็บฐานข้อมูล
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'nfc_project.db');

      // ตัวเลือกสำหรับลบฐานข้อมูล (สำหรับ debug)
      // await deleteDatabase(path);

      // เปิดหรือสร้างฐานข้อมูล
      final db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // สร้างตารางสำรับ (Decks)
          await db.execute('''
            CREATE TABLE decks (
              deckId TEXT PRIMARY KEY,
              deckName TEXT NOT NULL,
              cards TEXT NOT NULL
            )
          ''');

          // สร้างตารางการ์ด (Cards)
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

          // สร้างตารางหน้าเกม (Pages)
          await db.execute('''
            CREATE TABLE pages (
              game TEXT PRIMARY KEY REFERENCES cards(game),
              page INTEGER NOT NULL
            )
          ''');
        },
      );

      // ตั้งค่า PRAGMA เพื่อปรับแต่งประสิทธิภาพ
      await db.rawQuery('PRAGMA synchronous = NORMAL');
      await db.rawQuery('PRAGMA journal_mode = MEMORY');
      await db.rawQuery('PRAGMA cache_size = -8000');
      await db.rawQuery('PRAGMA temp_store = MEMORY');

      return db;
    } catch (e) {
      // โยนข้อผิดพลาดในกรณีที่การเริ่มต้นฐานข้อมูลล้มเหลว
      throw LocalDataException('ไม่สามารถเริ่มต้นฐานข้อมูลได้', details: e.toString());
    }
  }
}
