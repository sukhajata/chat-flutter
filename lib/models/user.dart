import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String profilePictureURL;
  final String age;
  final String country;
  final String firstLanguage;
  final String interestsEnglish;
  final String interestsThai;
  final String province;

  User({
    this.uid,
    this.name,
    this.email,
    this.profilePictureURL,
    this.age,
    this.country,
    this.firstLanguage,
    this.interestsEnglish,
    this.interestsThai,
    this.province
  });

  Map<String, Object> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email == null ? '' : email,
      'profilePictureURL': profilePictureURL,
      'age': age,
      'country': country == null ? '' : country,
      'firstLanguage': firstLanguage,
      'interestsEnglish': interestsEnglish == null ? '' : interestsEnglish,
      'interestsThai': interestsThai == null ? '' : interestsThai,
      'province': province == null ? '' : province
    };
  }

  factory User.fromJson(Map<String, Object> doc) {
    User user = new User(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      profilePictureURL: doc['profilePictureURL'],
      age: doc['age'],
      country: doc['country'],
      firstLanguage: doc['firstLanguage'],
      interestsEnglish: doc['interestsEnglish'],
      interestsThai: doc['interestsThai'],
      province: doc['province']
    );
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
