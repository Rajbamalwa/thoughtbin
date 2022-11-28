import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/utils/ReUse.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
  final userPosts = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/Images');
  final auth = FirebaseAuth.instance;
  final userNameController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> files() async {
    String download = await storage
        .ref('${FirebaseAuth.instance.currentUser!.uid}/ProfilePic')
        .getDownloadURL();
    return download;
  }

  final delete = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}');
  @override
  Widget build(BuildContext context) {
    String image = "";
    return Scaffold(
      backgroundColor: ColorClass().white,
      appBar: AppBar(
        backgroundColor: ColorClass().white,
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 0.1,
          splashColor: ColorClass().themeColor2,
          highlightColor: ColorClass().themeColor2,
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
                          border:
                              Border.all(color: ColorClass().white, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: image == ''
                                ? Container(
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: FutureBuilder(
                                        future: files(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Container(
                                              height: 140,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      snapshot.data!,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )),
                                            );
                                          }
                                          if (snapshot.connectionState ==
                                                  ConnectionState.waiting &&
                                              !snapshot.hasData) {
                                            return Container(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          }
                                          return Container(
                                            child: Image(
                                                image: AssetImage(
                                                    'assets/images/eye.png')),
                                          );
                                        }),
                                  )
                                : Center(child: Icon(Icons.image)),
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
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorClass().white,
                          border: Border.all(color: ColorClass().black12)),
                      child: Center(
                        child: IconButton(
                            splashRadius: 0.1,
                            splashColor: ColorClass().themeColor2,
                            highlightColor: ColorClass().themeColor2,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddPhoto()));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: ColorClass().black,
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
                  ' ${FirebaseAuth.instance.currentUser!.displayName.toString()}',
              onPress: () {
                showMyDialog(userNameController.text.toString());
              },
            ),
            AccountWidget(
                text: ' ${FirebaseAuth.instance.currentUser!.email}',
                onPress: () {}),
            AccountWidget(
              text: ' Change Password',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
              },
            ),
            AccountWidget(
              text:
                  'Number : ${FirebaseAuth.instance.currentUser?.phoneNumber}',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SetMobileNo()));
              },
            ),
            AccountWidget(
              text: ' Delete Account',
              onPress: () {
                deleteAcc();
              },
            ),
            AccountWidget(
              text: ' Language',
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
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: ColorClass().white, fontSize: 20),
                ),
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
            title: const Text('Do you want to delete your account?'),
            actions: [
              Buttons(
                  onPress: () async {
                    FirebaseAuth.instance.currentUser
                        ?.delete()
                        .whenComplete(() async {
                      toast().toastMessage(
                          'Your account was successfully deleted',
                          ColorClass().blue);
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => SignIn()));
                    });
                    delete
                        .child(FirebaseAuth.instance.currentUser!.uid)
                        .remove();
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
            elevation: 30,
            content: Container(
              height: 150,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(70)),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Username',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        IconButton(
                          splashRadius: 0.1,
                          splashColor: ColorClass().themeColor2,
                          highlightColor: ColorClass().themeColor2,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.clear),
                          color: ColorClass().red,
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ],
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
                      toast().toastMessage('Username Set', Colors.blue);
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
      padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
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
                overflow: TextOverflow.fade,
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
                      splashRadius: 0.1,
                      splashColor: ColorClass().themeColor2,
                      highlightColor: ColorClass().themeColor2,
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
