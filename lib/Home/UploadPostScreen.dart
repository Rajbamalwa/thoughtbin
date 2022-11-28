import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gugor_emoji/emoji_picker_flutter.dart';
import 'package:thought_bin/Home/HomePage.dart';
import '../utils/ReUse.dart';

class UploadPostScreen extends StatefulWidget {
  String title, detail;
  UploadPostScreen({required this.title, required this.detail});

  @override
  State<UploadPostScreen> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPostScreen> {
  final saved = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/saved');
  final Likes = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/Likes');
  final DisLikes = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/DisLikes');

  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;
  var emojis;
  onEmojiSelected(Emoji emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

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
              child: Padding(
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
                                  'title': widget.title.toString(),
                                  'detail': widget.detail.toString()
                                }).then((value) {
                                  toast().toastMessage(
                                      'Post Dislike', Colors.blue);
                                  setState(() {
                                    loading = false;
                                  });
                                }).onError((error, stackTrace) {
                                  toast().toastMessage(
                                      'Something went wrong', Colors.red);
                                  setState(() {
                                    loading = false;
                                  });
                                });
                                break;
                              case DismissDirection.startToEnd:
                                Likes.child(id).set({
                                  'id': id,
                                  'title': widget.title.toString(),
                                  'detail': widget.detail.toString()
                                }).then((value) {
                                  toast()
                                      .toastMessage('Post Liked', Colors.blue);
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
                              height: MediaQuery.of(context).size.height / 1.8,
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(widget.title.toString(),
                                            //  list[index]['title'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                overflow: TextOverflow.fade,
                                                color: ColorClass().white,
                                                fontSize: 30,
                                                decoration:
                                                    TextDecoration.underline))),
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Text(
                                                  widget.detail.toString(),
                                                  // list[index][   'detail'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: ColorClass().white,
                                                      fontSize: 16),
                                                )))),
                                    Divider(thickness: 2.5),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  child: Row(children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      showBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return SizedBox(
                                                                height: 500,
                                                                child: EmojiPicker(
                                                                    onEmojiSelected:
                                                                        (category,
                                                                            emoji) {
                                                                  emojis = emoji
                                                                      .emoji;

                                                                  setState(() {
                                                                    emojiShowing =
                                                                        !emojiShowing;
                                                                  });
                                                                }));
                                                          });
                                                    },
                                                    child: Image(
                                                        image: AssetImage(
                                                            'assets/images/emoji.png'))),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 150,
                                                                top: 10,
                                                                bottom: 10),
                                                        child: SizedBox(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Offstage(
                                                              offstage:
                                                                  emojiShowing,
                                                              child: Text(
                                                                emojis
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ])),
                                              GestureDetector(
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
                                                      'title': widget.title
                                                          .toString(),
                                                      'detail': widget.detail
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
                                                  ))
                                            ]))
                                  ])))))),
            ),
          ],
        ),
      ]),
    );
  }
}
