import 'package:flutter/material.dart';
import 'package:chatsapp/pages/Chatts.dart';
import 'package:chatsapp/pages/Settings.dart';
import 'package:chatsapp/pages/CallsPage.dart';
import 'package:chatsapp/pages/SearchPage.dart';
import 'package:chatsapp/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatsapp/pages/ContactsPage.dart';
import 'package:chatsapp/pages/CompleteProfile.dart';

//widget.userModel.email
// widget.userModel.fullname.toString(),
// NetworkImage(widget.userModel.profilepic.toString()),

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // pageController.jumpToPage(index);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuint);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple.withOpacity(0.1),
          title: Row(
            children: [
              //Navigate to Complete Profile Page
              GestureDetector(
                // onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const ProfileScreen(),
                //     )),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return CompleteProfile(
                        firebaseUser: widget.firebaseUser,
                        userModel: widget.userModel,
                      );
                    }),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepPurple[200],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4.5, 4.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.5, -4.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    backgroundImage:
                        NetworkImage(widget.userModel.profilepic.toString()),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              //Search for new Friend
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchPage(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    },
                  ),
                ),
                child: Container(
                  // height: 40,
                  // padding: const EdgeInsets.all(7),
                  padding: const EdgeInsets.fromLTRB(7, 7, 9, 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepPurple[200],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4.5, 4.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.5, -4.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.person_add,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
              ),

              //Heading
              Expanded(
                child: Center(
                  child: Text(
                    "ChatsApp",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.withOpacity(0.9),
                      shadows: [
                        Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 8.0,
                            color: Colors.black.withOpacity(0.5)),
                      ],
                      // shadows: [
                      //   Shadow(
                      //     offset: const Offset(1, 1),
                      //     blurRadius: 8.0,
                      //     color: Colors.deepPurple.withOpacity(0.9),
                      //   ),
                      // ],
                    ),
                  ),
                ),
              ),

              //Search From Chats
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchPage(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    },
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepPurple[200],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4.5, 4.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.5, -4.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ), //BoxShadow
                    ],
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 13,
              ),
              //Setting Button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepPurple[200],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4, 4),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.5, -4.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ), //BoxShadow
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: PageView(
          controller: pageController,
          children: [
            ChatsPage(
              firebaseUser: widget.firebaseUser,
              userModel: widget.userModel,
            ),
            const ContactsPage(),
            const CallsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatts'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Contacts'),
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
          ],
          onTap: onTapped,
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:chatsapp/pages/LoginPage.dart';
// import 'package:chatsapp/pages/SearchPage.dart';
// import 'package:chatsapp/models/UserModel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chatsapp/pages/ChatRoomPage.dart';
// import 'package:chatsapp/models/ChatRoomModel.dart';
// import 'package:chatsapp/models/FirebaseHelper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// //widget.userModel.email

// class HomePage extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;

//   const HomePage(
//       {Key? key, required this.userModel, required this.firebaseUser})
//       : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Chat App"),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.popUntil(context, (route) => route.isFirst);
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) {
//                   return LoginPage();
//                 }),
//               );
//             },
//             icon: Icon(Icons.exit_to_app),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("chatrooms")
//                 .where("participants.${widget.userModel.uid}", isEqualTo: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.active) {
//                 if (snapshot.hasData) {
//                   QuerySnapshot chatRoomSnapshot =
//                       snapshot.data as QuerySnapshot;

//                   return ListView.builder(
//                     itemCount: chatRoomSnapshot.docs.length,
//                     itemBuilder: (context, index) {
//                       ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
//                           chatRoomSnapshot.docs[index].data()
//                               as Map<String, dynamic>);

//                       Map<String, dynamic> participants =
//                           chatRoomModel.participants!;

//                       List<String> participantKeys = participants.keys.toList();
//                       participantKeys.remove(widget.userModel.uid);

//                       return FutureBuilder(
//                         future:
//                             FirebaseHelper.getUserModelById(participantKeys[0]),
//                         builder: (context, userData) {
//                           if (userData.connectionState ==
//                               ConnectionState.done) {
//                             if (userData.data != null) {
//                               UserModel targetUser = userData.data as UserModel;

//                               return ListTile(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) {
//                                       return ChatRoomPage(
//                                         chatroom: chatRoomModel,
//                                         firebaseUser: widget.firebaseUser,
//                                         userModel: widget.userModel,
//                                         targetUser: targetUser,
//                                       );
//                                     }),
//                                   );
//                                 },
//                                 leading: CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                       targetUser.profilepic.toString()),
//                                 ),
//                                 title: Text(targetUser.fullname.toString()),
//                                 subtitle: (chatRoomModel.lastMessage
//                                             .toString() !=
//                                         "")
//                                     ? Text(chatRoomModel.lastMessage.toString())
//                                     : Text(
//                                         "Say hi to your new friend!",
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .secondary,
//                                         ),
//                                       ),
//                               );
//                             } else {
//                               return Container();
//                             }
//                           } else {
//                             return Container();
//                           }
//                         },
//                       );
//                     },
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(snapshot.error.toString()),
//                   );
//                 } else {
//                   return const Center(
//                     child: Text("No Chats"),
//                   );
//                 }
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return SearchPage(
//                 userModel: widget.userModel, firebaseUser: widget.firebaseUser);
//           }));
//         },
//         child: const Icon(Icons.search),
//       ),
//     );
//   }
// }
