import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/note.dart';
import '../../../data/services/repository/repository.dart';
import 'package:filesaverz/filesaverz.dart';

class NoteController extends GetxController {
  final TextEditingController contentControl = TextEditingController();
  final TextEditingController titleControl = TextEditingController();
  late Rx<Note> note;
  final Repository repo = Repository.getInstance();

  NoteController(Note note) {
    this.note = Rx<Note>(note);
    contentControl.text = note.content;
    titleControl.text = note.title;
  }

  String get title => note.value.title;

  void updateNoteTitle() async {
    note.value.title = titleControl.text.trim();
    repo.updateNote(note.value);
  }

  void updateNoteContent() async {
    note.value.content = contentControl.text;
    repo.updateNote(note.value);
  }

  Future<void> saveTxtFile() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        openAppSettings();
      }
    }
    if (status.isGranted) {
      FileSaver fileSaver = FileSaver(
        fileTypes: const ['txt'],
        initialFileName: titleControl.text,
        style: FileSaverStyle(
          primaryColor: Get.theme.primaryColor,
          secondaryColor: Get.theme.colorScheme.background,
          secondaryTextStyle: const TextStyle(color: Colors.white),
        ),
      );
      await fileSaver.writeAsString(
        contentControl.text,
        context: Get.context!,
      );
    }
    Get.back();
  }

  void shareNote() {
    Share.share(contentControl.text, subject: titleControl.text);
  }
}
