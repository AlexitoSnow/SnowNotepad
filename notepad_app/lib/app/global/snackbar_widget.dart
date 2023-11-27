import 'package:get/get.dart';

class FormattedSnackbar {
  final String title;
  final String message;
  const FormattedSnackbar(this.title, this.message);

  SnackbarController showSnackbar() {
    return Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      colorText: Get.theme.snackBarTheme.contentTextStyle?.color,
      duration: const Duration(seconds: 1),
    );
  }
}
