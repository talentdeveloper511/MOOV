// import 'package:flutter/material.dart';
// import 'package:MOOV/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final dbRef = Firestore.instance;

  void createPost(
      {title,
      description,
      type,
      location,
      address,
      Map likes,
      DateTime startDate,
      DateTime endDate,
      String imageUrl}) async {
    // await dbRef.collection("books")
    //     .document("1")
    //     .setData({
    //       'title': 'Mastering Flutter',
    //       'description': 'Programming Guide for Dart'
    //     });
    DocumentReference ref = await dbRef.collection("food").add({
      'title': title,
      'likes': likes,
      'type': type,
      'description': description,
      'location': location,
      'address': address,
      'startDate': startDate,
      'endDate': endDate,
      'image': imageUrl,
    });
    // final String postId = ref.documentID;
    print(ref.documentID);

    Firestore.instance
        .collection("food")
        .orderBy("startDate", descending: true);
  }

  // void createSportPost(
  //     {title,
  //     description,
  //     type,
  //     location,
  //     address,
  //     DateTime startDate,
  //     DateTime endDate,
  //     String imageUrl}) async {
  //   // await dbRef.collection("books")
  //   //     .document("1")
  //   //     .setData({
  //   //       'title': 'Mastering Flutter',
  //   //       'description': 'Programming Guide for Dart'
  //   //     });
  //   DocumentReference ref = await dbRef.collection("sport").add({
  //     'title': title,
  //     'type': type,
  //     'description': description,
  //     'location': location,
  //     'address': address,
  //     'startDate': startDate,
  //     'endDate': endDate,
  //     'image': imageUrl,
  //   });
  //   print(ref.documentID);

  //   Firestore.instance
  //       .collection("sport")
  //       .orderBy("startDate", descending: true);
  // }

  void getData() {
    dbRef.collection("books").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
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
}
