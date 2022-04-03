import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:yuruli/model/entity/todo.dart';

class TodoDatabase {
  final String _tableName = 'Todo';
  final String _columnId = 'id';
  final String _columnTitle = 'title';
  final String _columnScore = 'score';
  final String _columnState = 'state';
  final String _columnCreatedAt = 'createdAt';

  var _database; // <Database>

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    // const scripts = []; // マイグレーション時のバージョン毎の変化

    return openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
      onUpgrade: _upgradeTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    String sql = ''' 
      CREATE TABLE $_tableName(
        $_columnId TEXT PRIMARY KEY,
        $_columnTitle TEXT,
        $_columnScore NUMBER,
        $_columnState TEXT,
        $_columnCreatedAt TEXT
      )
    ''';
    return await db.execute(sql);
  }

  Future<void> _upgradeTable(
      Database db, int oldVersion, int newVersion) async {
    String sql = ''' ''';
    return await db.execute(sql);
  }

  Future<List<Todo>> loadTodos(String state) async {
    final db = await database;
    var maps = await db.query(
      _tableName,
      orderBy: '$_columnScore DESC',
      where: '$_columnState = ?',
      whereArgs: [state],
    );

    if (maps.isEmpty) return [];

    return maps.map((elm) => fromMap(elm)).toList();
  }

  Future insert(Todo todo) async {
    final db = await database;
    return await db.insert(_tableName, toMap(todo));
  }

  Future update(Todo todo) async {
    final db = await database;
    return await db.update(
      _tableName,
      toMap(todo),
      where: '$_columnId = ?',
      whereArgs: [todo.id],
    );
  }

  Future delete(Todo todo) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [todo.id],
    );
  }

  Map<String, dynamic> toMap(Todo todo) {
    return {
      _columnId: todo.id,
      _columnTitle: todo.title,
      _columnScore: todo.score,
      _columnState: todo.state,
      _columnCreatedAt: todo.createdAt.toUtc().toIso8601String(),
    };
  }

  Todo fromMap(Map<String, dynamic> json) {
    return Todo(
      id: json[_columnId],
      title: json[_columnTitle],
      score: json[_columnScore],
      state: json[_columnState],
      createdAt: DateTime.parse(json[_columnCreatedAt]).toLocal(),
    );
  }
}
