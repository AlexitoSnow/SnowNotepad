import 'package:get/get.dart';

import '../../data/models/folder.dart';
import '../../data/models/note.dart';
import '../../data/services/repository/repository.dart';

class FoldersController extends GetxController {
  final int parentFolderId;
  final folders = RxList<MFolder>();
  final notes = RxList<MNote>();
  final Repository repo = Repository.getInstance();
  final _selectedFolder = (-1).obs;
  final _selectedNote = (-1).obs;
  final _isCardSelected = false.obs;

  FoldersController(this.parentFolderId);

  @override
  void onClose() {
    super.onClose();
    folders.clear();
    notes.clear();
  }

  bool get isCardSelected => _isCardSelected.value;

  int get selectedFolder => _selectedFolder.value;

  int get selectedNote => _selectedNote.value;

  set isCardSelected(bool value) {
    _isCardSelected.value = value;
  }

  set selectedFolder(int value) {
    _selectedFolder.value = value;
  }

  set selectedNote(int value) {
    _selectedNote.value = value;
  }

  void toggleFolderSelected(int itemId) {
    selectedFolder = selectedFolder == itemId ? -1 : itemId;
    selectedNote = selectedFolder != -1 ? -1 : selectedNote;
    isCardSelected = selectedFolder != -1;
  }

  void toggleNoteSelected(int itemId) {
    selectedNote = selectedNote == itemId ? -1 : itemId;
    selectedFolder = selectedNote != -1 ? -1 : selectedFolder;
    isCardSelected = selectedNote != -1;
  }

  @override
  void onInit() async {
    super.onInit();
    folders.addAll((await repo.getFoldersOf(parentFolderId))!);
    notes.addAll((await repo.getNotesOf(parentFolderId))!);
  }

  /// Add a new folder into a user folder
  void addFolder({String? title}) async {
    int id = folders.length + 1;
    title = title ?? 'New Folder $id';
    MFolder folder = MFolder(
        id: null, title: title, parentId: parentFolderId, userId: repo.userId!);
    folder = await repo.insertFolder(folder);
    folders.add(folder);
  }

  /// Add a new note into a user folder
  void addNote({String? title}) async {
    int id = notes.length + 1;
    title = title ?? 'New Note $id';
    MNote note = MNote(id: null, title: title, folderId: parentFolderId);
    note = await repo.insertNote(note);
    notes.add(note);
  }

  void deleteCard() {
    if (selectedFolder != -1) {
      final folder =
          folders.firstWhere((element) => element.id == selectedFolder);
      repo.deleteFolder(folder);
      folders.remove(folder);
      selectedFolder = -1;
    } else if (selectedNote != -1) {
      final note = notes.firstWhere((element) => element.id == selectedNote);
      repo.deleteNote(note);
      notes.remove(note);
      selectedNote = -1;
    }
  }

  void editCard(String newTitle) {
    if (selectedFolder != -1) {
      final folder =
          folders.firstWhere((element) => element.id == selectedFolder);
      folder.title = newTitle;
      repo.updateFolder(folder);
      selectedFolder = -1;
    } else if (selectedNote != -1) {
      final note = notes.firstWhere((element) => element.id == selectedNote);
      note.title = newTitle;
      repo.updateNote(note);
      selectedNote = -1;
    }
    update();
  }
}
