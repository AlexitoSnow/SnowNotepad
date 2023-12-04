import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/repository/repository.dart';

class SettingsController extends GetxController {
  Repository repo = Repository.getInstance();

  final _username = ''.obs;
  final _email = ''.obs;
  final _password = ''.obs;

  @override
  void onInit() {
    _username.value = repo.username!;
    _email.value = repo.email!;
    _password.value = repo.password!;
    super.onInit();
  }

  String get name => _username.value;

  String get email => _email.value;

  String get password => _password.value;

  changeName() {
    Get.defaultDialog(
      title: 'Change name',
      content: TextField(
        controller: TextEditingController(text: _username.value),
        onChanged: (value) => _username.value = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            repo.updateUser('username', _username.value);
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  changePassword() {
    Get.defaultDialog(
      title: 'Change password',
      content: TextField(
        controller: TextEditingController(),
        onChanged: (value) => _password.value = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            repo.updateUser('password', _password.value);
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  changeEmail() {
    Get.defaultDialog(
      title: 'Change email',
      content: TextField(
        controller: TextEditingController(text: _email.value),
        onChanged: (value) => _email.value = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            repo.updateUser('email', _email.value);
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
