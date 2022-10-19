import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/ReUse.dart';
import 'package:thought_bin/SignIn_SignUp/SignUp.dart';
import 'package:thought_bin/SignIn_SignUp/passwordReset.dart';
import 'package:thought_bin/SignIn_SignUp/setMobileNumber.dart';
import 'package:thought_bin/utils/AddPhoto.dart';
import '../SignIn_SignUp/SignIn.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final auth = FirebaseAuth.instance;
  final userEmail = FirebaseDatabase.instance.ref('user');
  final fireStore = FirebaseFirestore.instance.collection('user').snapshots();
  final userNameController = TextEditingController();
  final user = FirebaseDatabase.instance.ref('user');
  late bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    var image;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
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
                          child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: image ??
                                          NetworkImage(
                                              '${FirebaseAuth.instance.currentUser?.photoURL}')))),
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
                                    builder: (context) =>
                                        const ProfileScreen()));
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
              text: '${FirebaseAuth.instance.currentUser!.displayName}',
              onPress: () {
                showMyDialog(userNameController.text.toString());
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
              text: 'Number ${FirebaseAuth.instance.currentUser?.phoneNumber}',
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
                toast().toastMessage(
                    'Apologies for the fact that you can not add more then 1 account now , Our team is working on it so you can add multiple account soon',
                    ColorClass().red);
              },
            ),
            AccountWidget(
              text: 'Delete Account',
              onPress: () {
                toast().toastMessage(
                    'If you want to delete your account then email us on sendhere819@gmail.com with your email id and username',
                    ColorClass().red);
              },
            ),
            AccountWidget(
              text: 'Language',
              onPress: () {
                toast().toastMessage(
                    'Apologies for the fact that we are showing you in only one language, we will bring more languages for you very soon.',
                    ColorClass().red);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
              child: Buttons(
                onPress: () {
                  auth.signOut().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SignIn()));
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

  Future<void> showMyDialog(String userName) async {
    userNameController.text = userName;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: userNameController,
                maxLines: 3,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)))),
              ),
            ),
            actions: [
              TextButton(
                  child: const Text('Add User Name'),
                  onPressed: () {
                    auth.currentUser
                        ?.updateDisplayName(userNameController.text);
                  }),
            ],
          );
        });
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
