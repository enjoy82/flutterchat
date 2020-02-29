import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';


// ---------
// emailでのログインページ
// ---------
class EmailLoginPage extends StatefulWidget{
  EmailLoginPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  @override
  State createState() => new _EmailLoginPage();
}

class _EmailLoginPage extends State<EmailLoginPage> with TickerProviderStateMixin{
  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  //FirebaseUser _user;

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("emailログインページ"),
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
                controller: emailInputController,
                decoration: const InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 24.0),
              new TextFormField(
                controller: passwordInputController,
                decoration: new InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              new Center(
                child: new RaisedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    var email = emailInputController.text;
                    var password = passwordInputController.text;
                    //ログイン処理
                    /*widget.auth.EmailsignIn(email, password).then((userId) {
                      setState(() {
                        _user = userId;
                      });
                      if(_user != null)
                        Navigator.of(context).pushReplacementNamed("/MainPage", arguments: _user);
                      }).catchError((error) {
                        print(error);
                    });*/
                  },
                ),
              ),
              new Center(
                child: new RaisedButton(
                  child: const Text('アカウントお持ちでない方'),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/MakeEmailAccountPage");
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