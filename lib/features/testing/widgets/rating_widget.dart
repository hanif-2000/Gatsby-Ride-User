import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/static/colors.dart';
import 'common_text.dart';

class RatingWidget extends StatelessWidget {
  final String? ratingDate;
  final double? rating;
  final String? review;
  const RatingWidget({Key? key, this.ratingDate, this.rating, this.review})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  RatingBarIndicator(
                    rating: rating!,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: yellowE6B045Color,
                    ),
                    itemCount: 5,
                    itemSize: 24.0,
                    direction: Axis.horizontal,
                  ),
                  Text(
                    "($rating)",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'poPPinSemiBold',
                    ),
                  ),
                ],
              ),
              Text(
                "2Min ago",
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: "poPPinRegular",
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
            fontColor: grey606060Color,
            fontFamily: "poPPinMedium",
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
