
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/database.dart';
import 'package:popapp/screen/home/home.dart';

class UpdateInfo extends StatefulWidget {
  final String userEmail;
  const UpdateInfo({super.key, required this.userEmail});
  
  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  String err = " ";
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Username",style: TextStyle(color:currentTheme.value
                              ? const Color.fromARGB(242, 255, 253, 253)
                              : const Color.fromARGB(255, 0, 0, 0),),),
        
        elevation: 5.0,
        shadowColor: const Color.fromARGB(82, 0, 0, 0),
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Username",
                  hintStyle: TextStyle(
                    color: currentTheme.value
                              ? Colors.black26
                              : Colors.white30,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color:const Color.fromARGB(82, 255, 254, 254)),
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
                    var isWritten = await DatabaseService().write(
                      data: {
                        "username": nameController.text,
                        "email": widget.userEmail,
                        "uid" :uid,
                      },
                    );
                    if (isWritten == true) {
                      setState(() {
                        err = "Username already exists";
                      });
                    } else {
                      setState(() {
                        err = "";

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DataBaseForm(
                                userEmail: nameController.text, page: 0,
                              );
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
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text("Apply", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidUsername(String username) {
    final validUsernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if(validUsernameRegex.hasMatch(username) && !username.toLowerCase().contains("niga") && !username.toLowerCase().contains("nigga") && !username.toLowerCase().contains("gay")){
      return true;
    } else {
      return false;
    }
  }
}
