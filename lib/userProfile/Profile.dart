import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/userProfile/Account.dart';
import '../utils/ReUse.dart';
import 'package:readmore/readmore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showDrafts = false;
  bool showPosts = false;
  bool showSaved = false;
  bool loading = false;

  final draft = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/draft');
  final saved = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/saved');
  final posts = FirebaseDatabase.instance.ref('posts');
  final userPosts = FirebaseDatabase.instance
      .ref('${FirebaseAuth.instance.currentUser!.uid.toString()}/posts');
  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();
  TextEditingController editDetailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String image = "";
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                child: SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorClass().white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    '${FirebaseAuth.instance.currentUser?.photoURL}'))),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 140, 10, 0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: ColorClass().white),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AccountScreen()));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: ColorClass().themeColor2,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 180, 10, 0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '${FirebaseAuth.instance.currentUser?.displayName.toString()}',
                    style: TextStyle(
                        color: ColorClass().themeColor2,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 200, 10, 0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'This information will not be public on the app',
                      style: TextStyle(color: ColorClass().black45),
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyButtonList(
                      buttons1: [
                        ButtonData(
                            text: 'My Drafts',
                            onPressed: () {
                              setState(() {
                                showDrafts = !showDrafts;
                              });
                            }),
                        ButtonData(
                            text: 'Posts',
                            onPressed: () {
                              setState(() {
                                showPosts = !showPosts;
                              });
                            }),
                        ButtonData(
                            text: 'Saved Posts',
                            onPressed: () {
                              setState(() {
                                showSaved = !showSaved;
                              });
                            })
                      ],
                    )
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45,
              child: TextField(
                style: TextStyle(fontSize: 15, color: ColorClass().black54),
                maxLines: 1,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Keyboard',
                  prefixIcon: const Icon(Icons.search),
                  fillColor: ColorClass().black12,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          Visibility(
            replacement: Container(),
            visible: showDrafts,
            child: Expanded(
              child: FirebaseAnimatedList(
                query: draft,
                defaultChild: const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator())),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  final id = snapshot.child('id').value.toString();
                  final detail = snapshot.child('detail').value.toString();
                  if (searchController.text.isEmpty) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot
                                            .child('title')
                                            .value
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showMyDialog(
                                                title,
                                                snapshot
                                                    .child('id')
                                                    .value
                                                    .toString(),
                                                detail);
                                          },
                                          icon: const Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            draft
                                                .child(snapshot
                                                    .child('id')
                                                    .value
                                                    .toString())
                                                .remove()
                                                .then((value) {
                                              toast().toastMessage(
                                                  'Draft Deleted',
                                                  ColorClass().red);
                                            });
                                          },
                                          icon: const Icon(Icons.delete)),
                                    ],
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(
                                  height: 4,
                                  thickness: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ReadMoreText(
                                    snapshot.child('detail').value.toString(),
                                    style: const TextStyle(color: Colors.black),
                                    trimLines: 3,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )));
                  } else if (title.toLowerCase().contains(
                      searchController.text.toLowerCase().toLowerCase())) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.child(title).value.toString(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showMyDialog(
                                                title, id.toString(), detail);
                                          },
                                          icon: const Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            draft
                                                .child(snapshot
                                                    .child(id)
                                                    .value
                                                    .toString())
                                                .remove();
                                          },
                                          icon: const Icon(Icons.delete)),
                                    ],
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(
                                  height: 4,
                                  thickness: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ReadMoreText(
                                    snapshot.child('detail').value.toString(),
                                    style: const TextStyle(color: Colors.black),
                                    trimLines: 3,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Visibility(
              replacement: Container(),
              visible: showPosts,
              child: Expanded(
                child: FirebaseAnimatedList(
                  query: userPosts,
                  defaultChild: const SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator())),
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('title').value.toString();
                    final id = snapshot.child('id').value.toString();
                    final detail = snapshot.child('detail').value.toString();
                    if (searchController.text.isEmpty) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          snapshot
                                              .child('title')
                                              .value
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          userPosts
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove()
                                              .then((value) {
                                            toast().toastMessage('Post Deleted',
                                                ColorClass().red);
                                          });
                                          posts
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove()
                                              .then((value) {
                                            toast().toastMessage('Post Deleted',
                                                ColorClass().red);
                                          });
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Divider(
                                    height: 4,
                                    thickness: 2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ReadMoreText(
                                      snapshot.child('detail').value.toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                      trimLines: 3,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Show more',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )));
                    } else if (title.toLowerCase().contains(
                        searchController.text.toLowerCase().toLowerCase())) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          snapshot
                                              .child(title)
                                              .value
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showMyDialog(
                                                  title,
                                                  snapshot
                                                      .child(id)
                                                      .value
                                                      .toString(),
                                                  detail);
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              draft
                                                  .child(snapshot
                                                      .child(id)
                                                      .value
                                                      .toString())
                                                  .remove();
                                            },
                                            icon: const Icon(Icons.delete)),
                                      ],
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Divider(
                                    height: 4,
                                    thickness: 2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ReadMoreText(
                                      snapshot.child('detail').value.toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                      trimLines: 3,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Show more',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )));
                    } else {
                      return Container();
                    }
                  },
                ),
              )),
          Visibility(
            replacement: Container(),
            visible: showSaved,
            child: Expanded(
              child: FirebaseAnimatedList(
                query: saved,
                defaultChild: const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator())),
                itemBuilder: (context, snapshot, animation, index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snapshot.child('title').value.toString(),
                                      overflow: TextOverflow.fade,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      saved
                                          .child(snapshot
                                              .child('id')
                                              .value
                                              .toString())
                                          .remove()
                                          .then((value) {
                                        toast().toastMessage(
                                            'Saved Post Removed',
                                            ColorClass().red);
                                      });
                                    },
                                    child: const Image(
                                        image: AssetImage(
                                            'assets/images/SavedPost.png')),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                height: 4,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ReadMoreText(
                                  snapshot.child('detail').value.toString(),
                                  style: const TextStyle(color: Colors.black),
                                  trimLines: 3,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                ),
                              ),
                            ),
                          ],
                        ),
                      )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id, String detail) async {
    editController.text = title;
    editDetailController.text = detail;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              color: Colors.transparent,
              child: AlertDialog(
                title: Text(
                  'Edit Your draft',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorClass().themeColor2,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                content: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      ColorClass().themeColor2,
                                      ColorClass().themeColor
                                    ]),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Title',
                                    style: TextStyle(
                                        color: ColorClass().white,
                                        fontSize: 20),
                                  ),
                                ),
                                TextField(
                                  controller: editController,
                                  style: TextStyle(color: ColorClass().white),
                                  decoration: InputDecoration(
                                    hintText: 'Topic Title',
                                    hintStyle:
                                        TextStyle(color: ColorClass().white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Details',
                                      style: TextStyle(
                                          color: ColorClass().white,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorClass().white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                      maxLines: 10,
                                      controller: editDetailController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Description',
                                        hintStyle: TextStyle(
                                            color: ColorClass().black38,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Buttons(
                      height: 50,
                      boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              colors: [
                                ColorClass().themeColor2,
                                ColorClass().themeColor
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      onPress: () {
                        draft.child(id).update({
                          'id': id,
                          'title': editController.text.toLowerCase(),
                          'detail': editDetailController.text.toLowerCase(),
                        }).then((value) {
                          toast()
                              .toastMessage('Draft Updated', ColorClass().blue);
                        }).onError((error, stackTrace) {
                          toast()
                              .toastMessage(error.toString(), ColorClass().red);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Update'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Buttons(
                        height: 50,
                        boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [
                                  ColorClass().themeColor2,
                                  ColorClass().themeColor
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        onPress: () {
                          String id =
                              DateTime.now().microsecondsSinceEpoch.toString();

                          posts.child(id).update({
                            'id': id,
                            'title': editController.text,
                            'detail': editDetailController.text,
                          }).then((value) {
                            toast().toastMessage('Posted', Colors.blue);
                            setState(() {
                              loading = false;
                              editController.clear();
                              editDetailController.clear();
                            });
                          }).onError((error, stackTrace) {
                            toast().toastMessage(error.toString(), Colors.red);
                            setState(() {
                              loading = false;
                            });
                          });

                          userPosts.child(id).set({
                            'id': id,
                            'title': editController.text.toString(),
                            'detail': editDetailController.text.toString(),
                          }).then((value) {
                            toast().toastMessage('Posted', Colors.blue);
                            draft.child(id).remove();
                            setState(() {
                              loading = false;
                              editController.clear();
                              editDetailController.clear();
                            });
                          }).onError((error, stackTrace) {
                            toast().toastMessage('Error', Colors.red);
                            setState(() {
                              loading = false;
                            });
                          });
                        },
                        child: Text('Post')),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Buttons(
                      height: 50,
                      boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              colors: [
                                ColorClass().themeColor2,
                                ColorClass().themeColor
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      onPress: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ));
        });
  }
}
