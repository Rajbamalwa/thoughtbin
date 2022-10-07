import 'package:flutter/material.dart';
import 'package:thought_bin/Home/AddPostScreen.dart';
import 'package:thought_bin/Home/Profile.dart';
import '../ReUse.dart';
import 'UploadPostScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final page = [
    const UploadPostScreen(),
    const PostScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          page[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColorClass().themeColor2,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          // Respond to item press.
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            tooltip: 'feed',
            label: 'Favorites',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            tooltip: 'post',
            label: 'Favorites',
            icon: Icon(Icons.add_rounded),
          ),
          BottomNavigationBarItem(
            tooltip: 'profile',
            label: 'News',
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
          ),
        ],
      ),
    );
  }
}
