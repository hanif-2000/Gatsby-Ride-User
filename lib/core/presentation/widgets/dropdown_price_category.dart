import 'package:appkey_taxiapp_user/core/domain/entities/price_category.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';

class DropdowndPriceCategory extends StatelessWidget {
  final List<PriceCategory> priceCategory;

  const DropdowndPriceCategory({Key? key, required this.priceCategory})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<PriceCategory>(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: primaryColor,
              size: 40,
            ),
            hint: Text(
              appLoc.chooseTaxi,
              style: const TextStyle(color: Colors.grey),
            ),
            value: provider.selectedCategory,
            onChanged: (PriceCategory? item) {
              provider.setSelectedCategory = item;
              if (provider.destinationIsFilled) {
                // provider.fetchTotalPrice().listen((event) {});
              }
            },
            items: priceCategory.map((PriceCategory category) {
              return DropdownMenuItem<PriceCategory>(
                  value: category,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        category.categoryCar,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${category.seat.toString()} ${appLoc.people}',
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  ));
            }).toList()),
      );
    });
  }
}
