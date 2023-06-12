import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../features/login/presentation/pages/login_page.dart';
import '../../static/assets.dart';
import '../../utility/helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import '../providers/currency_state.dart';
import '../providers/splash_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), () async {
        if (kDebugMode) {
          log("This text showing after 2seconds");
          log(checkPermission().toString());
        }

        // if (await checkPermission()) {
        //   await sessionClearOrder();

        context.read<SplashProvider>().fetchCurrency().listen((state) async {
          switch (state.runtimeType) {
            case CurrencyLoading:
              break;
            case CurrencyLoaded:
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.routeName, (route) => false);
              // Navigator.pushNamedAndRemoveUntil(
              //     context, HomePage.routeName, (route) => false);
              break;
          }
        });
        // }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLoc = AppLocalizations.of(context)!;
    myLocale = Localizations.localeOf(context);
    sessionHelper = locator<Session>();

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double imgHeight = constraints.maxWidth * 0.5;
          double imgWidth = imgHeight;
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment:CrossAxisAlignment.center ,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: constraints.maxHeight * 0.35),
                  child: Image.asset(
                    logoSplash,
                    //height: imgHeight,
                    width: imgWidth,
                  ),
                ),
                // Center(
                //   child: Hero(
                //     tag: "taxiIcon",
                //     child: Image.asset(
                //       logoSplash,
                //       //height: imgHeight,
                //       width: imgWidth,
                //     ),
                //   ),
                // ),
                const Spacer(),
                Image.asset(
                  splashTaxiImage,
                  // height: imgHeight,
                  alignment: Alignment.bottomCenter,
                  width: constraints.maxWidth,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
