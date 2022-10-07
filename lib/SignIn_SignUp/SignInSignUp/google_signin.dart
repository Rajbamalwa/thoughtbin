import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thought_bin/ReUse.dart';

FirebaseAuth authFirebase = FirebaseAuth.instance;
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
        Future addUserDetails(String email) async {
          await FirebaseFirestore.instance.collection('users').add({
            'email': email,
          });
        }
      } catch (e) {
        toast().toastMessage(e.toString(), Colors.red);
      }
    }
  }
}
