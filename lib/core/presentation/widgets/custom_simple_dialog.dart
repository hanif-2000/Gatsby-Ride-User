import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/extension.dart';
import 'package:flutter/material.dart';

class CustomSimpleDialog extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color? color;
  const CustomSimpleDialog(
      {Key? key,
      required this.text,
      required this.onTap,
      this.color = primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ).useHiraginoKakuW3Font(),
      ),
      children: [
        SimpleDialogOption(
          onPressed: () => onTap(),
          child: Text(
            'OK',
            style: TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold, color: color)
                .useHiraginoKakuW6Font(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
