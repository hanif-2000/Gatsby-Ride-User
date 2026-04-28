import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/static/colors.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);
  static const routeName = '/termsandconditions';

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  late final WebViewController controller;

  static const String _htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Terms and Conditions</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
      line-height: 1.8;
      color: #333;
      background-color: #fff;
    }
    p {
      font-size: 15px;
      color: #333;
      margin-bottom: 8px;
    }
  </style>
</head>
<body>
  <p>1. By using Gatsby rideshare services, you agree to the following terms and conditions</p>
  <p>2. You must be at least 18 years old and possess a class 4 valid driver\'s license to use the Gatsby rideshare app as a driver.</p>
  <p>3. You must be at least 18 years old to use the Gatsby rideshare app as a passenger. Unless a parent or guardian consent.</p>
  <p>4. Gatsby rideshare drivers must have a valid and up-to-date insurance policy that meets the minimum requirements set by local laws</p>
  <p>5. Payment for rides must be made through the Gatsby rideshare app using a valid credit or debit card.</p>
  <p>6. Passengers are advised to behave responsibly and courteously during rides. Any misuse, vandalism, or damage to the vehicle may result in legal action.</p>
  <p>7. Drivers are responsible for ensuring that the vehicle used for transport is roadworthy, clean, and free of defects that may pose a risk to passengers.</p>
  <p>8. Gatsby rideshare does not provide any guarantee for reliability, quality, or success of any ride booked through the app</p>
  <p>9. Gatsby rideshare does not assume any liability for any loss or damages caused by or arising out of its services, including but not limited to accidents, theft, loss of property, and personal injuries.</p>
  <p>10. Gatsby rideshare reserves the right to suspend or terminate any user\'s account for any violation of the terms and conditions stated herein, or any other local or federal laws or regulations.</p>
  <p>11. Any disputes arising out of or related to the use of Gatsby rideshare services shall be governed by the laws of Alberta</p>
  <p>12. These terms and conditions may be modified by Gatsby rideshare at any time without prior notice. Users are advised to read the terms and conditions periodically and to discontinue use of the app if they do not agree with the revised terms and conditions.</p>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(whiteColor)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: black080808Color),
          ),
          title: const Text(
            'Terms and Conditions',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
