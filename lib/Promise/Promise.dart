import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import 'package:thought_bin/Promise/RelatedPost.dart';
import 'package:thought_bin/ReUse.dart';
import '../SignIn_SignUp/SignIn.dart';

class PromiseScreen extends StatefulWidget {
  const PromiseScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PromiseScreen> createState() => _PromiseScreenState();
}

class _PromiseScreenState extends State<PromiseScreen> {
  final formKey = GlobalKey<FormState>();
  final promiseController = TextEditingController();
  final auth = FirebaseAuth.instance;
  SignIn signIn = const SignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass().white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Image.asset(
                'assets/images/promise1.png',
                fit: BoxFit.cover,
              ),
              Text(
                'Please type the following...',
                style: TextStyle(fontSize: 20, color: ColorClass().black45),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1)),
                  padding: const EdgeInsets.all(5),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Promise Us';
                        }
                      },
                      controller: promiseController,
                      style: const TextStyle(color: Colors.black45),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              ' I promise that I will be sympathetic and\n supportive towards the community.'),
                      keyboardType: TextInputType.multiline,
                      minLines: 1, // <-- SEE HERE
                      maxLines: 5, // <-- SEE HERE
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 200),
              TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const RelatedPostFind()));
                    } else {
                      debugPrint('Please Promise Us');
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.blue,
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
