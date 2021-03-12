import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/models/comment_model.dart';
import 'package:MOOV/models/user_model.dart';

class PostModel {
  final String id, title, summary, body, imageURL;
  final DateTime postTime;
  final int reacts, views;
  final UserModel author;
  final bool likeStatus;
  final List<CommentModel> comments;

  const PostModel({
    @required this.id,
    @required this.title,
    @required this.summary,
    @required this.body,
    @required this.imageURL,
    @required this.author,
    @required this.postTime,
    @required this.reacts,
    @required this.views,
    @required this.comments,
    @required this.likeStatus,
  });

  String get postTimeFormatted => DateFormat.yMMMMEEEEd().format(postTime);
}

class Post {
  final String id, title, summary, body, imageURL;
  final DateTime postTime;
  final int reacts, views;
  final UserModel author;
  final bool likeStatus;
  final List<CommentModel> comments;

  const Post({
    @required this.id,
    @required this.title,
    @required this.summary,
    @required this.body,
    @required this.imageURL,
    @required this.author,
    @required this.postTime,
    @required this.reacts,
    @required this.views,
    @required this.comments,
    @required this.likeStatus,
  });

  String get postTimeFormatted => DateFormat.yMMMMEEEEd().format(postTime);
}
