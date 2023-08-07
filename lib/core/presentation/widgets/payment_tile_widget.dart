import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentTile extends StatelessWidget {
  final String assets;
  final String title;
  final Function onTap;
  final bool selected;

  const PaymentTile(
      {Key? key,
      required this.assets,
      required this.title,
      required this.selected,
      required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return Consumer<HomeProvider>(builder: (context, provider, _) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, // Your desired background color
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: greyB6B6B6Color.withOpacity(.1),
                blurRadius: 16,
                spreadRadius: 0.0,
                offset: const Offset(0, 20),
              ),
            ]),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
          tileColor: whiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 10.0, right: 20.0),
                child: SvgPicture.asset(
                  assets,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: AutoSizeText(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16.0),
                  minFontSize: 10,
                  maxLines: 1,
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  selected
                      ? const Icon(
                          Icons.radio_button_on_outlined,
                          color: yellowE5A829Color,
                          size: 35,
                        )
                      : const Icon(
                          Icons.radio_button_off_outlined,
                          color: greyB6B6B6Color,
                          size: 35,
                        )
                ],
              ))
            ],
          ),
          onTap: () => onTap(),
        ),
      ),
    );
    // });
  }
}
