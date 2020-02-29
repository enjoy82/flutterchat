import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

// ---------
// メインページ
// ---------
class MainPage extends StatelessWidget {
  MainPage({Key key, this.auth, this.currentPageChatSelectSet}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback currentPageChatSelectSet;
  
  final String name = "enjoy";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(auth.uid + "のメインページ"),
      ),
      backgroundColor: Color.fromRGBO(100, 100, 100, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gotoChatSelectPageBtn(context),
          ]
        ),
      ),
    );
  }

  Widget gotoChatSelectPageBtn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButtonBuilder(
            text: 'go to ChatSelectPage',
            icon: Icons.email,
            onPressed: () {
              currentPageChatSelectSet();
            },
            backgroundColor: Colors.blueGrey[700],
            width: 200.0,
          ),
        ]
      ),
    );
  }
}