import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/utils/ReUse.dart';
import 'package:thought_bin/SignIn_SignUp/SignInSignUp/SignUp.dart';
import 'package:thought_bin/SignIn_SignUp/phoneSignIn/passwordReset.dart';
import 'package:thought_bin/SignIn_SignUp/phoneSignIn/setMobileNumber.dart';
import 'package:thought_bin/utils/AddPhoto.dart';
import '../SignIn_SignUp/SignInSignUp/SignIn.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final auth = FirebaseAuth.instance;
  final userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String image = "";
    return Scaffold(
      backgroundColor: ColorClass().white,
      appBar: AppBar(
        backgroundColor: ColorClass().white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: ColorClass().black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
              color: ColorClass().themeColor2,
              fontSize: 30,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
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
                            shape: BoxShape.circle,
                            border: Border.all(color: ColorClass().black12),
                            gradient: LinearGradient(
                                colors: [
                                  ColorClass().themeColor2,
                                  ColorClass().themeColor
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        '${FirebaseAuth.instance.currentUser?.photoURL}'))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 30, 0, 0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorClass().white,
                      ),
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddPhoto()));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: ColorClass().themeColor2,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            AccountWidget(
              text:
                  'Name: ${FirebaseAuth.instance.currentUser!.displayName.toString()}',
              onPress: () {
                showMyDialog(userNameController.text.toString());
              },
            ),
            AccountWidget(
                text: 'Email: ${FirebaseAuth.instance.currentUser!.email}',
                onPress: () {}),
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
              text: 'No.:  ${FirebaseAuth.instance.currentUser?.phoneNumber}',
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
                    'Apologies for the fact that you can not add more then 1 account now , Our team is working hard on it so you can add multiple account soon',
                    ColorClass().red);
              },
            ),
            AccountWidget(
              text: 'Delete Account',
              onPress: () {
                deleteAcc();
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

  Future<void> deleteAcc() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Text('Do you want to delete your account?'),
            actions: [
              Buttons(
                  onPress: () async {
                    FirebaseAuth.instance.currentUser?.delete().then((value) {
                      toast().toastMessage(
                          'Your account was successfully deleted',
                          ColorClass().blue);
                    });
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => SignIn()));
                  },
                  child: Text('Confirm'),
                  height: 40,
                  boxDecoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    ColorClass().themeColor2,
                    ColorClass().themeColor
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
              Buttons(
                  onPress: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  height: 40,
                  boxDecoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    ColorClass().themeColor2,
                    ColorClass().themeColor
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
            ],
          );
        });
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
              Buttons(
                  height: 50,
                  boxDecoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    ColorClass().themeColor2,
                    ColorClass().themeColor
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: const Text('Add User Name'),
                  onPress: () {
                    auth.currentUser
                        ?.updateDisplayName(userNameController.text);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(
                            FirebaseAuth.instance.currentUser!.email.toString())
                        .update({
                      'Name': userNameController.text.toString(),
                    }).then((value) {
                      toast().toastMessage('Posted', Colors.blue);
                    }).onError((error, stackTrace) {
                      toast().toastMessage(error.toString(), Colors.red);
                    });
                    Navigator.pop(context);
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
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Container(
        height: 55,
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
                        Icons.mode_edit_outlined,
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
