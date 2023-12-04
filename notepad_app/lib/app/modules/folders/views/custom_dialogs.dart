import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/textformfield_widget.dart';

abstract class CustomDialogs {
  static editDialog({
    required TextEditingController controller,
    required VoidCallback onEdit,
  }) {
    Get.defaultDialog(
      onConfirm: () {
        Get.back();
        onEdit();
      },
      textCancel: 'Cancel',
      textConfirm: 'Edit',
      title: 'Edit title',
      content: FormattedTextFormField(
        keyboardType: TextInputType.name,
        labelText: 'New title',
        controller: controller,
        onSubmitted: () {
          Get.back();
          onEdit();
        },
      ),
    );
  }

  static deleteDialog({required VoidCallback onDelete}) {
    Get.defaultDialog(
      onConfirm: () {
        Get.back();
        onDelete();
      },
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      title: 'Delete Confirmation',
      middleText: 'Are you sure you want to delete this card?',
    );
  }
}
