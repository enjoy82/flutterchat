import 'package:flutter/material.dart';
//import 'package:web_socket_channel/io.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';

//Page
import 'page/MainPage.dart';
import 'page/LogInPage.dart';
//import 'page/MakeEmailAccountPage.dart';
//import 'page/EmailLoginPage.dart';
import 'page/ChatSelectPage.dart';
import 'page/ChatPage.dart';
import 'page/registerPage.dart';
import 'page/FriendregisterPage.dart';

//setup
import 'page/auth.dart';
import 'page/websocket.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Login',
      home: new RootPage(
      )
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

enum CurrentPage {
  ChatPage,
  ChatSelectPage,
  //EmailLoginPage,
  //MakeEmailAccountPage,
  LogInPage,
  MainPage,
  RegisterPage,
  FriendregisterPage,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  CurrentPage currentPage = CurrentPage.LogInPage;
  BaseAuth auth;
  WebSocket ws;

  initState() {
    super.initState(); 
    auth = new BaseAuth();
    // Firebase 認証 ↓ (02) カレントユーザ情報取得
    auth.currentUser().then((uid) {
      setState(() {
        if(auth.uid != null){
          print('uid setted');
          authStatus = AuthStatus.signedIn;
        }else{
          print('uid dont setted');
        }
      });
    });
  }
  // 認証状態更新 ↓ (03)Stateを更新する処理
  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  // カレントページを更新 ↓ (03)Stateを更新する処理
  void _updateCurrentPage(CurrentPage page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 画面制御処理
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        print('サインインするアカウント選択');
        // サインインページ
        return new LogInPage(
          //title: 'Flutter Firebase SignIn',
          auth: auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        if(ws == null){
          ws = new WebSocket();
          ws.setuid(auth.uid);
        }
        switch (currentPage) {
          case CurrentPage.ChatSelectPage:
            print('チャットセレクトページ');
            return new ChatSelectPage(
              auth: auth,
              //ページ遷移考える
              currentPageChatSet: () => _updateCurrentPage(CurrentPage.ChatPage),
              currentPageFriendregisterSet: () => _updateCurrentPage(CurrentPage.FriendregisterPage),
              currentPageMainSet: () => _updateCurrentPage(CurrentPage.MainPage)
            );
          case  CurrentPage.ChatPage:
            print('チャットページ');
            // チャットページ
            return new ChatPage(
              auth: auth,
              ws: ws,
              currentPageChatSelectSet: () => _updateCurrentPage(CurrentPage.ChatSelectPage)
            );
          case CurrentPage.RegisterPage:
            print('レジスターページ');
            return new RegisterPage(
              auth: auth,
              ws: ws,
              currentPageMainSet: () => _updateCurrentPage(CurrentPage.MainPage)
            );
          case CurrentPage.FriendregisterPage:
            print('Friendregister');
            return new FriendregisterPage(
              auth: auth,
              ws: ws,
              currentPageChatSelectSet: () => _updateCurrentPage(CurrentPage.ChatSelectPage)
            );
          default:
            print('メインページ');
            return new MainPage(
              auth: auth,
              currentPageChatSelectSet: () => _updateCurrentPage(CurrentPage.ChatSelectPage),
              currentPageRegisterSet: () => _updateCurrentPage(CurrentPage.RegisterPage),
              //取り除く予定
              onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
            );
        }
      /*case AuthStatus.signedUp:
        print('Emailサインアップ');
        // 新規登録ページ
        return new MakeEmailAccountPage(
          //title: 'Flutter Firebase SignUp',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn)
        );*/
    }
  }
}