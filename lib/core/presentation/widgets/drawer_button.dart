import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_list_tile.dart';

class DrawerButtonItemWidget extends StatelessWidget {
  const DrawerButtonItemWidget({
    Key? key,
    this.onTap,
    required this.title,
  }) : super(key: key);

  final void Function()? onTap;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomListTile(
          titlePadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          enableDivider: false,
          padding: EdgeInsets.zero,
          trailing: SvgPicture.asset('assets/icons/Disclosure Indicator.svg'),
          title: Text(title,
              style: const TextStyle(
                fontSize: 15.0,
                fontFamily: 'poPPinRegular',
              )),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
