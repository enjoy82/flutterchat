import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'auth.dart';
import 'dart:async';

// ---------
// ログインページ
// ---------
class LogInPage extends StatelessWidget{
  LogInPage({Key key, this.auth, this.onSignIn}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignIn;


  Widget build(BuildContext context){

    void _signIn() async {
      try {
        await auth.handleGooglesignin();
        onSignIn(); // ← (02) state更新処理を走らせ、画面遷移させる
      } catch (e) {
        print(e);
      }
  }

    return Scaffold(
      appBar: AppBar(
        title: Text("ログインページ"),
      ),
      backgroundColor: Color.fromRGBO(100, 100, 100, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //emailloginBtn(),
            //googleAuthBtn(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SignInButton(
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: _signIn,
                  ),
                ]
              ),
            )


          ]
        ),
      ),
    );
  }

  /*Widget emailloginBtn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButtonBuilder(
            text: 'Get going with Email',
            icon: Icons.email,
            //onPressed: 
            backgroundColor: Colors.blueGrey[700],
            width: 200.0,
          ),
        ]
      ),
    );
  }
  Widget googleAuthBtn() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: _signIn,
            ),
          ]
        ),
      );
  }*/
}
