import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/utility/helper.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../../../socket/latest_socket_provider.dart';
import '../../../register/presentation/pages/register_page.dart';
import '../providers/login_provider.dart';
import '../providers/login_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    var socketProvider = locator<LatestSocketProvider>();
    return ChangeNotifierProvider<LoginProvider>(
      create: (ctx) => locator<LoginProvider>(),
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
                    final GoogleSignIn _googleSignIn =
                        GoogleSignIn(signInOption: SignInOption.standard);

                    // Trigger the authentication flow
                    final GoogleSignInAccount? googleUser =
                        await _googleSignIn.signIn();

                    log("google user:--> $googleUser");

                    // Obtain the auth details from the request
                    final GoogleSignInAuthentication? googleAuth =
                        await googleUser?.authentication;

                    log("Google auth$googleAuth");

                    // Create a new credential
                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth?.accessToken,
                      idToken: googleAuth?.idToken,
                    );
                    log("Credential$credential");
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    // // Trigger the authentication flow
                    // final GoogleSignInAccount? googleUser =
                    //     await GoogleSignIn().signIn();

                    // // Obtain the auth details from the request
                    // final GoogleSignInAuthentication? googleAuth =
                    //     await googleUser?.authentication;

                    // log("Google auth " + googleAuth.toString());

                    // // Create a new credential
                    // final credential = GoogleAuthProvider.credential(
                    //   accessToken: googleAuth?.accessToken,
                    //   idToken: googleAuth?.idToken,
                    // );
                    // log("Credential " + credential.toString());

                    // Once signed in, return the UserCredential
                    await auth.signInWithCredential(credential).then((value) {
                      log("value is -->> $value");

                      log("email is :-->> ${value.user!.email}");
                      log("name is :-->> ${value.user!.displayName}");
                      log("google name is :-->> ${googleUser!.displayName!}");

                      log("uid is :-->> ${value.user!.uid}");

                      var provider =
                          Provider.of<LoginProvider>(context, listen: false);
                      provider
                          .updateSocialLoginData(
                        userEmail: value.user!.email!,
                        name:
                            value.user!.displayName ?? googleUser.displayName!,
                        id: value.user!.uid,
                      )
                          .then((value) {
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
                              socketProvider.connectToSocket(context);
                              Navigator.pushNamedAndRemoveUntil(context,
                                  HomePage.routeName, (route) => false);
                              logMe(
                                  "Authorization Token: ${session.sessionToken}");
                              break;
                          }
                        });
                      });
                      log("value" + value.toString());
                    });
                  },
                  buttonHeight: 50,
                  // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                  isRounded: true,
                  bgColor: greyC8C7CCColor,
                ),
              ),

// Sign in with apple

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
                          final FirebaseAuth auth = FirebaseAuth.instance;

                          final credential =
                              await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                          );
                          final oauthCredential =
                              OAuthProvider("apple.com").credential(
                            idToken: credential.identityToken,
                          );

                          // Navigator.pop(context);
                          log('Email - ${credential.email}');
                          log('Name - ${credential.givenName}');
                          log('Code - ${credential.authorizationCode}');
                          log('userIdentifier - ${credential.userIdentifier}');
                          log('Token - ${credential.identityToken}');

                          log("apple credentials: $credential");

                          if (credential.email == null ||
                              credential.email == '') {
                            var value = await FlutterKeychain.get(
                                key: "${credential.userIdentifier}");
                            if (value != null) {
                              log('User detail --> $value');
                              String name =
                                  value.split(':').first.split('/').first;
                              String lastName =
                                  value.split(':').first.split('/').last;
                              String email = value.split(':').last;

                              final oauthCredential =
                                  OAuthProvider("apple.com").credential(
                                idToken: credential.identityToken,
                              );

                              //  AuthCredential savedCredential= AuthorizationAppleID(000364.a2aa5cb11a3a4f288b26927d0f28fb1e.0445, apps, Davaloper, appsdeveloper22@gmail.com, null)

                              log('name - $name');
                              log('Email - $email');
                              log('lastname-$lastName');

                              // auth.signInWithCredential(oauthCredential).then((value) {
                              //   log("value $value");

                              //   loginApi(
                              //       socialId: value.user!.uid,
                              //       loginType: Constants.apple,
                              //       firstName: name,
                              //       lastName: lastName,
                              //       profilePic: '');
                              // });

                              await auth
                                  .signInWithCredential(oauthCredential)
                                  .then((value) {
                                var provider = Provider.of<LoginProvider>(
                                    context,
                                    listen: false);
                                provider
                                    .updateSocialLoginData(
                                  userEmail: value.user!.email ?? email,
                                  name: value.user!.displayName ??
                                      "$name $lastName",
                                  id: value.user!.uid,
                                )
                                    .then((value) {
                                  provider
                                      .doLoginApiSocial()
                                      .listen((state) async {
                                    log(state.toString());
                                    switch (state.runtimeType) {
                                      case LoginLoading:
                                        showLoading();

                                        break;
                                      case LoginFailure:
                                        final msg =
                                            (state as LoginFailure).failure;

                                        // log("-------->>>>>>" + msg.toString());
                                        dismissLoading();

                                        showToast(message: msg);
                                        break;
                                      case LoginSuccess:
                                        dismissLoading();

                                        final session = locator<Session>();
                                        session.setLoggedIn = true;
                                        showToast(message: appLoc.success);

                                        socketProvider.connectToSocket(context);
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            HomePage.routeName,
                                            (route) => false);
                                        logMe(
                                            "Authorization Token: ${session.sessionToken}");
                                        break;
                                    }
                                  });
                                });
                                log("value" + value.toString());
                              });

                              return true;
                            } else {
                              return true;
                            }
                          } else {
                            await FlutterKeychain.put(
                                key: credential.userIdentifier!,
                                value:
                                    "${credential.givenName}/${credential.familyName}:${credential.email}");
                            log('Saved in Keychain.....');

                            log("oauthcredential: $oauthCredential");

                            await auth
                                .signInWithCredential(oauthCredential)
                                .then((value) {
                              log("display name is:-->>${value.user!.displayName}");
                              log(" user email is:-->>${value.user!.email}");
                              log("user id  is:-->>${value.user!.uid}");

                              var provider = Provider.of<LoginProvider>(context,
                                  listen: false);
                              provider
                                  .updateSocialLoginData(
                                userEmail:
                                    value.user!.email ?? credential.email!,
                                name: value.user!.displayName ??
                                    credential.familyName!,
                                id: value.user!.uid,
                              )
                                  .then((value) {
                                provider
                                    .doLoginApiSocial()
                                    .listen((state) async {
                                  log(state.toString());
                                  switch (state.runtimeType) {
                                    case LoginLoading:
                                      showLoading();

                                      break;
                                    case LoginFailure:
                                      final msg =
                                          (state as LoginFailure).failure;

                                      // log("-------->>>>>>" + msg.toString());
                                      dismissLoading();

                                      showToast(message: msg);
                                      break;
                                    case LoginSuccess:
                                      dismissLoading();

                                      final session = locator<Session>();
                                      session.setLoggedIn = true;
                                      showToast(message: appLoc.success);
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          HomePage.routeName, (route) => false);
                                      logMe(
                                          "Authorization Token: ${session.sessionToken}");
                                      break;
                                  }
                                });
                              });
                              log("value" + value.toString());
                            });

                            // userModel = SocialUserModel(
                            //   credential.givenName,
                            //   credential.userIdentifier,
                            //   credential.email,
                            //   '',
                            // );
                            return true;
                          }
                        },
                        buttonHeight: 50,
                        // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                        isRounded: true,
                        bgColor: black080808Color,
                      ),
                    )
                  : SizedBox(),

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
