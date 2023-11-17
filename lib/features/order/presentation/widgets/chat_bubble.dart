import 'package:flutter/material.dart';

import '../../../../core/static/colors.dart';
import '../../../testing/widgets/common_text.dart';

class Bubble extends StatelessWidget {
  Bubble({required this.message, this.isMe});

  final String message;
  final isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? yellowFBF2DFColor : blackColor;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
          );
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.only(top: 14, bottom: 14, left: 18),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 40.0),
                  child: CommonText(
                    text: message,
                    fontSize: 16,
                    fontFamily: 'poPPinMedium',
                    fontColor: isMe ? blackColor : whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
