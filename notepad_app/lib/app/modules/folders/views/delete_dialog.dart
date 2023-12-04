import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAlertDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteAlertDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: const Text('Are you sure you want to delete this card?'),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              Get.back();
              onDelete();
            },
            child: const Text('Delete')),
      ],
    );
  }
}
