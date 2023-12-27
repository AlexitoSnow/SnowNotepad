import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../global/icon_widget.dart';
import '../../../global/snackbar_widget.dart';
import '../../../global/textformfield_widget.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailValidatorKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
        onSubmitted: login,
      ),
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
            onPressed: openRecoveryPassword,
            child: const Text(
              'Forgot password?',
            )),
      ),
      Obx(() => controller.isProcessing
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1.0,
              ),
            )
          : Center(
              child: ElevatedButton(
                onPressed: controller.isProcessing ? null : login,
                child: const Text('Login'),
              ),
            )),
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text("Don't have an account?"),
          Obx(
            () => TextButton(
              onPressed:
                  controller.isProcessing ? null : controller.goToRegister,
              child: const Text('Register'),
            ),
          ),
        ],
      ),
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

  void openRecoveryPassword() {
    Get.bottomSheet(
      Container(
        color: Get.theme.bottomSheetTheme.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: emailValidatorKey,
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                },
              ),
              ElevatedButton(
                onPressed: processRecovery,
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void processRecovery() async {
    if (!emailValidatorKey.currentState!.validate()) {
      const FormattedSnackbar(
              'Not a valid email', 'This email has not a valid format')
          .showSnackbar();
      return;
    }
    String? temporaryPassword =
        await controller.sendRecoveryPassword(emailController.text);
    if (temporaryPassword != null) {
      Get.defaultDialog(
          title: 'Temporary password',
          middleText: 'Please change your password after login',
          content:
              SelectableText('Your temporary password is: $temporaryPassword'),
          textConfirm: 'Thanks',
          onConfirm: Get.back);
    } else {
      const FormattedSnackbar(
              'Error', 'Email not found, please check your email')
          .showSnackbar();
    }
  }
}