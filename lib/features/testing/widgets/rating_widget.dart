import 'package:appkey_taxiapp_user/core/static/assets.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/circular_image_container.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final String? name;
  final String? ratingDate;
  final double? rating;
  final String? review;
  const RatingWidget(
      {Key? key, this.name, this.ratingDate, this.rating, this.review})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CommonCircularImageContainer(image: ''),
                  Column(
                    children: [
                      CommonText(
                        text: name,
                        fontWeight: FontWeight.w500,
                        fontColor: blackColor,
                        fontFamily: "poPPinMedium",
                        fontSize: 16,
                      ),
                      CommonText(
                        text: ratingDate,
                        fontWeight: FontWeight.w400,
                        fontColor: blackColor,
                        fontFamily: "poPPinMedium",
                        fontSize: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(starImage),
                  CommonText(
                    text: rating.toString(),
                    fontWeight: FontWeight.w600,
                    fontColor: blackColor,
                    fontFamily: "poPPinMedium",
                    fontSize: 14,
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        CommonText(
          text: review,
          fontWeight: FontWeight.w200,
          fontColor: blackColor,
          fontFamily: "poPPinMedium",
          fontSize: 12,
        ),
      ],
    );
  }
}
