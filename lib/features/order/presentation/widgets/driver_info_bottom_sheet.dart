import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/order/presentation/widgets/custom_contact_btn.dart';
import 'package:GetsbyRideshare/socket/latest_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../../history/presentation/widgets/driver_profile.dart';

class DriverInfoBottomSheet extends StatelessWidget {
  final String category;
  // final String driverId;
  // final String driverImage;
  // final String driverName;
  // final String platerNumber;
  // final String rating;
  final bool isReceiptVisible;
  final String driverStatusText;
  final Function() viewReceiptEvent;
  final Function() messageEvent;
  final Function() reviewEvent;
  int newMessgeCount;

  final Function() callEvent;

  DriverInfoBottomSheet(
      {Key? key,
      required this.category,
      // required this.driverId,
      // required this.driverImage,
      // required this.driverName,
      // required this.platerNumber,
      // required this.rating,
      required this.driverStatusText,
      required this.viewReceiptEvent,
      required this.callEvent,
      required this.messageEvent,
      required this.reviewEvent,
      required this.newMessgeCount,
      required this.isReceiptVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    final session = locator<Session>();
    return Consumer<LatestSocketProvider>(
      builder: (context, provider, _) {
        log("driver info model driver name is -->. ${provider.driverDetailResponseModel!.message.name}");
        log("current order status is : -->. ${provider.currentOrderStatus}");
        log("session order status is : -->. ${session.orderStatus}");

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              Text(
                driverStatusText,
                // ((provider.currentOrderStatus == 1) ||
                //         (session.orderStatus == 1))
                //     ? "Driver is arriving"
                //     : ((provider.currentOrderStatus == 2) ||
                //             (session.orderStatus == 2))
                //         ? "Driver is on the way"
                //         : ((provider.currentOrderStatus == 3) ||
                //                 (session.orderStatus == 3))
                //             ? "Driver reached your location"
                //             : ((provider.currentOrderStatus == 5) ||
                //                     (session.orderStatus == 5))
                //                 ? "Departure to your Destination"
                //                 : ((provider.currentOrderStatus == 7) ||
                //                         (session.orderStatus == 7))
                //                     ? "Ride is Completed"
                //                     : "",
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
                  driverId:
                      provider.driverDetailResponseModel!.message.id.toString(),
                  driverImage: provider.driverDetailResponseModel!.message.image
                      .toString(),
                  driverName: provider.driverDetailResponseModel!.message.name
                      .toString(),
                  platerNumber: provider
                      .driverDetailResponseModel!.message.plateNumber
                      .toString(),
                  rating: provider.driverDetailResponseModel!.message.rating
                      .toString(),
                ),
              ),
              Visibility(
                visible: !isReceiptVisible,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomContactBtn(
                            btnText: "Call now",
                            image: 'assets/icons/call_icon.svg',
                            btnWidth: _deviceSize.width * .44,
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
                              btnWidth: _deviceSize.width * .44,
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
                    ),
                    provider.unreadMessageCount != 0
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: redf52d56Color,
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  provider.unreadMessageCount.toString(),
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              Visibility(
                visible: isReceiptVisible || session.orderStatus == 7,
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
      },
    );
  }
}
