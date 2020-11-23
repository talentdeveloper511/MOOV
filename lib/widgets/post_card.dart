import 'package:flutter/material.dart';
import 'package:MOOV/helpers/common.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/pages/PostDepth.dart';
import 'package:MOOV/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:MOOV/widgets/post_stats.dart';
import 'package:MOOV/widgets/post_time_stamp.dart';
import 'package:MOOV/widgets/user_details.dart';
import 'package:MOOV/helpers/themes.dart';

class PostCard extends StatelessWidget {
  final PostModel postData;

  const PostCard({Key key, @required this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double aspectRatio = isLandscape(context) ? 6 / 2 : 6 / 3;

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return PostDepth(postData: postData);
        }));
      },
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Card(
          color: Colors.white,
          elevation: 2,
          child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            child: InheritedPostModel(
              postData: postData,
              child: Column(
                children: <Widget>[
                  _Post(),
                  Divider(color: Colors.grey),
                  _PostDetails(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  const _Post({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(children: <Widget>[_PostImage(), _PostTitleSummaryAndTime()]),
    );
  }
}

class _PostTitleSummaryAndTime extends StatelessWidget {
  const _PostTitleSummaryAndTime({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle titleTheme = TextThemes.headline1;
    final TextStyle summaryTheme = TextThemes.bodyText1;
    final String title = postData.title;
    final String summary = postData.summary;
    final int flex = isLandscape(context) ? 5 : 3;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: titleTheme,
                  ),
                ),
                SizedBox(height: 2.0),
                Center(child: Text(summary, style: summaryTheme)),
              ],
            ),
            PostTimeStamp(alignment: Alignment.centerRight),
          ],
        ),
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: TextThemes.ndBlue, width: 1)),
              child: Image.asset(
                postData.imageURL,
                fit: BoxFit.cover,
              )),
        ));
  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;

    return Row(
      children: <Widget>[
        Expanded(flex: 3, child: UserDetails(userData: postData.author)),
        Expanded(flex: 1, child: PostStats()),
      ],
    );
  }
}
