import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String groupName;
  final List<dynamic> members;

  Group({this.groupName, this.members});

  factory Group.fromDocument(DocumentSnapshot doc) {
    return Group(groupName: doc['groupName'], members: doc['members']);
  }
}
