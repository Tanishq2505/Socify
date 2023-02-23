import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socify/constants.dart';
import 'package:socify/view_model/respositories/post_repository.dart';

showNewPostSheet(
  context,
  Size size,
  String ownerId,
) {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  String imageLocation = "";
  TextEditingController caption = TextEditingController();
  TextEditingController likes = TextEditingController();
  TextEditingController tags = TextEditingController();
  bool loading = false;
  return showModalBottomSheet(
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (buildContext) {
      return StatefulBuilder(builder: (builderContext, setState) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(buildContext).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16),
            height: size.height * 0.6,
            width: size.width,
            child: SingleChildScrollView(
              child: Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: caption,
                      validator: validator,
                      decoration:
                          kInputTextDecoration.copyWith(hintText: "Caption"),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: likes,
                      validator: validator,
                      decoration: kInputTextDecoration.copyWith(
                        hintText: "Likes",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: tags,
                      validator: validator,
                      decoration: kInputTextDecoration.copyWith(
                        hintText: "Tags (separated by comma)",
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    FilledButton.tonal(
                      onPressed: () async {
                        XFile? pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          loading = true;
                          setState(() {});
                          var int = Random().nextInt(100000000);
                          FirebaseStorage _storage = FirebaseStorage.instance;
                          Reference reference =
                              _storage.ref().child("$ownerId-post$int");
                          TaskSnapshot uploadsTask = await reference.putFile(
                            File(pickedFile.path),
                          );
                          String location = await reference.getDownloadURL();
                          imageLocation = location;
                          loading = false;
                          setState(() {});
                        }
                      },
                      child: Text("Get Image from gallery"),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    (imageLocation != "")
                        ? Text("Image successfully uploaded")
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 6,
                    ),
                    FilledButton(
                      onPressed: () async {
                        if (key.currentState!.validate() &&
                            imageLocation != "" &&
                            loading != true) {
                          loading = true;
                          setState(() {});
                          await PostRepositories(buildContext)
                              .createPost(postData: {
                            "text": caption.text,
                            "image": imageLocation,
                            "likes": int.parse(likes.text),
                            "tags": tags.text.split(','),
                            "owner": ownerId
                          });
                          loading = false;
                          setState(() {});
                          Navigator.pop(buildContext);
                        }
                      },
                      child: loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text("Post"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}

String? validator(String? val) {
  if (val == null || val == "") {
    return "Please fill all details";
  }
  return null;
}
