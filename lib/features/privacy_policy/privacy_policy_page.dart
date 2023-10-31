import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/static/colors.dart';
import '../../core/utility/helper.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);
  static const routeName = '/privacypolicy';

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final WebViewController controller;

  var loadingPercentage = 0;
  var error = false;
  String url = "https://php.parastechnologies.in/taxi/public/privacy";

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    controller.setBackgroundColor(whiteColor);

    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          log("on page started called ");
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (int progress) {
          showLoading();

          log("progress is:-->> $progress");
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (String url) {
          dismissLoading();
          log("on page finished called");
          setState(() {
            loadingPercentage = 100;
          });
        },
        onWebResourceError: (WebResourceError error) =>
            setState(() => this.error = true),
        onNavigationRequest: (NavigationRequest request) =>
            NavigationDecision.navigate,
      ),
    );
    controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || error == true) {
      return const Center(child: Text("Error."));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}















































// import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
// import 'package:appkey_taxiapp_driver/core/static/styles.dart';
// import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
// import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class PrivacyPolicyPage extends StatelessWidget {
//   const PrivacyPolicyPage({Key? key}) : super(key: key);
//   static const routeName = '/PrivacyPolicyPage';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             largeVerticalSpacing(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
//                 ),
//                 Text(
//                   appLoc.privacyPolicy,
//                   textAlign: TextAlign.center,
//                   style: titleStyle.copyWith(
//                     fontSize: fontLarge,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 30,
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: sizeMedium, vertical: 8),
//               child: Text(
//                 'Lorem ipsum dolor sit amet, consectetur adipiscing elittiam ut rutrum sapien. ',
//                 textAlign: TextAlign.center,
//                 style: titleStyle
//                     .copyWith(
//                       fontSize: 13,
//                     )
//                     .usePoppinsW4Font(),
//               ),
//             ),
//             mediumVerticalSpacing(),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '1. Nunc sagittis mattis Pellentesque',
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 15,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   mediumVerticalSpacing(),
//                   Text(
//                     '2. Curabitur, luctus faucibus risus eu,',
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 15,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   mediumVerticalSpacing(),
//                   Text(
//                     '3. Nunc sagittis mattis Pellentesque',
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 15,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   mediumVerticalSpacing(),
//                   Text(
//                     '4. Curabitur, luctus faucibus risus eu,',
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 15,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   mediumVerticalSpacing(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }












// import 'package:GetsbyRideshare/core/static/colors.dart';
// import 'package:flutter/material.dart';

// class PrivacyPolicyPage extends StatelessWidget {
//   const PrivacyPolicyPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppBar(
//         backgroundColor: whiteColor,
//         elevation: 0.0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: blackColor,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           "Privacy Policy",
//           style: TextStyle(
//             color: blackColor,
//             fontFamily: 'poPPinSemiBold',
//             fontSize: 21.0,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text(
//                   "1. Safety first: Our top priority is the safety of both our passengers and drivers. We expect all drivers to comply with traffic laws, use seat belts, and never engage in distracted driving."),
//               Text(
//                   "2. Respectful behavior: We value courteous and respectful behavior from both passengers and drivers. Discrimination and inappropriate conduct will not be tolerated and could result in suspension or termination of the driver's account."),
//               Text(
//                   "3. Cleanliness: We expect drivers to maintain a clean and tidy car for the comfort of passengers. Passengers are also expected to respect the driver's property and keep the car clean."),
//               Text(
//                   "4. Open communication: We encourage open communication between drivers and passengers to ensure a pleasant and safe ride. Passengers should indicate their destination upon entering the car and be willing to assist with navigation if necessary"),
//               Text(
//                   "5. Fair pricing: We strive to keep pricing competitive and transparent. Passengers should see an estimate of the fare before requesting a ride, and drivers are expected to follow the pricing structure in their area.."),
//               Text(
//                   "6. Zero-tolerance policy for intoxication: Our services are strictly for sober transportation. Drivers have the right to refuse pick up passengers who are visibly intoxicated, and passengers who become belligerent or disruptive will be removed from the vehicle."),
//               Text(
//                   "By agreeing to these policies, we aim to provide a safe, comfortable, and reliable transportation service for all parties involved."),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
