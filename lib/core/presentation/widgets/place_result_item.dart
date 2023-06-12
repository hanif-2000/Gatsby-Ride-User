import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_list_tile.dart';

class PlaceResultItem extends StatelessWidget {
  final String name;
  final Function()? onTap;
  const PlaceResultItem({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leading: const Icon(Icons.place),
      titleText: name,
      enableDivider: false,
      enabled: true,
      onTap: onTap,
    );
  }
}
