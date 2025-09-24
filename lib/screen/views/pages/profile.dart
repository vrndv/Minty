import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/screen/auth/authenticate.dart';
import 'package:url_launcher/url_launcher.dart';
//bool func
bool i = true;
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String version = "";
  @override
  void initState() {
    super.initState();
    _chechVersion();
  }

  Uri url = Uri.parse("https://varundev.me");

  Future<void> _chechVersion() async {
    if (i) {
      final doc = await FirebaseFirestore.instance
          .collection('ver')
          .doc('currentVer')
          .get();
      newVer.value = doc["appVer"];
      Strversion.value = (await FirebaseFirestore.instance
                                  .collection('ver')
                                  .doc('currentVer')
                                  .get()).get('version ') ;
      i = !i;
      setState(() {
        print(Strversion.value);
      });
    }
  }

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
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      
                      showSnackBar(msg: version);
                    },
                    onLongPress: () {
                      isProfanity.value = !isProfanity.value;
                      setState(() {});
                      showSnackBar(
                        msg: " Profanity :${isProfanity.value ? "ON" : "OFF"}",
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //RESET PASSWORD
        Container(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            color: currentTheme.value
                ? const Color.fromARGB(113, 163, 163, 163)
                : const Color.fromARGB(151, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: currentEmail.value,
              );
              showSnackBar(
                msg:
                    "Reset link sent to: ${currentEmail.value}\nChech Spam folders ",
              );
              await Future.delayed(Duration(seconds: 4));
              FirebaseAuth.instance.signOut();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Auth()),
                (Route<dynamic> route) => false,
              );
            },
            child: ListTile(
              title: Text(
                "Reset Password",
                style: TextStyle(
                  color: currentTheme.value
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),

              trailing: Icon(
                Icons.lock_reset,
                size: 26,
                color: const Color.fromARGB(204, 0, 0, 0),
              ),
            ),
          ),
        ),
        //THEME BUTTON
        Container(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            color: currentTheme.value
                ? const Color.fromARGB(113, 163, 163, 163)
                : const Color.fromARGB(151, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
              currentTheme.value =!currentTheme.value;
                
              });
            },
            child: ListTile(
              title: Text(
                "Theme",
                style: TextStyle(
                  color: currentTheme.value
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              trailing: Icon(
                Icons.dark_mode_rounded,
                color: const Color.fromARGB(207, 0, 0, 0),
              ),
            ),
          ),
        ),

        //CHECK UPDATE
        Container(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            color: currentTheme.value
                ? const Color.fromARGB(113, 163, 163, 163)
                : const Color.fromARGB(151, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () async {
              if (!(currVer.value < newVer.value)) {
                _chechVersion();
                setState(() {
                  
                });
              }
              else{
                url = Uri.parse((await FirebaseFirestore.instance
                                  .collection('ver')
                                  .doc('currentVer')
                                  .get()).get('link'));
                if (!await launchUrl(url)) {
                showSnackBar(msg: "Couldn't Open link");
              }
              }
              
            },
            child: ListTile(
              subtitle:currVer.value < newVer.value?Text("version ${Strversion.value}",style: TextStyle(color:currentTheme.value
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 0, 0, 0), ),):null ,
              title: Text(
                 currVer.value < newVer.value?
                "Update availabe":"Check for Updates",
                style: TextStyle(
                  color: currentTheme.value
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),

              trailing: SizedBox(
                height: 25,
                width: 25,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.update_outlined,
                      size: 26,
                      color: const Color.fromARGB(204, 0, 0, 0),
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
              ),
            ),
          ),
        ),
        Expanded(child: Text("")),
        //LOGOUT
        Container(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            color: currentTheme.value
                ? const Color.fromARGB(255, 252, 223, 223)
                : const Color.fromARGB(255, 66, 33, 33),
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
              subtitle: Text(
                currentUser.value,
                style: TextStyle(
                  color: currentTheme.value
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 255, 156, 156),
                ),
              ),
              trailing: Icon(
                Icons.logout_rounded,
                color: const Color.fromARGB(199, 244, 67, 54),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showSnackBar({required String msg}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: Duration(seconds: 5)),
    );
  }
}
