import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/ReUse.dart';
import 'package:thought_bin/SignIn_SignUp/SignUp.dart';
import 'package:thought_bin/SignIn_SignUp/passwordReset.dart';
import 'package:thought_bin/SignIn_SignUp/setMobileNumber.dart';
import 'package:thought_bin/utils/AddPhoto.dart';
import '../SignIn_SignUp/SignIn.dart';
import '../utils/AddUserName.dart';
import '../utils/Language.dart';

class AccountScreen extends StatefulWidget {
  final String name;
  const AccountScreen({super.key, required this.name});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final auth = FirebaseAuth.instance;
  final userEmail = FirebaseDatabase.instance.ref('user');
  final fireStore = FirebaseFirestore.instance.collection('user').snapshots();
  late String userName;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(80, 10, 10, 10),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: ColorClass().themeColor2),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: ColorClass().white),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: const Image(
                              image: AssetImage('assets/images/eye.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 40, 10, 0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorClass().white,
                      ),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PhotoDp()));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: ColorClass().themeColor2,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            AccountWidget(
              text: 'user Name',
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddUserName()));
              },
            ),
            AccountWidget(
                text: '${FirebaseAuth.instance.currentUser!.email}',
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUp()));
                }),
            AccountWidget(
              text: 'Change Password',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
              },
            ),
            AccountWidget(
              text: '${FirebaseAuth.instance.currentUser?.phoneNumber}',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SetMobileNo()));
              },
            ),
            AccountWidget(
              text: 'Add another Account',
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
            ),
            AccountWidget(
              text: 'Language',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChooseLanguage()));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
              child: Buttons(
                onPress: () {
                  auth.signOut().then((value) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignIn()));
                  }).onError((error, stackTrace) {
                    toast().toastMessage(error.toString(), Colors.red);
                  });
                },
                height: 50,
                boxDecoration: BoxDecoration(
                    color: ColorClass().themeColor2,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('Sign Out'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccountWidget extends StatelessWidget {
  AccountWidget({Key? key, required this.text, required this.onPress})
      : super(key: key);
  String text;
  Function() onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: ColorClass().black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ColorClass().white),
                child: Center(
                  child: IconButton(
                      onPressed: onPress,
                      icon: Icon(
                        Icons.edit,
                        color: ColorClass().themeColor2,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
