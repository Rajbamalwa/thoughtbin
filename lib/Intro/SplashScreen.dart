import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import 'package:thought_bin/Intro/BreathInOutScreen.dart';
import 'package:thought_bin/ReUse.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BreathInOut()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass().themeColor2,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ColorClass().white,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Align(
                        alignment: Alignment.topCenter,
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(40 / 3),
                          child: Image(
                              height: 20,
                              width: 20,
                              image: AssetImage(
                                  'assets/images/SplashScreen2.png')),
                        ),
                      ),
                      Image(
                          height: 50,
                          width: 50,
                          image: AssetImage('assets/images/splashScreen.png')),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'ThoughtBin',
                      style: TextStyle(
                          fontFamily: 'Galada',
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
