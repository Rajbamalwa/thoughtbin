import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import 'package:thought_bin/Intro/IntroScreen.dart';
import 'package:thought_bin/Promise/RelatedPost.dart';
import 'package:thought_bin/utils/ReUse.dart';

class BreathInOut extends StatefulWidget {
  const BreathInOut({Key? key}) : super(key: key);

  @override
  State<BreathInOut> createState() => _BreathInOutState();
}

class _BreathInOutState extends State<BreathInOut> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorClass().themeColor2, ColorClass().themeColor])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/Gif.gif',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 60),
              TextButton(
                  onPressed: () {
                    if (auth.currentUser == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IntroScreenWidgets()));
                    } else {
                      toast().toastMessage(
                          'Welcome Back, Please type a topic and select it',
                          ColorClass().blue);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: ColorClass().white,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
