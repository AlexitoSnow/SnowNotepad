import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/appbar/appbar_widget.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FormattedAppBar().build(const Text('Settings')),
      body: Center(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            ListTile(
              title: const Text('Username'),
              subtitle: Obx(
                () => Text(controller.name),
              ),
              leading: const Icon(Icons.person),
              trailing: const Icon(Icons.edit),
              onTap: () => controller.changeName(),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Obx(
                () => Text(controller.email),
              ),
              leading: const Icon(Icons.email),
              trailing: const Icon(Icons.edit),
              onTap: () => controller.changeEmail(),
            ),
            ListTile(
              title: const Text('Password'),
              subtitle: const Text('********'),
              leading: const Icon(Icons.lock),
              trailing: const Icon(Icons.edit),
              onTap: () => controller.changePassword(),
            ),
          ],
        ),
      ),
    );
  }
}
