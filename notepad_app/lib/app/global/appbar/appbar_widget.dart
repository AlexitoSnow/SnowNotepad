import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/repository/repository.dart';
import '../../routes/routes.dart';
import 'app_bar_controller.dart';

class FormattedAppBar {
  static final AppBarController appBarController = Get.put(AppBarController());
  final Repository repo = Repository.getInstance();
  final screenWidth = Get.width;

  AppBar build(
    Widget title, {
    List<Widget>? actions,
    Widget? leading,
    List<PopupMenuItem<String>>? moreActions,
  }) {
    actions = actions ?? [];
    var list = <PopupMenuEntry<String>>[];
    if (moreActions != null) {
      for (var element in moreActions) {
        list.add(element);
      }
    }
    list.add(PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {
          Get.back();
          Get.toNamed(Routes.SETTINGS);
        },
      ),
    ));
    list.add(PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () {
          repo.logout();
          Get.offAllNamed(Routes.LOGIN);
        },
      ),
    ));
    actions.addAll([
      Obx(() => IconButton(
          tooltip: 'Change theme mode',
          onPressed: appBarController.changeThemeMode,
          icon: appBarController.themeModeIcon)),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        tooltip: 'More options',
        itemBuilder: (BuildContext context) {
          return list;
        },
      ),
    ]);
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
    );
  }
}
