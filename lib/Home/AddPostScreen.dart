import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/utils/ReUse.dart';
import 'package:thought_bin/SignIn_SignUp/SignInSignUp/SignIn.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  SignIn signIn = const SignIn();
  final topicKey = GlobalKey<FormState>();
  final detailKey = GlobalKey<FormState>();
  bool checkBoxValue = false;
  bool loading = false;
  final userDraft =
      FirebaseDatabase.instance.ref(FirebaseAuth.instance.currentUser!.uid);
  final userPosts =
      FirebaseDatabase.instance.ref(FirebaseAuth.instance.currentUser!.uid);
  final posts = FirebaseDatabase.instance.ref('posts');
  var NoData = FirebaseDatabase.instance.ref('NoData');
  var maxLength = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Pour Your Heart Out',
                      style: TextStyle(
                          color: ColorClass().themeColor2,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorClass().themeColor2,
                              ColorClass().themeColor
                            ]),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Title',
                            style: TextStyle(
                                color: ColorClass().white, fontSize: 20),
                          ),
                        ),
                        Form(
                          key: topicKey,
                          child: TextFormField(
                            maxLength: maxLength,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Type Title';
                              }
                            },
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: 'Topic Title',
                              hintStyle: TextStyle(color: ColorClass().white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Details',
                              style: TextStyle(
                                  color: ColorClass().white, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorClass().white,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(8),
                            child: Form(
                              key: detailKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Type Description';
                                  }
                                },
                                maxLines: 15,
                                controller: detailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Topic Details',
                                  hintStyle: TextStyle(
                                      color: ColorClass().black38,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 80, right: 80, top: 15, bottom: 5),
                  child: Buttons(
                      height: 50,
                      boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorClass().themeColor2,
                                ColorClass().themeColor,
                              ])),
                      onPress: () {
                        if (topicKey.currentState!.validate() &&
                            detailKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });

                          String id =
                              DateTime.now().microsecondsSinceEpoch.toString();
                          posts.child(id).update({
                            'title': titleController.text,
                            'id': id,
                            'detail': detailController.text,
                          }).then((value) {
                            toast().toastMessage('Posted', Colors.blue);
                            setState(() {
                              loading = false;
                              titleController.clear();
                              detailController.clear();
                            });
                          }).onError((error, stackTrace) {
                            toast().toastMessage(error.toString(), Colors.red);
                            setState(() {
                              loading = false;
                            });
                          });

                          userPosts.child('posts').update({
                            id: {
                              'title': titleController.text,
                              'id': id,
                              'detail': detailController.text,
                            }
                          }).then((value) {
                            toast().toastMessage('Posted', Colors.blue);
                            setState(() {
                              loading = false;
                              titleController.clear();
                              detailController.clear();
                            });
                          }).onError((error, stackTrace) {
                            toast().toastMessage(error.toString(), Colors.red);
                            setState(() {
                              loading = false;
                            });
                          });
                        } else {
                          return toast().toastMessage('Error', Colors.red);
                        }

                        NoData.child('NoData').update({
                          'title': titleController.text,
                          'detail': detailController.text,
                        }).then((value) {
                          toast().toastMessage('Posted', Colors.blue);
                          setState(() {
                            loading = false;
                            titleController.clear();
                            detailController.clear();
                          });
                        }).onError((error, stackTrace) {
                          toast().toastMessage(error.toString(), Colors.red);
                          setState(() {
                            loading = false;
                          });
                        });
                      },
                      child: Text('Post')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (topicKey.currentState!.validate() &&
                              detailKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            String id = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            userDraft.child('Drafted').update({
                              id: {
                                'title': titleController.text,
                                'id': id,
                                'detail': detailController.text,
                              }
                            }).then((value) {
                              toast().toastMessage('Drafted', Colors.blue);
                              setState(() {
                                loading = false;
                                titleController.clear();
                                detailController.clear();
                              });
                            }).onError((error, stackTrace) {
                              toast()
                                  .toastMessage(error.toString(), Colors.red);
                              setState(() {
                                loading = false;
                              });
                            });
                          } else {
                            return toast().toastMessage('Error', Colors.red);
                          }
                        },
                        child: Text(
                          'Save to draft',
                          style: TextStyle(
                              color: ColorClass().themeColor2,
                              decoration: TextDecoration.underline),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: ColorClass().themeColor2,
                          value: checkBoxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              if (checkBoxValue == true) {}
                              checkBoxValue = value!;
                            });
                          },
                        ),
                        Text(
                          'Turn off Reactions',
                          style: TextStyle(
                              color: ColorClass().themeColor2,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
