import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/widgets/add_new_card_popup.dart';
import '../../../../core/presentation/widgets/credit_card_tile_wisget.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/utility/helper.dart';
import '../providers/card_list_state.dart';
import '../providers/payment_provider.dart';

class CardPaymentExpansionTile extends StatelessWidget {
  final String assets;
  final String title;
  final Function onTap;
  final bool selected;
  final HomeProvider provider;

  const CardPaymentExpansionTile(
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

    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return ExpansionTile(
        onExpansionChanged: (value) {},
        maintainState: true,
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
        trailing: provider.paymentMethod == PaymentMethod.creditCard
            ? const Icon(
                Icons.radio_button_on_outlined,
                color: yellowE5A829Color,
                size: 35,
              )
            : Icon(
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
                    /******    Show List of Cards */

                    StreamBuilder<CardListState>(
                        stream:
                            context.read<PaymentProvider>().fetchCardListData(),
                        builder: (context, state) {
                          switch (state.data.runtimeType) {
                            case CardListLoading:
                              return const Center(
                                  child: CircularProgressIndicator());
                            case CardListFailure:
                              final failure =
                                  (state.data as CardListFailure).failure;
                              showToast(message: failure);
                              return const SizedBox.shrink();
                            case CardListSuccess:
                              final _data =
                                  (state.data as CardListSuccess).data;

                              log("my card list data is" +
                                  _data.data.toString());
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _data.data.length,
                                itemBuilder: (context, index) {
                                  return CreditCardTile(
                                      title:
                                          "*** *** *** ${_data.data[index].cardNumber.substring(_data.data[index].cardNumber.length - 4)}",
                                      assets:
                                          'assets/icons/logos_mastercard.svg',
                                      onTap: () {
                                        var selectedCardId =
                                            _data.data[index].id;

                                        log("selected card id is--->>>$selectedCardId");

                                        context
                                            .read<PaymentProvider>()
                                            .updateSelectedCardId(
                                                selectedCardId);

                                        context
                                            .read<PaymentProvider>()
                                            .updateSelectedCard(
                                                cardNo: _data
                                                    .data[index].cardNumber,
                                                expiry: _data
                                                    .data[index].expiryDate);

                                        provider.setPaymentMethod =
                                            PaymentMethod.creditCard;

                                        log("new card id is====>>${context.read<PaymentProvider>().selectedCardId}");

                                        // provider.setPaymentMethod =
                                        //     PaymentMethod.creditCard;
                                        // Navigator.pop(context);
                                      },
                                      selected: (context
                                                  .read<PaymentProvider>()
                                                  .selectedCardId ==
                                              _data.data[index].id)
                                          ? true
                                          : false

                                      //  provider.paymentMethod == null
                                      //     ? false
                                      //     : provider.paymentMethod ==
                                      //             PaymentMethod.creditCard
                                      //         ? true
                                      //         : false,
                                      );
                                },
                              );
                          }
                          return const SizedBox.shrink();
                        }),

                    /** Add New Card  */
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
                    // ],
                    // ),
                  ],
                )

                // Column(
                //   children: [
                //     ListView.builder(
                //       physics: const NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: _data.data.length,
                //       itemBuilder: (context, index) {
                //         return CreditCardTile(
                //           title:
                //               "*** *** *** ${_data.data[index].cardNumber.substring(_data.data[index].cardNumber.length - 4)}",
                //           assets: 'assets/icons/logos_mastercard.svg',
                //           onTap: () {
                //             provider.setPaymentMethod = PaymentMethod.creditCard;
                //             // Navigator.pop(context);
                //           },
                //           selected: provider.paymentMethod == null
                //               ? false
                //               : provider.paymentMethod == PaymentMethod.creditCard
                //                   ? true
                //                   : false,
                //         );
                //       },
                //     ),

                //     InkWell(
                //       onTap: () {
                //         showDialog(
                //           context: context,
                //           builder: (context) {
                //             return AlertDialog(
                //                 shape: RoundedRectangleBorder(
                //                     borderRadius:
                //                         BorderRadius.all(Radius.circular(32.0))),
                //                 content: AddNewCardPopUp());
                //           },
                //         );
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //             color: whiteF2F2F2Color,
                //             borderRadius: BorderRadius.circular(11.0),
                //             // Your desired background color

                //             boxShadow: const [
                //               BoxShadow(
                //                 color: whiteF2F2F2Color,
                //                 blurRadius: 20,
                //                 spreadRadius: 20.0,
                //                 offset: Offset(0, 15),
                //               ),
                //             ]),
                //         alignment: Alignment.center,
                //         height: _deviceSize.height * .1,
                //         child: const Text(
                //           "+ Add New Card",
                //           style: TextStyle(
                //             fontSize: 14.0,
                //             fontWeight: FontWeight.w600,
                //             color: blackColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                ),
          )
          // ListTile(
          //   title: Text(
          //     "items.description",
          //     style: TextStyle(fontWeight: FontWeight.w700),
          //   ),
          // )
        ],
      );

      // StreamBuilder<CardListState>(
      //     stream: context.read<PaymentProvider>().fetchCardListData(),
      //     builder: (context, state) {
      //       switch (state.data.runtimeType) {
      //         case CardListLoading:
      //           return const Center(child: CircularProgressIndicator());
      //         case CardListFailure:
      //           final failure = (state.data as CardListFailure).failure;
      //           showToast(message: failure);
      //           return const SizedBox.shrink();
      //         case CardListSuccess:
      //           final _data = (state.data as CardListSuccess).data;

      //           log("my card list data is" + _data.data.toString());

      //           return Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 8.0),
      //             child: Container(
      //               decoration: BoxDecoration(
      //                   color: whiteColor,
      //                   borderRadius: BorderRadius.circular(11),
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: greyB6B6B6Color.withOpacity(.1),
      //                       blurRadius: 16,
      //                       spreadRadius: 0.0,
      //                       offset: const Offset(0, 20),
      //                     ),
      //                   ]),
      //               child: GestureDetector(
      //                 onTap: () {},
      //                 child:

      //                 ExpansionTile(
      //                   onExpansionChanged: (value) {},
      //                   maintainState: true,
      //                   // onExpansionChanged: (value) async {
      //                   //   log("on expansion chaenged===>>>  $value");

      //                   //   if (value) {
      //                   //     await Provider.of<PaymentProvider>(context,
      //                   //             listen: false)
      //                   //         .fetchCardListData();

      //                   //     // provider.fetchCardListData();
      //                   //     // provider.getListOfCard();
      //                   //   }
      //                   // },
      //                   childrenPadding: EdgeInsets.zero,
      //                   shape: const Border(),
      //                   collapsedShape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(11.0)),
      //                   leading: Padding(
      //                     padding: const EdgeInsets.only(left: 10.0),
      //                     child: SvgPicture.asset(
      //                       assets,
      //                       width: 48,
      //                       height: 48,
      //                       fit: BoxFit.cover,
      //                     ),
      //                   ),
      //                   trailing: selected
      //                       ? const Icon(
      //                           Icons.radio_button_on_outlined,
      //                           color: yellowE5A829Color,
      //                           size: 35,
      //                         )
      //                       : const Icon(
      //                           Icons.radio_button_off_outlined,
      //                           color: greyB6B6B6Color,
      //                           size: 35,
      //                         ),
      //                   title: const Text(
      //                     "Debit/Credit Card",
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 16.0,
      //                       color: blackColor,
      //                     ),
      //                   ),
      //                   children: <Widget>[
      //                     Container(
      //                       decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(11.0),
      //                       ),
      //                       child: Padding(
      //                         padding: const EdgeInsets.all(8.0),
      //                         child: Column(
      //                           children: [
      //                             ListView.builder(
      //                               physics:
      //                                   const NeverScrollableScrollPhysics(),
      //                               shrinkWrap: true,
      //                               itemCount: _data.data.length,
      //                               itemBuilder: (context, index) {
      //                                 return CreditCardTile(
      //                                   title:
      //                                       "*** *** *** ${_data.data[index].cardNumber.substring(_data.data[index].cardNumber.length - 4)}",
      //                                   assets:
      //                                       'assets/icons/logos_mastercard.svg',
      //                                   onTap: () {
      //                                     provider.setPaymentMethod =
      //                                         PaymentMethod.creditCard;
      //                                     // Navigator.pop(context);
      //                                   },
      //                                   selected: provider.paymentMethod == null
      //                                       ? false
      //                                       : provider.paymentMethod ==
      //                                               PaymentMethod.creditCard
      //                                           ? true
      //                                           : false,
      //                                 );
      //                               },
      //                             ),
      //                             InkWell(
      //                               onTap: () {
      //                                 showDialog(
      //                                   context: context,
      //                                   builder: (context) {
      //                                     return AlertDialog(
      //                                         shape: RoundedRectangleBorder(
      //                                             borderRadius:
      //                                                 BorderRadius.all(
      //                                                     Radius.circular(
      //                                                         32.0))),
      //                                         content: AddNewCardPopUp());
      //                                   },
      //                                 );
      //                               },
      //                               child: Container(
      //                                 decoration: BoxDecoration(
      //                                     color: whiteF2F2F2Color,
      //                                     borderRadius:
      //                                         BorderRadius.circular(11.0),
      //                                     // Your desired background color

      //                                     boxShadow: const [
      //                                       BoxShadow(
      //                                         color: whiteF2F2F2Color,
      //                                         blurRadius: 20,
      //                                         spreadRadius: 20.0,
      //                                         offset: Offset(0, 15),
      //                                       ),
      //                                     ]),
      //                                 alignment: Alignment.center,
      //                                 height: _deviceSize.height * .1,
      //                                 child: const Text(
      //                                   "+ Add New Card",
      //                                   style: TextStyle(
      //                                     fontSize: 14.0,
      //                                     fontWeight: FontWeight.w600,
      //                                     color: blackColor,
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     )
      //                     // ListTile(
      //                     //   title: Text(
      //                     //     "items.description",
      //                     //     style: TextStyle(fontWeight: FontWeight.w700),
      //                     //   ),
      //                     // )
      //                   ],
      //                 ),

      //               ),
      //             ),

      //           );
      //       }
      //       return const SizedBox.shrink();
      //       ;
      //     });
    });
  }
}

// import 'package:GetsbyRideshare/core/static/colors.dart';
// import 'package:GetsbyRideshare/core/utility/injection.dart';
// import 'package:GetsbyRideshare/features/contact_us/presentation/providers/contactus_provider.dart';
// import 'package:GetsbyRideshare/features/contact_us/presentation/widgets/contact_us_form.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';

// class AContactUsPage extends StatelessWidget {
//   const AContactUsPage({Key? key}) : super(key: key);
//   static const routeName = '/contactus';

//   @override
//   Widget build(BuildContext context) {
//     var _deviceSize = MediaQuery.of(context).size;

//     return ChangeNotifierProvider(
//         create: (context) => locator<ContactusProvider>(),
//         child: Scaffold(
//             appBar: AppBar(
//               elevation: 0.0,
//               backgroundColor: whiteColor,
//               leading: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   color: blackColor,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             backgroundColor: whiteColor,
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SvgPicture.asset('assets/icons/contact_us.svg'),
//                   SizedBox(
//                     height: _deviceSize.height * .02,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       top: _deviceSize.height * .02,
//                       bottom: _deviceSize.height * .01,
//                     ),
//                     child: const Text(
//                       "Contact us",
//                       style: TextStyle(
//                         fontSize: 21.0,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   const Text(
//                     "Please enter your detail",
//                     style: TextStyle(
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.w400,
//                       color: grey767676Color,
//                     ),
//                   ),
//                   const ContactUsForm()
//                 ],
//               ),
//             )

//             // SafeArea(
//             //   child: ListView(
//             //     children: [
//             //       AspectRatio(
//             //         // aspectRatio: 3 / 0.8,
//             //         aspectRatio: 5 / 2,
//             //         child: Padding(
//             //           padding: const EdgeInsets.all(12.0),
//             //           child: Column(
//             //             crossAxisAlignment: CrossAxisAlignment.start,
//             //             mainAxisAlignment: MainAxisAlignment.center,
//             //             children: [
//             //               Align(
//             //                 alignment: Alignment.topLeft,
//             //                 child: InkWell(
//             //                   onTap: () {
//             //                     Navigator.pop(context);
//             //                   },
//             //                   child: const Padding(
//             //                     padding: EdgeInsets.all(0.0),
//             //                     child: Icon(Icons.arrow_back,
//             //                         color: black15141FColor),
//             //                   ),
//             //                 ),
//             //               ),
//             //               const Flexible(
//             //                 fit: FlexFit.loose,
//             //                 flex: 1,
//             //                 child: Center(
//             //                   child: Text(
//             //                     "Reset your password",
//             //                     textAlign: TextAlign.center,
//             //                     style: TextStyle(
//             //                       fontFamily: "poPPinSemiBold",
//             //                       fontWeight: FontWeight.w600,
//             //                       color: black15141FColor,
//             //                       fontSize: 24,
//             //                     ),
//             //                   ),
//             //                 ),
//             //               ),
//             //               const Flexible(
//             //                 // fit: FlexFit.loose,
//             //                 flex: 1,
//             //                 child: Center(
//             //                   child: Text(
//             //                     "Enter your official email to get a verification code.",
//             //                     // appLoc.welcome.toUpperCase(),
//             //                     textAlign: TextAlign.center,
//             //                     softWrap: true,
//             //                     style: TextStyle(
//             //                       fontFamily: "poPPinMedium",
//             //                       fontWeight: FontWeight.w500,
//             //                       color: grey7C7C7CColor,
//             //                       fontSize: 15,
//             //                     ),
//             //                   ),
//             //                 ),
//             //               ),
//             //               // Flexible(
//             //               //   fit: FlexFit.loose,
//             //               //   flex: 1,
//             //               //   child: Text(
//             //               //     appLoc.pleaseEnterYourEmailAddress,
//             //               //     textAlign: TextAlign.center,
//             //               //     style: const TextStyle(
//             //               //             fontSize: 15,
//             //               //             color: Colors.black,
//             //               //             fontWeight: FontWeight.bold)
//             //               //         .useHiraginoKakuW6Font(),
//             //               //   ),
//             //               // ),
//             //             ],
//             //           ),
//             //         ),
//             //       ),
//             //       const SizedBox(
//             //         height: 30,
//             //       ),
//             //       // const FormForgotPassword(),
//             //       // mediumVerticalSpacing(),
//             //     ],
//             //   ),
//             // ),

//             ));
//   }
// }
