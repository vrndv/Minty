import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/screen/auth/authenticate.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10,left: 15,right: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 252, 223, 223),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Auth();
          },));
        },
        child: ListTile(
          title: Text("Logout", style: TextStyle(color: Colors.red)),
          subtitle: Text(currentUser.value),
          trailing: Icon(Icons.logout_rounded, color: Colors.red),
        
        ),
      ),
    );
  }
}
