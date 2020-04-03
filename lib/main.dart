import 'package:flutter/material.dart';
//Page
import 'page/MainPage.dart';
import 'page/LogInPage.dart';
//import 'page/MakeEmailAccountPage.dart';
//import 'page/EmailLoginPage.dart';
import 'page/ChatSelectPage.dart';
import 'page/ChatPage.dart';
import 'page/auth.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Login',
      home: new RootPage(auth: new BaseAuth())
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

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
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  CurrentPage currentPage = CurrentPage.LogInPage;

  initState() {
    super.initState();

    // Firebase 認証 ↓ (02) カレントユーザ情報取得
    widget.auth.currentUser().then((uid) {
      setState(() {
        authStatus = uid != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
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
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        switch (currentPage) {
          case CurrentPage.ChatSelectPage:
            print('チャットセレクトページ');
            return new ChatSelectPage(
              auth: widget.auth,
              //ページ遷移考える
              currentPageChatSet: () => _updateCurrentPage(CurrentPage.ChatPage),
              currentPageMainSet: () => _updateCurrentPage(CurrentPage.MainPage)
            );
          case  CurrentPage.ChatPage:
            print('チャットページ');
            // チャットページ
            return new ChatPage(
              auth: widget.auth,
              //currentPageClaimSet: () => _updateCurrentPage(CurrentPage.ChatPage)
              currentPageChatSelectSet: () => _updateCurrentPage(CurrentPage.ChatSelectPage)
            );
          default:
            print('メインページ');
            // 請求画面
            return new MainPage(
              auth: widget.auth,
              currentPageChatSelectSet: () => _updateCurrentPage(CurrentPage.ChatSelectPage),
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