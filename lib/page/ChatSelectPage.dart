import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'auth.dart';

// ---------
// チャットセレクトページ
// ---------
class ChatSelectPage extends StatefulWidget {
  ChatSelectPage({Key key, this.auth, this.currentPageChatSet,this.currentPageFriendregisterSet, this.currentPageMainSet}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback currentPageChatSet;
  final VoidCallback currentPageFriendregisterSet;
  final VoidCallback currentPageMainSet;
  @override
  State createState() => new _ChatSelectPage();
}

class _ChatSelectPage extends State<ChatSelectPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("チャットセレクトページ"),

      ),
      backgroundColor: Color.fromRGBO(100, 100, 100, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gotoChatPageBtn(),
            gotoFriendregisterPageBtn(),
            gotoMainBtn(),
          ]
        ),
      ),
    );
  }

  Widget gotoChatPageBtn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButtonBuilder(
            text: 'go to ChatPage',
            icon: Icons.email,
            onPressed: () {
              widget.currentPageChatSet();
            },
            backgroundColor: Colors.blueGrey[700],
            width: 200.0,
          ),
        ]
      ),
    );
  }
  Widget gotoFriendregisterPageBtn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButtonBuilder(
            text: 'go to Friendregister',
            icon: Icons.email,
            onPressed: () {
              widget.currentPageFriendregisterSet();
            },
            backgroundColor: Colors.blueGrey[700],
            width: 200.0,
          ),
        ]
      ),
    );
  }
  Widget gotoMainBtn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButtonBuilder(
            text: 'go to MainPage',
            icon: Icons.email,
            onPressed: () {
              widget.currentPageMainSet();
            },
            backgroundColor: Colors.blueGrey[700],
            width: 200.0,
          ),
        ]
      ),
    );
  }
}
