import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import 'package:thought_bin/utils/ReUse.dart';

class RelatedPostFind extends StatefulWidget {
  const RelatedPostFind({Key? key}) : super(key: key);

  @override
  State<RelatedPostFind> createState() => _RelatedPostFindState();
}

class _RelatedPostFindState extends State<RelatedPostFind> {
  TextEditingController searchData = TextEditingController();
  var dbRef = FirebaseDatabase.instance.ref('posts');
  var search;
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 20),
                child: Text(
                  'A Word in Your Mind...',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: ColorClass().themeColor2),
                ),
              ),
              Visibility(
                visible: visible,
                child: Expanded(
                  child: FirebaseAnimatedList(
                    query: dbRef,
                    defaultChild: const SizedBox(
                        height: 50,
                        child: Center(child: CircularProgressIndicator())),
                    itemBuilder: (context, snapshot, animation, index) {
                      final title = snapshot.child('title').value.toString();
                      if (searchData.text.isEmpty) {
                        return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              color: ColorClass().white,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ButtonList2(buttons: [
                                  Button2(
                                    text: snapshot
                                        .child('title')
                                        .value
                                        .toString(),
                                    onPressed: () {
                                      search = snapshot
                                          .child('title')
                                          .value
                                          .toString();
                                    },
                                  )
                                ]),
                              ),
                            ));
                      } else if (title.toLowerCase().contains(
                          searchData.text.toLowerCase().toLowerCase())) {
                        return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              color: ColorClass().white,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ButtonList2(buttons: [
                                  Button2(
                                    text: snapshot
                                        .child('title')
                                        .value
                                        .toString(),
                                    onPressed: () {
                                      search = snapshot
                                          .child('title')
                                          .value
                                          .toString();
                                    },
                                  )
                                ]),
                              ),
                            ));
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      bottom: 100, top: 10, left: 20, right: 20),
                  child: SizedBox(
                      height: 55,
                      child: TextField(
                          style: TextStyle(
                              fontSize: 15, color: ColorClass().black54),
                          maxLines: 1,
                          controller: searchData,
                          decoration: InputDecoration(
                            hintText: 'e.g Fun Life',
                            prefixIcon: const Icon(Icons.search),
                            fillColor: ColorClass().black12,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                          onTap: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              search = value;
                            });
                          }))),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Buttons(
                    onPress: () async {
                      if (search == null) {
                        toast().toastMessage(
                            'Please type a topic or select one of them',
                            ColorClass().red);
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomePage()));
                      }
                    },
                    child: Text('Find Related Posts'),
                    height: 55,
                    boxDecoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              ColorClass().themeColor2,
                              ColorClass().themeColor
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(10))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
