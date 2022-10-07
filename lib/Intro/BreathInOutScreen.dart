import 'package:flutter/material.dart';
import 'package:thought_bin/Intro/IntroScreen.dart';
import 'package:thought_bin/ReUse.dart';

class BreathInOut extends StatelessWidget {
  const BreathInOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass().themeColor2,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ColorClass().themeColor2, ColorClass().themeColor])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => IntroScreenWidgets()));
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
        ),
      ),
    );
  }
}
