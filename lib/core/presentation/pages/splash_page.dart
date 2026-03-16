import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:GetsbyRideshare/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../features/login/presentation/pages/login_page.dart';
import '../../static/assets.dart';
import '../../utility/helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import '../providers/currency_state.dart';
import '../providers/splash_provider.dart';
import 'home_page/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _splashTimer;

  @override
  void initState() {

    super.initState();

    // newSocketProvider.connectToSocket();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      final session = locator<Session>();
      final splashProvider = context.read<SplashProvider>();
      splashProvider.getDeviceType();
      splashProvider.getSessionData();
      _splashTimer = Timer(const Duration(seconds: 3), (){
        if (!mounted) return;
        if (session.isLoggedIn) {
          Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
        /*  if (session.orderStatus == 100 || session.orderStatus == 8) {
            Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
          }*/
        } else {
          Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false);
        }

   /*     context.read<SplashProvider>().fetchCurrency().listen((state) async {

          log("state runtime type:==" + state.runtimeType.toString());

          switch (state.runtimeType) {
            case CurrencyLoading:
              break;
            case CurrencyLoaded:


              break;
          }
        });*/
        // }
      });
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLoc = AppLocalizations.of(context)!;
    myLocale = Localizations.localeOf(context);
    sessionHelper = locator<Session>();
    return LayoutBuilder(
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
    );
  }
}
