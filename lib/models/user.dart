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
  final String gender;
  final List<dynamic> friendArray;
  final postLimit;

  User(
      {this.id,
      this.email,
      this.photoUrl,
      this.displayName,
      this.bio,
      this.score,
      this.year,
      this.dorm,
      this.gender,
      this.friendArray,
      this.postLimit});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        bio: doc['bio'],
        score: doc['score'],
        dorm: doc['dorm'],
        year: doc['year'],
        gender: doc['gender'],
        friendArray: doc['friendArray'],
        postLimit: doc['postLimit']);
  }
}
