import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

class Sidebar extends StatelessWidget {
  final SidebarXController sideBarController;
  final List<SidebarXItem> items;
  final List<SidebarXItem> footerItems;
  final backgroundColor = Get.theme.scaffoldBackgroundColor;
  final primaryColor = Get.theme.primaryColor;
  final accentColor = Get.theme.colorScheme.primary;

  Sidebar(
      {Key? key, List<SidebarXItem>? items, List<SidebarXItem>? footerItems})
      : sideBarController =
            SidebarXController(selectedIndex: 0, extended: true),
        items = items ?? const [],
        footerItems = footerItems ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    );
    final borderRadius = BorderRadius.circular(10);
    final divider = Divider(color: Colors.white.withOpacity(0.3), height: 1);

    return SidebarX(
      controller: sideBarController,
      theme: SidebarXTheme(
        decoration: boxDecoration,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 10),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: accentColor),
        ),
        selectedItemDecoration: BoxDecoration(
          color: primaryColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: accentColor,
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: boxDecoration,
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 100,
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: FlutterLogo(size: 50),
              )),
        );
      },
      items: items,
      footerItems: footerItems,
    );
  }
}
