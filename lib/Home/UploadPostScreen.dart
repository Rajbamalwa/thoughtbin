import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gugor_emoji/emoji_picker_flutter.dart';
import 'package:thought_bin/Home/AddPostScreen.dart';
import '../ReUse.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPostScreen> {
  final auth = FirebaseAuth.instance;
  final recentEmojis = EmojiPickerUtils().getRecentEmojis();
  final controller = PageController();
  PostScreen postScreen = PostScreen();
  final title = FirebaseDatabase.instance.ref('title');
  final saved = FirebaseDatabase.instance.ref('saved');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded)),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
                stream: title.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Container());
                  } else {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = [];
                    list.clear();
                    list = map.values.toList();
                    return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(12, 30, 12, 0),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        ColorClass().themeColor2,
                                        ColorClass().themeColor
                                      ]),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          list[index]['title'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorClass().white,
                                              fontSize: 30,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          list[index]['detail'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorClass().white,
                                              fontSize: 15),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(9.0),
                                        child: Divider(
                                          thickness: 3,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                showBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: 500,
                                                        child: EmojiPicker(
                                                          onEmojiSelected:
                                                              (Category
                                                                      category,
                                                                  Emoji emoji) {
                                                            ;
                                                          },
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: const ClipOval(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/emoji.png'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                saved
                                                    .child(DateTime.now()
                                                        .microsecondsSinceEpoch
                                                        .toString())
                                                    .set({
                                                  'title': title.toString(),
                                                }).then((value) {
                                                  toast().toastMessage(
                                                      'Saved', Colors.blue);
                                                  setState(() {});
                                                }).onError((error, stackTrace) {
                                                  toast().toastMessage(
                                                      'Error', Colors.red);
                                                  setState(() {});
                                                });
                                              },
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/images/savePost.png'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
    );
  }

  Widget buildSticker() {
    return EmojiPicker(
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
    );
  }
}
