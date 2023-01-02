import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/ShowAllPosts.dart';
import 'package:thought_bin/utils/ReUse.dart';
import '../Home/ShowSearchPost.dart';

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
                        bottom: 1, top: 10, left: 20, right: 20),
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
                                    title1 = null;
                                    detail = null;
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
                              setState(() {});
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
                              title1 = snapshot.child('title').value.toString();
                              detail =
                                  snapshot.child('detail').value.toString();
                              searchData.text =
                                  snapshot.child('title').value.toString();
                              title1 = searchData.text;
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
                                  title1 =
                                      snapshot.child('title').value.toString();
                                  detail =
                                      snapshot.child('detail').value.toString();
                                  searchData.text =
                                      snapshot.child('title').value.toString();
                                  title1 = searchData.text;
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
          Container(
            color: ColorClass().white,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
              child: Buttons(
                  onPress: () async {
                    if (title1 == null) {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowAllPost()))
                          .onError((error, stackTrace) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NoData1()));
                      });
                    } else if (title1 != null) {
                      searchData.clear();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowSearchPost(
                                    title: title1,
                                    detail: detail,
                                  ))).whenComplete(() {
                        title1 = null;
                      }).onError((error, stackTrace) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NoData1()));
                      });
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NoData1()));
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
        ],
      ),
    );
  }
}
