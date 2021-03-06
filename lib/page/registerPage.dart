import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'auth.dart';
import 'websocket.dart';
import 'dart:convert';


class RegisterPage extends StatefulWidget{
  RegisterPage({Key key, this.auth, this.ws, this.currentPageMainSet});
  final BaseAuth auth;
  final WebSocket ws;
  final VoidCallback currentPageMainSet;
  @override
  State createState() => new _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> with TickerProviderStateMixin{
  final usernameController = new TextEditingController();


  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("username登録ページ"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            widget.currentPageMainSet();
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
              const SizedBox(height: 24.0),
              new TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: '新しいusername',
                ),
              ),
              const SizedBox(height: 24.0),
              new Center(
                child: new RaisedButton(
                  child: const Text('set username'),
                  onPressed: () {
                    var username = usernameController.text;
                    print(username);
                    widget.ws.channel.sink.add(json.encode({
                      "action": "setnewname",
                      "uid" : widget.auth.uid,
                      "newname": username
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