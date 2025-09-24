
//Just to save point ,the username adding option is currently situated in homescreen

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/firebase_options.dart';
import 'package:popapp/rootAuth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);  
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}
class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentTheme,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'PopApp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 132, 255),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 132, 255),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeMode? ThemeMode.light:ThemeMode.dark, // theme changes
          home: child,
        );
      },
      child: RootAppLogic(),
    );
  }
}
