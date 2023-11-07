import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/rating_submitted_screen.dart';
import 'package:GetsbyRideshare/features/testing/widgets/circular_image_container.dart';
import 'package:GetsbyRideshare/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart' as rating;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../../core/presentation/providers/home_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/submit_ratings_state.dart';

class FeedBackScreen extends StatelessWidget {
  final String name;
  final String img;
  final String carModal;
  final String carNo;

  const FeedBackScreen(
      {Key? key,
      required this.name,
      required this.img,
      required this.carModal,
      required this.carNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: whiteColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
              ),
              color: blackColor,
            ),
          ),
          body: Consumer<OrderProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: _deviceSize.width * .05),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 30.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: green63BA6BColor.withOpacity(.15)),
                          height: 140.0,
                          width: 140.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CommonCircularImageContainer(image: img),
                          ),
                        ),
                      ),
                      CommonText(
                        text: name,
                        fontWeight: FontWeight.w500,
                        fontColor: blackColor,
                        fontFamily: "poPPinMedium",
                        fontSize: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonText(
                            text: carModal,
                            fontWeight: FontWeight.w400,
                            fontColor: grey585858Color,
                            fontFamily: "poPPinMedium",
                            fontSize: 12,
                          ),
                          CommonText(
                            text: " $carNo",
                            fontWeight: FontWeight.w500,
                            fontColor: blackColor,
                            fontFamily: "poPPinMedium",
                            fontSize: 12,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _deviceSize.height * .015,
                      ),
                      CommonText(
                        text: appLoc.howWasYourRide,
                        fontWeight: FontWeight.w500,
                        fontColor: blackColor,
                        fontFamily: "poPPinMedium",
                        fontSize: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _deviceSize.width * .15,
                            vertical: 10.0),
                        child: CommonText(
                          text: appLoc.yourFeedbackImproveExperience,
                          fontWeight: FontWeight.w400,
                          fontColor: grey8A8A8FColor,
                          fontFamily: "poPPinMedium",
                          fontSize: 17,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: _deviceSize.height * .01),
                        child: RatingBar.builder(
                          updateOnDrag: true,
                          unratedColor: greyEFEFF4Color,
                          glow: false,
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: yellowFFCC00Color,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                            provider.updateRatingComment(
                              rating: rating,
                              comment: provider.commentsEditingController.text,
                            );
                          },
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border:
                                Border.all(width: 1.0, color: greyEFEFF2Color),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: provider.commentsEditingController,
                              maxLines: 5,
                              autofocus: false,
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "Additional comments...",
                                hintStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: "poPPinRegular",
                                    color: greyC8C7CCColor),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: _deviceSize.height * .05,
                      ),
                      CustomButton(
                        text: Text(
                          appLoc.submit,
                          // appLoc.login.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'poPPinSemiBold',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        event: () {
                          if (provider.ratingGiven == 10.0) {
                            showToast(message: appLoc.pleaseGiveRating);
                          } else {
                            //  SubmitRatingsResponseModel data=   provider.submitRatingsReview().;

                            provider
                                .submitRatingsReview()
                                .listen((event) async {
                              if (event is SubmitRatingsLoading) {
                                showLoading();
                                log("LOADING");
                              } else if (event is SubmitRatingsLoaded) {
                                log("Order Status LOADED--------");

                                provider.commentsEditingController.clear();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RatingSubmittedScreen(),
                                  ),
                                );

                                dismissLoading();
                              } else if (event is SubmitRatingsFailure) {
                                showToast(message: "submission falied");
                                log("Update Order Status Failed.......");
                                dismissLoading();
                              }
                            });
                          }

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             RatingSubmittedScreen()));
                        },
                        buttonHeight: 50,
                        // buttonHeight: MediaQuery.of(context)._deviceSize.height * 0.080,
                        isRounded: true,
                        bgColor: black080809Color,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: _deviceSize.height * .03,
                        ),
                        child: CustomButton(
                          buttonHeight: 50.0,
                          text: Text(
                            appLoc.skip,
                            style: TextStyle(
                              color: blackColor,
                            ),
                          ),
                          event: () async {
                            var homeProvider = Provider.of<HomeProvider>(
                                context,
                                listen: false);

                            var orderProvider = Provider.of<OrderProvider>(
                                context,
                                listen: false);
                            await homeProvider.clearState();
                            await orderProvider.clearState();

                            Navigator.pushNamedAndRemoveUntil(
                                context, HomePage.routeName, (route) => false);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PaymentScreen(),
                            //   ),
                            // );
                          },
                          bgColor: whiteColor,
                          isRounded: true,
                          borderColor: blackColor,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
