import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

// ---------
// emailでのアカウント作製ページ
// ---------
class MakeEmailAccountPage extends StatefulWidget{
  MakeEmailAccountPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  @override
  State createState() => new _MakeEmailAccountPage();
}

class _MakeEmailAccountPage extends State<MakeEmailAccountPage> with TickerProviderStateMixin{
  final usernameInputController = new TextEditingController();
  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser _user;

  Future<FirebaseUser> _buildaccount(email, password) async {
    final FirebaseUser user = await auth.createUserWithEmailAndPassword(email: email, password: password);
    assert (user != null);
    assert (await user.getIdToken() != null);
    return user;
  }
  
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("emailアカウント作製ページ"),
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
                  child: const Text('build account'),
                  onPressed: () {
                    var email = emailInputController.text;
                    var password = passwordInputController.text;
                    //アカウント作製処理
                    _buildaccount(email, password).then((user) {
                      setState(() {
                        _user = user;
                      });
                      if(_user != null)
                        Navigator.of(context).pushReplacementNamed("/MainPage", arguments: _user);
                      }).catchError((error) {
                        print(error);
                    });
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
