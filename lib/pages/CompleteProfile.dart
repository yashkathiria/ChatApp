import 'dart:io';
import 'dart:developer';
import 'package:chatsapp/main.dart';
import 'package:chatsapp/pages/ChatRoomPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatsapp/models/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? profileimageFile;
  TextEditingController fullNameController = TextEditingController();

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => getprofileImage(ImageSource.gallery),
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () => getprofileImage(ImageSource.camera),
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a photo"),
                ),
              ],
            ),
          );
        });
  }

  Future getprofileImage(imageSource) async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: imageSource).then((XFile) {
      if (XFile != null) {
        profileimageFile = File(XFile.path);
        uploadprofileImage();
      }
    });
  }

  Future uploadprofileImage() async {
    String fileName = uuid.v1();
    int status = 1;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap());

    var ref = FirebaseStorage.instance
        .ref()
        .child('Profile Photoes')
        .child("$fileName.jpg");

    var uploadTask =
        await ref.putFile(profileimageFile!).catchError((error) async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .update(
        {"profilepic": imageUrl},
      );

      log(imageUrl);
    }
  }

  // void checkValues() {
  //   String fullname = fullNameController.text.trim();

  //   if (fullname == "" || imageFile == null) {
  //     print("Please fill all the fields");
  //     UIHelper.showAlertDialog(context, "Incomplete Data",
  //         "Please fill all the fields and upload a profile picture");
  //   } else {
  //     log("Uploading data..");
  // uploadImage();
  // uploademail();
  //   }
  // }

  void editfullname() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Name: ${widget.userModel.fullname}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    hintText: widget.userModel.fullname,
                    suffixIcon: GestureDetector(
                        onTap: uploadfullname,
                        child: const Icon(
                          Icons.done_outline,
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void uploadfullname() async {
    String? fullname = fullNameController.text.trim();

    widget.userModel.fullname = fullname;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("Data uploaded!");
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: const Text("Complete Profile"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                showPhotoOptions();
              },
              padding: const EdgeInsets.all(0),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                      ),
                      child:
                          //  ShowImage(
                          //   imageUrl: (widget.userModel.profilepic).toString(),
                          // )
                          //  Image(
                          //     image: NetworkImage(
                          //         (widget.userModel.profilepic).toString()))
                          CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            widget.userModel.profilepic.toString()),
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 3,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.deepPurple,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        )),
                  ],
                ),
              ),
            ),
            //Full Name
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: ListTile(
                  title: (Text((widget.userModel.fullname).toString())),
                  trailing: GestureDetector(
                    onTap: editfullname,
                    child: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
              ),
            ),

            //Email Id
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: ListTile(
                  title: (Text((widget.userModel.email).toString())),
                  trailing: GestureDetector(
                    // onTap: editEmail,
                    child: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
