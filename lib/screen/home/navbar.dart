import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';

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
            NavigationDestination(icon: SizedBox(
                height: 25,
                width: 25,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.person,
                    ),

                    (currVer.value < newVer.value)
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.lens_rounded,
                              color: Colors.red,
                              size: 7,
                            ),
                          )
                        : Text(""),
                  ],
                ),
              ), label: "Profile"),
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
