import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormattedTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final Function()? onSubmitted;
  final bool obscureText;
  final String? helperText;
  final Function(String)? validator;

  const FormattedTextFormField({
    Key? key,
    this.controller,
    required this.keyboardType,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    this.onSubmitted,
    this.obscureText = false,
    this.helperText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        String? userValidatorMessage;
        if (validator != null) {
          userValidatorMessage = validator!(value!);
        }
        if (userValidatorMessage != null) {
          return userValidatorMessage;
        }
        if (value == null || value.isEmpty) {
          return 'Please complete the required field';
        }
        return null;
      },
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: border,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        helperText: helperText,
      ),
      onFieldSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted!();
        }
      },
      onTapOutside: (v) => Get.focusScope!.unfocus(),
      obscureText: obscureText,
    );
  }
}
