import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterestCommunityDetail extends StatelessWidget {
  final String groupId;
  const InterestCommunityDetail({@required this.groupId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: communityGroupsRef.doc(groupId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          String groupName = snapshot.data['groupName'];
          
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              flexibleSpace: Image.asset(
                'lib/assets/bouts.jpg',
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black38,
              ),
              title: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "M",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: TextThemes.ndGold),
                      ),
                      TextSpan(
                        text: "/" + groupName,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 20),
                      ),
                    ]),
              ),
            ),
          );
        });
  }
}
