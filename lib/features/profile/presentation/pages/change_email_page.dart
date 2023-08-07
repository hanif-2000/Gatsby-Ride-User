import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_app_title_bar.dart';
import '../widgets/form_change_email.dart';

class ChangeEmailPage extends StatefulWidget {
  static const String routeName = "ChangeEmailPage";
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: CustomAppTtitleBar(
          centerTitle: true,
          canBack: true,
          title: appLoc.emailAddressChange.toUpperCase(),
          hideShadow: true,
        ),
        body: SafeArea(child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              children: const [FormChangeEmail()],
            );
          },
        )));
  }
}
