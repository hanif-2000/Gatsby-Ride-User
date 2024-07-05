import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/custom_app_title_bar.dart';
import '../../../../core/static/styles.dart';
import '../providers/aboutus_provider.dart';
import '../providers/aboutus_state.dart';
import '../../../../core/utility/injection.dart';

class AboutUsPage extends StatefulWidget {
  static const String routeName = "AboutUsPage";
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String appVersion = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getVersion();
    });
  }

  Future getVersion() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
        logMe('appVersion $appVersion');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => locator<AboutUsProvider>(),
        child: Scaffold(
            backgroundColor: whiteColor,
            appBar: CustomAppTtitleBar(
              centerTitle: true,
              canBack: true,
              title: appLoc.appName.toUpperCase(),
              hideShadow: false,
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 25,
                      child: Text(
                        "User App",
                        style: versionAppHeadTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Text(
                        "Version $appVersion",
                        style: versionAppTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              elevation: 0,
            ),
            body: SafeArea(
              child: StreamBuilder<AboutUsState>(
                  stream: context.read<AboutUsProvider>().fetchAboutUs(),
                  builder: (context, state) {
                    switch (state.data.runtimeType) {
                      case AboutUsLoading:
                        return const Center(child: CircularProgressIndicator());
                      case AboutUsFailure:
                        final failure = (state.data as AboutUsFailure).failure;
                        showToast(message: failure);
                        return const SizedBox.shrink();
                      case AboutUsLoaded:
                        final data = (state.data as AboutUsLoaded).data;

                        return SingleChildScrollView(
                            child: HtmlWidget(
                          data!.text ?? '',
                          textStyle: TextStyle(fontFamily: "Yu Gothic"),
                        ));
                    }
                    return const SizedBox.shrink();
                  }),
            )));
  }
}
//
