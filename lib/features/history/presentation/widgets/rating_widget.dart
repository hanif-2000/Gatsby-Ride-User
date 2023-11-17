import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Rating Given",
            style: TextStyle(
                fontFamily: 'poPPinMedium',
                fontSize: 16.0,
                color: grey7D7979Color),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              decoration: BoxDecoration(
                  color: greyF9F9F9Color,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingBar.builder(
                                itemSize: 20.0,
                                initialRating: 4.5,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                // itemPadding:
                                //     const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: Text(
                                  "(4.6)",
                                  style: TextStyle(
                                    fontFamily: 'poPPinSemiBold',
                                    fontSize: 14.0,
                                    color: blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const Text(
                          //   "Rating",
                          //   style: TextStyle(
                          //       fontFamily: 'poPPinMedium',
                          //       fontSize: 16.0,
                          //       color: grey7D7979Color),
                          // ),

                          // const Text(
                          //   "2min ago",
                          //   style: TextStyle(
                          //       fontFamily: 'poPPinRegular',
                          //       fontSize: 12.0,
                          //       color: greyB8B8B8Color),
                          // ),
                        ]),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Very Continent ride and really nice driver behaviour. Quick service really enjoyed the ride.",
                        style: TextStyle(
                            fontFamily: 'poPPinRegular',
                            fontSize: 12.0,
                            color: grey7D7979Color),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Text(
            "Rating Received",
            style: TextStyle(
                fontFamily: 'poPPinMedium',
                fontSize: 16.0,
                color: grey7D7979Color),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              decoration: BoxDecoration(
                  color: greyF9F9F9Color,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingBar.builder(
                                itemSize: 20.0,
                                initialRating: 4.5,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                // itemPadding:
                                //     const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: Text(
                                  "(4.6)",
                                  style: TextStyle(
                                    fontFamily: 'poPPinSemiBold',
                                    fontSize: 14.0,
                                    color: blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const Text(
                          //   "Rating",
                          //   style: TextStyle(
                          //       fontFamily: 'poPPinMedium',
                          //       fontSize: 16.0,
                          //       color: grey7D7979Color),
                          // ),

                          // const Text(
                          //   "2min ago",
                          //   style: TextStyle(
                          //       fontFamily: 'poPPinRegular',
                          //       fontSize: 12.0,
                          //       color: greyB8B8B8Color),
                          // ),
                        ]),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Very Continent ride and really nice driver behaviour. Quick service really enjoyed the ride.",
                        style: TextStyle(
                            fontFamily: 'poPPinRegular',
                            fontSize: 12.0,
                            color: grey7D7979Color),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
