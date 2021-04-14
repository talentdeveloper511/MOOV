import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';

class MOOVMemories extends StatelessWidget {
  const MOOVMemories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: TextThemes.ndBlue,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(7.5),
          title: Padding(
            padding: EdgeInsets.all(10),
            child: GradientText(
              "MOOV Memories",
              gradient: LinearGradient(colors: [
                Colors.blue.shade400,
                Colors.blue.shade900,
              ]),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "lib/assets/clouds.jpeg",
                width: MediaQuery.of(context).size.width,
              ),
              Text(
                "Yours forever.",
                style: TextThemes.headlineWhite,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 175.0, left: 20, right: 20),
                child: Text(
                    """MOOVs delete one hour after start time for privacy. """
                    """\
                    But those you save to memory will stay here, \nfor your eyes only.""",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
