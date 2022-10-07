import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:thought_bin/Promise/Promise.dart';
import 'package:thought_bin/SignIn_SignUp/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thought_bin/SignIn_SignUp/passwordReset.dart';
import '../ReUse.dart';
import 'SignInSignUp/google_signin.dart';

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
  final user = FirebaseDatabase.instance.ref('user');

  @override
  bool checkBoxValue = false;

  void SignIn() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      toast().toastMessage(value.user!.email.toString(), Colors.blue);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PromiseScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      toast().toastMessage(error.toString(), Colors.red);
      setState(() {
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
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
              Buttons(
                height: 63,
                onPress: () {
                  googleSignIn(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PromiseScreen()));
                },
                boxDecoration: BoxDecoration(
                    border: Border.all(color: ColorClass().black12),
                    borderRadius: BorderRadius.circular(10),
                    color: ColorClass().white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                      child: Image.asset('assets/images/google.png'),
                    ),
                    Text(
                      'Continue With Google',
                      style:
                          TextStyle(color: ColorClass().black54, fontSize: 20),
                    )
                  ],
                ),
              ),
              Buttons(
                height: 63,
                onPress: () {
                  FacebookSignIn();
                },
                boxDecoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                    color: ColorClass().white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                      child: Image.asset('assets/images/facebook.png'),
                    ),
                    Text(
                      'Continue With Facebook',
                      style:
                          TextStyle(color: ColorClass().black54, fontSize: 20),
                    ),
                  ],
                ),
              ),
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

  void FacebookSignIn() async {
    setState(() {
      loading = true;
    });
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
        'imageUrl': userData['picture']['data']['url'],
        'name': userData['name'],
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PromiseScreen()));
      Future addUserDetails(String email) async {
        await FirebaseFirestore.instance.collection('users').add({
          'email': email,
        });
      }
    } catch (e) {
      toast().toastMessage('Something went wrong', ColorClass().red);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}