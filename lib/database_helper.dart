import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('student_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE students(
        id $idType,
        name $textType,
        phone $textType,
        email $textType,
        location $textType
      )
    ''');
  }

  Future<int> insertStudent(Map<String, dynamic> student) async {
    final db = await instance.database;
    return await db.insert('students', student, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final db = await instance.database;
    return await db.query('students');
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateStudent(Map<String, dynamic> student) async {
    final db = await instance.database;
    return await db.update('students', student, where: 'id = ?', whereArgs: [student['id']]);
  }
}