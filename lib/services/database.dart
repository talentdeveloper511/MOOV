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
      description,
      type,
      privacy,
      address,
      DateTime startDate,
      invitees,
      int maxOccupancy,
      bool barcode,
      imageUrl,
      userId,
      postId}) async {
    DocumentReference ref = await postsRef.doc(postId).set({
      'title': title,
      'type': type,
      'privacy': privacy,
      'description': description,
      'address': address,
      'startDate': startDate,
      'invitees': {
        for (var item in invitees) item.toString(): 2,
      },
      'maxOccupancy': maxOccupancy,
      'barcode': barcode,
      'image': imageUrl,
      'userId': userId,
      "featured": false,
      "postId": postId
    }).then(inviteesNotification(postId, imageUrl, title, invitees));

    postsRef.orderBy("startDate", descending: true);

    dbRef.runTransaction((transaction) async {
      final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      print('$userId');
      transaction.update(ref2, {'score': FieldValue.increment(30)});
      transaction.update(ref, {'postId': ref.id});
    });
  }

  Future<void> addNotGoing(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(1)});

      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );
      postsRef.doc(postId).set({
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
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
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
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(1)});

      postsRef.doc(postId).set({
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
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
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
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(5)});

      await postsRef.doc(postId).set({
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
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
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
      "previewImg": groupPic,
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

    // groupsRef
    //     .where('nextMOOV', isEqualTo: postId)
    //     .get()
    //     .then((QuerySnapshot snapshot) {});

    // notificationFeedRef.where("postId", isEqualTo: postId).get().then((doc) {
    //   print(doc);
     
      
    // });
    ///this is gonna be a little more complicated to delete notifs

    postsRef.doc(postId).get().then((doc) {
      if (doc.exists) {
        // _storage.ref().child(filePath).delete();
        ref.delete();

        doc.reference.delete();
      }
    });

    groupsRef.where("nextMOOV", isEqualTo: postId).get().then((doc) {
      final DocumentReference ref =
          dbRef.doc('notreDame/data/friendGroups/$doc');

      if (doc.docs.isNotEmpty) {
        return dbRef.runTransaction((transaction) async {
          transaction.update(ref, {
            'nextMOOV': FieldValue.arrayRemove([postId]),
          });
        });
      }
    });
  }

  Future<void> sendFriendRequest(String senderId, String receiverId,
      String senderName, String senderPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref =
          dbRef.doc('notreDame/data/users/$receiverId');
      String serializedMessage = senderId;
      transaction.update(ref, {
        'friendRequests': FieldValue.arrayUnion([serializedMessage]),
      });
    });
  }

  Future<void> acceptFriendRequest(
      String senderId, String receiverId, String strName, String strPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref =
          dbRef.doc('notreDame/data/users/$receiverId');
      final DocumentReference ref2 =
          dbRef.doc('notreDame/data/users/$senderId');
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
      final DocumentReference ref =
          dbRef.doc('notreDame/data/users/$receiverId');
      final DocumentReference ref2 =
          dbRef.doc('notreDame/data/users/$senderId');
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
      final DocumentReference ref =
          dbRef.doc('notreDame/data/users/$receiverId');
      final DocumentReference ref2 =
          dbRef.doc('notreDame/data/users/$senderId');
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
    return usersRef
        .where('id', isEqualTo: receiverId)
        .where('friendRequests', arrayContains: senderId)
        .get();
  }

  Future<QuerySnapshot> checkFriends(String senderId, String receiverId) {
    return usersRef
        .where('id', isEqualTo: receiverId)
        .where('friendArray', arrayContains: senderId)
        .get();
  }

  Future<void> leaveGroup(id, gname, gid) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/users/$id');
      final DocumentReference ref2 =
          dbRef.doc('notreDame/data/friendGroups/$gid');
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
      dbRef.doc('notreDame/data/friendGroups/$gid').delete();
    });
  }

  Future<void> sendChat(user, message, gid) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref =
          dbRef.doc('notreDame/data/friendGroups/$gid');
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
      final DocumentReference ref = dbRef.doc('notreDame/data/users/$id');
      final DocumentReference ref2 =
          dbRef.doc('notreDame/data/friendGroups/$gid');
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
      final DocumentReference ref =
          dbRef.doc('notreDame/data/friendGroups/$gid');
      transaction.update(ref, {
        'nextMOOV': moovId,
      });
    });
  }

  Future<void> suggestMOOV(
      userId, gid, postId, userName, members, title, pic, groupName) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(1)});

      groupsRef.doc(gid).collection("suggestedMOOVs").doc(userId).set({
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
        final DocumentReference ref = dbRef.doc('notreDame/data/users/$use');
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
      groupsRef.doc(gid).collection('suggestedMOOVs').doc(suggestorId).set({
        "voters": {userId: 1}
      }, SetOptions(merge: true));
    });
  }

  Future<void> removeNoVote(userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      groupsRef.doc(gid).collection('suggestedMOOVs').doc(suggestorId).set({
        "voters": {userId: FieldValue.delete()}
      }, SetOptions(merge: true));
    });
  }

  Future<void> addYesVote(userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      groupsRef.doc(gid).collection('suggestedMOOVs').doc(suggestorId).set({
        "voters": {userId: 2}
      }, SetOptions(merge: true));
    });
  }

  Future<void> removeYesVote(userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      groupsRef.doc(gid).collection('suggestedMOOVs').doc(suggestorId).set({
        "voters": {userId: FieldValue.delete()}
      }, SetOptions(merge: true));
    });
  }
}
