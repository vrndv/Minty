import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/screen/views/pages/profile.dart';
import 'package:SHADE/screen/views/pages/users.dart';

List<Widget> pages = [Users(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: currentPageNotifier,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return pages.elementAt(value);
        },
      ),
    );
  }
}
