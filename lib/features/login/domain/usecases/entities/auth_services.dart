import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/models/user_model.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
mixin AuthServices {

  Future<UserModel?> signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      // Sign out if already signed in
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Perform sign-in
      final result = await googleSignIn.signIn();
      if (result != null) {
        final googleAuth = await result.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return _signInWithCredential(
          credential,
          socialType: "google",
          userName: result.displayName,
          email: result.email,
        );
      }
      return null;
    } catch (e, s) {
      debugPrint('Google sign-in error: $e\n$s');
      return null;
    }
  }

  Future<UserModel?> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      final userCred = await FirebaseAuth.instance.signInWithProvider(appleProvider);
      return UserModel(
        socialId: userCred.user?.uid??"",
        email:userCred.user?.email??"",
        socialType: "apple",
        name: userCred.user?.displayName??"",
      );
    } catch (error) {
      debugPrint('Apple sign-in error: $error');
      return null;
    }
  }



  Future<UserModel?> _signInWithCredential(
      OAuthCredential oauthCredential, {
        String? userName,
        String? email,
        required String socialType,
      }) async {
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
      debugPrint('Sign-in with credential error: $e\n$s');
      return null;
    }
  }

  Future<UserCredential?> _signInWithFirebase(OAuthCredential oauthCredential) async {
    try {
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e, s) {
      debugPrint('Sign-in with Firebase error: $e\n$s');
      rethrow;
    }
  }

  Future<void> _updateUserProfile(User authUser, String? userName) async {
    if (userName != null && userName.isNotEmpty) {
      await authUser.updateProfile(displayName: userName);
      await authUser.reload();
    }
  }

  UserModel _buildUserModel(User? updatedUser, User? authUser, String? email, String socialType, String? userName) {
    return UserModel(
      socialId: updatedUser?.uid ?? authUser?.uid ?? '',
      email: email ?? authUser?.email ?? '',
      socialType: socialType,
      name: updatedUser?.displayName ?? userName ?? '',
    );
  }
}




