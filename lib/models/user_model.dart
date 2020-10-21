import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//class UserModel {
//  final String id;
//  final String name;
//  final String email;
//  final String image;
//  final int followers;
//  final DateTime joined;
//  final int posts;
//
//  const UserModel({
//    @required this.id,
//    @required this.name,
//    @required this.email,
//    @required this.image,
//    @required this.followers,
//    @required this.joined,
//    @required this.posts,
//  });
//
//}

class UserModel {
  String id;
  String name;
  String email;
  String image;
  int followers;
  DateTime joined;
  int posts;

  UserModel(
      {@required this.id,
      @required this.name,
      @required this.email,
      @required this.image,
      @required this.followers,
      @required this.joined,
      @required this.posts});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    followers = json['followers'];
    joined = json['joined'];
    posts = json['posts'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    data['followers'] = this.followers;
    data['joined'] = this.joined;
    data['posts'] = this.posts;
    return data;
  }

  String get postTimeFormatted => DateFormat.yMMMMEEEEd().format(joined);
}
