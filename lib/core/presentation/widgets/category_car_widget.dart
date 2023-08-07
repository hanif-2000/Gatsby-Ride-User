import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/dropdown_price_category.dart';
import 'package:GetsbyRideshare/core/static/assets.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/price_category_state.dart';

class CategoryCarWidget extends StatelessWidget {
  const CategoryCarWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PriceCategoryState>(
        stream: context.read<HomeProvider>().fetchPriceCategory(),
        builder: (context, state) {
          switch (state.data.runtimeType) {
            case PriceCategoryLoading:
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            case PriceCategoryLoaded:
              final data = (state.data as PriceCategoryLoaded).data;
              return Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 10.0, bottom: 0.0),
                child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(
                        builder: (context, constraint) {
                          return SizedBox(
                              height: 40,
                              width: constraint.maxWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        bottom: 10,
                                        right: 12),
                                    // child: Icon(
                                    //   Icons.directions_car_rounded,
                                    //   color: primaryColor,
                                    // ),
                                    child: ImageIcon(
                                      AssetImage(carIcon),
                                      color: primaryColor,
                                    ),
                                  ),
                                  DropdowndPriceCategory(priceCategory: data)
                                ],
                              ));
                        },
                      )),
                ),
              );
          }
          return const SizedBox.shrink();
        });
  }
}
