import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

class Sidebar extends StatelessWidget {
  final SidebarXController sideBarController;
  final List<SidebarXItem> items;
  final List<SidebarXItem> footerItems;

  Sidebar(
      {Key? key, List<SidebarXItem>? items, List<SidebarXItem>? footerItems})
      : sideBarController =
            SidebarXController(selectedIndex: 0, extended: true),
        items = items ?? const [],
        footerItems = footerItems ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Get.theme.scaffoldBackgroundColor;
    final accentColor = Get.theme.colorScheme.primary;
    final boxDecoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    );
    final borderRadius = BorderRadius.circular(10);
    final labelColor = Get.isDarkMode ? Colors.white : Colors.black;
    return SidebarX(
        controller: sideBarController,
        theme: SidebarXTheme(
          decoration: boxDecoration,
          textStyle: TextStyle(color: labelColor),
          selectedTextStyle: TextStyle(color: labelColor),
          itemTextPadding: const EdgeInsets.only(left: 10),
          selectedItemTextPadding: const EdgeInsets.only(left: 10),
          itemDecoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: accentColor),
          ),
          selectedItemDecoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: accentColor),
          ),
          iconTheme: IconThemeData(
            color: labelColor.withOpacity(0.7),
            size: 20,
          ),
          selectedIconTheme: IconThemeData(
            color: labelColor.withOpacity(0.7),
            size: 20,
          ),
        ),
        extendedTheme: SidebarXTheme(
          width: 200,
          decoration: boxDecoration,
        ),
        items: items,
        footerItems: footerItems);
  }
}
