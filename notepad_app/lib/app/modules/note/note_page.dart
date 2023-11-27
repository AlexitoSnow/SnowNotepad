// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/note.dart';
import '../../global/appbar/appbar_widget.dart';
import 'note_controller.dart';

class Note extends StatelessWidget {
  late NoteController controller;

  Note(MNote note, {super.key}) {
    controller = Get.put(NoteController(note));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            controller.updateNoteContent();
          })
    ];
    final title = TextField(
      style: const TextStyle(fontSize: 12, color: Colors.white),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
      ),
      controller: controller.titleControl,
      onSubmitted: (value) {
        controller.updateNoteTitle();
      },
      onTapOutside: (value) {
        controller.updateNoteTitle();
      },
    );

    return Scaffold(
      appBar: FormattedAppBar().build(title, actions: actions),
      body: SizedBox(
        height: Get.height,
        child: TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Write your note here...',
          ),
          controller: controller.contentControl,
          maxLines: null,
        ),
      ),
    );
  }
}
