import 'dart:async';
import 'dart:developer';
import 'package:GetsbyRideshare/socket/latest_socket_provider.dart';
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
import 'home_page/home_page.dart';

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

    // newSocketProvider.connectToSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 3), () async {
        // if (kDebugMode) {
        //   checkPermission().then((value) {
        //     return log(value.toString());
        //   });
        //   // log("This text showing after 2seconds");
        //   // log(checkPermission().toString());
        // }

        // if (await checkPermission()) {
        // log("Check Permission value----" + checkPermission().toString());
        // await sessionClearOrder();

        context.read<SplashProvider>().fetchCurrency().listen((state) async {
          // Permission.notification.isDenied.then((value) async {
          //   if (value) {
          //     Permission.notification.request();
          //   }
          // });

          // if (Platform.isAndroid) {
          //   // PermissionStatus status = await Permission.notification.request();
          //   // if (status.isGranted) {
          //   //   log("notification permissin is granetd");
          //   //   // notification permission is granted
          //   // } else {
          //   //   // Permission.notification.request();
          //   //   log("ask for notification permission ");
          //   //   AppSettings.openAppSettings(type: AppSettingsType.notification);
          //   //   // Open settings to enable notification permission
          //   // }
          // }

          final session = locator<Session>();
          final socketProvider = Provider.of<LatestSocketProvider>(
              locator<GlobalKey<NavigatorState>>().currentContext!,
              listen: false);

          // log("session token" + session.sessionToken.toString());
          // log("order id" + session.orderId.toString());

          log("state runtime type:==" + state.runtimeType.toString());

          switch (state.runtimeType) {
            case CurrencyLoading:
              break;
            case CurrencyLoaded:
              if (session.isLoggedIn) {
                if (session.orderStatus == 100 || session.orderStatus == 8) {
                  //  socketProvider.connectToSocket(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomePage.routeName, (route) => false);
                } else {
                  log("orogin lat lat :->> ${session.originLat}");
                  log("orogin lat long :->> ${session.originLong}");
                  //  socketProvider.connectToSocket(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomePage.routeName, (route) => false);

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => OrderPage(
                  //       location: OrderDataDetail(
                  //         destinationAddress: session.destinationAddress,
                  //         originAddress: session.originAddress,
                  //         originLatLng:
                  //             LatLng(session.originLat, session.originLong),
                  //         destinationLatLng: LatLng(
                  //             session.destinationLat, session.destinationLong),
                  //       ),
                  //     ),
                  //   ),
                  // );
                }

                //   if (session.orderStatus != 100 || session.orderStatus != 8) {

                //     // OrderDataDetail(destinationAddress: session.destinationAddress,originAddress: session.originAddress,
                //     //   originLatLng: LatLng(session.originLat, session.originLong),destinationLatLng: LatLng(session.destinationLat, session.destinationLong

                //     // Navigator.pushNamedAndRemoveUntil(
                //     //     context, OrderPage.routeName, (route) => false);

                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => OrderPage(
                //           location: OrderDataDetail(
                //             destinationAddress: session.destinationAddress,
                //             originAddress: session.originAddress,
                //             originLatLng:
                //                 LatLng(session.originLat, session.originLong),
                //             destinationLatLng: LatLng(
                //                 session.destinationLat, session.destinationLong),
                //           ),
                //         ),
                //       ),
                //     );
                //   } else {
                //     Navigator.pushNamedAndRemoveUntil(
                //         context, HomePage.routeName, (route) => false);
                //   }
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginPage.routeName, (route) => false);
              }

              // if(session.isLoggedIn){
              //   if(session.orderStatus=)
              // Navigator.pushNamedAndRemoveUntil(
              //     context, OrderPage.routeName, (route) => false);
              // }
              // session.isLoggedIn
              //     ? Navigator.pushNamedAndRemoveUntil(
              //         context, HomePage.routeName, (route) => false)
              //     : Navigator.pushNamedAndRemoveUntil(
              //         context, LoginPage.routeName, (route) => false);

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
