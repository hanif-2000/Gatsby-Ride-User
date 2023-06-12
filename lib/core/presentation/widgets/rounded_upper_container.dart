import 'package:flutter/material.dart';

import '../../static/colors.dart';

class RoundedUpperContainer extends StatelessWidget {
  final double height;
  final Widget child;
  const RoundedUpperContainer(
      {Key? key, required this.height, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.25),
            offset: const Offset(0, -5),
            blurRadius: 3.0,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: child,
    );
  }
}
