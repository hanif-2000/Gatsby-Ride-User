import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/static/colors.dart';
import '../../core/utility/helper.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);
  static const routeName = '/termsandconditions';

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  late final WebViewController controller;

  var loadingPercentage = 0;
  var error = false;
  String url = "https://api.gatsbyrideshare.com/terms";

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
            icon: Icon(
              Icons.arrow_back,
              color: black080808Color,
            ),
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
