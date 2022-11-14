import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Promise/RelatedPost.dart';
import 'package:thought_bin/utils/ReUse.dart';
import '../SignIn_SignUp/SignInSignUp/SignIn.dart';

class PromiseScreen extends StatefulWidget {
  const PromiseScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PromiseScreen> createState() => _PromiseScreenState();
}

class _PromiseScreenState extends State<PromiseScreen> {
  final formKey = GlobalKey<FormState>();
  final promiseController = TextEditingController();
  bool showText = false;

  checkText() {
    String text =
        'I promise that I will be sympathetic and supportive towards the community.';
    if (text.toString() != promiseController.text) {
      toast().toastMessage('Please check your promise', ColorClass().red);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RelatedPostFind()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: ColorClass().white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  'assets/images/promise1.png',
                  fit: BoxFit.cover,
                ),
                Text(
                  'Please type the following...',
                  style: TextStyle(fontSize: 20, color: ColorClass().black45),
                ),
                Visibility(
                    visible: showText,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                'I promise that I will be sympathetic and supportive towards the community.'),
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1)),
                    padding: const EdgeInsets.all(5),
                    child: Form(
                      key: formKey,
                      child: TextField(
                        onChanged: (value) {},
                        onTap: () {
                          setState(() {
                            showText = !showText;
                          });
                        },
                        controller: promiseController,
                        style: const TextStyle(color: Colors.black45),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'I promise that I will be sympathetic and supportive towards the community.'),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 200),
                TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.email
                              .toString())
                          .set({
                        'promise': promiseController.text.toString(),
                      }).then((value) {
                        toast().toastMessage('You Promise us', Colors.blue);
                      }).onError((error, stackTrace) {
                        toast().toastMessage(error.toString(), Colors.red);
                      });

                      checkText();
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          decoration: TextDecoration.underline),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
