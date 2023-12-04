import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/folder.dart';
import '../models/note.dart';
import '../models/user.dart';

class DatabaseProvider {
  static Future<void> deleteFolder(Folder folder) async {
    final Database database = await _openDB();
    await database.delete(
      'folders',
      where: 'id = ?',
      whereArgs: [folder.id],
    );
    await _deleteFolderAndSubfolders(database, folder.id!);
  }

  static Future<void> deleteNote(Note note) async {
    final Database database = await _openDB();
    await database.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<void> deleteUser(User user) async {
    final Database database = await _openDB();
    await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<User?> filterUserBy(String type, String value) async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query(
      'users',
      where: '$type = ?',
      whereArgs: [value],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]);
    }
    return null;
  }

  static Future<User?> findUser(String username, String password) async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]);
    }
    return null;
  }

  static Future<Folder?> folder(int id) async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query(
      'folders',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Folder.fromMap(maps[0]);
    }
    return null;
  }

  static Future<List<Folder>> folders(int parentId) async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query(
      'folders',
      where: 'parentId = ?',
      whereArgs: [parentId],
    );
    return List.generate(
      maps.length,
      (i) {
        return Folder.fromMap(maps[i]);
      },
    );
  }

  static Future<Folder> insertFolder(Folder folder) async {
    final Database database = await _openDB();
    await database.insert('folders', folder.toMap());
    final List<Map<String, dynamic>> maps = await database.query(
      'folders',
      orderBy: 'id DESC',
      limit: 1,
    );
    return Folder.fromMap(maps[0]);
  }

  static Future<Note> insertNote(Note note) async {
    final Database database = await _openDB();
    await database.insert('notes', note.toMap());
    final List<Map<String, dynamic>> maps = await database.query(
      'notes',
      orderBy: 'id DESC',
      limit: 1,
    );
    return Note.fromMap(maps[0]);
  }

  static Future<void> insertUser(User user) async {
    final Database database = await _openDB();
    await database.insert('users', user.toMap());
  }

  static Future<Folder?> mainFolder(int userId) async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query(
      'folders',
      where: 'userId = ? AND parentId IS NULL',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return Folder.fromMap(maps[0]);
    }
    return null;
  }

  static Future<Note?> note(int id) async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromMap(maps[0]);
    }
    return null;
  }

  static Future<List<Note>> notes(int folderId) async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query(
      'notes',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );
    return List.generate(
      maps.length,
      (i) {
        return Note.fromMap(maps[i]);
      },
    );
  }

  static Future<void> updateFolder(Folder folder) async {
    final Database database = await _openDB();
    await database.update(
      'folders',
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  static Future<void> updateNote(Note note) async {
    final Database database = await _openDB();
    await database.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<void> updateUser(User user) async {
    final Database database = await _openDB();
    await database.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<User?> user(int id) async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]);
    }
    return null;
  }

  static Future<List<User>> users() async {
    final Database database = await _openDB();
    final List<Map<String, dynamic>> maps = await database.query('users');
    return Future.wait(
      maps.map((userMap) async {
        final user = User.fromMap(userMap);
        return user;
      }).toList(),
    );
  }

  static Future<void> _deleteFolderAndSubfolders(
      Database database, int folderId) async {
    final subFolders = await folders(folderId);
    for (var subfolder in subFolders) {
      final subfolderId = subfolder.id!;
      await _deleteFolderAndSubfolders(database, subfolderId);
    }
    await database.delete(
      'notes',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );
  }

  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: _createTables,
      version: 1,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        password TEXT
        )
      ''',
    );
    await db.execute(
      '''
        CREATE TABLE folders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        userId INTEGER,
        parentId INTEGER,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (parentId) REFERENCES folders (id)
        )
      ''',
    );
    await db.execute(
      '''
        CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        folderId INTEGER,
        FOREIGN KEY (folderId) REFERENCES folders (id)
        )
      ''',
    );
  }
}
