// // lib/database/alarm_db.dart
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import '../models/alarm_model.dart';
//
// class AlarmDatabase {
//   static final AlarmDatabase instance = AlarmDatabase._init();
//   static Database? _database;
//
//   AlarmDatabase._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('alarms.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }
//
//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE alarms (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         note TEXT,
//         time TEXT NOT NULL,
//         frequency TEXT NOT NULL,
//         startDate TEXT NOT NULL,
//         endDate TEXT,
//         soundPath TEXT,
//         isActive INTEGER NOT NULL
//       )
//     ''');
//   }
//
//   Future<int> insertAlarm(AlarmModel alarm) async {
//     final db = await instance.database;
//     return await db.insert('alarms', alarm.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   Future<List<AlarmModel>> fetchAlarms() async {
//     final db = await instance.database;
//     final result = await db.query('alarms', orderBy: 'time ASC');
//     return result.map((json) => AlarmModel.fromMap(json)).toList();
//   }
//
//   Future<int> updateAlarm(AlarmModel alarm) async {
//     final db = await instance.database;
//     return await db.update(
//       'alarms',
//       alarm.toMap(),
//       where: 'id = ?',
//       whereArgs: [alarm.id],
//     );
//   }
//
//   Future<int> deleteAlarm(int id) async {
//     final db = await instance.database;
//     return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
//   }
//
//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }


//----------------Updated alarm db for my updated multiple times -------------------//
// lib/database/alarm_db.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/alarm_model.dart';

class AlarmDatabase {
  static final AlarmDatabase instance = AlarmDatabase._init();
  static Database? _database;

  AlarmDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('alarms.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2, // Increased version for schema update
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alarms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        note TEXT,
        times TEXT NOT NULL,
        frequency TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT,
        soundPath TEXT,
        medicineImagePath TEXT DEFAULT '',
        foodTiming TEXT DEFAULT 'Before Food',
        isActive INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Check if columns exist before adding them
      final tableInfo = await db.rawQuery('PRAGMA table_info(alarms)');
      final columnNames = tableInfo.map((e) => e['name'].toString()).toList();

      if (!columnNames.contains('medicineImagePath')) {
        await db.execute('ALTER TABLE alarms ADD COLUMN medicineImagePath TEXT DEFAULT ""');
      }
      if (!columnNames.contains('foodTiming')) {
        await db.execute('ALTER TABLE alarms ADD COLUMN foodTiming TEXT DEFAULT "Before Food"');
      }
      if (!columnNames.contains('times')) {
        await db.execute('ALTER TABLE alarms ADD COLUMN times TEXT DEFAULT ""');

        // Migrate existing 'time' column to 'times' column
        final List<Map<String, dynamic>> oldRecords = await db.query('alarms');
        for (var record in oldRecords) {
          if (record.containsKey('time') && record['time'] != null) {
            await db.update(
              'alarms',
              {'times': record['time']}, // Convert single time to times format
              where: 'id = ?',
              whereArgs: [record['id']],
            );
          }
        }
      }
    }
  }

  Future<int> insertAlarm(AlarmModel alarm) async {
    final db = await instance.database;
    return await db.insert('alarms', alarm.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AlarmModel>> fetchAlarms() async {
    final db = await instance.database;
    final result = await db.query('alarms', orderBy: 'name ASC');
    return result.map((json) => AlarmModel.fromMap(json)).toList();
  }

  Future<AlarmModel?> fetchAlarmById(int id) async {
    final db = await instance.database;
    final result = await db.query('alarms', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return AlarmModel.fromMap(result.first);
  }

  Future<int> updateAlarm(AlarmModel alarm) async {
    final db = await instance.database;
    return await db.update(
      'alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }

  Future<int> deleteAlarm(int id) async {
    final db = await instance.database;
    return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}