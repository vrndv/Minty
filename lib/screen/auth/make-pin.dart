import 'package:SHADE/database.dart';
import 'package:SHADE/screen/home/home.dart';
import 'package:SHADE/screen/views/widgets/auth_wave.dart';
import 'package:SHADE/screen/views/widgets/login_btn.dart';
import 'package:SHADE/services/keys.dart';
import 'package:flutter/material.dart';

class MakePin extends StatefulWidget {
  const MakePin({
    super.key,
    required this.uid,
    required this.email,
    required this.username,
  });

  final String uid;
  final String email;
  final String username;
  @override
  State<MakePin> createState() => _MakePinState();
}

class _MakePinState extends State<MakePin> {
  TextEditingController pinctrl = TextEditingController();
  String pin = "";
  Map<String, String> keys = {};
  ValueNotifier<bool> start = ValueNotifier(false);
  ValueNotifier<bool> created = ValueNotifier(false);
  ValueNotifier<bool> uploaded = ValueNotifier(false);
  var confirm;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AuthWave(),
            SizedBox(height: 30),
            SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 200),
                      Text(
                        'Set Your PIN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          controller: pinctrl,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter PIN',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          pin = pinctrl.text;
                          confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Private Pin"),
                                content: Text(
                                  "Are you sure with the pin : $pin \n\n\nYou can't chsange the pin afterwards \n\n losing the pin will lose your access to the app",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("I'm Sure"),
                                  ),
                                ],
                              );
                            },
                          );
                          confirm ? start.value = true : null;

                          if (confirm) {
                            keys = await createRSAKeys(pin);
                            created.value = true;

                            //uploading user data

                            await DatabaseService().write(
                              data: {
                                "username": widget.username,
                                "email": widget.email,
                                "uid": widget.uid,
                                "publicKey": keys["pubKey"],
                                "EprivateKey": keys["encryptedPrivKey"],
                              },
                            );
                            uploaded.value = true;
                            Future.delayed(Durations.medium4, () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DataBaseForm(
                                      userEmail: widget.username,
                                      page: 0,
                                    );
                                  },
                                ),
                              );
                            });
                          }
                        },
                        child: Login_btn(text: "Confirm"),
                      ),
                      ValueListenableBuilder(
                        valueListenable: start,
                        builder: (context, value, child) {
                          return value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Creating   "),
                                    ValueListenableBuilder(
                                      valueListenable: created,
                                      builder:
                                          (
                                            BuildContext context,
                                            dynamic value,
                                            Widget? child,
                                          ) {
                                            return value
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                  )
                                                : SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  );
                                          },
                                    ),
                                  ],
                                )
                              : SizedBox();
                        },
                      ),
                      SizedBox(height: 10),
                      ValueListenableBuilder(
                        valueListenable: created,
                        builder: (context, value, child) {
                          return created.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Protecting   "),
                                    ValueListenableBuilder(
                                      valueListenable: uploaded,
                                      builder:
                                          (
                                            BuildContext context,
                                            dynamic value,
                                            Widget? child,
                                          ) {
                                            return value
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                  )
                                                : SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  );
                                          },
                                    ),
                                  ],
                                )
                              : SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
