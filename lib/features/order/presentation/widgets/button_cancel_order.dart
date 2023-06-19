import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
                  showModalBottomSheet(
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .25,
                      ),
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                      )),
                      builder: (context) {
                        return confirmCancel(context, _deviceSize);
                      });
                  // showDialog(
                  //   context: context,
                  //   builder: (_) => CustomCancelDialog(
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

  Widget confirmCancel(BuildContext context, size) {
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
          SvgPicture.asset('assets/icons/grey_line.svg'),
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
                    event: () {},
                    bgColor: grey707070Color,
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
                    event: () {},
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
