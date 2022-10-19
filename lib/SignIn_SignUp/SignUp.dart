import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../Promise/Promise.dart';
import '../ReUse.dart';
import 'SignIn.dart';
import 'SignInSignUp/google_signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final bool _isChecked = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final user = FirebaseDatabase.instance.ref('user');
  void signUp() {
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      toast().toastMessage(
          'Your Account was Successfully Created now go and login',
          Colors.blue);
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      toast().toastMessage(error.toString(), Colors.red);
      setState(() {
        loading = false;
      });
    });
  }

  Future addUserDetails(String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
    });
  }

  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, top: 70),
                child: Text(
                  'Create\nNew Account',
                  textAlign: TextAlign.left,
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
                  textFieldWidget(
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
                  textFieldWidget(
                    passwordController,
                    'Password',
                    true,
                    (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                  textFieldWidget(
                    passwordController,
                    'Confirm Password',
                    true,
                    (value) {
                      if (value!.isEmpty) {
                        return 'Please Confirm Password';
                      }
                      return null;
                    },
                  ),
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
                Text("I agree with Terms & Conditions",
                    style:
                        TextStyle(fontSize: 12, color: ColorClass().blueGrey))
              ],
            ),
            Buttons(
              height: 63,
              loading: loading,
              onPress: () {
                if (formKey.currentState!.validate()) {
                  signUp();
                  user
                      .child(DateTime.now().microsecondsSinceEpoch.toString())
                      .set({
                        'email': emailController.text.toString(),
                        'password': passwordController.text.toString(),
                      })
                      .then((value) {})
                      .onError((error, stackTrace) {
                        toast().toastMessage('Error', Colors.red);
                      });
                } else {
                  return toast().toastMessage('Error', Colors.red);
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
              child: const Text('Create Account'),
            ),
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
            Buttons(
              height: 63,
              onPress: () {
                user
                    .child(DateTime.now().microsecondsSinceEpoch.toString())
                    .set({
                      'email': emailController.text.toString(),
                      'password': passwordController.text.toString(),
                    })
                    .then((value) {})
                    .onError((error, stackTrace) {
                      toast().toastMessage('Error', Colors.red);
                    })
                    .onError((error, stackTrace) {
                      toast().toastMessage(error.toString(), ColorClass().red);
                    });

                try {
                  setState(() {
                    loading = true;
                  });
                  googleSignIn(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const PromiseScreen()));
                  toast().toastMessage('Account Created', Colors.blue);
                  setState(() {
                    loading = false;
                  });
                  addUserDetails(emailController.text);
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  toast().toastMessage(e.toString(), Colors.red);
                }
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
                    style: TextStyle(color: ColorClass().black54, fontSize: 20),
                  )
                ],
              ),
            ),
            Buttons(
              height: 63,
              onPress: () {
                facebookLogin();
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
                    child: Image.asset('assets/images/facebook.png'),
                  ),
                  Text(
                    'Continue With Facebook',
                    style: TextStyle(color: ColorClass().black54, fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.black54),
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Sign In"),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  facebookLogin() async {
    print("FaceBook");
    try {
      final result = await FacebookAuth.i
          .login(permissions: ['public_profile', 'email', 'name']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print(userData);
      }
    } catch (error) {
      print(error);
    }
  }
}
