import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Promise/Promise.dart';
import '../SignIn_SignUp/SignInSignUp/google_signin.dart';

textFieldWidget(
  TextEditingController controller,
  String hint,
  bool? obscureText,
  validate,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    child: TextFormField(
      validator: validate,
      keyboardType: TextInputType.emailAddress,
      obscureText: obscureText!,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    ),
  );
}

class Buttons extends StatelessWidget {
  Buttons(
      {Key? key,
      required this.onPress,
      required this.child,
      required this.height,
      this.loading = false,
      required this.boxDecoration})
      : super(key: key);
  final bool loading;
  Function() onPress;
  Decoration boxDecoration;
  Widget child;
  double height;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
        child: InkWell(
            onTap: onPress,
            child: Container(
                decoration: boxDecoration,
                width: MediaQuery.of(context).size.width,
                height: height,
                child: Center(
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : child))));
  }
}

class toast {
  void toastMessage(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 15);
  }
}

class ColorClass {
  Color themeColor = const Color(0xFF00D3A1);
  Color themeColor2 = const Color(0xff13A6A7);
  Color iconColor = const Color(0xFFEFFBFA);
  Color white = Colors.white;
  Color black = Colors.black;
  Color blue = Colors.blue;
  Color red = Colors.red;
  Color grey = Colors.grey.shade700;
  Color black45 = Colors.black45;
  Color black38 = Colors.black38;
  Color black12 = Colors.black12;
  Color black54 = Colors.black54;
  Color blueGrey = Colors.blueGrey;
}

////////////////////////////////////////////////////////////////////
class MyButtonList extends StatefulWidget {
  MyButtonList({
    Key? key,
    required this.buttons1,
  }) : super(key: key);
  late double height, width;

  final List<ButtonData> buttons1;

  @override
  State<MyButtonList> createState() => _MyButtonListState();
}

class _MyButtonListState extends State<MyButtonList> {
  late List<bool> favoriateState;

  @override
  void initState() {
    favoriateState = List.generate(
        widget.buttons1.length, (index) => widget.buttons1[index].isFavorite);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < widget.buttons1.length; i++)
          Center(
            child: MyWidget(
              text: widget.buttons1[i].text,
              onPressed: () {
                for (var j = 0; j < favoriateState.length; j++) {
                  favoriateState[j] = false;
                }
                setState(() {
                  favoriateState[i] = true;
                  if (widget.buttons1[i].onPressed != null) {
                    widget.buttons1[i].onPressed!();
                  }
                });
              },
              isFavourte: favoriateState[i],
            ),
          ),
      ],
    );
  }
}

class ButtonData {
  final String text;
  final Function()? onPressed;
  final bool isFavorite;

  ButtonData({required this.text, this.onPressed, this.isFavorite = false});
}

class MyWidget extends StatelessWidget {
  const MyWidget(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.isFavourte = false})
      : super(key: key);

  final String text;
  final Function()? onPressed;
  final bool isFavourte;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width / 3.2,
        decoration: BoxDecoration(
          color: isFavourte ? ColorClass().themeColor2 : Colors.transparent,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: ColorClass().white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////

SaveUserData(String email, String name, String Number) {
  String id = FirebaseAuth.instance.currentUser!.email.toString();
  FirebaseFirestore.instance.collection('users').doc(id).set({
    'Email': email,
    'Name': name,
    'Number': Number,
  }).then((value) {
    print(id);
  }).onError((error, stackTrace) {});
}

class facebook {
  facebookLogin() async {
    print("FaceBook");
    try {
      final result = await FacebookAuth.i
          .login(permissions: ['public_profile', 'email', 'name']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print(userData);
      }
    } catch (error) {
      print(error);
    }
  }
}

class googleButton extends StatelessWidget {
  const googleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Buttons(
      height: 63,
      onPress: () {
        googleSignIn(context);
      },
      boxDecoration: BoxDecoration(
          border: Border.all(color: ColorClass().black12),
          borderRadius: BorderRadius.circular(10),
          color: ColorClass().white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
            child: Image.asset('assets/images/google.png'),
          ),
          Text(
            'Continue With Google',
            style: TextStyle(color: ColorClass().black54, fontSize: 20),
          )
        ],
      ),
    );
  }
}

class facebookButton extends StatelessWidget {
  const facebookButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Buttons(
      height: 63,
      onPress: () {
        facebook().facebookLogin().whenCompleted(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PromiseScreen()));
        });
      },
      boxDecoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
          color: ColorClass().white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
            child: Image.asset('assets/images/facebook.png'),
          ),
          Text(
            'Continue With Facebook',
            style: TextStyle(color: ColorClass().black54, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class NoData1 extends StatelessWidget {
  const NoData1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "I think you search wrong\n keyword or you didn't\n select the keyword",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
