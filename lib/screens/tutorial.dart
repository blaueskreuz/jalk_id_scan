import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:lottie/lottie.dart';

import 'package:jalk_app/shared/constants.dart';

class Tutorial extends StatefulWidget {
  final Function goToScan;

  const Tutorial({super.key, required this.goToScan});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  void onDonePress() {
    widget.goToScan();
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: [
        ContentConfig(
          title: context.tr('screens.tutorial.face_recognition.title'),
          description: context.tr('screens.tutorial.face_recognition.description'),
          backgroundColor: const Color(0xfff5a623),
          centerWidget: Lottie.asset(
            'assets/lottiefiles/face_recognition.json',
            height: 200.0,
          ),
        ),
        ContentConfig(
          title: context.tr('screens.tutorial.scan.title'),
          description: context.tr('screens.tutorial.scan.description'),
          backgroundColor: Color(0xff203152),
          centerWidget: Lottie.asset(
            'assets/lottiefiles/scan.json',
            height: 200.0,
          ),
        ),
        ContentConfig(
          title: context.tr('screens.tutorial.check_result.title'),
          description: context.tr('screens.tutorial.check_result.description'),
          backgroundColor: Color(0xff9932CC),
          centerWidget: Lottie.asset(
            'assets/lottiefiles/result.json',
            height: 200.0,
          ),
        ),
      ],
      onDonePress: onDonePress,
      isShowSkipBtn: false,
      isShowPrevBtn: true,
      renderSkipBtn: Text(context.tr('screens.tutorial.skip')),
      renderPrevBtn: Text(context.tr('screens.tutorial.previous')),
      renderNextBtn: Text(context.tr('screens.tutorial.next')),
      renderDoneBtn: Text(context.tr('screens.tutorial.done')),
      skipButtonStyle: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(jalkColorBlue),
        foregroundColor: MaterialStatePropertyAll(jalkColorWhite),
      ),
      prevButtonStyle: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(jalkColorBlue),
        foregroundColor: MaterialStatePropertyAll(jalkColorWhite),
      ),
      doneButtonStyle: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(jalkColorBlue),
        foregroundColor: MaterialStatePropertyAll(jalkColorWhite),
      ),
      nextButtonStyle: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(jalkColorBlue),
        foregroundColor: MaterialStatePropertyAll(jalkColorWhite),
      ),
    );
  }
}
