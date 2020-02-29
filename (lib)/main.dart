//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'dart:async';

void main() => runApp(MyApp());

const String _name = "Your Name";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: MainPage(),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new LogInPage(),
        '/LogInPage': (BuildContext context) => new LogInPage(),
        '/ChatPage' :(BuildContext context) => new ChatPage(),
        '/MainPage' :(BuildContext context) => new MainPage(),
        '/EmailLoginPage' :(BuildContext context) => new EmailLoginPage(),
        '/ChatSelectPage' :(BuildContext context) => new ChatSelectPage(),
        '/MakeEmailAccountPage'  :(BuildContext context) => new MakeEmailAccountPage(),
      },
    );
  }
}


// ---------
// ログインページ
// ---------
class LogInPage extends StatefulWidget{
  //LogInPage({Key key, this.title}) : super(key : key);
  //final String title;

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage>{
  FirebaseUser _user;

  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
        )
    );
    print("signed in " + user.displayName);
    return user;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("ログインページ"),
      ),
      backgroundColor: Color.fromRGBO(100, 100, 100, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            emailloginBtn(),
            googleAuthBtn(),
          ]
        ),
      ),
    );
  }

  Widget emailloginBtn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButtonBuilder(
            text: 'Get going with Email',
            icon: Icons.email,
            onPressed: () {
              Navigator.of(context).pushNamed("/EmailLoginPage");
            },
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
              onPressed: () {
                _handleGoogleSignIn().then((user) {
                  setState(() {
                    _user = user;
                  });
                  Navigator.of(context).pushReplacementNamed("/MainPage", arguments: _user);
                }).catchError((error) {
                  print(error);
                });
              },
            ),
          ]
        ),
      );
  }
}


// ---------
// emailでのログインページ
// ---------
class EmailLoginPage extends StatefulWidget{
  @override
  State createState() => new _EmailLoginPage();
}

class _EmailLoginPage extends State<EmailLoginPage> with TickerProviderStateMixin{
  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser _user;

  Future<FirebaseUser> _emailsignIn(String email, String password) async {
    if(email.length < 3 || password.length < 7){
      return null;
    }
    final FirebaseUser user = await auth.signInWithEmailAndPassword(email: email, password: password);
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);
    print('signInEmail succeeded: $user');
    return user;
  }
  
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
                    _emailsignIn(email, password).then((user) {
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

// ---------
// emailでのアカウント作製ページ
// ---------
class MakeEmailAccountPage extends StatefulWidget{
  @override
  State createState() => new _MakeEmailAccountPage();
}

class _MakeEmailAccountPage extends State<MakeEmailAccountPage> with TickerProviderStateMixin{
  /*var email = "";
  var password = "";
  var username = "";*/
  final usernameInputController = new TextEditingController();
  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser _user;

  Future<FirebaseUser> _buildaccount(email, password) async {
    if(email.length < 3 || password.length < 7){
      return null;
    }
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

// ---------
// メインページ
// ---------
class MainPage extends StatelessWidget {
  MainPage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  
  final String name = 'enjoy';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(name + "のメインページ"),
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
              Navigator.of(context).pushNamed("/ChatSelectPage", arguments: user);
            },
            backgroundColor: Colors.blueGrey[700],
            width: 200.0,
          ),
        ]
      ),
    );
  }
}


// ---------
// チャットセレクトページ
// ---------
class ChatSelectPage extends StatefulWidget {
  //ChatSelectPage({Key key, this.user}) : super(key: key);
  //final FirebaseUser user;

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
              Navigator.of(context).pushNamed("/ChatPage");
            },
            backgroundColor: Colors.blueGrey[700],
            width: 200.0,
          ),
        ]
      ),
    );
  }
}

// ---------
// チャットページ
// ---------
class ChatPage extends StatefulWidget {
  //ChatPage({Key key, this.title}) : super(key: key);
  //final FirebaseUser _user = ModalRoute.of(context).settings.arguments;

  @override
  State createState() => new _ChatPage();
}


//TickerProviderStateMixinはvsync用
class _ChatPage extends State<ChatPage> with TickerProviderStateMixin{
  final List<ChatMessage> _messages = <ChatMessage>[];
  //メッセージリスト定義
  final TextEditingController _textController = new TextEditingController();
  //Widgetで使うために定義、TextEditingControllerは既存
  //bool _isComposing = false;

  void _handleSubmitted(String text) {
    //Widgetで埋め込むための関数ここでChatMessageテキストとコントローラ渡してつくってる
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ), 
    );
    if(message.text.length > 0){
      setState(() {
        _messages.insert(0, message);
        //計算量どうなの？メッセージの配列0にインソート
      }); 
    }
    message.animationController.forward();
  }

  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }    

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("チャットページ"),
      ),
      body: new Column(
      children: <Widget>[
        new Flexible(
          //message
          child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true, 
            itemBuilder: (_, int index) => _messages[index],
            //配列作製 謎挙動
            itemCount: _messages.length,
            //配列の個数指定 
          ),
        ), 
        new Divider(height: 1.0),
        new Container(
          //送信用テキストボックス
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],
    )
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        //横にUI並べる
        children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                hintText: "Send a message"),
            ),
          ),
          //箱入れて入れ子
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text)
            ),
          ),
        ],
      ),
    );
  }
}

//チャットのUI
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  //定義
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
    sizeFactor: new CurvedAnimation(
        parent: animationController, curve: Curves.easeOut),
        //???
    axisAlignment: 0.0,
    child: new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Expanded(
              //メッセージ多いときに折り返してくれるUI
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}