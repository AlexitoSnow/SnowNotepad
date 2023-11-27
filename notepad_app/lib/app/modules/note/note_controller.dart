import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/note.dart';
import '../../data/services/repository/repository.dart';

class NoteController extends GetxController {
  final TextEditingController contentControl = TextEditingController();
  final TextEditingController titleControl = TextEditingController();
  late Rx<MNote> note;
  final Repository repo = Repository.getInstance();

  NoteController(MNote note) {
    this.note = Rx<MNote>(note);
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
}
