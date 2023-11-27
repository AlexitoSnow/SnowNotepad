import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/snackbar_widget.dart';
import '../../global/textformfield_widget.dart';
import 'register_controller.dart';

class Register extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headerSection(),
            formSection(),
          ],
        ),
      ),
    );
  }

  Widget formSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            FormattedTextFormField(
              controller: controller.usernameControl,
              keyboardType: TextInputType.name,
              labelText: 'Username',
              prefixIcon: Icons.person,
              onSubmitted: register,
            ),
            const SizedBox(height: 16.0),
            FormattedTextFormField(
              controller: controller.emailControl,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Email',
              prefixIcon: Icons.mail,
              onSubmitted: register,
              validator: (value) {
                if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email';
                }
              },
            ),
            const SizedBox(height: 16.0),
            Obx(() => FormattedTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: controller.passwordControl,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  suffixIcon: IconButton(
                      onPressed: controller.toggleShowPassword,
                      icon: Icon(controller.iconPassword)),
                  onSubmitted: register,
                  obscureText: controller.showPassword,
                )),
            const SizedBox(height: 16.0),
            Obx(() => FormattedTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: controller.confirmPasswordControl,
                  labelText: 'Confirm password',
                  prefixIcon: Icons.lock,
                  suffixIcon: IconButton(
                      onPressed: controller.toggleShowPassword,
                      icon: Icon(controller.iconPassword)),
                  onSubmitted: register,
                  obscureText: controller.showPassword,
                  validator: (value) {
                    if (value != controller.passwordControl.text) {
                      return 'Passwords do not match';
                    }
                  },
                )),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: register,
              child: const Text('Register now!'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                    onPressed: controller.goToLogin, child: const Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 40.0),
      alignment: Alignment.centerLeft,
      color: Get.theme.primaryColor,
      width: double.infinity,
      height: Get.height * 0.3,
      child: const Text(
        "Welcome to\nSnow's Notepad\nRegister here!",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      await controller.register()
          ? FormattedSnackbar('Welcome',
                  'You are logged in as ${controller.usernameControl.text.trim()}')
              .showSnackbar()
          : const FormattedSnackbar('Error', 'Username or email already exists')
              .showSnackbar();
    } else {
      const FormattedSnackbar('Warning', 'Please fill in the required fields')
          .showSnackbar();
    }
  }
}
