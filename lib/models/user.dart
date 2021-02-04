import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String year;
  final int score;
  final String dorm;
  final String header;
  final String gender;
  final List<dynamic> friendArray;
  final List<dynamic> friendRequests;
  final postLimit;
  final List<dynamic> friendGroups;
  final String venmo;
  final bool isAmbassador;
  final Timestamp timestamp;
  final String referral;
  final String venmoUsername;

  User(
      {this.id,
      this.email,
      this.photoUrl,
      this.displayName,
      this.bio,
      this.score,
      this.year,
      this.dorm,
      this.header,
      this.gender,
      this.friendArray,
      this.friendRequests,
      this.postLimit,
      this.venmo,
      this.timestamp,
      this.isAmbassador,
      this.friendGroups,
      this.referral,
      this.venmoUsername});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc.data()['id'],
        email: doc.data()['email'],
        photoUrl: doc.data()['photoUrl'],
        displayName: doc.data()['displayName'],
        bio: doc.data()['bio'],
        score: doc.data()['score'],
        dorm: doc.data()['dorm'],
        header: doc.data()['header'],
        year: doc.data()['year'],
        gender: doc.data()['gender'],
        friendArray: doc.data()['friendArray'],
        friendRequests: doc.data()['friendRequests'],
        postLimit: doc.data()['postLimit'],
        venmo: doc.data()['venmo'],
        isAmbassador: doc.data()['isAmbassador'],
        timestamp: doc.data()['timestamp'],
        friendGroups: doc.data()['friendGroups'],
        referral: doc.data()['referral'],
        venmoUsername: doc.data()['venmoUsername']);
  }
}
