import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/widgets/form_change_password.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  final String? email;
  static const String routeName = "ChangePasswordPage";
  const ChangePasswordPage({Key? key, this.email}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logMe("changed password email is :-------------->${widget.email}");
    return Scaffold(
      backgroundColor: whiteColor,
      // appBar: CustomAppTtitleBar(
      //   centerTitle: true,
      //   onPressed: () {
      //     var provider =
      //         Provider.of<ChangePasswordProvider>(context, listen: false);
      //     provider.refreshPassword();
      //     Navigator.pop(context);
      //   },
      //   canBack: true,
      //   title: appLoc.changePassword.toUpperCase(),
      //   hideShadow: true,
      // ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              children: [
                FormChangePassword(
                  email: widget.email,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
