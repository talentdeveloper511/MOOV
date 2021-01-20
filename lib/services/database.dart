import 'dart:async';

import 'package:MOOV/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class Database {
  final dbRef = FirebaseFirestore.instance;
  var postPic;
  String ownerId;
  dynamic startDate;
  var title;
  bool featured;
  String postId;
  String previewImg;

  final GoogleSignInAccount user = googleSignIn.currentUser;
  final strUserId = googleSignIn.currentUser.id;
  final strUserName = googleSignIn.currentUser.displayName;
  final strPic = googleSignIn.currentUser.photoUrl;

  FutureOr inviteesNotification(postId, previewImg, title, invitees) {
    if (invitees.length > 0) {
      for (int i = 0; i < invitees.length; i++) {
        notificationFeedRef
            .doc(invitees[i])
            .collection('feedItems')
            .doc(postId + 'eventinvite')
            .set({
          "type": "invite",
          "postId": postId,
          "previewImg": previewImg,
          "title": title,
          "username": currentUser.displayName,
          "userId": currentUser.id,
          "userProfilePic": currentUser.photoUrl,
          "timestamp": DateTime.now()
        });
      }
    }
  }

  void createPost(
      {title,
      String uid,
      description,
      type,
      likeCounter,
      privacy,
      address,
      likes,
      DateTime startDate,
      invitees,
      imageUrl,
      userId,
      userName,
      userEmail,
      profilePic,
      featured,
      postId}) async {
    DocumentReference ref = await dbRef.collection("food").doc(postId).set({
      'title': title,
      'likes': likes,
      'type': type,
      'likeCounter': likeCounter,
      'privacy': privacy,
      'description': description,
      'address': address,
      'startDate': startDate,
      'invitees': {
        for (var item in invitees) item.toString(): 2,
      },
      'image': imageUrl,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'profilePic': profilePic,
      "featured": featured,
      "postId": postId
    }).then(inviteesNotification(postId, imageUrl, title, invitees));

    FirebaseFirestore.instance
        .collection("food")
        .orderBy("startDate", descending: true);

    dbRef.runTransaction((transaction) async {
      final DocumentReference ref2 = dbRef.doc('users/$userId');
      print('$userId');
      transaction.update(ref2, {'score': FieldValue.increment(30)});
      transaction.update(ref, {'postId': ref.id});
    });
  }

  Future<void> addNotGoing(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('food/$postId');
      final DocumentReference ref2 = dbRef.doc('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(1)});

      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );
      FirebaseFirestore.instance.collection('food').doc(postId).set({
        "invitees": {userId: 1}
      }, SetOptions(merge: true));

      String serialUser = userId;
      transaction.update(ref, {
        // 'notGoing': FieldValue.arrayUnion([serialUser]),
        // 'notGoingCounter': FieldValue.increment(1)
      });
    });
  }

  Future<void> removeNotGoing(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('food/$postId');
      final DocumentReference ref2 = dbRef.doc('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(-1)});

      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );
      postsRef.doc(postId).set({
        "invitees": {user.id: FieldValue.delete()}
      }, SetOptions(merge: true));

      String serialUser = userId;
      transaction.update(ref, {
        // 'notGoing': FieldValue.arrayRemove([serialUser]),
        // 'notGoingCounter': FieldValue.increment(-1)
      });
    });
  }

  Future<void> addUndecided(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('food/$postId');
      final DocumentReference ref2 = dbRef.doc('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(1)});

      FirebaseFirestore.instance.collection('food').doc(postId).set({
        "invitees": {userId: 2}
      }, SetOptions(merge: true));

      String serialUser = userId;
      transaction.update(ref, {
        // 'undecided': FieldValue.arrayUnion([serialUser]),
        // 'undecidedCounter': FieldValue.increment(1)
      });
    });
  }

  Future<void> removeUndecided(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('food/$postId');
      final DocumentReference ref2 = dbRef.doc('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(-1)});

      postsRef.doc(postId).set({
        "invitees": {user.id: FieldValue.delete()}
      }, SetOptions(merge: true));

      String serialUser = userId;
      transaction.update(ref, {
        // 'undecided': FieldValue.arrayRemove([serialUser]),
        // 'undecidedCounter': FieldValue.increment(-1)
      });
    });
  }

  Future<void> addGoingGood(userId, ownerId, postId, title, pic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('food/$postId');
      final DocumentReference ref2 = dbRef.doc('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(5)});

      await FirebaseFirestore.instance.collection('food').doc(postId).set({
        "invitees": {userId: 3}
      }, SetOptions(merge: true));

      ///NOTIF FUNCTION BELOW
      bool isNotPostOwner = strUserId != ownerId;
      if (isNotPostOwner) {
        notificationFeedRef
            .doc(ownerId)
            .collection('feedItems')
            .doc(postId + ' from ' + currentUser.id)
            .set({
          "type": "going",
          "postId": postId,
          "previewImg": pic,
          "title": title,
          "username": currentUser.displayName,
          "userId": currentUser.id,
          "userProfilePic": currentUser.photoUrl,
          "timestamp": DateTime.now()
        });
      }

      String serialUser = userId;
      transaction.update(ref, {
        'going': FieldValue.arrayUnion([serialUser]),
        // 'goingCounter': FieldValue.increment(1)
      });
    });
  }

  Future<void> removeGoingGood(userId, ownerId, postId, title, pic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('food/$postId');
      final DocumentReference ref2 = dbRef.doc('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(-5)});

      notificationFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId + ' from ' + currentUser.id)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });

      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );

      postsRef.doc(postId).set({
        "invitees": {user.id: FieldValue.delete()}
      }, SetOptions(merge: true));

      String serialUser = userId;
      transaction.update(ref, {
        'going': FieldValue.arrayRemove([serialUser]),
        // 'goingCounter': FieldValue.increment(-5)
      });
    });
  }

  // Future<void> removeLike(userId, postId) async {
  //   return dbRef.runTransaction((transaction) async {
  //     final DocumentReference ref = dbRef.doc('food/$postId');
  //     final DocumentReference ref2 = dbRef.doc('users/$userId');
  //     transaction.update(ref2, {'score': FieldValue.increment(-2)});

  //     // addGoingToNotificationFeed(
  //     //     userId,
  //     //     postId
  //     //     );
  //     Map<String, dynamic> serializedMessage = {
  //       "uid": userId,
  //     };
  //     String serialUser = userId;
  //     transaction.update(ref, {
  //       'liked': FieldValue.arrayRemove([serializedMessage]),
  //       'liker': FieldValue.arrayRemove([serialUser]),
  //       'likeCounter': FieldValue.increment(-1)
  //     });
  //     transaction.update(ref2, {
  //       'likedMoovs': FieldValue.arrayRemove([postId])
  //     });
  //   });
  // }

  addedToGroup(
    String addee,
    String groupName,
    String groupId,
    String groupPic,
  ) {
    notificationFeedRef
        .doc(addee)
        .collection("feedItems")
        .doc('added to ' + groupId)
        .set({
      "type": "friendGroup",
      "username": currentUser.displayName,
      "userId": currentUser.id,
      "userProfilePic": currentUser.photoUrl,
      "groupPic": groupPic,
      "groupId": groupId,
      "groupName": groupName,
      "timestamp": DateTime.now()
    });
  }

  friendRequestNotification(
      String ownerId, String senderProPic, String ownerName, String sender) {
    notificationFeedRef
        .doc(ownerId)
        .collection("feedItems")
        .doc('request ' + sender)
        .set({
      "type": "request",
      "username": currentUser.displayName,
      "userId": currentUser.id,
      "userProfilePic": currentUser.photoUrl,
      "timestamp": DateTime.now(),
      "ownerName": ownerName,
    });
  }

  sendMOOVNotification(
    String ownerId,
    String previewImg,
    dynamic moovId,
    startDate,
    String title,
    String ownerProPic,
    String ownerName,
  ) {
    notificationFeedRef
        .doc(ownerId)
        .collection("feedItems")
        .doc('invite ' + moovId)
        .set({
      "type": "invite",
      "username": currentUser.displayName,
      "userId": currentUser.id,
      "userProfilePic": currentUser.photoUrl,
      "previewImg": previewImg,
      "postId": moovId,
      "timestamp": timestamp,
      "startDate": startDate,
      "title": title,
      "ownerProPic": ownerProPic,
      "ownerName": ownerName,
    });
  }

  friendAcceptNotification(
      String ownerId, String ownerProPic, String ownerName, String sender) {
    notificationFeedRef
        .doc(ownerId)
        .collection("feedItems")
        .doc('accept ' + sender)
        .set({
      "type": "accept",
      "username": currentUser.displayName,
      "userId": currentUser.id,
      "userEmail": currentUser.email,
      "userProfilePic": currentUser.photoUrl,
      "timestamp": DateTime.now(),
      "ownerProPic": ownerProPic,
      "ownerName": ownerName,
    });
  }

  removeGoingFromNotificationFeed(String ownerId, String moovId) {
    bool isNotPostOwner = strUserId != ownerId;
    if (isNotPostOwner) {
      notificationFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc('going ' + moovId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  deletePost(String postId, String ownerId, String title) {
    // final FirebaseStorage _storage =
    //     FirebaseStorage(storageBucket: 'gs://moov4-4d3c4.appspot.com');
    // String filePath = 'images/$ownerId$title';
    String filePath = 'images/$ownerId$title';

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(filePath);

    groupsRef
        .where('nextMOOV', isEqualTo: postId)
        .get()
        .then((QuerySnapshot snapshot) {});

//       List<dynamic> values = snapshot.docs;
//       print(values.toString());
//       values.forEach((v) {
//         final specificDocument = snapshot.docs.where((f) {
//      return f.id == xxx;
// }).toList();
//         print(v);
//         v.set({
//                               "voters": {"nextMOOV": ""}
//                             });
//       });
//     });
//  .then((querySnapshot) => {
//     querySnapshot.forEach((doc) => {
//         FirebaseFirestore.instance.batch().(doc.ref, {branch: {id: docId, name: after.name}})};
//     });

    bool isPostOwner = strUserId == ownerId;
    if (isPostOwner) {
      postsRef.doc(postId).get().then((doc) {
        if (doc.exists) {
          // _storage.ref().child(filePath).delete();
          ref.delete();

          doc.reference.delete();
          notificationFeedRef
              .doc(ownerId)
              .collection("feedItems")
              .doc(postId)
              .get()
              .then((doc) {
            if (doc.exists) {
              doc.reference.delete();
            }
          });
        }
      });
    }
  }

  Future<void> sendFriendRequest(String senderId, String receiverId,
      String senderName, String senderPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('users/$receiverId');
      String serializedMessage = senderId;
      transaction.update(ref, {
        'friendRequests': FieldValue.arrayUnion([serializedMessage]),
      });
    });
  }

  Future<void> acceptFriendRequest(
      String senderId, String receiverId, String strName, String strPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('users/$receiverId');
      final DocumentReference ref2 = dbRef.doc('users/$senderId');
      String serializedMessage = senderId;
      String serializedMessage2 = receiverId;
      String serializedMessage3 = senderId;
      String serializedMessage4 = receiverId;
      transaction.update(ref, {
        'friendRequests': FieldValue.arrayRemove([serializedMessage3]),
      });
      transaction.update(ref2, {
        'friendRequests': FieldValue.arrayRemove([serializedMessage4]),
      });
      transaction.update(ref, {
        'friendArray': FieldValue.arrayUnion([serializedMessage]),
      });
      transaction.update(ref2, {
        'friendArray': FieldValue.arrayUnion([serializedMessage2]),
      });
    });
  }

  Future<void> rejectFriendRequest(
      String senderId, String receiverId, String strName, String strPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('users/$receiverId');
      final DocumentReference ref2 = dbRef.doc('users/$senderId');
      String serializedMessage = senderId;
      String serializedMessage2 = receiverId;
      transaction.update(ref, {
        'friendRequests': FieldValue.arrayRemove([serializedMessage]),
      });
      transaction.update(ref2, {
        'friendRequests': FieldValue.arrayRemove([serializedMessage2]),
      });
    });
  }

  Future<void> unfriend(String senderId, String receiverId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('users/$receiverId');
      final DocumentReference ref2 = dbRef.doc('users/$senderId');
      String serializedMessage3 = senderId;
      String serializedMessage4 = receiverId;
      transaction.update(ref, {
        'friendArray': FieldValue.arrayRemove([serializedMessage3]),
      });
      transaction.update(ref2, {
        'friendArray': FieldValue.arrayRemove([serializedMessage4]),
      });
    });
  }

  Future<QuerySnapshot> checkStatus(String senderId, String receiverId) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: receiverId)
        .where('friendRequests', arrayContains: senderId)
        .get();
  }

  Future<QuerySnapshot> checkFriends(String senderId, String receiverId) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: receiverId)
        .where('friendArray', arrayContains: senderId)
        .get();
  }

  Future<void> leaveGroup(id, gname, gid) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('users/$id');
      final DocumentReference ref2 = dbRef.doc('friendGroups/$gid');
      transaction.update(ref, {
        'friendGroups': FieldValue.arrayRemove([gid]),
      });
      transaction.update(ref2, {
        'members': FieldValue.arrayRemove([id]),
      });
    });
  }

  Future<void> destroyGroup(gid) async {
    return dbRef.runTransaction((transaction) async {
      dbRef.doc('friendGroups/$gid').delete();
    });
  }

  Future<void> sendChat(user, message, gid) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('friendGroups/$gid');
      final Map<String, dynamic> chat = {
        'sender': user,
        'message': message,
        'timestamp': DateTime.now()
      };
      transaction.update(ref, {
        'chat': chat,
      });
    });
  }

  Future<void> addUser(id, gname, gid) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('users/$id');
      final DocumentReference ref2 = dbRef.doc('friendGroups/$gid');
      transaction.update(ref, {
        'friendGroups': FieldValue.arrayUnion([gid]),
      });
      transaction.update(ref2, {
        'members': FieldValue.arrayUnion([id]),
      });
    });
  }

  Future<void> setMOOV(gid, moovId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('friendGroups/$gid');
      transaction.update(ref, {
        'nextMOOV': moovId,
      });
    });
  }

  Future<void> suggestMOOV(
      userId, gid, postId, userName, members, title, pic, groupName) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref2 = dbRef.doc('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(1)});

      FirebaseFirestore.instance
          .collection('friendGroups')
          .doc(gid)
          .collection("suggestedMOOVs")
          .doc(userId)
          .set({
        "voters": {userId: 2},
        "nextMOOV": postId,
        "suggestorName": userName,
        "suggestorId": userId
      }, SetOptions(merge: true));
      for (var i = 0; i < members.length; i++) {
        if (members[i] != currentUser.id) {
          notificationFeedRef
              .doc(members[i])
              .collection('feedItems')
              .doc('suggest ' + postId)
              .set({
            "type": "suggestion",
            "postId": postId,
            "previewImg": pic,
            "title": title,
            "groupId": gid,
            "groupName": groupName,
            "username": currentUser.displayName,
            "userId": currentUser.id,
            "userProfilePic": currentUser.photoUrl,
            "timestamp": DateTime.now()
          });
        }
      }

      transaction.update(ref2, {'score': FieldValue.increment(1)});
    });
  }

  Future<void> updateGroupNames(members, newName, gid, old) async {
    return dbRef.runTransaction((transaction) async {
      for (var i = 0; i < members.length; i++) {
        final use = members[i];
        final DocumentReference ref = dbRef.doc('users/$use');
        transaction.update(ref, {
          'friendGroups': FieldValue.arrayRemove([old]),
        });
        transaction.update(ref, {
          'friendGroups': FieldValue.arrayUnion([newName]),
        });
      }
    });
  }

  Future<void> addNoVote(userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      FirebaseFirestore.instance
          .collection('friendGroups')
          .doc(gid)
          .collection('suggestedMOOVs')
          .doc(suggestorId)
          .set({
        "voters": {userId: 1}
      }, SetOptions(merge: true));
    });
  }

  Future<void> removeNoVote(userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      FirebaseFirestore.instance
          .collection('friendGroups')
          .doc(gid)
          .collection('suggestedMOOVs')
          .doc(suggestorId)
          .set({
        "voters": {userId: FieldValue.delete()}
      }, SetOptions(merge: true));
    });
  }

  Future<void> addYesVote(userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      FirebaseFirestore.instance
          .collection('friendGroups')
          .doc(gid)
          .collection('suggestedMOOVs')
          .doc(suggestorId)
          .set({
        "voters": {userId: 2}
      }, SetOptions(merge: true));
    });
  }

  Future<void> removeYesVote(userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      FirebaseFirestore.instance
          .collection('friendGroups')
          .doc(gid)
          .collection('suggestedMOOVs')
          .doc(suggestorId)
          .set({
        "voters": {userId: FieldValue.delete()}
      }, SetOptions(merge: true));
    });
  }
}
