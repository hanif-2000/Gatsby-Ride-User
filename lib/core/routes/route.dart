import 'package:appkey_taxiapp_user/core/domain/entities/order_data_detail.dart';
import 'package:appkey_taxiapp_user/core/presentation/pages/home_page/home_page.dart';
import 'package:appkey_taxiapp_user/features/about_us/presentation/pages/aboutus_page.dart';
import 'package:appkey_taxiapp_user/features/contact_us/presentation/pages/contact_us_page.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:appkey_taxiapp_user/features/history/presentation/pages/detail_history_page.dart';
import 'package:appkey_taxiapp_user/features/history/presentation/pages/history_page.dart';
import 'package:appkey_taxiapp_user/features/login/presentation/pages/login_page.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/pages/order_page.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/pages/change_email_page.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/pages/change_password_page.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/pages/profile_page.dart';
import 'package:appkey_taxiapp_user/features/register/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';

import '../../features/forgot_password/presentation/pages/otp_verification_page.dart';
import '../../features/history/data/models/history_response_model.dart';
import '../../features/profile/presentation/pages/create_profile_page.dart';
import '../presentation/pages/splash_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashPage.routeName:
      return MaterialPageRoute(builder: (_) => const SplashPage());
    case HomePage.routeName:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case LoginPage.routeName:
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case RegisterPage.routeName:
      return MaterialPageRoute(builder: (_) => const RegisterPage());
    case CreateProfilePage.routeName:
      return MaterialPageRoute(builder: (_) => const CreateProfilePage());
    case ForgotPasswordPage.routeName:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
    case OtpVerificationPage.routeName:
      final args = settings.arguments as Map;

      return MaterialPageRoute(
          builder: (_) => OtpVerificationPage(
                email: args['email'],
              ));
    case AboutUsPage.routeName:
      return MaterialPageRoute(builder: (_) => const AboutUsPage());
    case ProfilePage.routeName:
      return MaterialPageRoute(builder: (_) => const ProfilePage());
    case EditProfilePage.routeName:
      return MaterialPageRoute(builder: (_) => const EditProfilePage());
    case ChangeEmailPage.routeName:
      return MaterialPageRoute(builder: (_) => const ChangeEmailPage());
    case ChangePasswordPage.routeName:
      final args = settings.arguments as Map;

      return MaterialPageRoute(
          builder: (_) => ChangePasswordPage(
                email: args['email'],
              ));
    case HistoryPage.routeName:
      return MaterialPageRoute(builder: (_) => const HistoryPage());
    case DetailHistoryPage.routeName:
      final args = settings.arguments as HistoryOrder;
      return MaterialPageRoute(
          builder: (_) => DetailHistoryPage(
                item: args,
              ));
    case OrderPage.routeName:
      final args = settings.arguments as OrderDataDetail;
      return MaterialPageRoute(
          builder: (_) => OrderPage(
                location: args,
              ));

    case ContactUsPage.routeName:
      return MaterialPageRoute(builder: (_) => const ContactUsPage());

    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
