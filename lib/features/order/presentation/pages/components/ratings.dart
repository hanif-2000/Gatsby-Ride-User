import 'dart:developer';

import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/history/presentation/providers/history_provider.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utility/helper.dart';
import '../../../../history/presentation/providers/ratings_state.dart';
import '../../widgets/custom_rating_item.dart';
import 'package:provider/provider.dart';

class RatingsScreen extends StatelessWidget {
  final String driverId;
  const RatingsScreen({Key? key, required this.driverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                color: blackColor,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: CommonText(
                text: "Ratings",
                fontWeight: FontWeight.w500,
                fontColor: blackColor,
                fontFamily: "poPPinMedium",
                fontSize: 18,
              ),
            ),
            body: StreamBuilder<GetRatingState>(
              // stream: Provider.of<HistoryProvider>(context)
              //     .getRatingsAndReviews(driverId: driverId),
              stream: context
                  .read<HistoryProvider>()
                  .getRatingsAndReviews(driverId: driverId),
              builder: (context, state) {
                switch (state.data.runtimeType) {
                  case GetRatingLoading:
                    return const Center(child: CircularProgressIndicator());

                  case GetRatingFailure:
                    final failure = (state.data as GetRatingFailure).failure;
                    dismissLoading();

                    return const SizedBox.shrink();

                  case GetRatingLoaded:
                    final data = (state.data as GetRatingLoaded).data;

                    log(data.toString());

                    dismissLoading();
                    return SizedBox(
                        height: height,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                elevation: 1,
                                child: Row(
                                  children: [
                                    SizedBox(width: 18),
                                    CommonText(
                                      text: data.rating.toString(),
                                      fontWeight: FontWeight.w500,
                                      fontColor: blackColor,
                                      fontFamily: "poPPinMedium",
                                      fontSize: 34,
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RatingBarIndicator(
                                          rating: double.parse(
                                              data.rating.toString()),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 24.0,
                                          direction: Axis.horizontal,
                                        ),
                                        CommonText(
                                          text:
                                              "Based On ${data.ratingCount} Reviews",
                                          fontWeight: FontWeight.w400,
                                          fontColor: blackColor,
                                          fontFamily: "poPPinRegular",
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: data.list.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CustomRatingItem(
                                        date: DateFormat("yyyy")
                                            .parse(
                                                data.list[index].createdAt
                                                    .toString(),
                                                true)
                                            .toLocal()
                                            .toString(),
                                        image: data.list[index].image,
                                        name: data.list[index].name,
                                        rating: data.list[index].rating,
                                        reviews: data.list[index].review,
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ));
                }
                return const SizedBox.shrink();
              },
            )));
  }
}
