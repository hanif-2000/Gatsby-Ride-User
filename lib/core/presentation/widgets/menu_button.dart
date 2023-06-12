import 'package:appkey_taxiapp_user/core/static/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Function()? tap;
  final String title;
  final String imageAsset;
  final double height;

  const MenuButton(
      {Key? key,
      this.tap,
      required this.title,
      required this.imageAsset,
      required this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tap!();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 3.0),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height * 0.075,
            ),
            Image.asset(
              imageAsset,
              height: height * 0.40,
            ),
            SizedBox(
              height: height * 0.075,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: AutoSizeText(
                title,
                minFontSize: 10,
                style: labelTitleAppBar,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
