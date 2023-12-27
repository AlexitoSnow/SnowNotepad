import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarController extends GetxController {
  final _isDark =
      Get.theme.brightness == Brightness.dark ? true.obs : false.obs;
  final _themeModeIcon = Get.theme.brightness == Brightness.dark
      ? const Icon(Icons.dark_mode).obs
      : const Icon(Icons.light_mode).obs;

  bool get isDark => _isDark.value;

  Icon get themeModeIcon => _themeModeIcon.value;

  set isDark(bool value) => _isDark.value = value;

  void changeThemeMode() {
    _isDark.value = !_isDark.value;
    _themeModeIcon.value = _isDark.value
        ? const Icon(Icons.dark_mode)
        : const Icon(Icons.light_mode);
    Get.changeThemeMode(_isDark.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }
}
