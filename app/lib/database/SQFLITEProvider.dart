import 'package:path/path.dart';
import 'package:products_captor/models/Task.dart';
import 'package:sqflite/sqflite.dart';

class SQFLITEProvider {
  SQFLITEProvider._();

  static final SQFLITEProvider provider = SQFLITEProvider._();

  static Database? _database;

  Future<Database> get database async => _database ??= await init();

  Future<Database> init() async =>
      await openDatabase(join(await getDatabasesPath(), 'todo_app_db_1.db'),
          onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS tasks 
          (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, created_at TEXT)
        ''');
      }, version: 1);

  Future<int> addNewTask(Task task) async =>
      (await database).insert("tasks", task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List> getAllTasks() async =>
      (await (await database).query("tasks")).toList().isNotEmpty
          ? (await (await database).query("tasks")).toList()
          : [];
}
