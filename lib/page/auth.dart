import 'dart:async';
// Firebase ↓ (01) 必要なpackageをimport
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:src/table/users.dart';

class BaseAuth  {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final BaseUsers _users = new Users();
  String uid;

  Future<String> emailSignIn(String email, String password) async {
    if(email.length < 3 || password.length < 7){
      return null;
    }
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print('signInEmail succeeded: $user');

    //await _users.update(user.uid);
    uid = user.uid;
    return uid;
  }

  Future<String> handleGooglesignin() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
        )
    );
    //print("signed in " + user.displayName);
    //await _users.update(user.uid);
    uid = user.uid;
    return uid;
  }

  Future<String> emailcreateUser(String email, String password) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    assert (user != null);
    assert (await user.getIdToken() != null);
    //await _users.create(user.uid);
    uid = user.uid;
    return uid;
  }
  

  Future<String> currentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if(user == null){
      return null;
    }else{
      uid = user.uid;
      return uid;
    }
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

}