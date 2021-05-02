import 'package:MOOV/helpers/themes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

Container circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(TextThemes.ndGold),
      ));
}

Container linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(TextThemes.ndGold),
    ),
  );
}

Center loadingMOOVs() {
  return Center(
    child: SizedBox(
        width: 250.0,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 35,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 7.0,
                color: Colors.white,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText('Loading MOOVs...',
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(color: Colors.black)),
              FlickerAnimatedText('Loading Vibes...',
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(color: Colors.black)),
              FlickerAnimatedText("C'est La Vie...",
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(color: Colors.black)),
            ],
            onTap: () {
              print("Tap Event");
            },
          ),
        )),
  );
}
