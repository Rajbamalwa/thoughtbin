import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/Home/Account.dart';
import '../ReUse.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showDrafts = false;
  bool showPosts = false;
  bool showSaved = false;

  final auth = FirebaseAuth.instance;
  final draft = FirebaseDatabase.instance.ref('draft');
  final saved = FirebaseDatabase.instance.ref('saved');
  final posts = FirebaseDatabase.instance.ref('title');
  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: ColorClass().white),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Image(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/eye.png')),
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
                              builder: (context) => const AccountScreen(
                                    name: '',
                                  )));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: ColorClass().themeColor2,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 160, 10, 0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'UserName',
                    style: TextStyle(
                        color: ColorClass().themeColor2,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 185, 10, 0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'This information will not be public pon the app',
                      style: TextStyle(color: ColorClass().black45),
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyButtonList(
                      buttons: [
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
                      height: 50,
                      width: 112,
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
                defaultChild: Text('Loading'),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  final id = snapshot.child('id').value.toString();
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
                                            showMyDialog(title, id.toString());
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            draft
                                                .child(snapshot
                                                    .child('id')
                                                    .value
                                                    .toString())
                                                .remove();
                                          },
                                          icon: Icon(Icons.delete)),
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
                                  child: Text(
                                    snapshot.child('detail').value.toString(),
                                    style: const TextStyle(color: Colors.black),
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
                                                'title', id.toString());
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            draft
                                                .child(snapshot
                                                    .child('id')
                                                    .value
                                                    .toString())
                                                .remove();
                                          },
                                          icon: Icon(Icons.delete)),
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
                                  child: Text(
                                    snapshot.child('detail').value.toString(),
                                    style: const TextStyle(color: Colors.black),
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
                query: posts,
                defaultChild: const Text('Loading'),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
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
                                        posts
                                            .child(snapshot
                                                .child('id')
                                                .value
                                                .toString())
                                            .remove();
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
                                  child: Text(
                                    snapshot.child('detail').value.toString(),
                                    style: const TextStyle(color: Colors.black),
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
                                            draft
                                                .child(snapshot
                                                    .child('id')
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
                                  child: Text(
                                    snapshot.child('detail').value.toString(),
                                    style: const TextStyle(color: Colors.black),
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
            visible: showSaved,
            child: Expanded(
              child: FirebaseAnimatedList(
                query: saved,
                defaultChild: const Text('Loading'),
                itemBuilder: (context, snapshot, animation, index) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snapshot.child('title').value.toString(),
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
                                              .child('title')
                                              .value
                                              .toString())
                                          .remove();
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
                                child: Text(
                                  snapshot.child('detail').value.toString(),
                                  style: const TextStyle(color: Colors.black),
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

  Future<void> showMyDialog(String title, String? id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: editController,
                maxLines: 3,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)))),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  draft.child('id').update({
                    'title': editController.text.toLowerCase(),
                    'detail': editController.text.toLowerCase()
                  }).then((value) {
                    toast().toastMessage('Draft Updated', ColorClass().blue);
                  }).onError((error, stackTrace) {
                    toast().toastMessage(error.toString(), ColorClass().red);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
