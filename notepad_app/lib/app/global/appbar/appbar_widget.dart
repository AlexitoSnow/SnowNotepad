import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/repository/repository.dart';
import 'app_bar_controller.dart';

class FormattedAppBar {
  static final AppBarController appBarController = Get.put(AppBarController());
  final Repository repo = Repository.getInstance();

  AppBar build(
    Widget title, {
    List<Widget>? actions,
    Widget? leading,
    List<PopupMenuItem<String>>? moreActions,
  }) {
    actions = actions ?? [];
    var popUpActions = <PopupMenuEntry<String>>[];
    if (moreActions != null) {
      for (var additionalAction in moreActions) {
        popUpActions.add(additionalAction);
      }
    }
    actions.addAll([
      Obx(() => IconButton(
          tooltip: 'Change theme mode',
          onPressed: appBarController.changeThemeMode,
          icon: appBarController.themeModeIcon)),
      if (popUpActions.isNotEmpty)
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: 'More options',
          itemBuilder: (BuildContext context) {
            return popUpActions;
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
