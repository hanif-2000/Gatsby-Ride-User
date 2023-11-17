import 'package:flutter/material.dart';

import '../../../../core/static/colors.dart';

class SenderTile extends StatelessWidget {
  const SenderTile({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 38, left: 50),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        decoration: const BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Text(title!,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            )),
      ),
    );
  }
}
