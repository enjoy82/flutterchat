import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'auth.dart';
import 'websocket.dart';
import 'dart:convert';


class FriendregisterPage extends StatefulWidget{
  FriendregisterPage({Key key, this.auth, this.ws, this.currentPageChatSelectSet});
  final BaseAuth auth;
  final WebSocket ws;
  final VoidCallback currentPageChatSelectSet;
  @override
  State createState() => new _FriendregisterPage();
}

class _FriendregisterPage extends State<FriendregisterPage> with TickerProviderStateMixin{
  final userIDController = new TextEditingController();


  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("friend登録ページ"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            widget.currentPageChatSelectSet();
          },
        )
      ),
      body: new Center(
      child: new Form(
        child: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new StreamBuilder(
                stream: widget.ws.channel.stream,
                builder: (context, snapshot) {
                  print(snapshot);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                  );
                },
              ),
              const SizedBox(height: 24.0),
              new TextFormField(
                controller: userIDController,
                decoration: const InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: '`友人のID',
                ),
              ),
              const SizedBox(height: 24.0),
              new Center(
                child: new RaisedButton(
                  child: const Text('set friendsID'),
                  onPressed: () {
                    var userID = userIDController.text;
                    print(userID);
                    widget.ws.channel.sink.add(json.encode({
                      "action": "registerfrinend",
                      "uid" : widget.auth.uid,
                      "friendID": userID
                    }));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}