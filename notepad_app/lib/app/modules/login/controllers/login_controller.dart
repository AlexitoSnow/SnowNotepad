import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../../../data/services/repository/repository.dart';
import '../../../routes/app_pages.dart';
import '../../folders/views/folders_view.dart';

class LoginController extends GetxController {
  final Repository repo = Repository.getInstance();
  final TextEditingController usernameControl = TextEditingController();
  final TextEditingController passwordControl = TextEditingController();
  final _isProcessing = false.obs;

  bool get isProcessing => _isProcessing.value;

  set isProcessing(bool value) {
    _isProcessing.value = value;
  }

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
    isProcessing = true;
    final username = usernameControl.text.trim();
    final password = passwordControl.text.trim();
    await Future.delayed(const Duration(milliseconds: 500));
    if (!(await repo.login(username: username, password: password))) {
      isProcessing = false;
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

  /// Show your password if you have a local authentication
  Future<String?> sendRecoveryPassword(String email) async {
    Get.back();
    email = email.trim();
    if (await requestLocalAuth()) {
      if (await repo.searchUserBy('email', email)) {
        return repo.createTemporaryPassword(email);
      }
    } else {
      return null;
    }
    return null;
  }

  Future<bool> requestLocalAuth() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = await auth.authenticate(
      localizedReason: 'Verify your identity to recover your password',
      options: const AuthenticationOptions(
        stickyAuth: true,
      ),
    );
    return authenticated;
  }
}
