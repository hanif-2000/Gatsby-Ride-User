import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/circular_image_container.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';

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
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
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

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: greyF9F9F9Color,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Card(
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    children: [
                      CommonCircularImageContainer(
                        height: 45,
                        width: 45,
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: "Alex Robin",
                            fontWeight: FontWeight.w500,
                            fontColor: blackColor,
                            fontFamily: "poPPinMedium",
                            fontSize: 16,
                          ),
                          CommonText(
                            text: "Active now",
                            fontWeight: FontWeight.w400,
                            fontColor: blackColor,
                            fontFamily: "poPPinMedium",
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: blackColor,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Bubble(
                message: 'Hello, are you nearby?',
                isMe: false,
              ),
              Bubble(
                message: 'I will be there in a few mins',
                isMe: true,
              ),
              Bubble(
                message: 'Okay, I am waiting at my location',
                isMe: false,
              ),
              Bubble(
                message:
                    'Sorry, I am stuck in traffic. Please give me a more time',
                isMe: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
