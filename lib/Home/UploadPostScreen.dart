import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  PostScreen postScreen = const PostScreen();
  final title = FirebaseDatabase.instance.ref('title');
  final saved = FirebaseDatabase.instance.ref('saved');
  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;
  var emojis;
  onEmojiSelected(Emoji emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  final recentEmoji = EmojiPickerUtils().getRecentEmojis();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorClass().white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorClass().black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: title.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
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
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.8,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(list[index]['title'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  overflow: TextOverflow.fade,
                                                  color: ColorClass().white,
                                                  fontSize: 30,
                                                  decoration: TextDecoration
                                                      .underline))),
                                      Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Text(
                                                    list[index]['detail'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            ColorClass().white,
                                                        fontSize: 15),
                                                  )))),
                                      const Padding(
                                          padding: EdgeInsets.all(9.0),
                                          child: Divider(
                                            thickness: 3,
                                          )),
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
                                                              (category,
                                                                  emoji) {
                                                            emojis = emoji;
                                                            onEmojiSelected(
                                                                emoji);
                                                            setState(() {
                                                              emojiShowing =
                                                                  !emojiShowing;
                                                            });
                                                          },
                                                          config: const Config(
                                                            columns: 7,
                                                            emojiSizeMax: 30,
                                                            verticalSpacing: 0,
                                                            horizontalSpacing:
                                                                0,
                                                            initCategory:
                                                                Category.RECENT,
                                                            bgColor: Color(
                                                                0xFFF2F2F2),
                                                            enableSkinTones:
                                                                true,
                                                            showRecentsTab:
                                                                true,
                                                            recentsLimit: 28,
                                                            noRecentsText:
                                                                'No Recents',
                                                            noRecentsStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .black26),
                                                            tabIndicatorAnimDuration:
                                                                kTabScrollDuration,
                                                            categoryIcons:
                                                                CategoryIcons(),
                                                          ),
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
                                          SizedBox(
                                            height: 50,
                                            width: 100,
                                            child: Offstage(
                                              offstage: emojiShowing,
                                              child: Text(emojis.toString()),
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
                                                  'saved': title.toString(),
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
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Column(
                        children: const [
                          Icon(Icons.arrow_drop_down_sharp),
                          Text('Swipe Down')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
