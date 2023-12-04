import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/repository/repository.dart';
import '../../../routes/app_pages.dart';
import '../../folders/views/folders_view.dart';

class LoginController extends GetxController {
  final Repository repo = Repository.getInstance();
  final TextEditingController usernameControl = TextEditingController();
  final TextEditingController passwordControl = TextEditingController();

  final _showPassword = true.obs;

  final _iconPassword = Icons.visibility_off.obs;

  IconData get iconPassword => _iconPassword.value;

  bool get showPassword => _showPassword.value;

  @override
  void onClose() {
    usernameControl.dispose();
    passwordControl.dispose();
    super.onClose();
  }

  void toggleShowPassword() {
    _showPassword.value = !_showPassword.value;
    _iconPassword.value =
        _showPassword.value ? Icons.visibility_off : Icons.visibility;
  }

  Future<bool> login() async {
    final username = usernameControl.text.trim();
    final password = passwordControl.text.trim();
    if (!(await repo.login(username: username, password: password))) {
      return false;
    }
    final parentFolder = (await repo.getMainFolder())!;
    Get.offAll(() => FoldersView(parentFolder));
    return true;
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
    usernameControl.clear();
    passwordControl.clear();
  }

  /// Send a recovery password to the user email
  /// TODO: Implement this method
  Future<bool> sendRecoveryPassword(String email) async {
    Get.back();
    email = email.trim();
    return repo.searchUserBy('email', email);
  }
}
