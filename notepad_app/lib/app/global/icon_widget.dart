import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/launch-icon.png',
      height: height,
    );
  }
}
