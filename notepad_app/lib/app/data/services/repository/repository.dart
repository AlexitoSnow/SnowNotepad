import '../../models/folder.dart';
import '../../models/note.dart';
import '../../models/user.dart';
import '../../provider/db.dart';

class Repository {
  static Repository? _instance;

  User? _currentUser;

  Repository._() {
    _currentUser = null;
  }

  static Repository getInstance() {
    _instance = _instance ?? Repository._();
    return _instance!;
  }

  String? get username => _currentUser?.username;

  int? get userId => _currentUser?.id;

  String? get email => _currentUser?.email;

  String? get password => _currentUser?.password;

  Future<bool> login(
      {required String username, required String password}) async {
    final User? user = await DatabaseProvider.findUser(username, password);
    if (user == null) return false;
    _currentUser = user;
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  Future<void> updateUser(String field, String value) async {
    if (_currentUser == null) return;
    switch (field) {
      case 'username':
        _currentUser!.username = value;
        break;
      case 'email':
        _currentUser!.email = value;
        break;
      case 'password':
        _currentUser!.password = value;
        break;
      default:
        return;
    }
    await DatabaseProvider.updateUser(_currentUser!);
  }

  Future<bool> searchUserBy(String type, String value) async {
    User? user;
    type = type.toLowerCase().trim();
    if (type == 'username') {
      user = await DatabaseProvider.filterUserBy(type, value);
    } else if (type == 'email') {
      user = await DatabaseProvider.filterUserBy(type, value);
    }
    return user != null;
  }

  Future<bool> register(
      {required String username,
      required String password,
      required String email}) async {
    // Se cancela el registro si el usuario ya existe
    if (await searchUserBy('username', username) ||
        await searchUserBy('email', email)) return false;

    // Creamos el usuario
    User user = User(username: username, password: password, email: email);
    await DatabaseProvider.insertUser(user);

    // Recuperamos el usuario creado
    _currentUser = (await DatabaseProvider.findUser(username, password))!;

    // Creamos la carpeta principal del usuario
    MFolder mainFolder = MFolder(
        title: '$username main folder',
        parentId: null,
        id: null,
        userId: _currentUser!.id!);
    await DatabaseProvider.insertFolder(mainFolder);
    return true;
  }

  Future<MFolder?> getMainFolder() async {
    int id = _currentUser!.id ?? -1;
    if (id == -1) return null;
    final MFolder? mainFolder = await DatabaseProvider.mainFolder(id);
    return mainFolder;
  }

  Future<List<MFolder>?> getFoldersOf(int parentFolderId) async {
    return await DatabaseProvider.folders(parentFolderId);
  }

  Future<List<MNote>?> getNotesOf(int parentFolderId) async {
    return await DatabaseProvider.notes(parentFolderId);
  }

  /// Update or Insert the folders into the database
  Future<void> updateOrInsertFolders(List<MFolder> folders) async {
    for (var folder in folders) {
      final MFolder? f = await DatabaseProvider.folder(folder.id!);
      if (f != null) {
        updateFolder(folder);
      } else {
        insertFolder(folder);
      }
    }
  }

  Future<void> updateOrInsertNotes(List<MNote> notes) async {
    for (var note in notes) {
      final MNote? n = await DatabaseProvider.note(note.id!);
      if (n != null) {
        updateNote(note);
      } else {
        insertNote(note);
      }
    }
  }

  /// Insert a new folder into the database
  /// Return the folder with the id assigned by the database
  Future<MFolder> insertFolder(MFolder folder) async {
    return await DatabaseProvider.insertFolder(folder);
  }

  /// Insert a new note into the database
  /// Return the note with the id assigned by the database
  Future<MNote> insertNote(MNote note) async {
    return await DatabaseProvider.insertNote(note);
  }

  Future<void> updateNote(MNote note) async {
    await DatabaseProvider.updateNote(note);
  }

  Future<void> updateFolder(MFolder folder) async {
    await DatabaseProvider.updateFolder(folder);
  }

  void deleteNote(MNote note) {
    DatabaseProvider.deleteNote(note);
  }

  void deleteFolder(MFolder folder) {
    DatabaseProvider.deleteFolder(folder);
  }
}
