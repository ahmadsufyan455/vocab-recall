import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'vocab_recall.db');

  return openDatabase(
    path,
    version: 2,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE words (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word TEXT NOT NULL,
          meaning TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
    ''');

      await db.execute('''
        CREATE TABLE reviews (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_id INTEGER NOT NULL,
          reviewed_at TEXT NOT NULL,
          next_review_date TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE app_settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS app_settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
      }
    },
  );
}

Future<void> insertWord(String word, String meaning) async {
  final db = await openDb();
  await db.insert('words', {
    'word': word,
    'meaning': meaning,
    'created_at': DateTime.now().toIso8601String(),
  });
}

Future<List<Map<String, dynamic>>> getWords() async {
  final db = await openDb();
  return db.rawQuery('''
    SELECT w.id, w.word, w.meaning
      FROM words w
      LEFT JOIN reviews r
        ON w.id = r.word_id
      WHERE r.id IS NULL
        OR r.next_review_date <= DATE('now')
  ''');
}

Future<void> submitReview(int wordId) async {
  final db = await openDb();

  final today = DateTime.now();
  final todayDate =
      "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  final tomorrow = today.add(Duration(days: 1));
  final tomorrowDate =
      "${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}";

  await db.insert('reviews', {
    'word_id': wordId,
    'reviewed_at': todayDate,
    'next_review_date': tomorrowDate,
  });
}

Future<DateTime?> getFirstWordCreatedAt() async {
  final db = await openDb();
  final result = await db.rawQuery('''
    SELECT created_at FROM words
    ORDER BY created_at ASC
    LIMIT 1
  ''');

  if (result.isEmpty) {
    return null;
  }

  final createdAtString = result.first['created_at'] as String;
  return DateTime.parse(createdAtString);
}

Future<DateTime?> getLastDay7TestCompletedAt() async {
  final db = await openDb();
  final result = await db.rawQuery('''
    SELECT value FROM app_settings
    WHERE key = 'last_day7_test_completed_at'
    LIMIT 1
  ''');

  if (result.isEmpty) {
    return null;
  }

  final dateString = result.first['value'] as String;
  return DateTime.parse(dateString);
}

Future<void> setLastDay7TestCompletedAt(DateTime date) async {
  final db = await openDb();
  await db.insert('app_settings', {
    'key': 'last_day7_test_completed_at',
    'value': date.toIso8601String(),
  }, conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<DateTime?> getCycleStartDate() async {
  final lastTestDate = await getLastDay7TestCompletedAt();
  if (lastTestDate != null) {
    return lastTestDate;
  }
  return await getFirstWordCreatedAt();
}

Future<void> resetDatabaseForNewCycle() async {
  final db = await openDb();
  await db.delete('words');
  await db.delete('reviews');
  // Keep app_settings intact so the cycle tracking continues
}
