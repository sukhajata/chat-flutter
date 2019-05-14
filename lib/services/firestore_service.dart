import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everyday_language/models/user.dart';

const COLLECTION_ROOMS = "rooms";
const COLLECTION_USERS = "users";
const SUBCOLLECTION_MESSAGES = "messages";

class FirestoreService {
  static FirestoreService _instance;
  factory FirestoreService() => _instance ??= new FirestoreService._();

  FirestoreService._();

  Future<DocumentSnapshot> getUserDetails(String uid) {
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .document(uid)
        .get();
  }

  void addUser(User user) async {
    checkUserExist(user.uid).then((value) {
      if (!value) {
        print("user ${user.name} ${user.email} added");
        Firestore.instance
            .document("users/${user.uid}")
            .setData(user.toJson());
      } else {
        print("user ${user.name} ${user.email} exists");
      }
    });
  }

  Future<bool> checkUserExist(String uid) async {
    bool exists = false;
    try {
      await Firestore.instance.document("$COLLECTION_USERS/$uid").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getMessages(String roomId) {
    return Firestore.instance.collection(COLLECTION_ROOMS).document(roomId).collection(SUBCOLLECTION_MESSAGES).snapshots();
  }

  Future<void> addMessage(String roomId, String senderId, String senderName, String text) {
    return Firestore.instance
      .collection(COLLECTION_ROOMS)
      .document(roomId)
      .collection(SUBCOLLECTION_MESSAGES)
      .add({
        "senderId": senderId,
        "senderName": senderName,
        "text": text,
      });
  }
  
}

