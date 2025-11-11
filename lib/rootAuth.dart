import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/database.dart';
import 'package:SHADE/screen/auth/authenticate.dart';
import 'package:SHADE/screen/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootAppLogic extends StatefulWidget {
  const RootAppLogic({super.key});

  @override
  State<RootAppLogic> createState() => _RootAppLogicState();
}

class _RootAppLogicState extends State<RootAppLogic> {
  @override
  @override
  void initState() {
    super.initState();
  }

  Future<void> getTheme() async {
    final pref = await SharedPreferences.getInstance();
    final val = pref.getBool("currentTheme") ?? false;
    currentTheme.value = val;
  }

  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return FutureBuilder<String>(
            future: DatabaseService().findUsername(
              email: snapshot.data!.email!,
            ),
            builder: (context, unameSnapshot) {
              if (unameSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (unameSnapshot.hasError) {
                return const Auth();
              }
              if (unameSnapshot.hasData) {
                userID.value = FirebaseAuth.instance.currentUser!.uid;
                currentUser.value = unameSnapshot.data!;
                isLogged.value = true;
                return DataBaseForm(userEmail: unameSnapshot.data!, page: 0);
              }
              return const Scaffold(
                body: Center(child: Text('No username found')),
              );
            },
          );
        }
        return const Auth();
      },
    );
  }
}
