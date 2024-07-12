import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/tarea.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    print('Database path: $dbPath');
    return openDatabase(
      join(dbPath, 'tareas.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tareas(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTarea(Tarea tarea) async {
    final db = await database;
    await db.insert(
      'tareas',
      tarea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserted task: ${tarea.toMap()}');
  }

  Future<List<Tarea>> getTareas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tareas');
    print('Fetched tasks: $maps');
    return List.generate(maps.length, (i) {
      return Tarea(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
      );
    });
  }

  Future<void> updateTarea(Tarea tarea) async {
    final db = await database;
    await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
    print('Updated task: ${tarea.toMap()}');
  }

  Future<void> deleteTarea(int id) async {
    final db = await database;
    await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Deleted task with id: $id');
  }
}
