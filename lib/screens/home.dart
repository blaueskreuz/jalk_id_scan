import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jalk_app/screens/about_us.dart';
import 'package:jalk_app/screens/data_protection.dart';
import 'package:jalk_app/screens/scan.dart';
import 'package:jalk_app/screens/tutorial.dart';
import 'package:jalk_app/shared/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 3;
  late SharedPreferences _prefs;

  void goToScan() {
    setState(() {
      _currentPageIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;

      if (_prefs.getBool('subsequentTime') == true) {
        setState(() {
          _currentPageIndex = 0;
        });
      }
      else {
        _prefs.setBool('subsequentTime', true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        indicatorColor: jalkColorLightBlue,
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: const Icon(Icons.photo_camera),
            label: context.tr('navigation.scan'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.info),
            label: context.tr('navigation.about_us'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.policy),
            label: context.tr('navigation.data_protection'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.help),
            label: context.tr('navigation.tutorial'),
          ),
        ],
      ),
      body: <Widget>[
        const Scan(),
        const AboutUs(),
        const DataProtection(),
        Tutorial(goToScan: goToScan),
      ][_currentPageIndex],
    );
  }
}
