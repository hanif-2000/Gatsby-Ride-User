import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/widgets/info_driver_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/static/enums.dart';

class BottomContaineOrder extends StatelessWidget {
  const BottomContaineOrder({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, provider, _) {
      if (provider.orderStatus == OrderStatus.lookingDriver) {
        // return Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: const [ButtonCancelOrder()],
        // );
        return SizedBox();
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [DriverInfoWidget()],
        );
      }
    });
  }
}
