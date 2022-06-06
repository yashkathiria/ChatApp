import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatsapp/main.dart';
import 'package:flutter/material.dart';
import 'package:chatsapp/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatsapp/pages/ChatRoomPage.dart';
import 'package:chatsapp/models/ChatRoomModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0.5, 0.5),
                blurRadius: 3.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.deepPurple.withOpacity(0.2),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                cursorColor: Colors.deepPurple,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 1, 37, 10),
                  ),
                  hintText: 'Enter email address',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 1, 37, 10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide:
                        BorderSide(color: Colors.deepPurple, width: 1.75),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Colors.deepPurple, width: 1.75),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => setState(() {}),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        spreadRadius: 2,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-2.0, -2.0),
                        blurRadius: 3.0,
                        spreadRadius: 2,
                      ), //BoxShadow
                    ],
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: const Center(
                      child: Text(
                    "Search",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: searchController.text)
                      .where("email", isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        if (dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;

                          UserModel searchedUser = UserModel.fromMap(userMap);

                          return ListTile(
                            onTap: () async {
                              ChatRoomModel? chatroomModel =
                                  await getChatroomModel(searchedUser);

                              if (chatroomModel != null) {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ChatRoomPage(
                                    targetUser: searchedUser,
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                    chatroom: chatroomModel,
                                  );
                                }));
                              }
                            },
                            leading: SizedBox(
                              height: 57,
                              width: 57,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: CachedNetworkImage(
                                  imageUrl: searchedUser.profilepic!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              searchedUser.fullname!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(1, 1),
                                      blurRadius: 3.0,
                                      color: Colors.black.withOpacity(0.2)),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              searchedUser.email!,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                shadows: [
                                  Shadow(
                                      offset: const Offset(1, 1),
                                      blurRadius: 5.0,
                                      color: Colors.black.withOpacity(0.2)),
                                ],
                              ),
                            ),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          );
                        } else {
                          return const Text("No results found!");
                        }
                      } else if (snapshot.hasError) {
                        return const Text("An error occured!");
                      } else {
                        return const Text("No results found!");
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
