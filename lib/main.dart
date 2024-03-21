import 'dart:developer';
import 'package:GetsbyRideshare/core/presentation/providers/logout_provider.dart';
import 'package:GetsbyRideshare/core/static/strings.dart';
import 'package:GetsbyRideshare/deryde_folder/chat/provider/test_socket_provider.dart';
import 'package:GetsbyRideshare/features/contact_us/presentation/providers/contactus_provider.dart';
import 'package:GetsbyRideshare/features/forgot_password/presentation/providers/forgot_password_provider.dart';
import 'package:GetsbyRideshare/features/forgot_password/presentation/providers/otp_verification_provider.dart';
import 'package:GetsbyRideshare/features/login/presentation/providers/login_provider.dart';
import 'package:GetsbyRideshare/features/new_card_payment/presentation/providers/payment_provider.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/create_profile_provider.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/upload_profile_image_provider.dart';
import 'package:GetsbyRideshare/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/presentation/pages/splash_page.dart';
import 'core/presentation/providers/home_provider.dart';
import 'core/presentation/providers/place_picker_provider.dart';
import 'core/presentation/providers/splash_provider.dart';
import 'core/routes/route.dart';
import 'core/static/colors.dart';
import 'core/utility/firebase_helper.dart';
import 'core/utility/helper.dart';
import 'core/utility/injection.dart';
import 'core/utility/notification_service.dart';
import 'core/utility/session_helper.dart';
import 'features/about_us/presentation/providers/aboutus_provider.dart';
import 'features/history/presentation/providers/history_provider.dart';
import 'features/profile/presentation/providers/change_email_provider.dart';
import 'features/profile/presentation/providers/change_password_provider.dart';
import 'features/profile/presentation/providers/profile_edit_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var sp = await SharedPreferences.getInstance();
  var login = sp.getBool(IS_LOGGED_IN);
  log("login is main ********** $login");
  await Firebase.initializeApp(name: 'gatsbyRideShare', options: DefaultFirebaseOptions.currentPlatform);
  try {
    await init();
    await FirebaseMessaging.instance.requestPermission();
    await locator.isReady<Session>().then((_) async {
      var session = locator<Session>();
      log("is logged in------------->>>>>  " + session.isLoggedIn.toString());
      await NotificationHelper().init();
      await FirebaseHelper.init();
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SplashProvider>(
              create: (context) => locator<SplashProvider>(),
            ),
            ChangeNotifierProvider<HomeProvider>(
              create: (context) => locator<HomeProvider>(),
            ),
            // ChangeNotifierProvider<OrderProvider>(
            //   create: (context) => locator<OrderProvider>(),
            // ),
            ChangeNotifierProvider<PlacePickerProvider>(
              create: (context) => locator<PlacePickerProvider>(),
            ),
            ChangeNotifierProvider<AboutUsProvider>(
              create: (context) => locator<AboutUsProvider>(),
            ),
            ChangeNotifierProvider<ProfileProvider>(
              create: (context) => locator<ProfileProvider>(),
            ),
            ChangeNotifierProvider<HistoryProvider>(
              create: (context) => locator<HistoryProvider>(),
            ),
            ChangeNotifierProvider<ProfileEditProvider>(
              create: (context) => locator<ProfileEditProvider>(),
            ),
            ChangeNotifierProvider<ChangeEmailProvider>(
              create: (context) => locator<ChangeEmailProvider>(),
            ),
            ChangeNotifierProvider<ChangePasswordProvider>(
              create: (context) => locator<ChangePasswordProvider>(),
            ),
            ChangeNotifierProvider<ForgotPasswordProvider>(
              create: (context) => locator<ForgotPasswordProvider>(),
            ),
            ChangeNotifierProvider<OtpVerificationProvider>(
              create: (context) => locator<OtpVerificationProvider>(),
            ),
            ChangeNotifierProvider<CreateProfileProvider>(
              create: (context) => locator<CreateProfileProvider>(),
            ),
            ChangeNotifierProvider<UploadProfileImageProvider>(
              create: (context) => locator<UploadProfileImageProvider>(),
            ),
            ChangeNotifierProvider<ContactusProvider>(
              create: (context) => locator<ContactusProvider>(),
            ),
            ChangeNotifierProvider<LoginProvider>(
              create: (context) => locator<LoginProvider>(),
            ),
            // ChangeNotifierProvider<SocketProvider>(
            //   create: (context) => locator<SocketProvider>(),
            // ),
            ChangeNotifierProvider<PaymentProvider>(
              create: (context) => locator<PaymentProvider>(),
            ),
            ChangeNotifierProvider<TestSocketProvider>(
              create: (context) => locator<TestSocketProvider>(),
            ),
            // ChangeNotifierProvider<LatestSocketProvider>(
            //   create: (context) => LatestSocketProvider(),
            // ),
            ChangeNotifierProvider<LogOutProvider>(
              create: (context) => locator<LogOutProvider>(),
            ),

            // ChangeNotifierProvider<SocketProvider>(
            //   create: (context) => SocketProvider(),
            // ),
          ],
          builder: (context, _) => const MyApp(),
        ),
      );
    });
  } catch (e) {
    logMe(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<GlobalKey<NavigatorState>>(),
      title: 'GatsbyRideShare',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: yellowE5A829Color
                // primary: primaryColor,
                ),
      ),
      navigatorObservers: [routeObserver],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      // Initialize routes
      onGenerateRoute: generateRoute,
      home: const SplashPage(),
      // home: CreateProfilePage(),
      debugShowCheckedModeBanner: false,

      builder: FlutterSmartDialog.init(),
    );

    // return MaterialApp(
    //   home: PaymentScreen(),
    // );
  }
}
