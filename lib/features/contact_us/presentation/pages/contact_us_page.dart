import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/features/contact_us/presentation/providers/contactus_provider.dart';
import 'package:GetsbyRideshare/features/contact_us/presentation/widgets/contact_us_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);
  static const routeName = '/contactus';

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
        create: (context) => locator<ContactusProvider>(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: whiteColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: blackColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: whiteColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset('assets/icons/contact_us.svg'),
                  SizedBox(
                    height: _deviceSize.height * .02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: _deviceSize.height * .02,
                      bottom: _deviceSize.height * .01,
                    ),
                    child: const Text(
                      "Contact us",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Text(
                    "Please enter your detail",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: grey767676Color,
                    ),
                  ),
                  const ContactUsForm()
                ],
              ),
            )

            // SafeArea(
            //   child: ListView(
            //     children: [
            //       AspectRatio(
            //         // aspectRatio: 3 / 0.8,
            //         aspectRatio: 5 / 2,
            //         child: Padding(
            //           padding: const EdgeInsets.all(12.0),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Align(
            //                 alignment: Alignment.topLeft,
            //                 child: InkWell(
            //                   onTap: () {
            //                     Navigator.pop(context);
            //                   },
            //                   child: const Padding(
            //                     padding: EdgeInsets.all(0.0),
            //                     child: Icon(Icons.arrow_back,
            //                         color: black15141FColor),
            //                   ),
            //                 ),
            //               ),
            //               const Flexible(
            //                 fit: FlexFit.loose,
            //                 flex: 1,
            //                 child: Center(
            //                   child: Text(
            //                     "Reset your password",
            //                     textAlign: TextAlign.center,
            //                     style: TextStyle(
            //                       fontFamily: "poPPinSemiBold",
            //                       fontWeight: FontWeight.w600,
            //                       color: black15141FColor,
            //                       fontSize: 24,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               const Flexible(
            //                 // fit: FlexFit.loose,
            //                 flex: 1,
            //                 child: Center(
            //                   child: Text(
            //                     "Enter your official email to get a verification code.",
            //                     // appLoc.welcome.toUpperCase(),
            //                     textAlign: TextAlign.center,
            //                     softWrap: true,
            //                     style: TextStyle(
            //                       fontFamily: "poPPinMedium",
            //                       fontWeight: FontWeight.w500,
            //                       color: grey7C7C7CColor,
            //                       fontSize: 15,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               // Flexible(
            //               //   fit: FlexFit.loose,
            //               //   flex: 1,
            //               //   child: Text(
            //               //     appLoc.pleaseEnterYourEmailAddress,
            //               //     textAlign: TextAlign.center,
            //               //     style: const TextStyle(
            //               //             fontSize: 15,
            //               //             color: Colors.black,
            //               //             fontWeight: FontWeight.bold)
            //               //         .useHiraginoKakuW6Font(),
            //               //   ),
            //               // ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 30,
            //       ),
            //       // const FormForgotPassword(),
            //       // mediumVerticalSpacing(),
            //     ],
            //   ),
            // ),

            ));
  }
}
