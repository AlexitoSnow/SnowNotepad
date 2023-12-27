import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notepad_app/app/global/textformfield_widget.dart';

import '../../../data/services/repository/repository.dart';

class SettingsController extends GetxController {
  Repository repo = Repository.getInstance();
  final TextEditingController _oldPasswordControl = TextEditingController();
  final TextEditingController _newPasswordControl = TextEditingController();
  final _username = ''.obs;
  final _email = ''.obs;
  final _oldPassword = ''.obs;
  final _newPassword = ''.obs;

  @override
  void onInit() {
    _username.value = repo.username!;
    _email.value = repo.email!;
    _oldPassword.value = repo.password!;
    super.onInit();
  }

  String get name => _username.value;

  String get email => _email.value;

  String get password => _oldPassword.value;

  String get newPassword => _newPassword.value;

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

  changePassword() async {
    debugPrint(_oldPassword.value);
    var globalKey = GlobalKey<FormState>();
    if (await requestLocalAuth() == false) return;
    Get.defaultDialog(
      title: 'Change password',
      content: Form(
        key: globalKey,
        child: Column(
          children: [
            FormattedTextFormField(
              keyboardType: TextInputType.text,
              labelText: 'Old password',
              controller: _oldPasswordControl,
              validator: (value) {
                if (value != _oldPassword.value) {
                  return 'Incorrect password';
                }
                return null;
              },
            ),
            const Gap(10),
            FormattedTextFormField(
              labelText: 'New password',
              controller: _newPasswordControl,
              validator: (value) {
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
      textCancel: 'Cancel',
      textConfirm: 'Save',
      onConfirm: () {
        if (globalKey.currentState!.validate()) {
          _newPassword.value = _newPasswordControl.text;
          repo.updateUser('password', _newPassword.value);
          debugPrint(_newPassword.value);
          Get.back();
        }
      },
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

  Future<bool> requestLocalAuth() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = await auth.authenticate(
      localizedReason: 'Verify your identity to change your password',
      options: const AuthenticationOptions(
        stickyAuth: true,
      ),
    );
    return authenticated;
  }
}
