import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.chat_rounded),
              label: "Chats",
            ),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
          height: 70,
          selectedIndex: currentPage,
          onDestinationSelected: (value) {
            currentPageNotifier.value = value;
            isSearch.value = false;
          },
        );
      },
    );
  }
}
