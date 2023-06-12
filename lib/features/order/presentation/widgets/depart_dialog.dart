import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/types/fonts.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DepartDialog extends StatelessWidget {
  final Function(bool b, bool call)? callback;

  const DepartDialog({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 350 * 0.3,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35)),
              ),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AutoSizeText(
                  appLoc.didTheTaxiArrive,
                  maxFontSize: 22,
                  minFontSize: 9,
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'Hiragino Kaku',
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              )),
            ),
            Container(
              height: 350 * 0.5,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                        text: Text(
                          appLoc.yes.toUpperCase(),
                          style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)
                              .useHiraginoKakuW6Font(),
                        ),
                        buttonHeight:
                            MediaQuery.of(context).size.height * 0.075,
                        isRounded: true,
                        event: () {
                          callback!(true, false);
                          Navigator.pop(context);
                        },
                        bgColor: primaryColor),
                    CustomButton(
                        text: Text(
                          appLoc.call.toUpperCase(),
                          style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)
                              .useHiraginoKakuW6Font(),
                        ),
                        buttonHeight:
                            MediaQuery.of(context).size.height * 0.075,
                        isRounded: true,
                        event: () {
                          callback!(false, true);
                        },
                        bgColor: Colors.black),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
