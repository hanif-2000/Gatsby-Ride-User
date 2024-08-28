import 'dart:developer';
import 'dart:io';

import 'package:GetsbyRideshare/features/login/domain/usecases/entities/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/utility/helper.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../../register/presentation/pages/register_page.dart';
import '../providers/login_provider.dart';
import '../providers/login_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with AuthServices{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (ctx) => locator<LoginProvider>(),
      child: Scaffold(
        backgroundColor: whiteColor,
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
          /*    Padding(
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
              ),*/

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
                    await signInWithGoogle().then((value) {
                      if(value != null){
                        log("value" + value.toString());
                        var provider = Provider.of<LoginProvider>(context, listen: false);
                        provider.updateSocialLoginData(
                          userEmail: value.email??"",
                          name: value.name??"",
                          id: value.socialId??""
                        );
                        provider.doLoginApiSocial().listen((state) async {
                          log(state.toString());
                          switch (state.runtimeType) {
                            case LoginLoading:
                              showLoading();

                              break;
                            case LoginFailure:
                              final msg = (state as LoginFailure).failure;

                              // log("-------->>>>>>" + msg.toString());
                              dismissLoading();

                              showToast(message: msg);
                              break;
                            case LoginSuccess:
                              dismissLoading();

                              final session = locator<Session>();
                              session.setLoggedIn = true;
                              showToast(message: "Login Success");
                              // socketProvider.connectToSocket(context);
                              Navigator.pushNamedAndRemoveUntil(context,
                                  HomePage.routeName, (route) => false);
                              logMe(
                                  "Authorization Token: ${session.sessionToken}");
                              break;
                          }
                        });
                      }


                    });
                  },
                  buttonHeight: 50,
                  // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                  isRounded: true,
                  bgColor: greyC8C7CCColor,
                ),
              ),

              Platform.isIOS
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: sizeMedium,
                        right: sizeMedium,
                        bottom: sizeMedium,
                      ),
                      child: CustomButton(
                        text: const Text(
                          "Sign in with Apple",
                          style: TextStyle(
                            fontFamily: "poPPinSemiBold",
                            fontWeight: FontWeight.w600,
                            color: whiteColor,
                            fontSize: 15,
                          ),
                        ),
                        image: SvgPicture.asset('assets/icons/apple.svg'),
                        event: () async {
                         await signInWithApple().then((value){
                           if(value != null){
                             log("value" + value.toString());
                             var provider = Provider.of<LoginProvider>(context, listen: false);
                             provider.updateSocialLoginData(
                               userEmail: value.email??"",
                               name: value.name ?? "",
                               id: value.socialId??"",
                             );
                             provider.doLoginApiSocial().listen((state) async {
                               log(state.toString());
                               switch (state.runtimeType) {
                                 case LoginLoading:
                                   showLoading();
                                   break;
                                 case LoginFailure:
                                   final msg = (state as LoginFailure).failure;
                                   dismissLoading();
                                   showToast(message: msg);
                                   break;
                                 case LoginSuccess:
                                   log("+++++++++++++>>>>>>>APPLE LOGIN SUCCESS==============");
                                   dismissLoading();
                                   final session = locator<Session>();
                                   session.setLoggedIn = true;
                                   showToast(message: appLoc.success);

                                   //   socketProvider.connectToSocket(context);

                                   Navigator.pushNamedAndRemoveUntil(
                                       context,
                                       HomePage.routeName,
                                           (route) => true);

                                   logMe(
                                       "Authorization Token: ${session.sessionToken}");
                                   break;
                               }
                             });
                           }
                         });
                        },
                        buttonHeight: 50,
                        // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                        isRounded: true,
                        bgColor: black080808Color,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
