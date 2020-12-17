// import 'package:flutter/material.dart';
// import 'package:MOOV/pages/HomePage.dart';
import 'dart:io';
import 'dart:math';

import 'package:MOOV/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Database {
  final dbRef = Firestore.instance;
  var postId;
  var postPic;
  var ownerId;
  dynamic startDate;
  var title;
  bool featured;

  final GoogleSignInAccount user = googleSignIn.currentUser;
  final strUserId = googleSignIn.currentUser.id;
  final strUserName = googleSignIn.currentUser.displayName;
  final strPic = googleSignIn.currentUser.photoUrl;

  getdata() {
    Firestore.instance.collection('food').snapshots().listen((snapshot) {
      for (var i = 0; i < snapshot.documents.length; i++) {
        DocumentSnapshot course = snapshot.documents[i];
        ownerId = course["userId"];
        postId = course.documentID;
      }
    });
  }
  // Map likes

  void createPost(
      {title,
      String uid,
      description,
      type,
      likeCounter,
      privacy,
      location,
      address,
      likes,
      DateTime startDate,
      DateTime endDate,
      imageUrl,
      userId,
      userName,
      userEmail,
      profilePic,
      featured}) async {
    DocumentReference ref = await dbRef.collection("food").add({
      'title': title,
      'likes': likes,
      'type': type,
      'likeCounter': likeCounter,
      'privacy': privacy,
      'description': description,
      'location': location,
      'address': address,
      'startDate': startDate,
      'endDate': endDate,
      'image': imageUrl,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'profilePic': profilePic,
      "featured": featured,
    });
    // final String postId = ref.documentID;
    print(ref.documentID);

    Firestore.instance
        .collection("food")
        .orderBy("startDate", descending: true);

    dbRef.runTransaction((transaction) async {
      final DocumentReference ref2 = dbRef.document('users/$uid');
      print('$uid');
      transaction.update(ref2, {'score': FieldValue.increment(20)});
    });
  }

  Future<void> addGoing(
      String ownerId,
      String previewImg,
      String uid,
      String moovId,
      String strName,
      strPic,
      startDate,
      title,
      description,
      location,
      address,
      ownerProPic,
      ownerName,
      ownerEmail,
      likedArray) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('food/$moovId');
      final DocumentReference ref2 = dbRef.document('users/$uid');
      print('$uid');
      transaction.update(ref2, {'score': FieldValue.increment(2)});

      addGoingToNotificationFeed(
          ownerId,
          previewImg,
          moovId,
          startDate,
          title,
          description,
          location,
          address,
          ownerProPic,
          ownerName,
          ownerEmail,
          likedArray);
      Map<String, dynamic> serializedMessage = {
        "uid": uid,
        "strName": strName,
        "strPic": strPic,
      };
      transaction.update(ref, {
        'liked': FieldValue.arrayUnion([serializedMessage]),
        'likeCounter': FieldValue.increment(1)
      });
    });
  }

  addGoingToNotificationFeed(
      String ownerId,
      String previewImg,
      dynamic moovId,
      startDate,
      String title,
      String description,
      String location,
      address,
      String ownerProPic,
      String ownerName,
      String ownerEmail,
      List<dynamic> likedArray) {
    bool isNotPostOwner = strUserId != ownerId;
    if (isNotPostOwner) {
      notificationFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(moovId)
          .setData({
        "type": "going",
        "username": currentUser.displayName,
        "userId": currentUser.id,
        "userEmail": currentUser.email,
        "userProfilePic": currentUser.photoUrl,
        "previewImg": previewImg,
        "postId": moovId,
        "timestamp": timestamp,
        "startDate": startDate,
        "title": title,
        "description": description,
        "location": location,
        "address": address,
        "ownerProPic": ownerProPic,
        "ownerName": ownerName,
        "ownerEmail": ownerEmail,
        "likedArray": likedArray
      });
    }
  }

  removeGoingFromNotificationFeed(
      String ownerId, String previewImg, String moovId) {
    bool isNotPostOwner = strUserId != ownerId;
    if (isNotPostOwner) {
      notificationFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(moovId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

    addFriendToNotificationFeed(
      String ownerId,
      String previewImg,
      dynamic moovId,
      startDate,
      String title,
      String description,
      String location,
      address,
      String ownerProPic,
      String ownerName,
      String ownerEmail,
      List<dynamic> likedArray) {
    
      notificationFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(moovId)
          .setData({
        "type": "friend",
        "username": currentUser.displayName,
        "userId": currentUser.id,
        "userEmail": currentUser.email,
        "userProfilePic": currentUser.photoUrl,
        "previewImg": previewImg,
        "postId": moovId,
        "timestamp": timestamp,
        "startDate": startDate,
        "title": title,
        "description": description,
        "location": location,
        "address": address,
        "ownerProPic": ownerProPic,
        "ownerName": ownerName,
        "ownerEmail": ownerEmail,
        "likedArray": likedArray
      });
    
  }

  removeFriendFromNotificationFeed(
      String ownerId, String previewImg, String moovId) {
    bool isNotPostOwner = strUserId != ownerId;
      notificationFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(moovId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    
  }

  Future<void> sendEventNotification(String senderId, String receiverId,
      String senderName, String senderPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('users/$receiverId');
      Map<String, dynamic> serializedMessage = {
        "uid": senderId,
        "strName": senderName,
        "strPic": senderPic,
        "requestStatus": "pending"
      };
      transaction.update(ref, {
        'request': FieldValue.arrayUnion([serializedMessage]),
      });
    });
  }

  Future<void> sendFriendRequest(String senderId, String receiverId,
      String senderName, String senderPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('users/$receiverId');
      Map<String, dynamic> serializedMessage = {
        senderId: 0,
      };
      transaction.update(ref, {
        'friendArray': FieldValue.arrayUnion([serializedMessage]),
      });
    });
  }

  Future<void> removeGoing(
      String ownerId,
      String previewImg,
      String uid,
      String moovId,
      String strName,
      strPic,
      startDate,
      title,
      description,
      location,
      address,
      ownerProPic,
      ownerName,
      ownerEmail,
      likedArray) async {
    return dbRef.runTransaction((transaction) async {
      removeGoingFromNotificationFeed(ownerId, previewImg, moovId);

      DocumentSnapshot snapshot;
      //   while (snapshot == null) {
      final DocumentReference userRef = dbRef.document('food/$moovId');
      final DocumentReference userRef2 = dbRef.document('users/$uid');
      Map<String, dynamic> serializedMessage = {
        "uid": uid,
        "strName": strName,
        "strPic": strPic,
      };
      transaction.update(userRef, {
        'liked': FieldValue.arrayRemove([serializedMessage]),
        'likeCounter': FieldValue.increment(-1)
      });
      transaction.update(userRef2, {'score': FieldValue.increment(-2)});
    });
  }

  // Future<void> acceptFriendRequest(
  //     String senderId, String receiverId, String strName, String strPic) async {
  //   final DocumentReference ref = dbRef.document('users/$senderId');
  //   Map<String, dynamic> serializedMessage = {
  //     "uid": receiverId,
  //     "strName": strName,
  //     "strPic": strPic,
  //     "requestStatus": "accept"
  //   };
  //   ref.setData({
  //     'request': FieldValue.arrayUnion([serializedMessage]),
  //   });
  // }

  // Future<void> rejectFriendRequest(
  //     String senderId, String receiverId, String strName, String strPic) async {
  //   return dbRef.runTransaction((transaction) async {
  //     final DocumentReference ref = dbRef.document('users/$receiverId');
  //     Map<String, dynamic> serializedMessage = {
  //       "uid": senderId,
  //       "strName": strName,
  //       "strPic": strPic,
  //       "requestStatus": "rejected"
  //     };
  //     transaction.update(ref, {
  //       'request': FieldValue.arrayUnion([serializedMessage]),
  //     });
  //   });
  // }

  Future<QuerySnapshot> checkStatus(String senderId, String receiverId) {
    return Firestore.instance
        .collection('users')
        .where('id', isEqualTo: receiverId)
        .getDocuments();
  }
}
