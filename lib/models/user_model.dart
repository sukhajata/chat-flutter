import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:everyday_language/models/user.dart';
import 'package:everyday_language/services/auth_service.dart';
import 'package:everyday_language/services/firestore_service.dart';

enum Status {
  Unauthenticated,
  Unregistered,
  Authenticated,
}

class UserModel extends Model {
  UserModel(){
    _authService = AuthService();
    _authService.registerAuthenticationStateChangedListener(_onAuthStateChanged);
    _firestoreService = FirestoreService();
  }
  AuthService _authService;
  FirestoreService _firestoreService;
  Status _status = Status.Unauthenticated;
  bool _isLoading = false;
  User _user;
  FirebaseUser _firebaseUser;

  User get user => _user;
  FirebaseUser get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;
  Status get status => _status;

  static UserModel of(BuildContext context) =>
    ScopedModel.of<UserModel>(context);

  Future<void> signIn() {
    return _authService.signInWithFacebook();
  }

  Future<void> signOut() {
    return _authService.signOut();
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _firebaseUser = null;
      _user = null;
      _status = Status.Unauthenticated;
    } else {
      if (firebaseUser.uid != _firebaseUser?.uid) {
        _firebaseUser = firebaseUser;
      }
      _status = Status.Unregistered;
      if (firebaseUser.uid != _user?.uid) {
        DocumentSnapshot doc = await _firestoreService.getUserDetails(_firebaseUser.uid);
        _user = User.fromDocument(doc);
      }
      if (_user != null) {
        _status = Status.Authenticated;
      }
    }
    _isLoading = false;

    notifyListeners();
    
  }

  void addUserDetails(Map<String, String> formData) async {
    _user = User.fromJson(formData);

    notifyListeners();
  }

}
