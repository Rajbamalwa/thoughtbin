import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/Account.dart';

import '../ReUse.dart';

class AddUserName extends StatelessWidget {
  AddUserName({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: textFieldWidget(
              nameController,
              'Add User Name',
              false,
              (value) {
                if (value!.isEmpty) {
                  return 'Please Confirm Password';
                }
                return null;
              },
            )),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
              child: Buttons(
                onPress: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AccountScreen(
                            name: nameController.text,
                          )));
                },
                height: 50,
                boxDecoration: BoxDecoration(
                    color: ColorClass().themeColor2,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('Add UserName'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
