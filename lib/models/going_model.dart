import 'package:flutter/cupertino.dart';

class Set {
  final String strName;
  final String strPic;
  final String uid;

  Set(this.strName, this.strPic, this.uid);

  Map<String, dynamic> toMap() =>
      {
        "strName": this.strName,
        "strPic": this.strPic,
        "uid": this.uid
      };

  Set.fromMap(Map<dynamic, dynamic> map)
      : strName = map["strName"].toString(),
       strPic = map["strPic"].toString(),
       uid = map["uid"].toString();
}