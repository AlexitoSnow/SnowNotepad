// ignore_for_file: overridden_fields
import 'package:admob_flutter/admob_flutter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../../data/models/folder.dart';
import '../../../data/models/item.dart';
import '../../../data/models/note.dart';
import '../../../global/appbar/appbar_widget.dart';
import '../../../global/sidebar.dart';
import '../../../global/textformfield_widget.dart';
import '../../../routes/app_pages.dart';
import '../../note/views/note_view.dart';
import '../controllers/folders_controller.dart';
import 'card_widget.dart';
import 'custom_dialogs.dart';

class FoldersView extends StatelessWidget {
  final String title;
  final FoldersController controller;

  FoldersView(Folder parentFolder, {Key? key})
      : controller = Get.put(FoldersController(parentFolder.id!),
            tag: parentFolder.id.toString()),
        title =
            parentFolder.parentId == null ? 'Dashboard' : parentFolder.title,
        super(key: key);

  void askForNewFolder() {
    createNewCard(
      'New Folder',
      Icons.create_new_folder,
      'Note title',
      (String value) => controller.addFolder(title: value),
    );
  }

  void askForNewNote() {
    createNewCard(
      'New note',
      Icons.note_add,
      'Note title',
      (String value) => controller.addNote(title: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      IconButton(
          tooltip: 'Add folder',
          icon: const Icon(Icons.create_new_folder),
          onPressed: askForNewFolder),
      IconButton(
          tooltip: 'Add note',
          icon: const Icon(Icons.note_add),
          onPressed: askForNewNote),
    ];
    return Scaffold(
      appBar: FormattedAppBar().build(Text(title), actions: actions),
      drawer: drawer(),
      body: GestureDetector(
        onTap: clearSelection,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(() {
                  switch (controller.currentIndex) {
                    case 0:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          folders(),
                          notes(),
                        ],
                      );
                    case 1:
                      return folders();
                    case 2:
                      return notes();
                    default:
                      return const Center(
                        child: Text('No page found'),
                      );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => cardOptions(),
      ),
      persistentFooterButtons: [
        Container(
          constraints: const BoxConstraints.expand(height: 50),
          child: AdmobBanner(
            adUnitId: controller.adId,
            adSize: AdmobBannerSize.BANNER,
          ),
        ),
      ],
    );
  }

  Visibility cardOptions() {
    var buttons = [
      IconButton(
        tooltip: 'Delete card',
        onPressed: () => CustomDialogs.deleteDialog(onDelete: () {
          controller.deleteCard();
          clearSelection();
        }),
        icon: const Icon(Icons.delete),
      ),
      IconButton(
        tooltip: 'Edit card',
        onPressed: editSelectedCard,
        icon: const Icon(Icons.edit),
      ),
      if (controller.selectedNote != -1)
        IconButton(
          tooltip: 'Share note',
          onPressed: controller.shareNote,
          icon: const Icon(Icons.share),
        ),
      if (controller.selectedNote != -1)
        IconButton(
          tooltip: 'Export to TXT',
          onPressed: controller.saveTxtFile,
          icon: const Icon(Icons.text_snippet_outlined),
        ),
    ];
    return Visibility(
      visible: controller.isCardSelected,
      child: BottomAppBar(
          padding: const EdgeInsets.only(bottom: 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons,
          )),
    );
  }

  void clearSelection() {
    controller.isCardSelected = false;
    controller.selectedFolder = -1;
    controller.selectedNote = -1;
  }

  FormattedCard createFolderCard(Item folder) {
    Folder ensureFolder = folder as Folder;
    return FormattedCard(
        keyId: ensureFolder.id!,
        title: ensureFolder.title,
        leading: const Icon(Icons.create_new_folder),
        backgroundColor: cardColor,
        selectedColor: cardSelectedColor,
        onTap: () async {
          clearSelection();
          Get.toNamed(Routes.SPLASH);
          Get.off(() => FoldersView(ensureFolder));
        },
        selected: controller.selectedFolder == ensureFolder.id!,
        onLongPress: () {
          controller.toggleFolderSelected(ensureFolder.id!);
        },
        width: cardWidth);
  }

  void createNewCard(
    String title,
    IconData icon,
    String labelText,
    Function(String) onAdd,
  ) {
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
      textCancel: 'Cancel',
      onConfirm: onConfirm,
      onCancel: Get.back,
    );
  }

  FormattedCard createNoteCard(Item note) {
    Note ensureNote = note as Note;
    const height = 80.0;
    return FormattedCard(
        keyId: ensureNote.id!,
        title: ensureNote.title,
        subtitle: ensureNote.content,
        selected: controller.selectedNote == ensureNote.id!,
        leading: const Icon(Icons.note),
        backgroundColor: cardColor,
        selectedColor: cardSelectedColor,
        onTap: () {
          clearSelection();
          Get.to(() => NoteView(ensureNote));
        },
        onLongPress: () {
          controller.toggleNoteSelected(ensureNote.id!);
        },
        width: cardWidth,
        height: height);
  }

  Sidebar drawer() {
    return Sidebar(
      items: [
        SidebarXItem(
          icon: Icons.widgets,
          label: 'Dashboard',
          onTap: () {
            controller.currentIndex = 0;
            Get.back();
          },
        ),
        SidebarXItem(
          icon: Icons.folder,
          label: 'Folders',
          onTap: () {
            controller.currentIndex = 1;
            Get.back();
          },
        ),
        SidebarXItem(
          icon: Icons.note,
          label: 'Notes',
          onTap: () {
            controller.currentIndex = 2;
            Get.back();
          },
        ),
      ],
      footerItems: [
        SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () {
            Get.back();
            Get.toNamed(Routes.SETTINGS);
          },
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'Logout',
          onTap: () {
            Get.back();
            controller.logout();
          },
        ),
      ],
    );
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

    CustomDialogs.editDialog(
      controller: editController,
      onEdit: () {
        controller.editCard(editController.text.trim());
        clearSelection();
      },
    );
  }

  Widget emptySignal(
      {required void Function()? onPressed, required String type}) {
    return TextButton(
      onPressed: onPressed,
      child: DottedBorder(
        color: Get.theme.primaryColor,
        strokeWidth: 1,
        dashPattern: const [5, 5],
        child: Container(
          margin: const EdgeInsets.all(10),
          width: screenWidth,
          child: Align(
              alignment: Alignment.center,
              child: Text("No $type added.\nClick to add one.")),
        ),
      ),
    );
  }

  ExpansionTile folders() {
    return sectionOf(
      title: 'Folders',
      icon: Icons.create_new_folder,
      iconAction: askForNewFolder,
      items: controller.folders,
      createCard: createFolderCard,
    );
  }

  ExpansionTile notes() {
    return sectionOf(
        title: 'Notes',
        icon: Icons.note_add,
        iconAction: askForNewNote,
        items: controller.notes,
        createCard: createNoteCard);
  }

  ExpansionTile sectionOf({
    required String title,
    required IconData icon,
    required Function() iconAction,
    required List<Item> items,
    required FormattedCard Function(Item) createCard,
  }) {
    return ExpansionTile(
      expandedAlignment: Alignment.topLeft,
      initiallyExpanded: true,
      trailing: IconButton(
        icon: Icon(icon),
        onPressed: iconAction,
      ),
      title: Text(title),
      children: <Widget>[
        Obx(() {
          if (items.isEmpty) {
            return emptySignal(onPressed: iconAction, type: title);
          } else {
            return wrapOf(children: items, createCard: createCard);
          }
        }),
      ],
    );
  }

  Widget wrapOf(
      {required List<Item> children,
      required FormattedCard Function(Item) createCard}) {
    return Wrap(
        children: children.map<Widget>((item) => createCard(item)).toList());
  }
}

const cardColor = Color.fromARGB(255, 108, 73, 204);
const cardSelectedColor = Color.fromARGB(255, 60, 41, 114);
final screenWidth = Get.width;
final cardWidth = Get.width / 2;
