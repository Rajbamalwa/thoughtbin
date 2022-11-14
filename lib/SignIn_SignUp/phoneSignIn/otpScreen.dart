import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import '../../utils/ReUse.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '6 digit code'),
            ),
            const SizedBox(
              height: 80,
            ),
            Buttons(
              onPress: () async {
                setState(() {
                  loading = true;
                });
                final crenditial = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationCodeController.text.toString());

                try {
                  await FirebaseAuth.instance.currentUser
                      ?.updatePhoneNumber(crenditial);

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  toast().toastMessage(e.toString(), ColorClass().red);
                }
                FirebaseFirestore.instance
                    .collection(
                        FirebaseAuth.instance.currentUser!.email.toString())
                    .doc('Details')
                    .update({
                  'Number': FirebaseAuth.instance.currentUser
                      ?.updatePhoneNumber(crenditial)
                      .toString(),
                }).then((value) {
                  toast().toastMessage('Posted', Colors.blue);
                }).onError((error, stackTrace) {
                  toast().toastMessage(error.toString(), Colors.red);
                });
              },
              height: 50,
              boxDecoration: BoxDecoration(
                  color: ColorClass().themeColor2,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text('Verify'),
            )
          ],
        ),
      ),
    );
  }
}
