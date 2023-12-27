import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../global/icon_widget.dart';
import '../../../global/snackbar_widget.dart';
import '../../../global/textformfield_widget.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(MediaQuery.of(context).size.height * 0.2),
            IconWidget(height: MediaQuery.of(context).size.height * 0.1),
            formSection(),
          ],
        ),
      ),
    );
  }

  Widget formSection() {
    var children = [
      FormattedTextFormField(
        controller: controller.usernameControl,
        keyboardType: TextInputType.name,
        labelText: 'Username',
        prefixIcon: Icons.person,
        onSubmitted: register,
      ),
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
      Center(
        child: ElevatedButton(
          onPressed: register,
          child: const Text('Register now!'),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
              onPressed: controller.goToLogin, child: const Text('Login'))
        ],
      )
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => children[index],
                separatorBuilder: (context, index) => const Gap(16),
                itemCount: children.length),
          ],
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
