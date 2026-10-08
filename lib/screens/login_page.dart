import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoggedIn = false;
  // late GoogleSignInAccount _userObj;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Login Page'),
      ),
    );
    // return Scaffold(
    //   body: Container(
    //     child: _isLoggedIn
    //         ? Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Image.network(_userObj.photoUrl!),
    //           const SizedBox(height: 20,),
    //           Text(_userObj.displayName!),
    //           const SizedBox(height: 20,),
    //           Text(_userObj.email),
    //           const SizedBox(height: 20,),
    //           MaterialButton(
    //             onPressed: () {
    //               _googleSignIn.signOut().then((value) {
    //                 setState(() {
    //                   _isLoggedIn = false;
    //                 });
    //               }).catchError((e) {});
    //             },
    //             height: 50,
    //             minWidth: 100,
    //             color: Colors.red,
    //             child: const Text('Logout',style: TextStyle(color: Colors.white),),
    //           )
    //         ],
    //       ),
    //     ) : Center(
    //         child: MaterialButton(
    //           onPressed: () {
    //             _googleSignIn.signIn().then((userData) {
    //               setState(() {
    //                 _isLoggedIn = true;
    //                 _userObj = userData!;
    //               });
    //             }).catchError((e) {
    //               print(e);
    //             });
    //           },
    //           height: 50,
    //           minWidth: 100,
    //           color: Colors.red,
    //           child: const Text('Google Signin',style: TextStyle(color: Colors.white),),
    //         )
    //     ),
    //   ),
    // );
  }
}
