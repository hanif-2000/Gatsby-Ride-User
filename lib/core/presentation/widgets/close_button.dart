import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';

class CloseDrawerButtonWidget extends StatelessWidget {
  const CloseDrawerButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.arrow_back,
        size: 24.0,
      ),
      color: blackColor,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
