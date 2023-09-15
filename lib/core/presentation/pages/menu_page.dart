import 'package:GetsbyRideshare/core/presentation/widgets/profile_drawer.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/contact_us/presentation/pages/contact_us_page.dart';
import 'package:GetsbyRideshare/features/history/presentation/pages/history_page.dart';
import 'package:GetsbyRideshare/features/privacy_policy/privacy_policy_page.dart';
import 'package:GetsbyRideshare/features/terms_and_conditions/terms_and_conditions.dart';
// import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:flutter/material.dart';

import '../../utility/helper.dart';
import '../widgets/close_button.dart';
import '../widgets/custom_dialog_logout.dart';
import '../widgets/drawer_button.dart';
import 'splash_page.dart';

class HomeDrawerPage extends StatelessWidget {
  const HomeDrawerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: CloseDrawerButtonWidget()),

                // User Profile
                const ProfileInformationDrawer(),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    children: [
                      // History
                      DrawerButtonItemWidget(
                        title: appLoc.history,
                        onTap: () {
                          Navigator.pushNamed(context, HistoryPage.routeName);
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   HistoryPage.routeName,
                          // );
                        },
                      ),

                      // //Information
                      // DrawerButtonItemWidget(
                      //   title: appLoc.profile,
                      //   onTap: () {
                      //     Navigator.pushReplacementNamed(
                      //       context,
                      //       ProfilePage.routeName,
                      //     );
                      //   },
                      // ),

                      //Contact Us
                      DrawerButtonItemWidget(
                        title: appLoc.contactUs,
                        onTap: () {
                          Navigator.pushNamed(context, ContactUsPage.routeName);
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   ContactUsPage.routeName,
                          // );
                        },
                      ),

//Privacy Policy
                      DrawerButtonItemWidget(
                        title: appLoc.privacyPolicy,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyPage(),
                            ),
                          );
                        },
                      ),

                      //Terms and Conditions

                      DrawerButtonItemWidget(
                        title: appLoc.termAndConditions,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionsPage(),
                            ),
                          );
                        },
                      ),

                      //Testing Button for payment

                      // DrawerButtonItemWidget(
                      //   title: "Testing Payment",
                      //   onTap: () {
                      //     sendPayment();
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => PaymentHomePage(),
                      //     //   ),
                      //     // );
                      //   },
                      // ),

                      //ABOUT US
                      // DrawerButtonItemWidget(
                      //   title: appLoc.we,
                      //   onTap: () {
                      //     Navigator.pushReplacementNamed(
                      //       context,
                      //       AboutUsPage.routeName,
                      //     );
                      //   },
                      // ),

                      //LogOut
                      // DrawerButtonItemWidget(
                      //   title: appLoc.logout,
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (_) => CustomLogoutDialog(
                      //         positiveAction: () async {
                      //           await sessionLogOut().then((_) =>
                      //               Navigator.of(context)
                      //                   .pushNamedAndRemoveUntil(
                      //                       SplashPage.routeName,
                      //                       (route) => false));
                      //         },
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => CustomLogoutDialog(
                        positiveAction: () async {
                          await sessionLogOut().then((_) =>
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  SplashPage.routeName, (route) => false));
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      appLoc.logout,
                      style: TextStyle(
                        color: grey858585Color,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPayment() async {
    // String upiurl =
    //     'upi://pay?pa=user@hdfgbank&pn=SenderName&tn=TestingGpay&am=100&cu=INR';
    // await launchUrl(Uri.parse(upiurl));

    // final res = await EasyUpiPaymentPlatform.instance.startPayment(
    //   EasyUpiPaymentModel(
    //     payeeVpa: 'amitbahadur@aubank',
    //     payeeName: 'Amit Bahadur',
    //     amount: 10.0,
    //     description: 'Testing payment',
    //   ),
    // );
    // TODO: add your success logic here
    // print(res);
  }

  //   on EasyUpiPaymentException {
  //     // TODO: add your exception logic here
  //   }
  // }
}
