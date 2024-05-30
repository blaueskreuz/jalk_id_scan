import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:jalk_app/shared/constants.dart';

class DataProtection extends StatefulWidget {
  const DataProtection({super.key});

  @override
  State<DataProtection> createState() => _DataProtectionState();
}

class _DataProtectionState extends State<DataProtection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: jalkPadding,
      children: <Widget>[
        Text(
            context.tr('screens.data_protection.title'),
            style: const TextStyle(
                fontSize: jalkTitleFontSize,
                fontWeight: FontWeight.bold
            )
        ),
        const SizedBox(height: jalkTitleMarginBottom),
        Text(
            context.tr('screens.data_protection.text'),
            style: const TextStyle(
                fontSize: jalkTextFontSize
            )
        ),
      ]
    );
  }
}
