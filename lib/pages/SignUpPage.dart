import 'dart:developer';
import 'package:chatsapp/pages/HomePage.dart';
import 'package:chatsapp/pages/LoginPage.dart';
import 'package:chatsapp/utils/color_utils.dart';
import 'package:chatsapp/utils/reusable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatsapp/models/UIHelper.dart';
import 'package:chatsapp/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatsapp/pages/CompleteProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else if (password != cPassword) {
      UIHelper.showAlertDialog(context, "Password Mismatch",
          "The passwords you entered do not match!");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);

      UIHelper.showAlertDialog(
          context, "An error occured", ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        log("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return HomePage(
                userModel: newUser, firebaseUser: credential!.user!);
          }),
        );
        
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) {
        //     return CompleteProfile(
        //         userModel: newUser, firebaseUser: credential!.user!);
        //   }),
        // );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
                reusableTextField("Enter Email Address", Icons.email_outlined,
                    false, emailController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    passwordController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Confirm Password", Icons.lock_outlined, true,
                    cPasswordController),
                const SizedBox(
                  height: 20,
                ),
                //Sign Up Button
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
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                //Already Have an Account???
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",
                        style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        " Sign In",
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
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:chatsapp/models/UIHelper.dart';
// import 'package:chatsapp/models/UserModel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chatsapp/pages/CompleteProfile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController cPasswordController = TextEditingController();

//   void checkValues() {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//     String cPassword = cPasswordController.text.trim();

//     if (email == "" || password == "" || cPassword == "") {
//       UIHelper.showAlertDialog(
//           context, "Incomplete Data", "Please fill all the fields");
//     } else if (password != cPassword) {
//       UIHelper.showAlertDialog(context, "Password Mismatch",
//           "The passwords you entered do not match!");
//     } else {
//       signUp(email, password);
//     }
//   }

//   void signUp(String email, String password) async {
//     UserCredential? credential;

//     UIHelper.showLoadingDialog(context, "Creating new account..");

//     try {
//       credential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//     } on FirebaseAuthException catch (ex) {
//       Navigator.pop(context);

//       UIHelper.showAlertDialog(
//           context, "An error occured", ex.message.toString());
//     }

//     if (credential != null) {
//       String uid = credential.user!.uid;
//       UserModel newUser =
//           UserModel(uid: uid, email: email, fullname: "", profilepic: "");
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .set(newUser.toMap())
//           .then((value) {
//         log("New User Created!");
//         Navigator.popUntil(context, (route) => route.isFirst);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) {
//             return CompleteProfile(
//                 userModel: newUser, firebaseUser: credential!.user!);
//           }),
//         );
//       });
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
//                   const SizedBox(
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
//                     height: 10,
//                   ),
//                   TextField(
//                     controller: cPasswordController,
//                     obscureText: true,
//                     decoration:
//                         const InputDecoration(labelText: "Confirm Password"),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   CupertinoButton(
//                     onPressed: () {
//                       checkValues();
//                     },
//                     color: Theme.of(context).colorScheme.secondary,
//                     child: const Text("Sign Up"),
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
//               "Already have an account?",
//               style: TextStyle(fontSize: 16),
//             ),
//             CupertinoButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text(
//                 "Log In",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
