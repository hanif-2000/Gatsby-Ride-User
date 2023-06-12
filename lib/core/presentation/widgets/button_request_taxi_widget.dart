import 'package:appkey_taxiapp_user/core/domain/entities/order_data_detail.dart';
import 'package:appkey_taxiapp_user/core/presentation/providers/create_order_state.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/pages/order_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/login/presentation/pages/login_page.dart';
import '../../static/styles.dart';
import '../../utility/global_function.dart';
import '../providers/home_provider.dart';
import 'custom_simple_dialog.dart';

class ButtonRequestTaxi extends StatelessWidget {
  const ButtonRequestTaxi({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
        child: SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomButton(
                text: Text(
                  appLoc.callTaxi,
                  style: txtButtonStyle,
                ),
                event: () {
                  checkUserSession().then((value) {
                    if (value) {
                      if (!provider.destinationIsFilled) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CustomSimpleDialog(
                                text: appLoc.dropoffCoordinateIsEmpty,
                                onTap: () {
                                  Navigator.pop(context);
                                });
                          },
                        );
                      } else if (provider.paymentMethod == null) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CustomSimpleDialog(
                                text: appLoc.paymentMethodNotSelected,
                                onTap: () {
                                  Navigator.pop(context);
                                });
                          },
                        );
                      } else if (provider.selectedCategory == null) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CustomSimpleDialog(
                                text: appLoc.taxiTypeNotSelected,
                                onTap: () {
                                  Navigator.pop(context);
                                });
                          },
                        );
                      } else {
                        provider.submitOrder().listen((event) async {
                          if (event is CreateOrderLoading) {
                            showLoading();
                          } else if (event is CreateOrderLoaded) {
                            dismissLoading();
                            showToast(message: appLoc.orderCreatedSuccessfully);
                            final OrderDataDetail orderDataDetail =
                                OrderDataDetail(
                                    originLatLng: provider.originLatLng,
                                    destinationLatLng:
                                        provider.destinationLatLng,
                                    originAddress: provider.originAddress,
                                    destinationAddress:
                                        provider.destinationAddress);
                            Navigator.pushNamedAndRemoveUntil(
                                context, OrderPage.routeName, (route) => false,
                                arguments: orderDataDetail);
                          } else if (event is CreateOrderFailure) {
                            dismissLoading();
                          }
                        });
                      }
                    } else {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    }
                  });
                },
                bgColor: primaryColor)),
      );
    });
  }
}
