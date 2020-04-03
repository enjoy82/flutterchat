import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

// ---------
// メインページ
// ---------
class MainPage extends StatelessWidget {
  MainPage({Key key, this.auth, this.currentPageChatSelectSet, this.onSignOut}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback currentPageChatSelectSet;
  //取り除く予定
  final VoidCallback onSignOut;
  final String name = "enjoy";

  void _signout() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

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
            gotoLogInPageBtn(context)
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
  //取除く予定
  Widget gotoLogInPageBtn(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButtonBuilder(
              text: 'debug LogInPage',
              icon: Icons.email,
              onPressed: _signout,
              backgroundColor: Colors.blueGrey[700],
              width: 200.0,
            ),
          ]
      ),
    );
  }
}