import 'package:GetsbyRideshare/core/domain/entities/total_price.dart';
import 'package:GetsbyRideshare/core/presentation/providers/home_provider.dart';
import 'package:GetsbyRideshare/core/presentation/providers/total_price_state.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/styles.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistancePriceWidget extends StatelessWidget {
  const DistancePriceWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: AutoSizeText(appLoc.distance,
                              maxFontSize: 18,
                              minFontSize: 9,
                              maxLines: 1,
                              style: distanceTextStyle),
                        ),
                        Expanded(
                            child: AutoSizeText(
                          mergeDistanceTxt(provider.distance),
                          maxFontSize: 20,
                          minFontSize: 9,
                          maxLines: 2,
                          style: priceTextStyle,
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                        width: 1,
                        child: Container(
                          color: Colors.grey[350],
                        )),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: AutoSizeText(appLoc.price,
                              maxFontSize: 18,
                              minFontSize: 9,
                              maxLines: 1,
                              style: distanceTextStyle),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: AutoSizeText(
                          mergePriceTxt(provider.price),
                          maxFontSize: 20,
                          minFontSize: 9,
                          maxLines: 2,
                          style: priceTextStyle,
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
