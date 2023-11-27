import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/repository/repository.dart';
import '../folders/folders_page.dart';

class RegisterController extends GetxController {
  final Repository repo = Repository.getInstance();
  final TextEditingController usernameControl = TextEditingController();
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passwordControl = TextEditingController();
  final TextEditingController confirmPasswordControl = TextEditingController();

  final _showPassword = true.obs;

  final _iconPassword = Icons.visibility_off.obs;

  IconData get iconPassword => _iconPassword.value;

  bool get showPassword => _showPassword.value;

  @override
  void onClose() {
    usernameControl.dispose();
    emailControl.dispose();
    passwordControl.dispose();
    super.onClose();
  }

  void toggleShowPassword() {
    _showPassword.value = !_showPassword.value;
    _iconPassword.value =
        _showPassword.value ? Icons.visibility_off : Icons.visibility;
  }

  Future<bool> register() async {
    final userName = usernameControl.text.trim();
    final password = passwordControl.text;
    final email = emailControl.text.trim();
    if (!(await repo.register(
        username: userName, password: password, email: email))) {
      return false;
    }
    final parentFolder = (await repo.getMainFolder())!;
    Get.offAll(() => Folders(parentFolder));
    return true;
  }

  void goToLogin() {
    Get.back();
  }
}
