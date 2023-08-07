import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utility/helper.dart';

class CustomRatingItem extends StatelessWidget {
  final String? name;
  final String? date;
  final String? reviews;
  final String? rating;
  final String image;

  const CustomRatingItem({
    Key? key,
    this.name,
    this.date,
    this.reviews,
    this.rating,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(image == ''
                        ? 'https://picsum.photos/250?image=9'
                        : mergePhotoUrl(image)),
                    maxRadius: 18.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name!,
                        style: TextStyle(
                          fontFamily: 'poPPinMedium',
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        date!,
                        style: TextStyle(
                          fontFamily: "poPPinRegular",
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/filled_star.svg'),
                  Text(
                    rating!,
                    style: TextStyle(
                      fontFamily: 'poPPinSemiBold',
                      fontSize: 14.0,
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              reviews!,
              style: TextStyle(
                fontFamily: "poPPinRegular",
                fontSize: 12.0,
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
            color: greyECECECColor,
          )
        ]),
      ),
    );
  }
}
