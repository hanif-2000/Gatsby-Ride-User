import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../data/models/login_response_model.dart';
import '../../../data/models/user_model.dart';


mixin AuthServices {

  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      final result = await googleSignIn.signIn();
      if (result != null) {
        final googleAuth = await result.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return  _signInWithCredential(credential, socialType: "google",userName: result.displayName,email: result.email);
      }
      return null;
    } catch (e, s) {
      print('Google sign-in error: $e $s',);
      return null;
    }
  }

/*  Future<UserModel?> facebookLogin() async {
    try {
      final res = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      switch (res.status) {
        case LoginStatus.success:
          final accessToken = res.accessToken;
          printLog('Access token: ${accessToken?.tokenString}');
          if (accessToken?.tokenString == null) {
            return null;
          }
          final facebookAuthCredential = FacebookAuthProvider.credential(accessToken!.tokenString);
          return await _signInWithCredential(facebookAuthCredential, socialType: "facebook");
        case LoginStatus.failed:
          blocLog(msg: 'Facebook login failed: ${res.message}', bloc: "AuthServices");
          return null;
        default:
          return null;
      }
    } catch (e, s) {
      blocLog(msg: 'Facebook login error: $e', bloc: "AuthServices", exp: s.toString());
      return null;
    }
  }*/

  Future<UserModel?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
      );
      _logAppleCredentials(credential);
      if (credential.email == null || credential.email!.isEmpty) {
        final savedUserDetails = await FlutterKeychain.get(key: credential.userIdentifier!);
        if (savedUserDetails != null) {
          final userDetails = _extractUserDetails(savedUserDetails);
          _logExtractedDetails(userDetails);
          final fullName =_getFullName(userDetails["givenName"],userDetails["familyName"]);
          return  _signInWithCredential(oauthCredential, userName: fullName,email: userDetails['email'], socialType: "apple");
        } else {
          final fullName =_getFullName(credential.givenName,credential.familyName);
          return  _signInWithCredential(oauthCredential, userName: fullName,email: credential.email,socialType: "apple");
        }
      } else {
        await _saveUserDetailsToKeychain(credential);
        final fullName =_getFullName(credential.givenName,credential.familyName);
        return  _signInWithCredential(oauthCredential,userName: fullName, email: credential.email, socialType: "apple");
      }
    } catch (error) {
      debugPrint('Error during Apple login: $error');
      return null;
    }
  }
   String _getFullName(String? firstName, String? lastName) {
    if (firstName != null && lastName != null) {
      return "$firstName $lastName";
    } else if (firstName != null) {
      return firstName;
    } else {
      return "";
    }
  }
  void _logAppleCredentials(AuthorizationCredentialAppleID credential) {
    debugPrint('Email - ${credential.email}');
    debugPrint('Name - ${credential.givenName}');
    debugPrint('Code - ${credential.authorizationCode}');
    debugPrint('userIdentifier - ${credential.userIdentifier}');
    debugPrint('Token - ${credential.identityToken}');
    debugPrint("Apple credentials: $credential");
  }

  Map<String, String> _extractUserDetails(String savedUserDetails) {
    final parts = savedUserDetails.split(':');
    final names = parts.first.split('/');
    return {
      'givenName': names.first,
      'familyName': names.last,
      'email': parts.last,
    };
  }

  void _logExtractedDetails(Map<String, String> userDetails) {
    debugPrint('Name - ${userDetails['givenName']}');
    debugPrint('Family Name - ${userDetails['familyName']}');
    debugPrint('Email - ${userDetails['email']}');
  }

  Future<void> _saveUserDetailsToKeychain(AuthorizationCredentialAppleID credential) async {
    await FlutterKeychain.put(
      key: credential.userIdentifier!,
      value: "${credential.givenName}/${credential.familyName}:${credential.email}",
    );
    debugPrint('Saved in Keychain.....');
  }

  Future<UserModel?> _signInWithCredential(OAuthCredential oauthCredential, {String? userName, String? email, required String socialType}) async {
    try {
      final userCredential = await _signInWithFirebase(oauthCredential);
      final authUser = userCredential?.user;
      if (authUser != null) {
        await _updateUserProfile(authUser, userName);
        final updatedUser = FirebaseAuth.instance.currentUser;
        return _buildUserModel(updatedUser, authUser, email, socialType, userName);
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint('Sign-in with credential error: $e,$s',);
      return null;
    }
  }

  Future<UserCredential?> _signInWithFirebase(OAuthCredential oauthCredential) async {
    try {
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e, s) {
      debugPrint('Sign-in with credential error: $e,$s',);
      rethrow;
    }
  }

  Future<void> _updateUserProfile(User authUser, String? userName) async {
    if (userName != null && userName.isNotEmpty) {
       authUser.updateProfile(displayName: userName);
       authUser.reload();
    }
  }

  UserModel _buildUserModel(User? updatedUser, User authUser, String? email, String socialType, String? userName) {
    return UserModel(
      socialId: updatedUser?.uid ?? authUser.uid,
      email: email ?? authUser.email,
      socialType: socialType,
      name: updatedUser?.displayName ?? userName,
    );
  }

}

