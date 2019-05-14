import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthService {
  static AuthService _instance;
  factory AuthService() => _instance ??= new AuthService._();

  AuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FacebookLogin _facebookLogin = new FacebookLogin();

  void registerAuthenticationStateChangedListener(authStateChanged) {
    _firebaseAuth.onAuthStateChanged.listen(authStateChanged);
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    return user.uid;
  }

  Future<String> signInWithFacebook() async {
    final FacebookLoginResult loginResult = 
      await _facebookLogin.logInWithReadPermissions(['email', 'user_birthday']);
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: loginResult.accessToken.token
    );

    FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);

    return user.uid;
  }

  /*  Future<String> signInGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user = await _auth.signInWithCredential(credential);
    print("Signed in " + user.displayName);
    return user.uid;
  }*/

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

}