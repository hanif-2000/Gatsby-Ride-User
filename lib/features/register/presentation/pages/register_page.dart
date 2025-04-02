import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utility/injection.dart';
import '../providers/register_provider.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<RegisterProvider>(),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: ListView(
            children: [
              AspectRatio(
                // aspectRatio: 3 / 0.8,
                aspectRatio: 5 / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child:
                              Icon(Icons.arrow_back, color: black15141FColor),
                        ),
                      ),
                    ),
                    const Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "poPPinSemiBold",
                          fontWeight: FontWeight.w600,
                          color: black15141FColor,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        "Create your account  by filling the following information below",
                        // appLoc.welcome.toUpperCase(),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "poPPinMedium",
                          fontWeight: FontWeight.w500,
                          color: grey7C7C7CColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const FormRegister(),
              mediumVerticalSpacing(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Have an account?",
                      // appLoc.welcome.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "poPPinRegular",
                        fontWeight: FontWeight.w400,
                        color: grey7C7C7CColor,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      " Sign In",
                      // appLoc.welcome.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "poPPinMedium",
                        fontWeight: FontWeight.w500,
                        color: black080809Color,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
