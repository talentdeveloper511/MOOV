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
  final String venmo;

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
      this.venmo});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        bio: doc['bio'],
        score: doc['score'],
        dorm: doc['dorm'],
        header: doc['header'],
        year: doc['year'],
        gender: doc['gender'],
        friendArray: doc['friendArray'],
        friendRequests: doc['friendRequests'],
        postLimit: doc['postLimit'],
        venmo: doc['venmo']);
  }
}
