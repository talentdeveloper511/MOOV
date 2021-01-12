import 'package:MOOV/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class Database {
  final dbRef = Firestore.instance;
  var postPic;
  var ownerId;
  dynamic startDate;
  var title;
  bool featured;
var postId; 

  final GoogleSignInAccount user = googleSignIn.currentUser;
  final strUserId = googleSignIn.currentUser.id;
  final strUserName = googleSignIn.currentUser.displayName;
  final strPic = googleSignIn.currentUser.photoUrl;

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
      featured,
      postId}) async {
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
      "postId": postId
    });


    Firestore.instance
        .collection("food")
        .orderBy("startDate", descending: true);

    dbRef.runTransaction((transaction) async {
      final DocumentReference ref2 = dbRef.document('users/$userId');
      print('$userId');
      transaction.update(ref2, {'score': FieldValue.increment(30)});
      transaction.update(ref, {'postId': ref.documentID});
    });
  }

  Future<void> addLike(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('food/$postId');
      final DocumentReference ref2 = dbRef.document('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(2)});

      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );
      Map<String, dynamic> serializedMessage = {
        "uid": userId,
      };
      String serialUser = userId;
      transaction.update(ref, {
        'liked': FieldValue.arrayUnion([serializedMessage]),
        'liker': FieldValue.arrayUnion([serialUser]),
        'likeCounter': FieldValue.increment(1)
      });
      transaction.update(ref2, {
        'likedMoovs': FieldValue.arrayUnion([postId])
      });
    });
  }

  Future<void> removeLike(userId, postId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('food/$postId');
      final DocumentReference ref2 = dbRef.document('users/$userId');
      transaction.update(ref2, {'score': FieldValue.increment(-2)});

      // addGoingToNotificationFeed(
      //     userId,
      //     postId
      //     );
      Map<String, dynamic> serializedMessage = {
        "uid": userId,
      };
      String serialUser = userId;
      transaction.update(ref, {
        'liked': FieldValue.arrayRemove([serializedMessage]),
        'liker': FieldValue.arrayRemove([serialUser]),
        'likeCounter': FieldValue.increment(-1)
      });
      transaction.update(ref2, {
        'likedMoovs': FieldValue.arrayRemove([postId])
      });
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
      };
      String serialUser = uid;
      transaction.update(ref, {
        'liked': FieldValue.arrayUnion([serializedMessage]),
        'liker': FieldValue.arrayUnion([serialUser]),
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

  addedToGroup(String addee, String gname, String gid, String groupPic,
      List<dynamic> members, String moov) {
    notificationFeedRef
        .document(addee)
        .collection("feedItems")
        .document(gid)
        .setData({
      "type": "friendgroup",
      "username": currentUser.displayName,
      "userId": currentUser.id,
      "userEmail": currentUser.email,
      "userProfilePic": currentUser.photoUrl,
      "previewImg": groupPic,
      "postId": gid,
      "title": gname,
      "likedArray": members,
      "address": moov,
      "timestamp": DateTime.now()
    });
  }

  friendRequestNotification(
      String ownerId, String ownerProPic, String ownerName, String sender) {
    notificationFeedRef
        .document(ownerId)
        .collection("feedItems")
        .document(sender)
        .setData({
      "type": "request",
      "username": currentUser.displayName,
      "userId": currentUser.id,
      "userEmail": currentUser.email,
      "userProfilePic": currentUser.photoUrl,
      "timestamp": DateTime.now(),
      "ownerProPic": ownerProPic,
      "ownerName": ownerName,
    });
  }

  sendMOOVNotification(
      String ownerId,
      String previewImg,
      dynamic moovId,
      startDate,
      String title,
      String description,
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
      "type": "invite",
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
      "address": address,
      "ownerProPic": ownerProPic,
      "ownerName": ownerName,
      "ownerEmail": ownerEmail,
      "likedArray": likedArray
    });
  }

  friendAcceptNotification(
      String ownerId, String ownerProPic, String ownerName, String sender) {
    notificationFeedRef
        .document(ownerId)
        .collection("feedItems")
        .document(sender)
        .setData({
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

  deletePost(String postId, String ownerId, String title) {
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://moov4-4d3c4.appspot.com');
    String filePath = 'images/$ownerId$title';

    bool isPostOwner = strUserId == ownerId;
    if (isPostOwner) {
      postsRef.document(postId).get().then((doc) {
        if (doc.exists) {
          _storage.ref().child(filePath).delete();

          doc.reference.delete();
          notificationFeedRef
              .document(ownerId)
              .collection("feedItems")
              .document(postId)
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
      };
      String serialUser = uid;

      transaction.update(userRef, {
        'liked': FieldValue.arrayRemove([serializedMessage]),
        'liker': FieldValue.arrayRemove([serialUser]),
        'likeCounter': FieldValue.increment(-1)
      });
      transaction.update(userRef2, {
        'score': FieldValue.increment(-2),
      });
    });
  }

  Future<void> sendFriendRequest(String senderId, String receiverId,
      String senderName, String senderPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('users/$receiverId');
      String serializedMessage = senderId;
      transaction.update(ref, {
        'friendRequests': FieldValue.arrayUnion([serializedMessage]),
      });
    });
  }

  Future<void> acceptFriendRequest(
      String senderId, String receiverId, String strName, String strPic) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('users/$receiverId');
      final DocumentReference ref2 = dbRef.document('users/$senderId');
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
      final DocumentReference ref = dbRef.document('users/$receiverId');
      final DocumentReference ref2 = dbRef.document('users/$senderId');
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

  Future<QuerySnapshot> checkStatus(String senderId, String receiverId) {
    return Firestore.instance
        .collection('users')
        .where('id', isEqualTo: receiverId)
        .where('friendRequests', arrayContains: senderId)
        .getDocuments();
  }

  Future<QuerySnapshot> checkFriends(String senderId, String receiverId) {
    return Firestore.instance
        .collection('users')
        .where('id', isEqualTo: receiverId)
        .where('friendArray', arrayContains: senderId)
        .getDocuments();
  }

  Future<void> leaveGroup(id, gname, gid) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('users/$id');
      final DocumentReference ref2 = dbRef.document('friendGroups/$gid');
      transaction.update(ref, {
        'friendGroups': FieldValue.arrayRemove([gname]),
      });
      transaction.update(ref2, {
        'members': FieldValue.arrayRemove([id]),
      });
    });
  }

  Future<void> destroyGroup(gid) async {
    return dbRef.runTransaction((transaction) async {
      dbRef.document('friendGroups/$gid').delete();
    });
  }

  Future<void> sendChat(user, message, gid) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('friendGroups/$gid');
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
      final DocumentReference ref = dbRef.document('users/$id');
      final DocumentReference ref2 = dbRef.document('friendGroups/$gid');
      transaction.update(ref, {
        'friendGroups': FieldValue.arrayUnion([gname]),
      });
      transaction.update(ref2, {
        'members': FieldValue.arrayUnion([id]),
      });
    });
  }

  Future<void> setMOOV(gid, moovId) async {
    return dbRef.runTransaction((transaction) async {
      final DocumentReference ref = dbRef.document('friendGroups/$gid');
      transaction.update(ref, {
        'nextMOOV': moovId,
      });
    });
  }

  Future<void> updateGroupNames(members, newName, gid, old) async {
    return dbRef.runTransaction((transaction) async {
      for (var i = 0; i < members.length; i++) {
        final use = members[i];
        final DocumentReference ref = dbRef.document('users/$use');
        transaction.update(ref, {
          'friendGroups': FieldValue.arrayRemove([old]),
        });
        transaction.update(ref, {
          'friendGroups': FieldValue.arrayUnion([newName]),
        });
      }
    });
  }
}
