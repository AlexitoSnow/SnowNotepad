// ignore_for_file: overridden_fields

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/folder.dart';
import '../../../data/models/note.dart';
import '../../../global/appbar/appbar_widget.dart';
import '../../../global/textformfield_widget.dart';
import '../../../routes/app_pages.dart';
import '../../note/views/note_view.dart';
import '../controllers/folders_controller.dart';
import 'card_widget.dart';
import 'delete_dialog.dart';
import 'edit_dialog.dart';

class FoldersView extends GetView<FoldersController> {
  final String title;
  final cardColor = const Color.fromARGB(255, 108, 73, 204);
  final cardSelectedColor = const Color.fromARGB(255, 60, 41, 114);
  final screenWidth = Get.width;
  final cardWidth = Get.width / 2;
  @override
  final String tag;

  FoldersView(Folder parentFolder, {Key? key})
      : tag = parentFolder.id!.toString(),
        title =
            parentFolder.parentId == null ? 'Dashboard' : parentFolder.title,
        super(key: key);

  IconButton actionButton(IconData icon, String label, Function() onPressed) {
    return IconButton(
        icon: Column(
          children: [
            Icon(icon),
            Text(label),
          ],
        ),
        onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      IconButton(
          tooltip: 'Add folder',
          icon: const Icon(Icons.create_new_folder),
          onPressed: createNewFolder),
      IconButton(
          tooltip: 'Add note',
          icon: const Icon(Icons.note_add),
          onPressed: createNewNote),
    ];
    return Scaffold(
        appBar: FormattedAppBar().build(Text(title), actions: actions),
        body: GestureDetector(
          onTap: clearSelection,
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ExpansionTile(
                    expandedAlignment: Alignment.topLeft,
                    initiallyExpanded: true,
                    trailing: IconButton(
                        icon: const Icon(Icons.create_new_folder),
                        onPressed: createNewFolder),
                    title: const Text('Folders'),
                    children: <Widget>[
                      Obx(() => emptyfolderSignal()),
                      Obx(() => foldersSection()),
                    ],
                  ),
                  ExpansionTile(
                    expandedAlignment: Alignment.topLeft,
                    initiallyExpanded: true,
                    trailing: IconButton(
                        icon: const Icon(Icons.note_add),
                        onPressed: createNewNote),
                    title: const Text('Notes'),
                    children: <Widget>[
                      Obx(() => emptyNoteSignal()),
                      Obx(() => notesSection()),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(() => cardOptionsSection()));
  }

  void clearSelection() {
    controller.isCardSelected = false;
    controller.selectedFolder = -1;
    controller.selectedNote = -1;
  }

  Visibility cardOptionsSection() {
    return Visibility(
      visible: controller.isCardSelected,
      child: BottomAppBar(
          padding: const EdgeInsets.only(bottom: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              actionButton(Icons.delete, 'Delete', deleteSelectedCard),
              actionButton(Icons.edit, 'Edit', editSelectedCard),
            ],
          )),
    );
  }

  FormattedCard createFolderCard(Folder folder) {
    return FormattedCard(
        keyId: folder.id!,
        title: folder.title,
        leading: const Icon(Icons.folder),
        backgroundColor: cardColor,
        selectedColor: cardSelectedColor,
        onTap: () async {
          clearSelection();
          Get.toNamed(Routes.SPLASH);
          Get.off(() => FoldersView(folder));
        },
        selected: controller.selectedFolder == folder.id!,
        onLongPress: () {
          controller.toggleFolderSelected(folder.id!);
        },
        width: cardWidth);
  }

  void createNewCard(
      String title, IconData icon, String labelText, Function(String) onAdd) {
    final controller = TextEditingController(text: title);
    onConfirm() {
      final title = controller.text.trim();
      onAdd(title);
      Get.back();
    }

    Get.defaultDialog(
        title: title,
        content: FormattedTextFormField(
            prefixIcon: icon,
            keyboardType: TextInputType.text,
            labelText: labelText,
            controller: controller,
            onSubmitted: onConfirm),
        textConfirm: 'Add',
        onConfirm: onConfirm);
  }

  void createNewFolder() {
    createNewCard(
        'New folder ${controller.folders.length + 1}',
        Icons.create_new_folder,
        'Folder name',
        (String value) => controller.addFolder(title: value));
  }

  void createNewNote() {
    createNewCard('New note ${controller.notes.length + 1}', Icons.note_add,
        'Note title', (String value) => controller.addNote(title: value));
  }

  FormattedCard createNoteCard(Note note) {
    const height = 80.0;
    return FormattedCard(
        keyId: note.id!,
        title: note.title,
        subtitle: note.content,
        selected: controller.selectedNote == note.id!,
        leading: const Icon(Icons.note),
        backgroundColor: cardColor,
        selectedColor: cardSelectedColor,
        onTap: () {
          clearSelection();
          Get.to(() => NoteView(note));
        },
        onLongPress: () {
          controller.toggleNoteSelected(note.id!);
        },
        width: cardWidth,
        height: height);
  }

  void deleteSelectedCard() {
    Get.dialog(DeleteAlertDialog(onDelete: () {
      controller.deleteCard();
      clearSelection();
    }));
  }

  void editSelectedCard() {
    final oldTitle = controller.selectedFolder != -1
        ? controller.folders
            .firstWhere((element) => element.id == controller.selectedFolder)
            .title
        : controller.notes
            .firstWhere((element) => element.id == controller.selectedNote)
            .title;
    var editController = TextEditingController(text: oldTitle);

    Get.dialog(EditAlertDialog(
      controller: editController,
      onEdit: () {
        controller.editCard(editController.text.trim());
        clearSelection();
      },
    ));
  }

  Visibility emptyfolderSignal() {
    return Visibility(
        visible: controller.folders.isEmpty,
        child: TextButton(
          onPressed: () => controller.addFolder(),
          child: DottedBorder(
            color: Get.theme.primaryColor,
            strokeWidth: 1,
            dashPattern: const [5, 5],
            child: Container(
                width: screenWidth,
                margin: const EdgeInsets.all(10),
                child: const Align(
                    alignment: Alignment.center,
                    child: Text("No folders added.\nClick to add one."))),
          ),
        ));
  }

  Visibility emptyNoteSignal() {
    return Visibility(
      visible: controller.notes.isEmpty,
      child: TextButton(
        onPressed: () => controller.addNote(),
        child: DottedBorder(
          color: Get.theme.primaryColor,
          strokeWidth: 1,
          dashPattern: const [5, 5],
          child: Container(
            margin: const EdgeInsets.all(10),
            width: screenWidth,
            child: const Align(
                alignment: Alignment.center,
                child: Text("No notes added.\nClick to add one.")),
          ),
        ),
      ),
    );
  }

  Visibility foldersSection() {
    return Visibility(
      visible: controller.folders.isNotEmpty,
      child: Wrap(
          children: controller.folders
              .map((folder) => createFolderCard(folder))
              .toList()),
    );
  }

  Visibility notesSection() {
    return Visibility(
      visible: controller.notes.isNotEmpty,
      child: Wrap(
          children:
              controller.notes.map((note) => createNoteCard(note)).toList()),
    );
  }
}
