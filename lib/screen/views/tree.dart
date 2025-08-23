import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/screen/views/pages/chat.dart';
import 'package:popapp/screen/views/pages/profile.dart';

List<Widget> pages = [
  ChatPage(),
  ProfilePage(),
];


class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ValueListenableBuilder(
        valueListenable: currentPageNotifier,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return pages.elementAt(value);
        },
      ),
    );
  }
}