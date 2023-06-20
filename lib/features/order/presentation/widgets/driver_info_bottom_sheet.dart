import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/widgets/custom_contact_btn.dart';
import 'package:flutter/material.dart';

import '../../../history/presentation/widgets/driver_profile.dart';

class DriverInfoBottomSheet extends StatelessWidget {
  final String category;
  final String driverId;
  final String driverImage;
  final String driverName;
  final String platerNumber;
  final String rating;
  final bool isReceiptVisible;

  const DriverInfoBottomSheet(
      {Key? key,
      required this.category,
      required this.driverId,
      required this.driverImage,
      required this.driverName,
      required this.platerNumber,
      required this.rating,
      required this.isReceiptVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          Text(
            "Your Driver is arriving in 5 minutes",
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: "poPPinMedium",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: DriverProfileWidget(
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
                btnColor: green2DAA5FColor,
                event: () {},
              ),
              CustomContactBtn(
                btnText: "Message",
                image: 'assets/icons/message_icon.svg',
                btnWidth: _deviceSize.width * .45,
                btnColor: blue249DE0Color,
                event: () {},
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
                event: () {},
                bgColor: blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
