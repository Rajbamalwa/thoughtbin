import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import 'package:thought_bin/Home/UploadPostScreen.dart';
import 'package:thought_bin/ReUse.dart';
import 'package:thought_bin/SignIn_SignUp/SignIn.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<String> myList = <String>[];

  void onTitleAndDetailCreated(String title, String detail) {
    setState(() {
      myList.add(title);
    });
    setState(() {
      myList.add(detail);
    });
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  SignIn signIn = const SignIn();
  final topicKey = GlobalKey<FormState>();
  final detailKey = GlobalKey<FormState>();
  bool checkBoxValue = false;
  bool loading = false;
  final titledatabase = FirebaseDatabase.instance.ref('title');
  final detaildatabase = FirebaseDatabase.instance.ref('detail');
  final draftdatabase = FirebaseDatabase.instance.ref('draft');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 40, 9, 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded)),
                ),
              ),
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
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Type Title';
                            }
                          },
                          controller: titleController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Topic Title',
                            hintStyle: TextStyle(color: ColorClass().white),
                          ),
                        ),
                      ),
                      Divider(
                        color: ColorClass().white,
                        thickness: 1,
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
                        padding: const EdgeInsets.all(8.0),
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
                              maxLines: 14,
                              controller: detailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Description',
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
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('assets/images/eye.png'),
                        height: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Posting as Anonymous',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 7),
                child: draft_post(() {
                  if (topicKey.currentState!.validate() &&
                      detailKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    String id =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    titledatabase.child(id).set({
                      'id': id,
                      'title': titleController.text.toString(),
                      'detail': detailController.text.toString(),
                    }).then((value) {
                      toast().toastMessage('Posted', Colors.blue);
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      toast().toastMessage('Error', Colors.red);
                      setState(() {
                        loading = false;
                      });
                    });
                  } else {
                    return toast().toastMessage('Error', Colors.red);
                  }
                }, 'Post'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        if (topicKey.currentState!.validate() &&
                            detailKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          draftdatabase
                              .child(DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString())
                              .set({
                            'title': titleController.text.toString(),
                            'detail': detailController.text.toString(),
                          }).then((value) {
                            toast().toastMessage('Drafted', Colors.blue);
                            setState(() {
                              loading = false;
                              titleController.clear();
                              detailController.clear();
                            });
                          }).onError((error, stackTrace) {
                            toast().toastMessage('Error', Colors.red);
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
                  const SizedBox(width: 50),
                  Checkbox(
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
          ),
        ),
      ),
    );
  }
}
