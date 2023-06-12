import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key, required this.iconColor, this.onPressed})
      : super(key: key);
  final Color iconColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            Navigator.pop(context);
          },
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: iconColor,
      ),
    );
  }
}
