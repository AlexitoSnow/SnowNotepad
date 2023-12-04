import 'package:flutter/material.dart';

class FormattedCard extends StatelessWidget {
  final int keyId;
  final String title;
  final String? subtitle;
  final Widget leading;
  final Color backgroundColor;
  final Color iconColor;
  final Function() onTap;
  final Function()? onLongPress;
  final double width;
  final double height;
  final bool? selected;
  final Color selectedColor;

  FormattedCard(
      {required this.keyId,
      required this.title,
      this.subtitle = '',
      required this.leading,
      required this.backgroundColor,
      this.iconColor = Colors.white,
      required this.onTap,
      this.onLongPress,
      required this.width,
      this.selected = false,
      required this.selectedColor,
      this.height = 70})
      : super(key: ValueKey(keyId));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        child: ListTile(
          selected: selected!,
          selectedTileColor: selectedColor,
          tileColor: backgroundColor,
          title: Text(title),
          subtitle: Text(
            subtitle!,
            maxLines: 2,
          ),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              overflow: TextOverflow.ellipsis),
          subtitleTextStyle: const TextStyle(
              color: Colors.white, overflow: TextOverflow.ellipsis),
          leading: leading,
          iconColor: iconColor,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
