import 'package:appkey_taxiapp_user/features/contact_us/presentation/providers/contactus_provider.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/providers/forgot_password_provider.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/providers/otp_verification_provider.dart';
import 'package:appkey_taxiapp_user/features/login/presentation/providers/login_provider.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/create_profile_provider.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/upload_profile_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
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
import 'features/order/presentation/providers/order_provider.dart';
import 'features/profile/presentation/providers/change_email_provider.dart';
import 'features/profile/presentation/providers/change_password_provider.dart';
import 'features/profile/presentation/providers/profile_edit_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // getKeyHash();

  try {
    await init();

    locator.isReady<Session>().then((_) async {
      await NotificationHelper().init();
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SplashProvider>(
              create: (context) => locator<SplashProvider>(),
            ),
            ChangeNotifierProvider<HomeProvider>(
              create: (context) => locator<HomeProvider>(),
            ),
            ChangeNotifierProvider<OrderProvider>(
              create: (context) => locator<OrderProvider>(),
            ),
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
          ],
          builder: (context, _) => const MyApp(),
        ),
      );
      await FirebaseHelper.init().then((_) {});
    });
  } catch (e) {
    logMe(e);
  }
}

// Platform messages are asynchronous, so we initialize in an async method.
// Future<void> getKeyHash() async {
//   String keyHash;
//   // Platform messages may fail, so we use a try/catch PlatformException.
//   // We also handle the message potentially returning null.
//   try {
//     keyHash = await FlutterFacebookKeyhash.getFaceBookKeyHash ??
//         'Unknown platform KeyHash';
//   } on PlatformException {
//     keyHash = 'Failed to get Kay Hash.';
//   }

//   log("KEY HASH IS===============>>>>>>>>>>>>>" + keyHash);

// If the widget was removed from the tree while the asynchronous platform
// message was in flight, we want to discard the reply rather than calling
// setState to update our non-existent appearance.
// if (!mounted) return;

// setState(() {
//   _keyHash = keyHash;
// });
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<GlobalKey<NavigatorState>>(),
      title: 'Flutter Demo',
      theme: ThemeData(
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
      ],
      supportedLocales: const [
        Locale('en', ''),
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
