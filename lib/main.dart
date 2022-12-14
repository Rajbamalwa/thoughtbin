import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Intro/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thought bin',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
