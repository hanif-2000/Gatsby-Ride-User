import 'dart:developer';

import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/static/dimens.dart';
import 'package:appkey_taxiapp_user/features/register/presentation/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/utility/injection.dart';
import '../providers/login_provider.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (context) => locator<LoginProvider>(),
      child: Scaffold(
        backgroundColor: whiteColor,
        // appBar: CustomAppTtitleBar(
        //   centerTitle: true,
        //   canBack: true,
        //   title: appLoc.login.toUpperCase(),
        //   hideShadow: false,
        // ),
        body: SafeArea(
          child: ListView(
            children: [
              AspectRatio(
                aspectRatio: 5 / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        "Hi, Welcome Back! ",
                        // appLoc.welcome.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "poPPinSemiBold",
                          fontWeight: FontWeight.w600,
                          color: black15141FColor,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        "Sign in to your account.",
                        // appLoc.welcome.toUpperCase(),
                        textAlign: TextAlign.center,
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
              const LoginForm(),
              const SizedBox(
                height: 26,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RegisterPage.routeName,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Don’t have an account?",
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
                      " Sign Up",
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
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    dividerIcon,
                    color: greyEBEBEBColor,
                  ),
                  const Text(
                    "    Or login with    ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'poPPinRegular',
                      color: greyA2A0A8Color,
                    ),
                  ),
                  Image.asset(
                    dividerIcon,
                    color: greyEBEBEBColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: sizeMedium,
                  right: sizeMedium,
                  bottom: sizeMedium,
                ),
                child: CustomButton(
                  text: const Text(
                    "Login with Facebook",
                    style: TextStyle(
                      fontFamily: "poPPinSemiBold",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  image: Image.asset(
                    facebookIcon,
                    width: 21,
                    height: 21,
                  ),
                  event: () {
                    //                   Future<UserCredential> signInWithFacebook() async {
                    // // Trigger the sign-in flow
                    // final LoginResult loginResult = await FacebookAuth.instance.login();

                    // // Create a credential from the access token
                    // final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);

                    // // Once signed in, return the UserCredential
                    // return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// }
                  },
                  buttonHeight: 50,
                  // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                  isRounded: true,
                  bgColor: blue3B5998Color,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: sizeMedium,
                  right: sizeMedium,
                  bottom: sizeMedium,
                ),
                child: CustomButton(
                  text: const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      fontFamily: "poPPinSemiBold",
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                      fontSize: 15,
                    ),
                  ),
                  image: SvgPicture.asset('assets/icons/google.svg'),
                  event: () async {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    // Trigger the authentication flow
                    final GoogleSignInAccount? googleUser =
                        await GoogleSignIn().signIn();

                    // Obtain the auth details from the request
                    final GoogleSignInAuthentication? googleAuth =
                        await googleUser?.authentication;

                    log("Google auth" + googleAuth.toString());

                    // Create a new credential
                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth?.accessToken,
                      idToken: googleAuth?.idToken,
                    );
                    log("Credential" + credential.toString());

                    // Once signed in, return the UserCredential
                    return await auth.signInWithCredential(credential);
                  },
                  buttonHeight: 50,
                  // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                  isRounded: true,
                  bgColor: greyC8C7CCColor,
                ),
              ),

              // Center(
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.pushNamedAndRemoveUntil(
              //           context, HomePage.routeName, (route) => false);
              //     },
              //     child: const Text(
              //       'Skip for now',
              //       style: TextStyle(
              //         fontFamily: 'poPPinRegular',
              //         fontSize: 15,
              //         fontWeight: FontWeight.w400,
              //         color: greyA2A0A8Color,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),

              // mediumVerticalSpacing(),
              //
              // Padding(
              //     padding: const EdgeInsets.only(
              //       left: sizeMedium,
              //       right: sizeMedium,
              //       bottom: sizeMedium,
              //     ),
              //     child: CustomButton(
              //         text: Text(
              //           appLoc.signup.toUpperCase(),
              //           style: txtButtonStyle,
              //         ),
              //         event: () {
              //           Navigator.pushNamed(
              //             context,
              //             RegisterPage.routeName,
              //           );
              //         },
              //         buttonHeight: MediaQuery.of(context).size.height * 0.080,
              //         isRounded: true,
              //         bgColor: blackColor,),),
            ],
          ),
        ),
      ),
    );
  }
}
