import 'package:appkey_taxiapp_user/core/domain/entities/order_data_detail.dart';
import 'package:appkey_taxiapp_user/core/presentation/pages/home_page/home_page.dart';
import 'package:appkey_taxiapp_user/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/static/order_status.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/pages/order_page.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/custom_cancel_dialog.dart';
import '../../../../core/presentation/widgets/custom_dialog_logout.dart';
import '../../../../core/presentation/widgets/custom_simple_dialog.dart';
import '../../../../core/static/styles.dart';
import '../providers/update_status_order_state.dart';

class ButtonCancelOrder extends StatelessWidget {
  const ButtonCancelOrder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
        child: SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomButton(
                text: Text(
                  appLoc.cancel.toUpperCase(),
                  style: txtButtonCancelStyle,
                ),
                event: () {
                  showDialog(
                    context: context,
                    builder: (_) => CustomCancelDialog(
                      positiveAction: () async {
                        Navigator.pop(context);
                        provider
                            .submitStatusOrder(Order.cancel)
                            .listen((event) async {
                          if (event is UpdateStatusOrderLoading) {
                            showLoading();
                          } else if (event is UpdateStatusOrderLoaded) {
                            var homeProvider = Provider.of<HomeProvider>(
                                context,
                                listen: false);
                            await homeProvider.clearState();
                            dismissLoading();
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CustomSimpleDialog(
                                    text: appLoc.orderCanceled,
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        HomePage.routeName,
                                        (route) => false,
                                      );
                                    });
                              },
                            );
                          } else if (event is UpdateStatusOrderFailure) {
                            dismissLoading();
                          }
                        });
                      },
                    ),
                  );
                },
                bgColor: Colors.grey)),
      );
    });
  }
}
