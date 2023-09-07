import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/add_new_card_popup.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/credit_card_tile_wisget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utility/dummy_data.dart';

class CreditCardExpansionTile extends StatelessWidget {
  final String assets;
  final String title;
  final Function onTap;
  final bool selected;
  final HomeProvider provider;

  const CreditCardExpansionTile(
      {Key? key,
      required this.assets,
      required this.title,
      required this.selected,
      required this.provider,
      required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    // return Consumer<HomeProvider>(builder: (context, provider, _) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: greyB6B6B6Color.withOpacity(.1),
                blurRadius: 16,
                spreadRadius: 0.0,
                offset: const Offset(0, 20),
              ),
            ]),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            log("on expansion chaenged===>>>  $value");

            if (value) {
              provider.getListOfCard();
            }
          },
          childrenPadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SvgPicture.asset(
              assets,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          trailing: selected
              ? const Icon(
                  Icons.radio_button_on_outlined,
                  color: yellowE5A829Color,
                  size: 35,
                )
              : const Icon(
                  Icons.radio_button_off_outlined,
                  color: greyB6B6B6Color,
                  size: 35,
                ),
          title: const Text(
            "Debit/Credit Card",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: blackColor,
            ),
          ),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: DummyData.dummyCardList.length,
                      itemBuilder: (context, index) {
                        return CreditCardTile(
                          title:
                              "*** *** *** ${DummyData.dummyCardList[index]["cardNumber"]}",
                          assets: 'assets/icons/logos_mastercard.svg',
                          onTap: () {
                            provider.setPaymentMethod =
                                PaymentMethod.creditCard;
                            // Navigator.pop(context);
                          },
                          selected: provider.paymentMethod == null
                              ? false
                              : provider.paymentMethod ==
                                      PaymentMethod.creditCard
                                  ? true
                                  : false,
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                content: AddNewCardPopUp());
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: whiteF2F2F2Color,
                            borderRadius: BorderRadius.circular(11.0),
                            // Your desired background color

                            boxShadow: const [
                              BoxShadow(
                                color: whiteF2F2F2Color,
                                blurRadius: 20,
                                spreadRadius: 20.0,
                                offset: Offset(0, 15),
                              ),
                            ]),
                        alignment: Alignment.center,
                        height: _deviceSize.height * .1,
                        child: const Text(
                          "+ Add New Card",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            // ListTile(
            //   title: Text(
            //     "items.description",
            //     style: TextStyle(fontWeight: FontWeight.w700),
            //   ),
            // )
          ],
        ),
      ),

      //  Container(
      //   decoration: BoxDecoration(
      //       color: Colors.white, // Your desired background color
      //       borderRadius: BorderRadius.circular(11),
      //       boxShadow: [
      //         BoxShadow(
      //           color: greyB6B6B6Color.withOpacity(.1),
      //           blurRadius: 16,
      //           spreadRadius: 0.0,
      //           offset: const Offset(0, 20),
      //         ),
      //       ]),
      //   child: ListTile(
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
      //     tileColor: whiteColor,
      //     title: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(
      //               top: 8.0, bottom: 8.0, left: 10.0, right: 20.0),
      //           child: SvgPicture.asset(
      //             assets,
      //             width: 43,
      //             height: 34,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //         Flexible(
      //           flex: 5,
      //           fit: FlexFit.tight,
      //           child: AutoSizeText(
      //             title,
      //             style: const TextStyle(
      //                 fontWeight: FontWeight.w500, fontSize: 16.0),
      //             minFontSize: 10,
      //             maxLines: 1,
      //           ),
      //         ),
      //         Expanded(
      //             child: Row(
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             selected
      //                 ? const Icon(
      //                     Icons.check_box,
      //                     size: 26,
      //                     color: green9ADB59Color,
      //                   )
      //                 : const Text(''),
      //           ],
      //         ))
      //       ],
      //     ),
      //     onTap: () => onTap(),
      //   ),
      // ),
    );
    // });
  }
}
