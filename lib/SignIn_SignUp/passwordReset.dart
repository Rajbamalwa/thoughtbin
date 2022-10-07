import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ReUse.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: textFieldWidget(
              emailController,
              'Email',
              false,
              (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Email';
                }
                return null;
              },
            ),
          ),
          Buttons(
            onPress: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  showSpinner = true;
                });
                try {
                  auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then((value) {
                    toast().toastMessage(
                        'Please Check Your Email, a reset link has been sent to you via email',
                        Colors.blue);
                    setState(() {
                      showSpinner = false;
                    });
                  }).onError((error, stackTrace) {
                    toast().toastMessage(error.toString(), Colors.red);
                  });
                } catch (e) {
                  toast().toastMessage(e.toString(), Colors.red);
                  setState(() {
                    showSpinner = true;
                  });
                }
              }
            },
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF13A6A7), Color(0xFF00D3A1)]),
            ),
            height: 63,
            child: const Text('Recover Password'),
          )
        ],
      )),
    );
  }
}
