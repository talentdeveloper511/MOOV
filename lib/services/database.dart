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

  FutureOr inviteesNotification(postId, previewImg, title, statuses) {
    if (statuses.length > 0) {
      for (int i = 0; i < statuses.length; i++) {
        notificationFeedRef
            .doc(statuses[i])
            .collection('feedItems')
            .doc('invite ' + postId)
            .set({
          "seen": false,
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

  canceledNotification(String postId, String title, List<dynamic> going) {
    for (var i = 0; i < going.length; i++) {
      if (going[i] != currentUser.id) {
        notificationFeedRef
            .doc(going[i])
            .collection("feedItems")
            .doc('canceled ' + postId)
            .set({
          "seen": false,
          "type": "deleted",
          "username": title,
          "userId": currentUser.id,
          "userEmail": currentUser.email,
          "postId": postId,
          "userProfilePic": currentUser.photoUrl,
          "timestamp": DateTime.now()
        });
      }
    }
  }

  setNotifsSeen() {
    notificationFeedRef
        .doc(currentUser.id)
        .collection('feedItems')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.set({"seen": true}, SetOptions(merge: true));
      }
    });
  }

  setMessagesSeen(dmId) {
    messagesRef.doc(dmId).collection('chat').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update({"seen": true});
      }
    });
    messagesRef.doc(dmId).update({"seen": true});
  }

  editPostNotification(String postId, String title, List<dynamic> going) {
    for (var i = 0; i < going.length; i++) {
      if (going[i] != currentUser.id) {
        notificationFeedRef
            .doc(going[i])
            .collection("feedItems")
            .doc('edit ' + DateTime.now().toString())
            .set({
          "seen": false,
          "type": "edit",
          "username": title,
          "userId": currentUser.id,
          "userEmail": currentUser.email,
          "postId": postId,
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
      int unix,
      statuses,
      int maxOccupancy,
      int venmo,
      bool barcode,
      imageUrl,
      userId,
      postId,
      posterName,
      bool push,
      int goingCount //BETA
      }) {
    bool isPartyOrBar = false;
    if (type == "Pregames & Parties" || type == "Bars & Restaurants") {
      isPartyOrBar = true;
    }
    print(isPartyOrBar);

    postsRef.doc(postId).set({
      'title': title,
      'type': type,
      'privacy': privacy,
      'description': description,
      'address': address,
      'startDate': startDate,
      'unix': unix,
      'statuses': {
        for (var item in statuses) item.toString(): -1,
      },
      'maxOccupancy': maxOccupancy,
      'venmo': venmo,
      'barcode': barcode,
      'image': imageUrl,
      'userId': userId,
      "featured": false,
      "postId": postId,
      "posterName": posterName,
      "push": push,
      "goingCount": 0,
      "going": [],
      "isPartyOrBar": isPartyOrBar
    }).then(inviteesNotification(postId, imageUrl, title, statuses));

    if (privacy == 'Public' || privacy == 'Friends Only') {
      friendCreatedNotification(
          postId, title, imageUrl, currentUser.friendArray);
    }
    usersRef.doc(currentUser.id).get().then((value) {
      if (value['postLimit'] >= 1) {
        print(value['postLimit']);
        usersRef
            .doc(currentUser.id)
            .update({"postLimit": FieldValue.increment(-1)});
        usersRef
            .doc(currentUser.id)
            .update({"score": FieldValue.increment(100)});
      }
    });
  }

  Future<void> addNotGoing(userId, postId, List<dynamic> goingList) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      // final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      // transaction.update(ref2, {'score': FieldValue.increment(10)});

      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );
      postsRef.doc(postId).set({
        "statuses": {userId: 1}
      }, SetOptions(merge: true));

      String serialUser = userId;
      transaction.update(ref, {
        'going': FieldValue.arrayRemove([serialUser]),

        // 'notGoing': FieldValue.arrayUnion([serialUser]),
        // 'notGoingCounter': FieldValue.increment(1)
      });
    });
  }

  Future<void> removeNotGoing(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      // final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      // var checkZero;
      // ref2.get().then((snap) => {
      //       if (snap.data()['score'] == 0) {checkZero = "true"}
      //     });
      // if (checkZero != "true") {
      //   transaction.update(ref2, {'score': FieldValue.increment(-10)});
      // }
      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );
      postsRef.doc(postId).set({
        "statuses": {user.id: FieldValue.delete()}
      }, SetOptions(merge: true));

      // String serialUser = userId;
      // transaction.update(ref, {
      //   // 'notGoing': FieldValue.arrayRemove([serialUser]),
      //   // 'notGoingCounter': FieldValue.increment(-1)
      // });
    });
  }

  Future<void> addUndecided(userId, postId, List<dynamic> goingList) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      // final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      // transaction.update(ref2, {'score': FieldValue.increment(10)});

      if (goingList.contains(userId)) {
        transaction.update(ref, {'goingCount': FieldValue.increment(-1)});
      }

      postsRef.doc(postId).set({
        "statuses": {userId: 2}
      }, SetOptions(merge: true));

      String serialUser = userId;

      transaction.update(ref, {
        'going': FieldValue.arrayRemove([serialUser]),

        // 'undecided': FieldValue.arrayUnion([serialUser]),
        // 'undecidedCounter': FieldValue.increment(1)
      });
    });
  }

  Future<void> removeUndecided(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      // final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      // var checkZero;
      // ref2.get().then((snap) => {
      //       if (snap.data()['score'] == 0) {checkZero = "true"}
      //     });
      // if (checkZero != "true") {
      //   transaction.update(ref2, {'score': FieldValue.increment(-10)});
      // }
      postsRef.doc(postId).set({
        "statuses": {user.id: FieldValue.delete()}
      }, SetOptions(merge: true));

      // String serialUser = userId;
      // transaction.update(ref, {
      //   // 'undecided': FieldValue.arrayRemove([serialUser]),
      //   // 'undecidedCounter': FieldValue.increment(-1)
      // });
    });
  }

  Future<void> addGoingGood(
      userId, ownerId, postId, title, pic, bool push) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/food/$postId');
      // final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      // transaction.update(ref2, {'score': FieldValue.increment(500)});
      transaction.update(ref, {'goingCount': FieldValue.increment(1)});

      await postsRef.doc(postId).set({
        "statuses": {userId: 3}
      }, SetOptions(merge: true));

      ///NOTIF FUNCTION BELOW
      bool isNotPostOwner = strUserId != ownerId;
      if (isNotPostOwner) {
        notificationFeedRef
            .doc(ownerId)
            .collection('feedItems')
            .doc(postId + ' from ' + currentUser.id)
            .set({
          "seen": false,
          "type": "going",
          "postId": postId,
          "previewImg": pic,
          "push": push,
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
      // final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      transaction.update(ref, {'goingCount': FieldValue.increment(-1)});

      // transaction.update(ref2, {'score': FieldValue.increment(-50)});
      // notificationFeedRef
      //     .doc(ownerId)
      //     .collection("feedItems")
      //     .doc(postId + ' from ' + currentUser.id)
      //     .get()
      //     .then((doc) {
      //   if (doc.exists) {
      //     doc.reference.delete();
      //   }
      // });

      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );

      postsRef.doc(postId).set({
        "statuses": {user.id: FieldValue.delete()}
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

  Future<void> goingPushSetting(newValue) async {
    return dbRef.runTransaction((transaction) async {
      usersRef.doc(currentUser.id).set({
        "pushSettings": {"going": newValue}
      }, SetOptions(merge: true));
    });
  }

  Future<void> hourPushSetting(newValue) async {
    return dbRef.runTransaction((transaction) async {
      usersRef.doc(currentUser.id).set({
        "pushSettings": {"hourBefore": newValue}
      }, SetOptions(merge: true));
    });
  }

  Future<void> suggestionsPushSetting(newValue) async {
    return dbRef.runTransaction((transaction) async {
      usersRef.doc(currentUser.id).set({
        "pushSettings": {"suggestions": newValue}
      }, SetOptions(merge: true));
    });
  }

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
      "seen": false,
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

  askToJoinGroup(
    String asker,
    String askerPic,
    String askerId,
    String groupName,
    String groupId,
  ) {
    notificationFeedRef
        .doc(groupId)
        .collection("feedItems")
        .doc('asked to join ' + groupId)
        .set({
      "seen": false,
      "type": "askToJoin",
      "title": groupName,
      "username": currentUser.displayName,
      "userId": currentUser.id,
      "userProfilePic": currentUser.photoUrl,
      "previewImg": askerPic,
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
      "seen": false,
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
        .doc('sent ' + moovId)
        .set({
      "seen": false,
      "type": "sent",
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

    usersRef.doc(currentUser.id).get().then((value) {
      if (value['sendLimit'] >= 0) {
        usersRef
            .doc(currentUser.id)
            .update({"sendLimit": FieldValue.increment(-1)});
        usersRef
            .doc(currentUser.id)
            .update({"score": FieldValue.increment(50)});
      }
    });
  }

  friendAcceptNotification(
      String ownerId, String ownerProPic, String ownerName, String sender) {
    notificationFeedRef
        .doc(ownerId)
        .collection("feedItems")
        .doc('accept ' + sender)
        .set({
      "seen": false,
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

  commentNotification(String ownerId, String message, String postId,
      DateTime timestamp, String previewImg) {
    var title;
    postsRef.doc(postId).get().then((snap) => {
          title = snap.data()['title'],
          notificationFeedRef
              .doc(ownerId)
              .collection("feedItems")
              .doc(currentUser.id + timestamp.toString())
              .set({
            "seen": false,
            "type": "comment",
            "username": currentUser.displayName,
            "userId": currentUser.id,
            "title": title,
            "userEmail": currentUser.email,
            "userProfilePic": currentUser.photoUrl,
            "timestamp": timestamp,
            "previewImg": previewImg,
            "postId": postId,
            "message": message,
          })
        });
  }

  friendCreatedNotification(String postId, String title, String previewImg,
      List<dynamic> friendArray) {
    for (var i = 0; i < friendArray.length; i++) {
      notificationFeedRef
          .doc(friendArray[i])
          .collection("feedItems")
          .doc('created ' + postId)
          .set({
        "seen": false,
        "type": "created",
        "username": currentUser.displayName,
        "userId": currentUser.id,
        "userEmail": currentUser.email,
        "previewImg": previewImg,
        "postId": postId,
        "title": title,
        "userProfilePic": currentUser.photoUrl,
        "timestamp": DateTime.now()
      });
    }
  }

  deletePost(String postId, String ownerId, String title, Map statuses,
      String posterName) {
    String filePath = 'images/$ownerId$title';

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(filePath);

    //BETA ACTIVITY
    if (statuses.length >= 5) {
      betaActivityTracker(posterName, Timestamp.now(), "5+ statuses");
    }
    List<String> statusNames = statuses.keys.toList();

    if (statuses != null && statuses.length != 0)
      for (int i = 0; i < statuses.length; i++) {
        String who;

        usersRef.doc(statusNames[i]).get().then((snap) => {
              who = snap.data()['displayName'],
              betaActivityTracker(
                  who, Timestamp.now(), "responded to post " + postId)
            });
      }
    //BETA

    ///this is for deleting related notifications
    FirebaseFirestore.instance
        .collectionGroup("feedItems")
        .where("postId", isEqualTo: postId)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    FirebaseFirestore.instance

        ///this is for deleted related suggested moovs
        .collectionGroup("suggestedMOOVs")
        .where("nextMOOV", isEqualTo: postId)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    postsRef.doc(postId).get().then((doc) {
      if (doc.exists) {
        // _storage.ref().child(filePath).delete();
        ref.delete();

        doc.reference.delete();
      }
    });
    postsRef.doc(postId).collection('comments').get().then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
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

  Future<void> leaveGroup(id, gname, gid, displayName) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/users/$id');
      final DocumentReference ref2 =
          dbRef.doc('notreDame/data/friendGroups/$gid');
      transaction.update(ref, {
        'friendGroups': FieldValue.arrayRemove([gid]),
      });
      transaction.update(ref2, {
        'members': FieldValue.arrayRemove([id]),
        'memberNames': FieldValue.arrayRemove([displayName]),
      });
    });
  }

  Future<void> destroyGroup(gid, groupName) async {
    String filePath = "images/group" + groupName;

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(filePath);

    groupsRef.doc(gid).get().then((doc) {
      if (doc.exists) {
        // _storage.ref().child(filePath).delete();
        ref.delete();

        doc.reference.delete();
      }
    });

    // return dbRef.runTransaction((transaction) async {
    //   dbRef.doc('notreDame/data/friendGroups/$gid').delete();
    // });
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

  Future<void> addUser(id, gname, gid, displayName) async {
    usersRef.doc(currentUser.id).get().then((value) {
      if (value['groupLimit'] >= 1) {
        usersRef
            .doc(currentUser.id)
            .update({"groupLimit": FieldValue.increment(-1)});
        usersRef
            .doc(currentUser.id)
            .update({"score": FieldValue.increment(75)});
      }
    });

    betaActivityTracker(displayName, Timestamp.now(), "joined Friend Group");
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.doc('notreDame/data/users/$id');
      final DocumentReference ref2 =
          dbRef.doc('notreDame/data/friendGroups/$gid');
      transaction.update(ref, {
        'friendGroups': FieldValue.arrayUnion([gid]),
        // 'score': FieldValue.increment(75)
      });
      transaction.update(ref2, {
        'members': FieldValue.arrayUnion([id]),
        'memberNames': FieldValue.arrayUnion([displayName]),
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

  Future<void> suggestMOOV(userId, gid, postId, unix, userName, members, title,
      pic, groupName) async {
    usersRef.doc(currentUser.id).get().then((value) {
      if (value['suggestLimit'] >= 1) {
        usersRef
            .doc(currentUser.id)
            .update({"suggestLimit": FieldValue.increment(-1)});
        usersRef
            .doc(currentUser.id)
            .update({"score": FieldValue.increment(30)});
      }
    });

    return dbRef.runTransaction((transaction) async {
      // final DocumentReference ref2 = dbRef.doc('notreDame/data/users/$userId');
      // transaction.update(ref2, {'score': FieldValue.increment(30)});

      groupsRef
          .doc(gid)
          .collection("suggestedMOOVs")
          .doc(unix.toString() + " from " + userId)
          .set({
        "voters": {userId: 2},
        "nextMOOV": postId,
        "unix": unix,
        "suggestorName": userName,
        "suggestorId": userId
      }, SetOptions(merge: true));
      bool push = true;

      notificationFeedRef
          .doc(gid)
          .collection('feedItems')
          .doc('suggest ' + postId)
          .set({
        "seen": false,
        "type": "suggestion",
        "push": push,
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
    });
  }

  Future<void> betaActivityTracker(
      //BETA ACTIVITY TRACKER
      String who,
      Timestamp when,
      String what) async {
    final dateToCheck = when.toDate();
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

    String whenString = DateFormat('MMMd').format(aDate);
    // if (who != "Alvin Alaphat" && who != "Kevin Camson" && who != "MOOV Team") {

    FirebaseFirestore.instance.collection(who).get().then((value) {
      print(value);
    });

    // if (value['postLimit'] >= 1) {

    FirebaseFirestore.instance
        .collection(who)
        .doc(whenString)
        .collection(what)
        .doc(what)
        .set({
      "who": who,
      "when": when,
      "what": what,
    });
    //}
  }

  Future<void> addNoVote(unix, userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      groupsRef
          .doc(gid)
          .collection('suggestedMOOVs')
          .doc(unix.toString() + " from " + suggestorId)
          .set({
        "voters": {userId: 1}
      }, SetOptions(merge: true));
    });
  }

  Future<void> removeNoVote(unix, userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      groupsRef
          .doc(gid)
          .collection('suggestedMOOVs')
          .doc(unix.toString() + " from " + suggestorId)
          .set({
        "voters": {userId: FieldValue.delete()}
      }, SetOptions(merge: true));
    });
  }

  Future<void> addYesVote(unix, userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      groupsRef
          .doc(gid)
          .collection('suggestedMOOVs')
          .doc(unix.toString() + " from " + suggestorId)
          .set({
        "voters": {userId: 2}
      }, SetOptions(merge: true));
    });
  }

  Future<void> removeYesVote(unix, userId, gid, suggestorId) async {
    return dbRef.runTransaction((transaction) async {
      groupsRef
          .doc(gid)
          .collection('suggestedMOOVs')
          .doc(unix.toString() + " from " + suggestorId)
          .set({
        "voters": {userId: FieldValue.delete()}
      }, SetOptions(merge: true));
    });
  }

  updateAllDocs() async {
    var snapshots = usersRef.snapshots();
    try {
      await snapshots.forEach((snapshot) async {
        List<DocumentSnapshot> documents = snapshot.docs;

        for (var document in documents) {
          await document.reference.set({
            // "sendLimit": {
            //   "friendFinderVisibility": true,
            //   "friendsOnly": false,
            //   "incognito": false,
            //   "showDorm": true
            // }
            "nameChangeLimit": 1,
            // "groupLimit": 2
          }, SetOptions(merge: true));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updatePoll() async {
    var snapshots = FirebaseFirestore.instance
        .collection('notreDame')
        .doc('data')
        .collection('poll')
        .snapshots();
    try {
      await snapshots.forEach((snapshot) async {
        List<DocumentSnapshot> documents = snapshot.docs;

        for (var document in documents) {
          await document.reference.set({
            "choice1": "",
            "choice2": "",
            "question": "",
            "voters": {"107290090512658207959": 1}
          }, SetOptions(merge: true));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  funnyScreenshot({user, timestamp, venmo, imageUrl}) {
    FirebaseFirestore.instance.collection("screenshots").doc().set({
      "user": user,
      "timestamp": timestamp,
      "venmo": venmo,
      "imageUrl": imageUrl
    });
  }
}
