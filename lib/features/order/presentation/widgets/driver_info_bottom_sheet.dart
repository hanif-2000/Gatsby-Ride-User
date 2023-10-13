import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/order/presentation/widgets/custom_contact_btn.dart';
import 'package:flutter/material.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../../history/presentation/widgets/driver_profile.dart';

class DriverInfoBottomSheet extends StatelessWidget {
  final String category;
  final String driverId;
  final String driverImage;
  final String driverName;
  final String platerNumber;
  final String rating;
  final bool isReceiptVisible;
  final String driverStatusText;
  final Function() viewReceiptEvent;
  final Function() messageEvent;
  final Function() reviewEvent;

  final Function() callEvent;

  const DriverInfoBottomSheet(
      {Key? key,
      required this.category,
      required this.driverId,
      required this.driverImage,
      required this.driverName,
      required this.platerNumber,
      required this.rating,
      required this.driverStatusText,
      required this.viewReceiptEvent,
      required this.callEvent,
      required this.messageEvent,
      required this.reviewEvent,
      required this.isReceiptVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    final session = locator<Session>();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          Text(
            driverStatusText,
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: "poPPinMedium",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: DriverProfileWidget(
              onClickOnReview: reviewEvent,
              category: category,
              driverId: driverId,
              driverImage: driverImage,
              driverName: driverName,
              platerNumber: platerNumber,
              rating: rating,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomContactBtn(
                btnText: "Call now",
                image: 'assets/icons/call_icon.svg',
                btnWidth: _deviceSize.width * .45,
                btnColor:
                    //  session.orderStatus == 1

                    // ? green2DAA5FColor
                    // : session.orderStatus == 2
                    //     ? green2DAA5FColor
                    //     : session.orderStatus == 3
                    //         ?

                    green2DAA5FColor,
                // : grey606060Color,
                event:
                    // session.orderStatus == 1
                    //     ? callEvent
                    //     : session.orderStatus == 2
                    //         ? callEvent
                    //         : session.orderStatus == 3
                    //             ?
                    callEvent,
                // : () {},
              ),
              CustomContactBtn(
                  btnText: "Message",
                  image: 'assets/icons/message_icon.svg',
                  btnWidth: _deviceSize.width * .45,
                  btnColor:
                      // session.orderStatus == 1
                      //     ? blue249DE0Color
                      //     : session.orderStatus == 2
                      //         ? blue249DE0Color
                      //         : session.orderStatus == 3
                      //             ?
                      blue249DE0Color,
                  // : grey606060Color,
                  // btnColor: blue249DE0Color,
                  event:
                      //  session.orderStatus == 1
                      //     ? messageEvent
                      //     : session.orderStatus == 2
                      //         ? messageEvent
                      //         : session.orderStatus == 3
                      //             ?
                      messageEvent

                  // : () {},
                  ),
            ],
          ),
          Visibility(
            visible: isReceiptVisible,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: CustomButton(
                isRounded: true,
                text: "View Receipt",
                event: viewReceiptEvent,
                bgColor: blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
