import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/textformfield_widget.dart';

class EditAlertDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onEdit;

  const EditAlertDialog(
      {super.key, required this.controller, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit title'),
      content: FormattedTextFormField(
          keyboardType: TextInputType.name,
          labelText: 'New title',
          controller: controller),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              Get.back();
              onEdit();
            },
            child: const Text('Confirm')),
      ],
    );
  }
}
