import 'package:flutter/material.dart';
import 'package:chatsapp/models/UserModel.dart';
import 'package:chatsapp/pages/ChatRoomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatsapp/models/ChatRoomModel.dart';
import 'package:chatsapp/models/FirebaseHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatsPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const ChatsPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants.${widget.userModel.uid}", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                return ListView.builder(
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                        chatRoomSnapshot.docs[index].data()
                            as Map<String, dynamic>);

                    Map<String, dynamic> participants =
                        chatRoomModel.participants!;

                    List<String> participantKeys = participants.keys.toList();
                    participantKeys.remove(widget.userModel.uid);

                    return FutureBuilder(
                      future:
                          FirebaseHelper.getUserModelById(participantKeys[0]),
                      builder: (context, userData) {
                        if (userData.connectionState == ConnectionState.done) {
                          if (userData.data != null) {
                            UserModel targetUser = userData.data as UserModel;

                            return ListTile(
                              hoverColor: Colors.deepPurple.withOpacity(0.2),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ChatRoomPage(
                                      chatroom: chatRoomModel,
                                      firebaseUser: widget.firebaseUser,
                                      userModel: widget.userModel,
                                      targetUser: targetUser,
                                    );
                                  }),
                                );
                              },
                              leading: SizedBox(
                                height: 57,
                                width: 57,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: CachedNetworkImage(
                                    imageUrl: targetUser.profilepic.toString(),
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Colors.deepPurple)),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                targetUser.fullname.toString(),
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
                              subtitle: (chatRoomModel.lastMessage.toString() !=
                                      "")
                                  ? Text(chatRoomModel.lastMessage.toString())
                                  : Text(
                                      "Say hi to your new friend!",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        shadows: [
                                          Shadow(
                                              offset: const Offset(1, 1),
                                              blurRadius: 5.0,
                                              color: Colors.black
                                                  .withOpacity(0.2)),
                                        ],
                                      ),
                                    ),
                              trailing: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                // color: Colors.deepPurple.withOpacity(0.3),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: Text("No Chats"),
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
    );
  }
}
// ------------------------------------------------------------

// import 'package:chatsapp/models/ChatRoomModel.dart';
// import 'package:chatsapp/models/FirebaseHelper.dart';
// import 'package:chatsapp/models/UserModel.dart';
// import 'package:chatsapp/pages/ChatRoomPage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class ChatsPage extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;
//   const ChatsPage(
//       {Key? key, required this.userModel, required this.firebaseUser})
//       : super(key: key);

//   @override
//   State<ChatsPage> createState() => _ChatsPageState();
// }

// class _ChatsPageState extends State<ChatsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection("chatrooms")
//               .where("participants.${widget.userModel.uid}", isEqualTo: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.active) {
//               if (snapshot.hasData) {
//                 QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

//                 return ListView.builder(
//                   itemCount: chatRoomSnapshot.docs.length,
//                   itemBuilder: (context, index) {
//                     ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
//                         chatRoomSnapshot.docs[index].data()
//                             as Map<String, dynamic>);

//                     Map<String, dynamic> participants =
//                         chatRoomModel.participants!;

//                     List<String> participantKeys = participants.keys.toList();
//                     participantKeys.remove(widget.userModel.uid);

//                     return FutureBuilder(
//                       future:
//                           FirebaseHelper.getUserModelById(participantKeys[0]),
//                       builder: (context, userData) {
//                         if (userData.connectionState == ConnectionState.done) {
//                           if (userData.data != null) {
//                             UserModel targetUser = userData.data as UserModel;

//                             return Padding(
//                               padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width - 30,
//                                 height: 70,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       blurRadius: 3,
//                                       color: Color(0x411D2429),
//                                       offset: Offset(0, 1),
//                                     )
//                                   ],
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(8, 8, 8, 8),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.max,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             0, 1, 1, 1),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           child: Image.network(
//                                             'https://images.unsplash.com/photo-1574914629385-46448b767aec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bGF0dGV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60', // targetUser.profilepic.toString(),
//                                             width: 55,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Padding(
//                                           padding: const EdgeInsetsDirectional
//                                               .fromSTEB(8, 8, 4, 0),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 targetUser.fullname.toString(),
//                                                 style: const TextStyle(
//                                                   fontFamily: 'Outfit',
//                                                   color: Color(0xFF090F13),
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsetsDirectional
//                                                           .fromSTEB(0, 4, 8, 0),
//                                                   child: (chatRoomModel
//                                                               .lastMessage
//                                                               .toString() !=
//                                                           "")
//                                                       ? Text(
//                                                           chatRoomModel
//                                                               .lastMessage
//                                                               .toString(),
//                                                           textAlign:
//                                                               TextAlign.start,
//                                                           style:
//                                                               const TextStyle(
//                                                             fontFamily:
//                                                                 'Outfit',
//                                                             color: Color(
//                                                                 0xFF7C8791),
//                                                             fontSize: 14,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                           ),
//                                                         )
//                                                       : const Text(
//                                                           "Say hi to your new friend!",
//                                                           textAlign:
//                                                               TextAlign.start,
//                                                           style: TextStyle(
//                                                             fontFamily:
//                                                                 'Outfit',
//                                                             color: Color(
//                                                                 0xFF7C8791),
//                                                             fontSize: 14,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                           ),
//                                                         ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: const [
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 4, 0, 0),
//                                             child: Icon(
//                                               Icons.chevron_right_rounded,
//                                               color: Color(0xFF57636C),
//                                               size: 24,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 0, 4, 8),
//                                             // child: Text(
//                                             //   '$11.00',
//                                             //   textAlign: TextAlign.end,
//                                             //   style: TextStyle(
//                                             //     fontFamily: 'Outfit',
//                                             //     color: Color(0xFF4B39EF),
//                                             //     fontSize: 14,
//                                             //     fontWeight: FontWeight.w500,
//                                             //   ),
//                                             // ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Container();
//                           }
//                         } else {
//                           return Container();
//                         }
//                       },
//                     );
//                   },
//                 );
//               } else if (snapshot.hasError) {
//                 return Center(
//                   child: Text(snapshot.error.toString()),
//                 );
//               } else {
//                 return const Center(
//                   child: Text("No Chats"),
//                 );
//               }
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// -----------------------------------------------------------------
