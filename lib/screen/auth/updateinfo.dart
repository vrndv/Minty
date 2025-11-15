import 'package:SHADE/screen/auth/make-pin.dart';
import 'package:SHADE/screen/views/widgets/auth_wave.dart';
import 'package:SHADE/screen/views/widgets/avatar.dart';
import 'package:SHADE/screen/views/widgets/login_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/database.dart';
import 'package:SHADE/screen/home/home.dart';

class UpdateInfo extends StatefulWidget {
  final String userEmail;
  const UpdateInfo({super.key, required this.userEmail});

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  String err = " ";
  String uid = FirebaseAuth.instance.currentUser!.uid;
  ValueNotifier<String> userName = ValueNotifier("Your username");
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = new TextEditingController();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AuthWave(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(95, 0, 0, 0),
                    ),
                    width: 300,
                    child: ValueListenableBuilder(
                      valueListenable: userName,
                      builder: (context, value, child) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Avatar(seed: value, r: 50,color: const Color.fromARGB(36, 13, 13, 13),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 120, top: 30),
                              child: Text(
                                value == "" ? "Your username" : value,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      maxLength: 15,
                      controller: nameController,
                      onChanged: (value) {
                        userName.value = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(
                          color: currentTheme.value
                              ? Colors.black26
                              : Colors.white30,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                            color: const Color.fromARGB(82, 255, 254, 254),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    err,
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  //BUTTON
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (isValidUsername(nameController.text) == true) {
                          setState(() {
                            err = "";
                          });
                          var isWritten = await DatabaseService().userExist(data: nameController.text);
                          if (isWritten == true) {
                            setState(() {
                              err = "Username already exists";
                            });
                          }
                          else {
                            setState(() {
                              err = "";
                              userID.value = FirebaseAuth.instance.currentUser!.uid;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MakePin(uid:uid , email: widget.userEmail, username: nameController.text);
                                  },
                                ),
                              );
                            });
                          }
                        } else {
                          setState(() {
                            err = "Invalid username";
                          });
                        }
                        ;
                      },
                      child: Login_btn(text: "Apply")
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidUsername(String username) {
    final validUsernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (validUsernameRegex.hasMatch(username) &&
        !username.toLowerCase().contains("niga") &&
        !username.toLowerCase().contains("nigga") &&
        !username.toLowerCase().contains("gay")) {
      return true;
    } else {
      return false;
    }
  }
}
