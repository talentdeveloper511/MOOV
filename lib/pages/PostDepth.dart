import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:MOOV3/models/post_model.dart';
import 'package:MOOV3/helpers/themes.dart';
import 'package:MOOV3/widgets/comments_list.dart';
import 'package:MOOV3/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:MOOV3/widgets/post_stats.dart';
import 'package:MOOV3/widgets/post_time_stamp.dart';
import 'package:MOOV3/widgets/user_details_with_follow.dart';
import 'HomePage.dart';

class PostDepthKeys {
  static final ValueKey wholePage = ValueKey("wholePage");
  static final ValueKey bannerImage = ValueKey("bannerImage");
  static final ValueKey summary = ValueKey("summary");
  static final ValueKey mainBody = ValueKey("mainBody");
}

class PostDepth extends StatelessWidget {
  final PostModel postData;

  const PostDepth({Key key, @required this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          title: Text(
        postData.title,
        style: TextThemes.bodyText1,
        textScaleFactor: 2,
      )),
      body: InheritedPostModel(
        postData: postData,
        child: ListView(
          key: PostDepthKeys.wholePage,
          children: <Widget>[
            _BannerImage(key: PostDepthKeys.bannerImage),
            _NonImageContents(),
          ],
        ),
      ),
    );
  }
}

class _NonImageContents extends StatelessWidget {
  const _NonImageContents({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Summary(key: PostDepthKeys.summary),
          PostTimeStamp(),
          _MainBody(key: PostDepthKeys.mainBody),
          UserDetailsWithFollow(
            userData: postData.author,
          ),
          SizedBox(height: 8.0),
          PostStats(),
          CommentsList(),
        ],
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({Key key}) : super(key: key);

  final double _sigmaX = 5.00; // from 0-10
  final double _sigmaY = 5.00; // from 0-10
  final double _opacity = 0.3; // from 0-1.0

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(InheritedPostModel.of(context).postData.imageURL),
          fit: BoxFit.fitWidth,
        )),
        height: 200,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 10,
              color: Colors.black.withOpacity(_opacity),
            ),
          ),
        ),
      ),
      Container(
        alignment: Alignment(0.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 23),
          child: Image.asset(
            'lib/assets/dummyqr.png',
            height: 150,
            width: 150,
          ),
        ),
      )
    ]);
  }
}

class _Summary extends StatelessWidget {
  const _Summary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        InheritedPostModel.of(context).postData.summary,
        style: TextThemes.headline1,
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  const _MainBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        InheritedPostModel.of(context).postData.body,
        style: TextThemes.bodyText1,
      ),
    );
  }
}
