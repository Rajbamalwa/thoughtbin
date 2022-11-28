import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import '../../Promise/Promise.dart';
import '../../utils/ReUse.dart';

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

  final authFirebase = FirebaseAuth.instance;

  void signUp() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) async {
      toast()
          .toastMessage('Your Account was Successfully Created', Colors.blue);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => PromiseScreen()));
      final credential = EmailAuthProvider.credential(
          email: emailController.text, password: passwordController.text);
      final auth = await authFirebase.signInWithCredential(credential);
      if (auth.additionalUserInfo!.isNewUser) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PromiseScreen()));
        emailController.clear();
        passwordController.clear();
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
      }
      setState(() {
        loading = false;
      });
      SaveUserData(
        emailController.text.toString(),
        FirebaseAuth.instance.currentUser!.displayName.toString(),
        FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
      );
    }).onError((error, stackTrace) {
      toast().toastMessage(error.toString(), Colors.red);
      setState(() {
        loading = false;
      });
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
                        activeColor: ColorClass().themeColor2,
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
                if (formKey.currentState!.validate() && checkBoxValue == true) {
                  signUp();
                } else {
                  if (checkBoxValue == true) {
                  } else {
                    toast().toastMessage(
                        'please agree the conditions', Colors.blue);
                  }
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
            googleButton(),
            facebookButton(),
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
}
