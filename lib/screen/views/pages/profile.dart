import 'package:SHADE/screen/views/widgets/picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/screen/auth/authenticate.dart';
import 'package:SHADE/screen/views/widgets/avatar.dart';
import 'package:SHADE/screen/views/widgets/profile_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      Strversion.value =
          (await FirebaseFirestore.instance
                  .collection('ver')
                  .doc('currentVer')
                  .get())
              .get('version ');
      i = !i;
      setState(() {
        print(Strversion.value);
      });
    }
  }

  Future<void> saveThemeValue({required bool val}) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('currentTheme', val);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = currentTheme.value
        ? Colors.grey[200]
        : const Color.fromARGB(225, 20, 20, 20);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,

        title: Text(
          'Profile',
          style: TextStyle(
            color: currentTheme.value ? Colors.black : Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: currentTheme.value ? Colors.black : Colors.white,
            ),
            onPressed: () async {
              // Confirm logout with dialog
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Auth()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            tooltip: "Logout",
          ),
        ],
      ),

      body: Column(
        children: [
          //AVATAR
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 250,
                  color: bgColor,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 17),
                          child: Text(
                            currentUser.value,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "${(chatLen.value).toInt()} chats",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ValueListenableBuilder(
                          valueListenable: currentPFP,
                          builder: (context, value, child) =>
                              Avatar(seed: currentPFP.value, r: 60),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: 210,
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AvatarPicker();
                                },
                              ),
                            );
                          },
                          onLongPress: () {
                            isProfanity.value = !isProfanity.value;
                            setState(() {});
                            showSnackBar(
                              msg:
                                  " Profanity :${isProfanity.value ? "ON" : "OFF"}",
                            );
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: Text("")),
          //RESET PASSWORD
          ProfileButoon(
            function: () async {
              String text = "";
              if (isLogged.value) {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: currentEmail.value,
                );
                text =
                    "Reset link sent to: ${currentEmail.value}\nChech Spam folders ";
                isLogged.value = false;
                showSnackBar(msg: text);
                await Future.delayed(Duration(seconds: 4));
                FirebaseAuth.instance.signOut();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Auth()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            title: "Reset Password",
            icon: Icons.lock_reset_outlined,
          ),

          //THEME BUTTON
          ProfileButoon(
            function: () {
              setState(() {
                currentTheme.value = !currentTheme.value;
                saveThemeValue(val: currentTheme.value);
              });
            },
            title: 'Theme',
            icon: Icons.brightness_medium_sharp,
          ),

          //CHECK UPDATE
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              color: currentTheme.value
                  ? const Color.fromARGB(52, 163, 163, 163)
                  : const Color.fromARGB(151, 255, 255, 255),
              borderRadius: BorderRadius.circular(8),
            ),

            child: ListTile(
              onTap: () async {
                if (!(currVer.value < newVer.value)) {
                  _chechVersion();
                  setState(() {
                    showSnackBar(msg: "${newVer.value}");
                  });
                } else {
                  url = Uri.parse(
                    (await FirebaseFirestore.instance
                            .collection('ver')
                            .doc('currentVer')
                            .get())
                        .get('link'),
                  );
                  if (!await launchUrl(url)) {
                    showSnackBar(msg: "Couldn't Open link");
                  }
                }
              },
              subtitle: currVer.value < newVer.value
                  ? Text(
                      "version ${Strversion.value}",
                      style: TextStyle(
                        color: currentTheme.value
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 0, 0, 0),
                      ),
                    )
                  : null,
              title: Text(
                currVer.value < newVer.value
                    ? "Update availabe"
                    : "Check for Updates",
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
          SizedBox(height: 30),
        ],
      ),
    );
  }

  void showSnackBar({required String msg}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: Duration(seconds: 5)),
    );
  }
}
