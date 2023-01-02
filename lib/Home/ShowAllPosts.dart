import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/HomePage.dart';
import '../utils/ReUse.dart';

class ShowAllPost extends StatefulWidget {
  @override
  State<ShowAllPost> createState() => _UploadPostState();
}

class _UploadPostState extends State<ShowAllPost> {
  final saved = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/saved');
  final Likes = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/Likes');
  final DisLikes = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/DisLikes');
  var data = FirebaseDatabase.instance.ref('posts');
  final controller = PageController();

  var image;
  @override
  void initState() {
    image = false;
    super.initState();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass().white,
      body: Stack(children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 50,
                    child: Column(children: [
                      Icon(Icons.keyboard_arrow_down_outlined,
                          color: ColorClass().black54),
                      Text('Swipe Down',
                          style: TextStyle(color: ColorClass().black54))
                    ])))),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    splashRadius: 0.1,
                    splashColor: ColorClass().themeColor2,
                    highlightColor: ColorClass().themeColor2,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icon(Icons.close, color: ColorClass().black)),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: data.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();
                      return PageView.builder(
                          controller: controller,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.snapshot.children.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Center(
                                child: Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (DismissDirection direction) {
                                    String id = DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString();

                                    switch (direction) {
                                      case DismissDirection.none:
                                        break;

                                      case DismissDirection.endToStart:
                                        DisLikes.child(id).update({
                                          'id': id,
                                          'title': list[index]['title'],
                                          'detail': list[index]['detail']
                                        }).then((value) {
                                          toast().toastMessage(
                                              'Post Dislike', Colors.blue);
                                          setState(() {
                                            loading = false;
                                          });
                                        }).onError((error, stackTrace) {
                                          toast().toastMessage(
                                              'Something went wrong',
                                              Colors.red);
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                        break;
                                      case DismissDirection.startToEnd:
                                        Likes.child(id).set({
                                          'id': id,
                                          'title': list[index]['title'],
                                          'detail': list[index]['detail']
                                        }).then((value) {
                                          toast().toastMessage(
                                              'Post Liked', Colors.blue);
                                          setState(() {
                                            loading = false;
                                          });
                                        }).onError((error, stackTrace) {
                                          toast().toastMessage(
                                              'Something went wrong'.toString(),
                                              Colors.red);
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                        break;
                                    }
                                  },
                                  background: Center(
                                      child: Text(
                                    'Post Liked',
                                    style: TextStyle(
                                        color: ColorClass().blue,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  secondaryBackground: Center(
                                    child: Text(
                                      'Post DisLike',
                                      style: TextStyle(
                                          color: ColorClass().red,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  crossAxisEndOffset: 0.1,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.8,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              ColorClass().themeColor2,
                                              ColorClass().themeColor
                                            ])),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(list[index]['title'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      color: ColorClass().white,
                                                      fontSize: 30,
                                                      decoration: TextDecoration
                                                          .underline))),
                                          Expanded(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Text(
                                                        list[index]['detail'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: ColorClass()
                                                                .white,
                                                            fontSize: 15),
                                                      )))),
                                          const Padding(
                                              padding: EdgeInsets.all(9.0),
                                              child: Divider(
                                                thickness: 3,
                                              )),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    image = !image;
                                                    loading = true;
                                                  });
                                                  String id = DateTime.now()
                                                      .microsecondsSinceEpoch
                                                      .toString();

                                                  saved.child(id).set({
                                                    'id': id,
                                                    'title': list[index]
                                                            ['title']
                                                        .toString(),
                                                    'detail': list[index]
                                                            ['detail']
                                                        .toString()
                                                  }).then((value) {
                                                    toast().toastMessage(
                                                        'Saved', Colors.blue);
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }).onError(
                                                      (error, stackTrace) {
                                                    toast().toastMessage(
                                                        'Error', Colors.red);
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 40,
                                                  child: Image(
                                                      image: AssetImage(image
                                                          ? 'assets/images/saved.png'
                                                          : 'assets/images/savePost.png')),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            )
          ],
        ),
      ]),
    );
  }
}
