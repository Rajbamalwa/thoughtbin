import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:thought_bin/utils/ReUse.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({Key? key}) : super(key: key);

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  bool loading = false;
  File? _image;
  File? _background;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final userPosts =
      FirebaseDatabase.instance.ref(FirebaseAuth.instance.currentUser!.uid);

  Future getImageGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Container(
          color: ColorClass().red,
        );
      }
    });
  }

  Future<String> files() async {
    String download = await storage
        .ref('${FirebaseAuth.instance.currentUser!.uid}/ProfilePic')
        .getDownloadURL();
    return download;
  }

  Future getBackGroundImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _background = File(pickedFile.path);
      } else {
        Container(
          color: ColorClass().red,
        );
      }
    });
  }

  Future<String> backgroundImage() async {
    String download = await storage
        .ref('${FirebaseAuth.instance.currentUser!.uid}/backgroundImage')
        .getDownloadURL();
    return download;
  }

  @override
  Widget build(BuildContext context) {
    String image = "";
    String background = '';
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(50),
                  child: Container(
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Center(child: Icon(Icons.image)),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Buttons(
                    onPress: getImageGallery,
                    child: Text('Get Profile Image'),
                    height: 50,
                    boxDecoration: BoxDecoration(
                        color: ColorClass().themeColor2,
                        borderRadius: BorderRadius.circular(10))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Buttons(
                    loading: loading,
                    child: Text('Set Profile Image'),
                    height: 50,
                    boxDecoration: BoxDecoration(
                        color: ColorClass().themeColor2,
                        borderRadius: BorderRadius.circular(10)),
                    onPress: () async {
                      setState(() {
                        loading = true;
                      });
                      firebase_storage.Reference ref =
                          firebase_storage.FirebaseStorage.instance.ref(
                              '/${FirebaseAuth.instance.currentUser!.uid}/ProfilePic');
                      firebase_storage.UploadTask uploadTask =
                          ref.putFile(_image!.absolute);

                      Future.value(uploadTask).then((value) async {
                        var newUrl = await ref.getDownloadURL();
                        userPosts.child('Images').set({
                          'id': FirebaseAuth.instance.currentUser!.uid,
                          'Image': newUrl.toString()
                        }).whenComplete(() {
                          setState(() {
                            loading = false;
                          });
                          toast().toastMessage(
                              'Set Profile picture', ColorClass().blue);
                        }).onError((error, stackTrace) {
                          print(error.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                      }).onError((error, stackTrace) {
                        toast()
                            .toastMessage(error.toString(), ColorClass().red);
                        setState(() {
                          loading = false;
                        });
                      });
                    }),
              ),
              Padding(
                  padding: EdgeInsets.all(50),
                  child: Container(
                    child: _background != null
                        ? Image.file(_background!.absolute)
                        : Center(child: Icon(Icons.image)),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Buttons(
                    onPress: getBackGroundImage,
                    child: Text('Get Background Image'),
                    height: 50,
                    boxDecoration: BoxDecoration(
                        color: ColorClass().themeColor2,
                        borderRadius: BorderRadius.circular(10))),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Buttons(
                      loading: loading,
                      child: Text('Set Background Image'),
                      height: 50,
                      boxDecoration: BoxDecoration(
                          color: ColorClass().themeColor2,
                          borderRadius: BorderRadius.circular(10)),
                      onPress: () async {
                        setState(() {
                          loading = true;
                        });
                        firebase_storage.Reference ref =
                            firebase_storage.FirebaseStorage.instance.ref(
                                '/${FirebaseAuth.instance.currentUser!.uid}/backgroundImage');
                        firebase_storage.UploadTask uploadTask =
                            ref.putFile(_background!.absolute);
                        setState(() {
                          loading = false;
                        });
                        toast().toastMessage(
                            'set your Profile background', ColorClass().blue);
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
