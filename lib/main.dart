import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jalk_app/screens/home.dart';
import 'package:jalk_app/shared/constants.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/lottiefiles/OFL.txt');
    yield LicenseEntryWithLineBreaks(['lottiefiles'], license);
  });

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('de'), Locale('fr'), Locale('it')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: const JalkApp(),
  ));
}

class JalkApp extends StatelessWidget {
  const JalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Jalk App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: jalkColorBlue),
        useMaterial3: true,
        textTheme: GoogleFonts.barlowTextTheme(),
      ),
      home: Home(),
    );
  }
}
