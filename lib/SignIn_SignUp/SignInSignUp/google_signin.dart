import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thought_bin/Home/HomePage.dart';
import 'package:thought_bin/utils/ReUse.dart';
import '../../Promise/Promise.dart';

final authFirebase = FirebaseAuth.instance;
Future<void> googleSignIn(context) async {
  final googleSignIn = GoogleSignIn();
  final googleAccount = await googleSignIn.signIn();
  if (googleAccount != null) {
    final googleAuth = await googleAccount.authentication;
    if (googleAuth.accessToken != null && googleAuth.idToken != null) {
      try {
        final authResult = await authFirebase.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );

        if (authResult.additionalUserInfo!.isNewUser) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PromiseScreen()));
        } else {
          toast().toastMessage('Welcome back', ColorClass().themeColor2);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
        }

        SaveUserData(
          authResult.user!.email.toString(),
          FirebaseAuth.instance.currentUser!.displayName.toString(),
          FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
        );
      } catch (e) {
        toast().toastMessage(e.toString(), Colors.red);
      }
    }
  }
}
