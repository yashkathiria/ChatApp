import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> docIDs = [];

  Future getDocID() async {
    docIDs.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('fullname')
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                future: getDocID(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: GetUserName(
                              uid: docIDs[index],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetUserName extends StatelessWidget {
  final String uid;

  GetUserName({required this.uid});

  @override
  Widget build(BuildContext context) {
    //getting the collection
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(uid).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: SizedBox(
                  height: 57,
                  width: 57,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: CachedNetworkImage(
                      imageUrl: '${data['profilepic']}',
                      progressIndicatorBuilder: (context, url,
                              downloadProgress) =>
                          CircularProgressIndicator(
                              value: downloadProgress.progress,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.deepPurple)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data['fullname']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${data['email']}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          );
        }
        return const Text('Loading...');
      }),
    );
  }
}


//----------------------------------------------------------------

// class Contacts extends StatefulWidget {
//   const Contacts({Key? key}) : super(key: key);

//   @override
//   State<Contacts> createState() => _ContactsState();
// }

// class _ContactsState extends State<Contacts> {
//   final user = FirebaseAuth.instance.currentUser;
//   List<String> docIDs = [];

//   Future getDocID() async {
//     docIDs.clear();
//     await FirebaseFirestore.instance
//         .collection('user')
//         .orderBy('first name')
//         .get()
//         .then(
//           (snapshot) => snapshot.docs.forEach(
//             (document) {
//               print(document.reference);
//               docIDs.add(document.reference.id);
//             },
//           ),
//         );
//   }

//   // @override

//   // void initState() {
//   //   getDocID();
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search...",
//                   hintStyle: TextStyle(color: Colors.grey.shade600),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Colors.grey.shade600,
//                     size: 20,
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade200,
//                   contentPadding: const EdgeInsets.all(8),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     borderSide: BorderSide(
//                       color: Colors.deepPurple.withOpacity(0.1),
//                       width: 1,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     borderSide: BorderSide(
//                       color: Colors.deepPurple.withOpacity(0.3),
//                       width: 2,
//                     ),
//                   ),
//                 ),
//                 cursorColor: Colors.deepPurple,
//               ),
//             ),
//             Expanded(
//               child: FutureBuilder(
//                 future: getDocID(),
//                 builder: (context, snapshot) {
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: docIDs.length,
//                     itemBuilder: (context, index) {
//                       return Column(
//                         children: [
//                           ListTile(
//                             title: GetUserName(
//                               documentId: docIDs[index],
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GetUserName extends StatelessWidget {
//   final String documentId;

//   GetUserName({required this.documentId});

//   @override
//   Widget build(BuildContext context) {
//     //getting the collection
//     CollectionReference user = FirebaseFirestore.instance.collection('user');
//     return FutureBuilder<DocumentSnapshot>(
//       future: user.doc(documentId).get(),
//       builder: ((context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;

//           return Row(
//             children: [
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
//                 child: CircleAvatar(
//                   // backgroundImage: NetworkImage(widget.imageUrl),
//                   maxRadius: 30,
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${data['first name']}' ' ' '${data['last name']}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('${data['mobile no']}'),
//                 ],
//               ),
//             ],
//           );
//         }
//         return Text('Loading...');
//       }),
//     );
//   }
// }
