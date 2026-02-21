import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/contact_model.dart';
import 'constants.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, Constants.dbName);

    return openDatabase(
      path,
      version: Constants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Constants.contactsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT,
        notes TEXT,
        is_favorite INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertContact(ContactModel contact) async {
    final db = await database;
    return db.insert(Constants.contactsTable, contact.toMap());
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await database;
    final maps = await db.query(
      Constants.contactsTable,
      orderBy: 'name ASC',
    );
    return maps.map((m) => ContactModel.fromMap(m)).toList();
  }

  Future<List<ContactModel>> getFavoriteContacts() async {
    final db = await database;
    final maps = await db.query(
      Constants.contactsTable,
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return maps.map((m) => ContactModel.fromMap(m)).toList();
  }

  Future<ContactModel?> getContactById(int id) async {
    final db = await database;
    final maps = await db.query(
      Constants.contactsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return ContactModel.fromMap(maps.first);
  }

  Future<int> updateContact(ContactModel contact) async {
    final db = await database;
    return db.update(
      Constants.contactsTable,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return db.delete(
      Constants.contactsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return db.update(
      Constants.contactsTable,
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
