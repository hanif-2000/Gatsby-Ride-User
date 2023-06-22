import 'dart:developer';

import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/providers/home_provider.dart';
import '../../../../core/static/order_status.dart';
import '../../../../core/utility/helper.dart';
import '../providers/update_status_order_state.dart';

class ButtonCancelOrder extends StatelessWidget {
  const ButtonCancelOrder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Consumer<OrderProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
        child: SizedBox(
            height: 48,
            width: double.infinity,
            child: CustomButton(
                isRounded: true,
                text: Text(
                  "Cancel Ride",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "poPPinSemiBold",
                  ),
                ),
                event: () {
//Testing driver fetch bottom sheet

//                   showModalBottomSheet(
//                       isDismissible: false,
//                       isScrollControlled: false,
//                       backgroundColor: whiteColor,
//                       context: context,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(20.0),
//                         topLeft: Radius.circular(20.0),
//                       )),
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       builder: (context) {
//                         return Wrap(children: [
//                           DriverInfoBottomSheet(
//                             callEvent: () {},
//                             messageEvent: () {},
//                             viewReceiptEvent: () {
//                               log("On Click on View Review");
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (context) => RatingsScreen(),
//                               //   ),
//                               // );
//                               // Navigat
//                             },
//                             driverStatusText: "driverStatusText",
//                             category: "driverDetails.model",
//                             driverId: '4',
//                             driverImage: '',
//                             driverName: "driverDetails.name",
//                             platerNumber: "driverDetails.plat",
//                             rating: "4.5",
//                             isReceiptVisible:
//                                 (provider.session.orderStatus == (6))
//                                     ? true
//                                     : false,
//                           ),
//                         ]);
//                       });

//                   /**  NEW CODE */
                  showModalBottomSheet(
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .21,
                      ),
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                      )),
                      builder: (context) {
                        return confirmCancel(
                          context: context,
                          size: _deviceSize,
                          onConfirm: () async {
                            provider
                                .submitStatusOrder(Order.cancel)
                                .listen((event) async {
                              if (event is UpdateStatusOrderLoading) {
                                showLoading();
                                log("Order Status LOADING");
                              } else if (event is UpdateStatusOrderLoaded) {
                                log("Order Status LOADED--------");

                                var homeProvider = Provider.of<HomeProvider>(
                                    context,
                                    listen: false);
                                await homeProvider.clearState();
                                dismissLoading();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomePage.routeName,
                                  (route) => false,
                                );

//Show dialog for order canceled
                                // showDialog(
                                //   barrierDismissible: false,
                                //   context: context,
                                //   builder: (context) {
                                //     return CustomSimpleDialog(
                                //         text: appLoc.orderCanceled,
                                //         onTap: () {
                                //           Navigator.pushNamedAndRemoveUntil(
                                //             context,
                                //             HomePage.routeName,
                                //             (route) => false,
                                //           );
                                //         });
                                //   },
                                // );
                              } else if (event is UpdateStatusOrderFailure) {
                                log("Update Order Status Failed.......");
                                dismissLoading();
                              }
                            });
                          },
                        );
                      });

/**  Old Code */

                  // showDialog(
                  //   context: context,
                  //   builder: (_) => CustomCancelDialog(
                  //     // Cancel Ride: Ok
                  //     positiveAction: () async {
                  //       Navigator.pop(context);
                  //       provider
                  //           .submitStatusOrder(Order.cancel)
                  //           .listen((event) async {
                  //         if (event is UpdateStatusOrderLoading) {
                  //           showLoading();
                  //         } else if (event is UpdateStatusOrderLoaded) {
                  //           var homeProvider = Provider.of<HomeProvider>(
                  //               context,
                  //               listen: false);
                  //           await homeProvider.clearState();
                  //           dismissLoading();

                  //           showDialog(
                  //             barrierDismissible: false,
                  //             context: context,
                  //             builder: (context) {
                  //               return CustomSimpleDialog(
                  //                   text: appLoc.orderCanceled,
                  //                   onTap: () {
                  //                     Navigator.pushNamedAndRemoveUntil(
                  //                       context,
                  //                       HomePage.routeName,
                  //                       (route) => false,
                  //                     );
                  //                   });
                  //             },
                  //           );
                  //         } else if (event is UpdateStatusOrderFailure) {
                  //           dismissLoading();
                  //         }
                  //       });
                  //     },
                  //   ),
                  // );
                },
                bgColor: black080808Color)),
      );
    });
  }

  Widget confirmCancel(
      {required BuildContext context, size, required VoidCallback onConfirm}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          SvgPicture.asset(
            'assets/icons/grey_line.svg',
            color: grey707070Color.withOpacity(.3),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * .05,
              bottom: size.height * .03,
            ),
            child: Text(
              "Would you like to cancel ?",
              style: TextStyle(
                fontFamily: "poPPinRegular",
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 48.0,
                  width: size.width * .25,
                  child: CustomButton(
                    text: "Yes",
                    event: onConfirm,
                    bgColor: grey707070Color.withOpacity(
                      .4,
                    ),
                    isRounded: true,
                  ),
                ),
                SizedBox(
                  width: size.width * .05,
                ),
                SizedBox(
                  height: 48.0,
                  width: size.width * .25,
                  child: CustomButton(
                    text: "No",
                    event: () {
                      Navigator.pop(context);
                    },
                    bgColor: blackColor,
                    isRounded: true,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
