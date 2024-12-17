import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../exceptions/local_data.dart';

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
      final path = join(dbPath, 'nfc_project.db');
      await deleteDatabase(path);
      print('Database deleted: $path');
      await Directory(dbPath).create(recursive: true);
      return await openDatabase(
        path,
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
