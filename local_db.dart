import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import '../models/job.dart';

class LocalDb {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;

    print('Opening local database…');
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/kaamsetu_local.db';
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    print('Database opened at $path');
    return _db!;
  }

  static Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jobs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        location TEXT NOT NULL,
        salary TEXT,
        skill_required TEXT NOT NULL
      )
    ''');
    print('Jobs table created');
  }

  static Future<List<Job>> fetchJobs() async {
    print('Fetching jobs from local DB');
    final database = await db;
    final maps = await database.query('jobs');
    print('Fetched ${maps.length} jobs');
    return maps.map((map) => Job.fromMap(map)).toList();
  }

  static Future<Job> createJob(Job job) async {
    print('Inserting job: ${job.title}');
    final database = await db;
    final id = await database.insert('jobs', job.toMap());
    print('Inserted job with id $id');
    return job.copyWith(id: id);
  }
}
