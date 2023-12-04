import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/snackbar_widget.dart';
import '../../../global/textformfield_widget.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headerSection(MediaQuery.of(context).size.height * 0.3),
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
              onSubmitted: login,
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
                  onSubmitted: login,
                  obscureText: controller.showPassword,
                )),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: goToRecovery,
                  child: const Text(
                    'Forgot password?',
                  )),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: controller.goToRegister,
                    child: const Text('Register'))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget headerSection(double height) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 40.0),
      alignment: Alignment.centerLeft,
      color: Get.theme.primaryColor,
      width: double.infinity,
      height: height,
      child: const Text(
        "Welcome to\nSnow's Notepad",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          height: 2,
        ),
      ),
    );
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      const FormattedSnackbar('Warning', 'Please fill in the required fields')
          .showSnackbar();
    } else {
      if (!await controller.login()) {
        const FormattedSnackbar('Error', 'Username or password is incorrect')
            .showSnackbar();
      }
    }
  }

  void goToRecovery() {
    var emailController = TextEditingController();
    Get.bottomSheet(
      Container(
        color: Get.theme.bottomSheetTheme.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Password recovery',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            FormattedTextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              labelText: 'Email',
              helperText:
                  "If you have an account with this email, we'll send you a link",
              prefixIcon: Icons.mail,
            ),
            ElevatedButton(
              onPressed: () async {
                if (await controller
                    .sendRecoveryPassword(emailController.text)) {
                  const FormattedSnackbar('Success',
                          'We have sent you an email with a link to reset your password')
                      .showSnackbar();
                } else {
                  const FormattedSnackbar(
                          'Error', 'Email not found, please check your email')
                      .showSnackbar();
                }
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
