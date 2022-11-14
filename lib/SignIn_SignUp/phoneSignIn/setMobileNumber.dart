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

  Future addUserDetails(int Number) async {
    await FirebaseFirestore.instance.collection('users').add({
      'Phone Number': Number,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            TextFormField(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              controller: phoneNumberController,
              decoration: InputDecoration(
                  icon: Icon(Icons.call),
                  hintText: '+918765432198',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 80,
            ),
            Buttons(
              onPress: () {
                setState(() {
                  loading = true;
                });
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
                          toast().toastMessage(e.toString(), ColorClass().red);
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
                          toast().toastMessage(e.toString(), ColorClass().red);
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
              },
              height: 50,
              boxDecoration: BoxDecoration(
                  color: ColorClass().themeColor2,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
