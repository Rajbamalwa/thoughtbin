import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../ReUse.dart';

class PhotoDp extends StatefulWidget {
  const PhotoDp({Key? key}) : super(key: key);

  @override
  State<PhotoDp> createState() => _PhotoDpState();
}

class _PhotoDpState extends State<PhotoDp> {
  bool loading = false;
  File? image;
  final picker = ImagePicker();
  final databaseRef = FirebaseDatabase.instance.ref('image');
  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        toast().toastMessage('No image Picked', ColorClass().red);
      }
    });
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: image != null
                    ? Image.file(image!.absolute)
                    : const Center(child: Icon(Icons.image)),
              ),
            ),
            const SizedBox(height: 50),
            Buttons(
                onPress: () {
                  getImageGallery();
                },
                height: 50,
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorClass().themeColor2,
                ),
                child: Text('Pick Image')),
            const SizedBox(height: 20),
            Buttons(
                loading: loading,
                onPress: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      .ref('/foldername' + '1234');
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(image!.absolute);

                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();

                    databaseRef.child('1').set({
                      'id': '1212',
                      'image': newUrl.toString(),
                    });
                    setState(() {
                      loading = false;
                    });
                    toast().toastMessage('Uploaded', ColorClass().blue);
                  }).onError((error, stackTrace) {
                    toast().toastMessage(error.toString(), ColorClass().red);
                    setState(() {
                      loading = false;
                    });
                  });
                },
                height: 50,
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorClass().themeColor2,
                ),
                child: Text('Upload'))
          ],
        ),
      ),
    );
  }
}
