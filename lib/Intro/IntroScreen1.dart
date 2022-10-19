import 'package:flutter/material.dart';
import 'package:thought_bin/SignIn_SignUp/SignIn.dart';
import '../ReUse.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/IntroImage1.png'),
            SizedBox(height: 50),
            Text(
              'There are people who want to listen to your story.\n We @ThoughtBin bridge this gap.\nYou can use this app for personal diary writing.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorClass().grey, fontSize: 15),
            ),
            const SizedBox(height: 250),
            Text(
              'Swipe to Next',
              style: TextStyle(
                  fontSize: 20,
                  color: ColorClass().blue,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )),
    );
  }
}

class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Image.asset('assets/images/IntroImage2.png'),
            const SizedBox(height: 40),
            Text(
              'I promise that I will be sympathetic\n and supportive towards the community.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorClass().grey, fontSize: 15),
            ),
            const SizedBox(height: 180),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignIn()));
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                )),
          ],
        )),
      ),
    );
  }
}
