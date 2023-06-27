import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/circular_image_container.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';

import '../../widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: greyF9F9F9Color,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Card(
            elevation: 1,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Bubble(
                          message: 'I will be there in a few mins',
                          isMe: true,
                        );
                      },
                    ),
                  ),
                  // TextField()
                ],
              ),
            )

            //  Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: <Widget>[
            //     Bubble(
            //       message: 'Hello, are you nearby?',
            //       isMe: false,
            //     ),
            //     Bubble(
            //       message: 'I will be there in a few mins',
            //       isMe: true,
            //     ),
            //     Bubble(
            //       message: 'Okay, I am waiting at my location',
            //       isMe: false,
            //     ),
            //     Bubble(
            //       message:
            //           'Sorry, I am stuck in traffic. Please give me a more time',
            //       isMe: true,
            //     ),
            //   ],
            // ),
            ),
      ),
    );
  }
}
