import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/ReUse.dart';

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
          Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Email';
                  }
                  return null;
                },
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.alternate_email),
                    hintText: 'Email Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 20),
            child: Buttons(
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
              child: Text(
                'Recover Password',
                style: TextStyle(fontSize: 21, color: ColorClass().white),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 50, bottom: 30, left: 10, right: 30),
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                  elevation: 0.0,
                  tooltip: 'Back',
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: ColorClass().themeColor2,
                  splashColor: ColorClass().themeColor2,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.keyboard_backspace_outlined,
                      color: ColorClass().black)),
            ),
          ),
        ],
      )),
    );
  }
}
