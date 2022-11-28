import 'package:flutter/material.dart';
import 'package:thought_bin/Home/AddPostScreen.dart';
import 'package:thought_bin/Promise/RelatedPost.dart';
import 'package:thought_bin/userProfile/Profile.dart';
import '../utils/ReUse.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final page = [
    RelatedPostFind(),
    PostScreen(),
    ProfileScreen(),
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
            backgroundColor: Colors.transparent,
            elevation: 0,
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
            items: [
              BottomNavigationBarItem(
                tooltip: 'feed',
                label: 'feed',
                activeIcon: navigationBar(Icon(Icons.home)),
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                tooltip: 'post',
                label: 'post',
                activeIcon: navigationBar(Icon(Icons.add_circle)),
                icon: Icon(Icons.add_circle),
              ),
              BottomNavigationBarItem(
                tooltip: 'profile',
                label: 'profile',
                activeIcon: navigationBar(
                  Icon(Icons.person),
                ),
                icon: Icon(Icons.person),
              ),
            ]));
  }
}

navigationBar(Widget icon) {
  return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 0), //(x,y)
          blurRadius: 0.5,
        ),
      ], shape: BoxShape.circle, color: ColorClass().iconColor),
      child: Center(
        child: icon,
      ));
}
