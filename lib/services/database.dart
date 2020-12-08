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
      description,
      type,
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
  }

  void getData() {
    dbRef.collection("books").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  Future<List<String>> getFavorites(String uid) async {
    DocumentSnapshot querySnapshot =
        await Firestore.instance.collection('food').document(uid).get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('favorites') &&
        querySnapshot.data['favorites'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['favorites']);
    }
    return [];
  }

  void updateData() {
    try {
      dbRef
          .collection('books')
          .document('1')
          .updateData({'description': 'Head First Flutter'});
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteData() {
    try {
      dbRef.collection('books').document('1').delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addGoing(
      String ownerId, String uid, String moovId, String strName, strPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('food/$moovId');

      addGoingToNotificationFeed(ownerId, moovId);
      Map<String, dynamic> serializedMessage = {
        "uid": uid,
        "strName": strName,
        "strPic": strPic,
      };
      transaction.update(ref, {
        'liked': FieldValue.arrayUnion([serializedMessage]),
      });
    });
  }

  addGoingToNotificationFeed(String ownerId, String moovId) {
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
        "userProfilePic": currentUser.photoUrl,
        "postId": moovId,
        "timestamp": timestamp
      });
    }
  }

  removeGoingFromNotificationFeed(String ownerId, String moovId) {
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

  /*Future<void> sendFriendRequest(String senderId, String receiverId, String senderName, String senderPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('users/$receiverId');
      Map<String, dynamic> serializedMessage = {
        "uid" : senderId,
        "strName" : senderName,
        "strPic" : senderPic,
        "requestStatus" : "pending"
      };
      transaction.update(ref, {
        'request': FieldValue.arrayUnion([serializedMessage]),
      });
    });
  }*/
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

  void addFriends({uid, strName, strPic, requestStatus}) async {
    DocumentReference ref = await dbRef.collection("users").add({
      'uid': uid,
      'strName': strName,
      'strPic': strPic,
      'requestStatus': requestStatus,
    });
    // final String postId = ref.documentID;
    print(ref.documentID);

    Firestore.instance
        .collection("food")
        .orderBy("startDate", descending: true);
  }

  // Future<void> addLike(
  //     String uid, String moovId, String strName, strPic) async {

  //   return dbRef.runTransaction((transaction) async {
  //     final int index = Random().nextInt(10);
  //     //  final DocumentReference ref = dbRef.document('food/$moovId/likes/shred-$index');
  //     final DocumentReference ref = dbRef.document('food/$moovId');
  //     final DocumentSnapshot snapshot = await transaction.get(ref);
  //     transaction.update(ref, {
  //       'liked': FieldValue.arrayUnion([uid, strName, strPic]),
  //     });

  //     /*if (!snapshot.exists) {
  //       transaction.set(ref, {'likeCounter': 1});
  //     } else {
  //       transaction.update(ref, {'likeCounter': FieldValue.increment(1)});
  //     }*/

  //     /*final DocumentReference userRef = dbRef.document('users/$uid');
  //     transaction.update(userRef, {
  //       'liked': FieldValue.arrayUnion([moovId])
  //     });*/
  //   });
  // }

  Future<void> removeGoing(
      String ownerId, String uid, String moovId, String strName, strPic) async {
    return dbRef.runTransaction((transaction) async {
      removeGoingFromNotificationFeed(ownerId, moovId);

      DocumentSnapshot snapshot;
      //   while (snapshot == null) {
      final DocumentReference userRef = dbRef.document('food/$moovId');
      Map<String, dynamic> serializedMessage = {
        "uid": uid,
        "strName": strName,
        "strPic": strPic,
      };
      transaction.update(userRef, {
        'liked': FieldValue.arrayRemove([serializedMessage])
      });
      /*final DocumentReference ref = dbRef.document('food/$moovId/likes/shred-$index');
        snapshot = await transaction.get(ref);

        if (!snapshot.exists) {
          index = random.nextInt(10);
          snapshot = null;
        }*/
      //   }

      //    transaction.update(snapshot.reference, {'counter': FieldValue.increment(-1)});
      /* final DocumentReference userRef = dbRef.document('users/$uid');
      transaction.update(userRef, {
        'liked': FieldValue.arrayRemove([moovId])
      });*/
    });
  }

  // Stream<int> likesForMoov(String moovId) {
  //   return dbRef.collection('food/$moovId/likes').snapshots().map((snapshot) =>
  //       snapshot.documents.fold(0, (sum, item) => sum + item['counter']));
  // }

  Future<void> acceptFriendRequest(
      String senderId, String receiverId, String strName, String strPic) async {
    final DocumentReference ref = dbRef.document('users/$senderId');
    Map<String, dynamic> serializedMessage = {
      "uid": receiverId,
      "strName": strName,
      "strPic": strPic,
      "requestStatus": "accept"
    };
    ref.setData({
      'request': FieldValue.arrayUnion([serializedMessage]),
    });
    /*DocumentReference washingtonRef = db.collection("cities").document("DC");

// Atomically add a new region to the "regions" array field.
washingtonRef.update("regions", FieldValue.arrayUnion("greater_virginia"));

// Atomically remove a region from the "regions" array field.
washingtonRef.update("regions", FieldValue.arrayRemove("east_coast"));*/
    /*return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('users/$senderId');
      Map<String, dynamic> serializedMessage = {
        "uid" : receiverId,
        "strName" : strName,
        "strPic" : strPic,
        "requestStatus" : "accepted"
      };
      transaction.updateData(ref, {
        'request': FieldValue.arrayUnion([serializedMessage]),
      });
    });*/
  }

  Future<void> rejectFriendRequest(
      String senderId, String receiverId, String strName, String strPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('users/$receiverId');
      Map<String, dynamic> serializedMessage = {
        "uid": senderId,
        "strName": strName,
        "strPic": strPic,
        "requestStatus": "rejected"
      };
      transaction.update(ref, {
        'request': FieldValue.arrayUnion([serializedMessage]),
      });
    });
  }
}
