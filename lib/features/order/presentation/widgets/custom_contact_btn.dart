import 'package:GetsbyRideshare/core/types/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomContactBtn extends StatelessWidget {
  final String btnText;
  final String image;
  final Color btnColor;

  final VoidCallback event;

  final double btnWidth;

  const CustomContactBtn(
      {Key? key,
      required this.btnText,
      required this.image,
      required this.btnWidth,
      required this.btnColor,
      required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: event,
      child: Container(
        width: btnWidth,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: btnColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(image),
            Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
              ),
              child: Text(btnText,
                  style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)
                      .usePoppinsW6Font()),
            ),
          ],
        ),
      ),
    );
  }
}
