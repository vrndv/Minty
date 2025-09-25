import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/database.dart';
import 'package:popapp/screen/auth/authenticate.dart';
import 'package:popapp/screen/home/home.dart';

class RootAppLogic extends StatelessWidget {
  const RootAppLogic({super.key});

  @override
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
