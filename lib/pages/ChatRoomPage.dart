// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:chatsapp/main.dart';
// import 'package:chatsapp/models/ChatRoomModel.dart';
// import 'package:chatsapp/models/MessageModel.dart';
// import 'package:chatsapp/models/UserModel.dart';

// class ChatRoomPage extends StatefulWidget {
//   final UserModel targetUser;
//   final ChatRoomModel chatroom;
//   final UserModel userModel;
//   final User firebaseUser;

//   const ChatRoomPage(
//       {Key? key,
//       required this.targetUser,
//       required this.chatroom,
//       required this.userModel,
//       required this.firebaseUser})
//       : super(key: key);

//   @override
//   _ChatRoomPageState createState() => _ChatRoomPageState();
// }

// class _ChatRoomPageState extends State<ChatRoomPage> {
//   TextEditingController messageController = TextEditingController();

//   void sendMessage() async {
//     String msg = messageController.text.trim();
//     messageController.clear();

//     if (msg != "") {
//       // Send Message
//       MessageModel newMessage = MessageModel(
//           messageid: uuid.v1(),
//           sender: widget.userModel.uid,
//           createdon: DateTime.now(),
//           text: msg,
//           seen: false);

//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatroom.chatroomid)
//           .collection("messages")
//           .doc(newMessage.messageid)
//           .set(newMessage.toMap());

//       widget.chatroom.lastMessage = msg;
//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatroom.chatroomid)
//           .set(widget.chatroom.toMap());

//       log("Message Sent!");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.deepPurple.withOpacity(0.3),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.grey[300],
//               backgroundImage:
//                   NetworkImage(widget.targetUser.profilepic.toString()),
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     widget.targetUser.fullname.toString(),
//                     style: TextStyle(
//                       color: Colors.black,
//                       shadows: [
//                         Shadow(
//                             offset: const Offset(1, 1),
//                             blurRadius: 5.0,
//                             color: Colors.black.withOpacity(0.5)),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     "Online",
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 13,
//                       shadows: [
//                         Shadow(
//                             offset: const Offset(0.5, 0.5),
//                             blurRadius: 2.0,
//                             color: Colors.grey.withOpacity(0.5)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(
//               Icons.videocam,
//               color: Colors.black,
//             ),
//             const SizedBox(
//               width: 20,
//             ),
//             const Icon(
//               Icons.call,
//               color: Colors.black,
//             ),
//             const SizedBox(
//               width: 20,
//             ),
//             const Icon(
//               Icons.settings,
//               color: Colors.black,
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               color: Colors.deepPurple.withOpacity(0.1),
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection("chatrooms")
//                     .doc(widget.chatroom.chatroomid)
//                     .collection("messages")
//                     .orderBy("createdon", descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.active) {
//                     if (snapshot.hasData) {
//                       QuerySnapshot dataSnapshot =
//                           snapshot.data as QuerySnapshot;

//                       return ListView.builder(
//                         reverse: true,
//                         shrinkWrap: true,
//                         itemCount: dataSnapshot.docs.length,
//                         padding: const EdgeInsets.only(top: 10, bottom: 10),
//                         itemBuilder: (context, index) {
//                           MessageModel currentMessage = MessageModel.fromMap(
//                               dataSnapshot.docs[index].data()
//                                   as Map<String, dynamic>);

//                           return Container(
//                             padding: const EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Align(
//                               alignment:
//                                   (currentMessage.sender == widget.userModel.uid
//                                       ? Alignment.topRight
//                                       : Alignment.topLeft),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     color: (currentMessage.sender ==
//                                             widget.userModel.uid)
//                                         ? Colors.deepPurple[300]
//                                         : Colors.grey.shade300,
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                         color: Colors.black.withOpacity(0.5),
//                                         width: 0.25)),
//                                 padding: const EdgeInsets.all(15),
//                                 child: Text(
//                                   currentMessage.text.toString(),
//                                   style: const TextStyle(
//                                       color: Colors.black, fontSize: 15),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     } else if (snapshot.hasError) {
//                       return const Center(
//                         child: Text(
//                             "An error occured! Please check your internet connection."),
//                       );
//                     } else {
//                       return const Center(
//                         child: Text("Say hi to your new friend"),
//                       );
//                     }
//                   } else {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),

//           // Enter Message
//           Container(
//             // color: Colors.grey[200],
//             color: Colors.deepPurple.withOpacity(0.1),
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             child: Row(
//               children: [
//                 //Add Button
//                 GestureDetector(
//                   onTap: () {},
//                   child: Container(
//                     height: 32,
//                     width: 32,
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: const Icon(
//                       Icons.add,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 // controller: messageController,
//                 // maxLines: null,
//                 Flexible(
//                   child: Container(
//                     height: 45,
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           width: 1,
//                           color: Colors.deepPurple.withOpacity(0.2),
//                         ),
//                         borderRadius: BorderRadius.circular(20)),
//                     child: TextField(
//                       maxLines: null,
//                       controller: messageController,
//                       decoration: InputDecoration(
//                         hintText: "Enter message...",
//                         hintStyle: const TextStyle(color: Colors.black54),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.only(
//                           left: 15,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide(
//                               color: Colors.deepPurple.withOpacity(0.1),
//                               width: 1),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide(
//                               color: Colors.deepPurple.withOpacity(0.3),
//                               width: 2),
//                         ),
//                       ),
//                       cursorColor: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//                 // Flexible(
//                 //   child: TextField(
//                 //     controller: messageController,
//                 //     maxLines: null,
//                 //     decoration: const InputDecoration(
//                 //         border: InputBorder.none, hintText: "Enter message"),
//                 //   ),
//                 // ),
//                 const SizedBox(
//                   width: 15,
//                 ),
//                 //Send Button
//                 ElevatedButton(
//                   onPressed: () {
//                     sendMessage();
//                   },
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(
//                       Colors.deepPurple,
//                     ),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                     ),
//                   ),
//                   child: const Icon(
//                     Icons.send,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatsapp/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatsapp/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatsapp/models/MessageModel.dart';
import 'package:chatsapp/models/ChatRoomModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((XFile) {
      if (XFile != null) {
        imageFile = File(XFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = uuid.v1();
    String type = "image";
    int status = 1;
    String msg = messageController.text.trim();
    messageController.clear();

    MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        type: type,
        seen: false);

    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatroom.chatroomid)
        .collection("messages")
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .update(
        {"text": imageUrl},
        // {"type": image}
      );

      log(imageUrl);
    }
  }

  void sendMessage() async {
    String msg = messageController.text.trim();
    String type = "txt";
    messageController.clear();

    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: widget.userModel.uid,
          createdon: DateTime.now(),
          text: msg,
          type: type,
          seen: false);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());

      log("Message Sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple.withOpacity(0.3),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  NetworkImage(widget.targetUser.profilepic.toString()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.targetUser.fullname.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      shadows: [
                        Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.5)),
                      ],
                    ),
                  ),
                  Text(
                    "Online",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      shadows: [
                        Shadow(
                            offset: const Offset(0.5, 0.5),
                            blurRadius: 2.0,
                            color: Colors.grey.withOpacity(0.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.videocam,
              color: Colors.black,
            ),
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.call,
              color: Colors.black,
            ),
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.deepPurple.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatroom.chatroomid)
                    .collection("messages")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: dataSnapshot.docs.length,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return currentMessage.type == "txt"
                              ? Container(
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14, top: 5, bottom: 5),
                                  child: Align(
                                    alignment: (currentMessage.sender ==
                                            widget.userModel.uid
                                        ? Alignment.topRight
                                        : Alignment.topLeft),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? Colors.deepPurple.withOpacity(0.9)
                                            : Colors.deepPurple
                                                .withOpacity(0.1),
                                        // ? Colors.grey.shade300
                                        // : Colors.deepPurple[300],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.5),
                                          width: 0.25,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: const Offset(
                                              4.0,
                                              4.0,
                                            ),
                                            blurRadius: 3.0,
                                            spreadRadius: 0.5,
                                          ), //BoxShadow
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: TextStyle(
                                            color: (currentMessage.sender ==
                                                    widget.userModel.uid)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14, top: 5, bottom: 5),
                                  child: Align(
                                    alignment: (currentMessage.sender ==
                                            widget.userModel.uid
                                        ? Alignment.topRight
                                        : Alignment.topLeft),
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ShowImage(
                                            imageUrl:
                                                currentMessage.text.toString(),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                          // color: Colors.deepPurple,
                                          padding: const EdgeInsets.all(3),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.70,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(23),
                                            color: Colors.deepPurple
                                                .withOpacity(0.9),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                offset: const Offset(
                                                  3.0,
                                                  3.0,
                                                ),
                                                blurRadius: 5.0,
                                                spreadRadius: 1.0,
                                              ), //BoxShadow
                                              const BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 0.0,
                                                spreadRadius: 0.0,
                                              ), //BoxShadow
                                            ],
                                          ),
                                          alignment:
                                              currentMessage.text.toString() !=
                                                      ""
                                                  ? null
                                                  : Alignment.center,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: currentMessage.text
                                                        .toString() !=
                                                    ""
                                                ? CachedNetworkImage(
                                                    imageUrl: currentMessage
                                                        .text
                                                        .toString(),
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child: CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .deepPurple))),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                  )
                                                // Image.network(
                                                //     currentMessage.text
                                                //         .toString(),
                                                //     fit: BoxFit.cover,
                                                //   )
                                                : const CircularProgressIndicator(),
                                          )
                                          // currentMessage.text.toString() !=
                                          //         ""
                                          //     ? Image.network(
                                          //         currentMessage.text.toString(),
                                          //         fit: BoxFit.cover,
                                          //       )
                                          //     : const CircularProgressIndicator(),
                                          ),
                                    ),
                                  ),
                                );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occured! Please check your internet connection."),
                      );
                    } else {
                      return const Center(
                        child: Text("Say hi to your new friend"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),

          // Enter Message
          Container(
            // color: Colors.grey[200],
            color: Colors.deepPurple.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                //Add Button
                GestureDetector(
                  onTap: () => getImage(),
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // controller: messageController,
                // maxLines: null,
                Flexible(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.deepPurple.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextField(
                      maxLines: null,
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Enter message...",
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          left: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.deepPurple.withOpacity(0.1),
                              width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.deepPurple.withOpacity(0.3),
                              width: 2),
                        ),
                      ),
                      cursorColor: Colors.deepPurple,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 15,
                ),
                //Send Button
                ElevatedButton(
                  onPressed: () {
                    sendMessage();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.deepPurple,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
