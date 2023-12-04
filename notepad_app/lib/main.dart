import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/theme_data.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: FormattedTheme.light,
      darkTheme: FormattedTheme.dark,
      debugShowCheckedModeBanner: false,
      title: "Snow's Notepad",
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
    ),
  );
}
