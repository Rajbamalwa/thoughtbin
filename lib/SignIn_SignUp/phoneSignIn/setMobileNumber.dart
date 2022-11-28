import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/utils/ReUse.dart';
import 'otpScreen.dart';

class SetMobileNo extends StatefulWidget {
  const SetMobileNo({Key? key}) : super(key: key);

  @override
  State<SetMobileNo> createState() => _SetMobileNoState();
}

class _SetMobileNoState extends State<SetMobileNo> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  Future addUserDetails(int Number) async {
    await FirebaseFirestore.instance.collection('users').add({
      'Phone Number': Number,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Form(
                key: formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Phone Number';
                    }
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.call),
                      hintText: '+918765432198',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Buttons(
                onPress: () {
                  setState(() {
                    loading = true;
                  });
                  if (formKey.currentState!.validate()) {
                    auth.verifyPhoneNumber(
                        phoneNumber: phoneNumberController.text,
                        verificationCompleted: (_) {
                          setState(() {
                            loading = true;
                          });
                          auth.verifyPhoneNumber(
                            phoneNumber: phoneNumberController.text,
                            verificationCompleted: (_) {},
                            verificationFailed: (e) {
                              toast()
                                  .toastMessage(e.toString(), ColorClass().red);
                            },
                            codeSent: (String verificationId, int? token) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyCodeScreen(
                                      verificationId: verificationId),
                                ),
                              );
                            },
                            codeAutoRetrievalTimeout: (e) {
                              toast()
                                  .toastMessage(e.toString(), ColorClass().red);
                            },
                          );
                        },
                        verificationFailed: (e) {
                          setState(() {
                            loading = false;
                          });
                          toast().toastMessage(e.toString(), ColorClass().blue);
                        },
                        codeSent: (String verificationId, int? token) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyCodeScreen(
                                        verificationId: verificationId,
                                      )));
                          setState(() {
                            loading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          toast().toastMessage(e.toString(), ColorClass().red);
                          setState(() {
                            loading = false;
                          });
                        });
                    addUserDetails(int.parse(phoneNumberController.text));
                  } else {
                    toast().toastMessage(
                        'Please Enter Valid Phone number', ColorClass().red);
                  }
                },
                height: 50,
                boxDecoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF13A6A7), Color(0xFF00D3A1)]),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('Login'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 30, left: 10, right: 20),
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
        ),
      ),
    );
  }
}
