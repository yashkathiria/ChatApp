import 'dart:developer';
import 'package:chatsapp/datastore/data.dart';
import 'package:chatsapp/pages/ResetPasswordPage.dart';
import 'package:chatsapp/utils/color_utils.dart';
import 'package:chatsapp/utils/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatsapp/pages/HomePage.dart';
import 'package:chatsapp/models/UIHelper.dart';
import 'package:chatsapp/models/UserModel.dart';
import 'package:chatsapp/pages/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    DataStore.email = email;
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Logging In..");

    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      // Close the loading dialog
      Navigator.pop(context);

      // Show Alert Dialog
      UIHelper.showAlertDialog(
          context, "An error occured", ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      // Go to HomePage
      log("Log In Successful!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage(
              userModel: userModel, firebaseUser: credential!.user!);
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: [
                logoWidget("assets/images/logo1.png"),
                const SizedBox(
                  height: 30,
                ),
                //Email
                reusableTextField("Email Address", Icons.person_outline, false,
                    emailController),
                const SizedBox(
                  height: 20,
                ),
                //Password
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    passwordController),
                const SizedBox(
                  height: 5,
                ),
                //Forgot Password
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 35,
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.right,
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPassword())),
                  ),
                ),
                //Sign In Button
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                    onPressed: () {
                      checkValues();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return Colors.white;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                //Don't Have Account???
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?",
                        style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:chatsapp/pages/HomePage.dart';
// import 'package:chatsapp/models/UIHelper.dart';
// import 'package:chatsapp/models/UserModel.dart';
// import 'package:chatsapp/pages/SignUpPage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   void checkValues() {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();

//     if (email == "" || password == "") {
//       UIHelper.showAlertDialog(
//           context, "Incomplete Data", "Please fill all the fields");
//     } else {
//       logIn(email, password);
//     }
//   }

//   void logIn(String email, String password) async {
//     UserCredential? credential;

//     UIHelper.showLoadingDialog(context, "Logging In..");

//     try {
//       credential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//     } on FirebaseAuthException catch (ex) {
//       // Close the loading dialog
//       Navigator.pop(context);

//       // Show Alert Dialog
//       UIHelper.showAlertDialog(
//           context, "An error occured", ex.message.toString());
//     }

//     if (credential != null) {
//       String uid = credential.user!.uid;

//       DocumentSnapshot userData =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();
//       UserModel userModel =
//           UserModel.fromMap(userData.data() as Map<String, dynamic>);

//       // Go to HomePage
//       log("Log In Successful!");
//       Navigator.popUntil(context, (route) => route.isFirst);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) {
//           return HomePage(
//               userModel: userModel, firebaseUser: credential!.user!);
//         }),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 40,
//           ),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Text(
//                     "Chat App",
//                     style: TextStyle(
//                         color: Theme.of(context).colorScheme.secondary,
//                         fontSize: 45,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     controller: emailController,
//                     decoration:
//                         const InputDecoration(labelText: "Email Address"),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(labelText: "Password"),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   CupertinoButton(
//                     onPressed: () {
//                       checkValues();
//                     },
//                     color: Theme.of(context).colorScheme.secondary,
//                     child: const Text("Log In"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Don't have an account?",
//               style: TextStyle(fontSize: 16),
//             ),
//             CupertinoButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) {
//                     return SignUpPage();
//                   }),
//                 );
//               },
//               child: const Text(
//                 "Sign Up",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
