import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import 'package:thought_bin/utils/ReUse.dart';

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
  bool showText = false;

  checkText() {
    String text =
        'I promise that I will be sympathetic and supportive towards the community.';
    if (text.toString() != promiseController.text) {
      toast().toastMessage('Please check your promise', ColorClass().red);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass().white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 70),
            Image.asset(
              'assets/images/promise1.png',
              fit: BoxFit.cover,
            ),
            Text(
              'Please type the following...',
              style: TextStyle(fontSize: 20, color: ColorClass().black45),
            ),
            SizedBox(height: 70),
            Visibility(
                visible: showText,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'I promise that I will be sympathetic and supportive towards the community.'),
                      ),
                    ),
                  ),
                )),
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
                  child: TextField(
                    onChanged: (value) {},
                    onTap: () {
                      setState(() {
                        showText = !showText;
                      });
                    },
                    controller: promiseController,
                    style: const TextStyle(color: Colors.black45),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'I promise that I will be sympathetic and supportive towards the community.'),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                  ),
                ),
              ),
            ),
            SizedBox(height: 70),
            TextButton(
                onPressed: () {
                  checkText();
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
    );
  }
}
