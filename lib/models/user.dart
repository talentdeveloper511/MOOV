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
  final String race;
  final List<dynamic> friendArray;
  final List<dynamic> friendRequests;
  final postLimit;
  final List<dynamic> friendGroups;
  final int verifiedStatus;
  final Timestamp timestamp;
  final String referral;
  final String venmoUsername;
  final Map pushSettings;
  final List<dynamic> followers;
  final bool isBusiness;
  final bool isSingle;
  final int nameChangeLimit;
  final GeoPoint businessLocation;
  final String businessType;
  final Map userType;

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
      this.race,
      this.friendArray,
      this.friendRequests,
      this.postLimit,
      this.timestamp,
      this.verifiedStatus,
      this.friendGroups,
      this.referral,
      this.venmoUsername,
      this.pushSettings,
      this.nameChangeLimit,
      this.isBusiness,
      this.isSingle,
      this.followers,
      this.businessLocation,
      this.businessType,
      this.userType});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: (doc.data() as Map<String, dynamic>)['id'],
        email: (doc.data() as Map<String, dynamic>)['email'],
        photoUrl: (doc.data() as Map<String, dynamic>)['photoUrl'],
        displayName: (doc.data() as Map<String, dynamic>)['displayName'],
        bio: (doc.data() as Map<String, dynamic>)['bio'],
        score: (doc.data() as Map<String, dynamic>)['score'],
        dorm: (doc.data() as Map<String, dynamic>)['dorm'],
        header: (doc.data() as Map<String, dynamic>)['header'],
        year: (doc.data() as Map<String, dynamic>)['year'],
        gender: (doc.data() as Map<String, dynamic>)['gender'],
        race: (doc.data() as Map<String, dynamic>)['race'],
        friendArray: (doc.data() as Map<String, dynamic>)['friendArray'],
        friendRequests: (doc.data() as Map<String, dynamic>)['friendRequests'],
        postLimit: (doc.data() as Map<String, dynamic>)['postLimit'],
        verifiedStatus: (doc.data() as Map<String, dynamic>)['verifiedStatus'],
        timestamp: (doc.data() as Map<String, dynamic>)['timestamp'],
        friendGroups: (doc.data() as Map<String, dynamic>)['friendGroups'],
        referral: (doc.data() as Map<String, dynamic>)['referral'],
        venmoUsername: (doc.data() as Map<String, dynamic>)['venmoUsername'],
        pushSettings: (doc.data() as Map<String, dynamic>)['pushSettings'],
        nameChangeLimit:
            (doc.data() as Map<String, dynamic>)['nameChangeLimit'],
        isBusiness: (doc.data() as Map<String, dynamic>)['isBusiness'],
        isSingle: (doc.data() as Map<String, dynamic>)['isSingle'],
        followers: (doc.data() as Map<String, dynamic>)['followers'],
        businessLocation:
            (doc.data() as Map<String, dynamic>)['businessLocation'],
        businessType: (doc.data() as Map<String, dynamic>)['businessType'],
        userType: (doc.data() as Map<String, dynamic>)['userType']);
  }
}
