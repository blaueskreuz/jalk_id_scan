import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:jalk_app/shared/constants.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: jalkPadding,
      children: <Widget>[
        Text(
          context.tr('screens.about_us.title'),
          style: const TextStyle(
            fontSize: jalkTitleFontSize,
            fontWeight: FontWeight.bold
          )
        ),
        const SizedBox(height: jalkTitleMarginBottom),
        Text(
          context.tr('screens.about_us.text'),
          style: const TextStyle(
            fontSize: jalkTextFontSize
          )
        ),
        const SizedBox(height: jalkTitleMarginBottom),
        Text(
          context.tr('screens.about_us.licenses'),
          style: const TextStyle(
            fontSize: jalkTitleFontSize,
            fontWeight: FontWeight.bold
          )
        ),
        TextButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(jalkColorBlue),
            foregroundColor: MaterialStatePropertyAll(jalkColorWhite),
          ),
          onPressed: () {
            showLicensePage(
              context: context,
            );
          },
          child: Text(context.tr('screens.about_us.show_licenses')),
        )
      ]
    );
  }
}
