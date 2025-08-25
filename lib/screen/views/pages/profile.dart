import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/screen/auth/authenticate.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //AVATAR
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 40),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 100,
                  child: Icon(Icons.person_outline_rounded, size: 100),
                ),
               Positioned(bottom: 10,right: 10,child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.edit)))
              ],
            ),
          ),
        ),

        //RESET PASSWORD
        Container(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(50, 114, 114, 114),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: currentEmail.value,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Reset link sent to: ${currentEmail.value}\nChech Spam folders ",
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
              await Future.delayed(Duration(seconds: 4));
              FirebaseAuth.instance.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Auth();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text(
                "Reset Paassword",
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),

              trailing: Icon(
                Icons.lock_reset,
                size: 26,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ),

        //LOGOUT
        Container(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 252, 223, 223),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Auth();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text("Logout", style: TextStyle(color: Colors.red)),
              subtitle: Text(currentUser.value),
              trailing: Icon(Icons.logout_rounded, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
