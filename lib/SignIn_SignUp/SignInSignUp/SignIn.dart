import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thought_bin/Promise/Promise.dart';
import 'package:thought_bin/Promise/RelatedPost.dart';
import 'package:thought_bin/SignIn_SignUp/SignInSignUp/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thought_bin/SignIn_SignUp/phoneSignIn/passwordReset.dart';
import '../../utils/ReUse.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool checkBoxValue = false;
  SignIn() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) async {
      AuthCredential credential = EmailAuthProvider.credential(
          email: emailController.text, password: passwordController.text);
      UserCredential userCred = await _auth.signInWithCredential(credential);
      bool? isNewUser = userCred.additionalUserInfo?.isNewUser;

      toast().toastMessage(value.user!.email.toString(), Colors.blue);
      if (isNewUser == true) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PromiseScreen()));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RelatedPostFind()));
      }
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      toast().toastMessage(error.toString(), Colors.red);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 70),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 30,
                      color: ColorClass().themeColor2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    textFieldWidget(emailController, 'Email', false, (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Email';
                      }
                    }),
                    const SizedBox(height: 10),
                    textFieldWidget(passwordController, 'Password', true,
                        (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    }),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                          value: checkBoxValue,
                          activeColor: Colors.green,
                          onChanged: (newValue) {
                            setState(() {
                              if (checkBoxValue == true) {}
                              checkBoxValue = newValue!;
                            });
                          }),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text("Remember me",
                      style:
                          TextStyle(fontSize: 12, color: ColorClass().blueGrey))
                ],
              ),
              Buttons(
                height: 63,
                loading: loading,
                onPress: () {
                  if (formKey.currentState!.validate()) {
                    SignIn();
                  }
                },
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorClass().themeColor,
                        ColorClass().themeColor2
                      ]),
                ),
                child: const Text('Sign In'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPassword()));
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: ColorClass().black54),
                ),
              ),
              SizedBox(height: 20),
              Row(children: <Widget>[
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: ColorClass().black,
                        height: 36,
                      )),
                ),
                const Text("OR"),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(
                        color: ColorClass().black,
                        height: 36,
                      )),
                ),
              ]),
              const SizedBox(height: 20),
              googleButton(),
              facebookButton(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: ColorClass().black54),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignUp()));
                      },
                      child: const Text("SignUp"),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
