import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _dbName = 'places.db';

  static const String _createPlacesTable =
      'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, image TEXT, dateTime TEXT)';

  static Future<Database> _getDB(String dbName) async {
    final db = await sql.openDatabase(
        path.join(await sql.getDatabasesPath(), dbName),
        onCreate: (db, version) => db.execute(_createPlacesTable),
        version: 1);
    return db;
  }

  static Future<void> insert(String table, Map<String, dynamic> values) async {
    final db = await DBHelper._getDB(DBHelper._dbName);

    // Updates entry if already exists or else inserts a new one! :D
    await db.insert(table, values,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper._getDB(DBHelper._dbName);
    return db.query(table);
  }
}
