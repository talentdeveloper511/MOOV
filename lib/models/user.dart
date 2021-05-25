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
  final Map mobileOrderMenu;

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
      this.userType,
      this.mobileOrderMenu});

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
        race: doc.data()['race'],
        friendArray: doc.data()['friendArray'],
        friendRequests: doc.data()['friendRequests'],
        postLimit: doc.data()['postLimit'],
        verifiedStatus: doc.data()['verifiedStatus'],
        timestamp: doc.data()['timestamp'],
        friendGroups: doc.data()['friendGroups'],
        referral: doc.data()['referral'],
        venmoUsername: doc.data()['venmoUsername'],
        pushSettings: doc.data()['pushSettings'],
        nameChangeLimit: doc.data()['nameChangeLimit'],
        isBusiness: doc.data()['isBusiness'],
        isSingle: doc.data()['isSingle'],
        followers: doc.data()['followers'],
        businessLocation: doc.data()['businessLocation'],
        businessType: doc.data()['businessType'],
        userType: doc.data()['userType'],
        mobileOrderMenu: doc.data()['mobileOrderMenu'] == null ? null : doc.data()['mobileOrderMenu']);
  }
}
