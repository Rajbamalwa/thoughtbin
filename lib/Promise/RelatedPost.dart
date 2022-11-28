import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/utils/ReUse.dart';
import '../Home/UploadPostScreen.dart';

class RelatedPostFind extends StatefulWidget {
  const RelatedPostFind({Key? key}) : super(key: key);

  @override
  State<RelatedPostFind> createState() => _RelatedPostFindState();
}

class _RelatedPostFindState extends State<RelatedPostFind> {
  TextEditingController searchData = TextEditingController();
  var data = FirebaseDatabase.instance.ref('posts');
  var title1;
  var detail;
  bool visible = false;
  bool isVisible = false;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass().white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.only(top: 0),
            color: ColorClass().white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 20),
                  child: Center(
                    child: Text(
                      'A Word in Your Mind...',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: ColorClass().themeColor2),
                    ),
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 1, top: 10, left: 15, right: 15),
                    child: Container(
                        color: ColorClass().white,
                        height: 55,
                        child: TextField(
                            style: TextStyle(
                                fontSize: 15, color: ColorClass().black54),
                            maxLines: 1,
                            controller: searchData,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    searchData.clear();
                                  },
                                  icon: Icon(Icons.clear)),
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
                                isVisible = !isVisible;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                title1 = value;
                              });
                            }))),
              ],
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Expanded(
                child: FirebaseAnimatedList(
                    defaultChild: Container(),
                    query: data,
                    itemBuilder: (context, snapshot, animation, index) {
                      final title = snapshot.child('title').value.toString();
                      if (searchData.text.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 1),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            highlightColor: ColorClass().themeColor2,
                            splashColor: ColorClass().themeColor2,
                            onTap: () {
                              setState(() {
                                visible = !visible;
                              });
                              title1 = snapshot.child('title').value.toString();
                              detail =
                                  snapshot.child('detail').value.toString();
                              searchData.text =
                                  snapshot.child('title').value.toString();
                              searchData = title1;
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              selected: true,
                              selectedTileColor: ColorClass().black12,
                              title: Text(
                                snapshot.child('title').value.toString(),
                                overflow: TextOverflow.fade,
                                style: TextStyle(color: ColorClass().black),
                              ),
                            ),
                          ),
                        );
                      } else if (title
                          .toLowerCase()
                          .contains(searchData.text.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 1),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 1),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                highlightColor: ColorClass().themeColor2,
                                splashColor: ColorClass().themeColor2,
                                onTap: () {
                                  setState(() {
                                    visible = !visible;
                                  });
                                  title1 =
                                      snapshot.child('title').value.toString();
                                  detail =
                                      snapshot.child('detail').value.toString();
                                  searchData.text =
                                      snapshot.child('title').value.toString();
                                  searchData.text = title1;
                                },
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  selected: true,
                                  selectedTileColor: ColorClass().black12,
                                  title: Text(
                                    snapshot.child('title').value.toString(),
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(color: ColorClass().black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    })),
          ),
          Visibility(
            visible: visible,
            replacement: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Buttons(
                onPress: () {
                  toast().toastMessage(
                      'Please type a topic and select it!', ColorClass().red);
                },
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorClass().black12,
                ),
                height: 50,
                child: Text('Please Select topic to Enable button'),
              ),
            ),
            child: Container(
              color: ColorClass().white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                child: Buttons(
                    onPress: () async {
                      if (title1 == null) {
                        searchData.clear();
                        toast().toastMessage(
                            'Please type a topic and select it',
                            ColorClass().red);
                      } else if (title1 != null) {
                        searchData.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadPostScreen(
                                      title: title1,
                                      detail: detail,
                                    )));
                      } else {
                        toast().toastMessage(
                            'Please type full word and then select it',
                            ColorClass().red);
                      }
                    },
                    child: Text(
                      'Find Related Posts',
                      style: TextStyle(color: ColorClass().white, fontSize: 21),
                    ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
