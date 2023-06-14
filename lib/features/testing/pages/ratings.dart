import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart' as rating;

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Icon(
              Icons.arrow_back,
              color: blackColor,
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
          body: SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 2,
                      child: Row(
                        children: [
                          SizedBox(width: 18),
                          CommonText(
                            text: "4.5",
                            fontWeight: FontWeight.w500,
                            fontColor: blackColor,
                            fontFamily: "poPPinMedium",
                            fontSize: 34,
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              rating.RatingBarIndicator(
                                rating: 5,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 19.0,
                                direction: Axis.horizontal,
                              ),
                              CommonText(
                                text: "Based On 20 Reviews",
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
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                RatingWidget(
                                  name: 'Alex Robin',
                                  ratingDate: 'Ratings12 May 2023',
                                  rating: 4.5,
                                  review:
                                      'Lorem ipsum dolor sit amet consectetur. Scelerisque ornare nunc adipiscing ipsum id turpis quis. Viverra amet arcu eget quisque cras risus lacus tristique morbi. Nisl magnis aliquam tortor dui adipiscing .',
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Divider(),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ))),
    );
  }
}
