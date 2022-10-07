import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';

import '../ReUse.dart';

class RelatedPostFind extends StatefulWidget {
  const RelatedPostFind({Key? key}) : super(key: key);

  @override
  State<RelatedPostFind> createState() => _RelatedPostFindState();
}

class _RelatedPostFindState extends State<RelatedPostFind> {
  int _currentIndex = 0;
  TextEditingController controller = TextEditingController();
  bool showList = false;
  String wantJustice = 'Want justice';
  String careers = 'Careers';
  String politics = 'Politics';
  String mentalHealth = 'Mental Health';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A Word in Your Mind...',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: ColorClass().themeColor2),
            ),
            const SizedBox(height: 30),
            Visibility(
              visible: showList,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorClass().white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MyButtonList2(
                          buttons: [
                            ButtonData2(text: wantJustice, onPressed: () {}),
                            ButtonData2(text: careers, onPressed: () {}),
                            ButtonData2(text: politics, onPressed: () {}),
                            ButtonData2(text: mentalHealth, onPressed: () {})
                          ],
                          height: 55,
                          width: 330,
                        )
                      ],
                    )),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                    controller: controller,
                    onTap: () {
                      setState(() {
                        showList = !showList;
                      });
                    },
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'e.g Fun Life',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))))),
            Buttons(
                onPress: () {
                  toast().toastMessage(
                      "ThoughtBin Welcome's you", ColorClass().blue);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                height: 60,
                boxDecoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorClass().themeColor2,
                          ColorClass().themeColor
                        ]),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Find Related Posts',
                  style: TextStyle(fontSize: 17, color: ColorClass().white),
                ))
          ],
        ),
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
