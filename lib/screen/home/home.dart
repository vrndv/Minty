import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popapp/screen/auth/authenticate.dart';
import 'package:popapp/screen/home/navbar.dart';
import 'package:popapp/screen/views/pages/search.dart';
import 'package:popapp/screen/views/tree.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/screen/views/widgets/avatar.dart';

class DataBaseForm extends StatefulWidget {
  final String userEmail;
  final int page;
  const DataBaseForm({super.key, required this.userEmail, required this.page});

  @override
  State<DataBaseForm> createState() => _DataBaseFormState();
}

class _DataBaseFormState extends State<DataBaseForm> {
  DateTime? _lastBackPressTime;
  bool _canPop = false;
  Future<void> _handlePop() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > Duration(seconds: 2)) {
      _lastBackPressTime = now;
      if (isSearch.value) {
        isSearch.value = false;
        _canPop = false;
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      setState(() {
        _canPop = true;
      });
      Navigator.of(context).pop();
      SystemNavigator.pop(); // Closes the app (Android only)
    }
  }

  TextEditingController textController = TextEditingController();
  int id = 0;
  String? text;
  String? out;
  String err = " ";
  @override
  void initState() {
    super.initState();
    currentUser.value = widget.userEmail;
    currentEmail.value = FirebaseAuth.instance.currentUser!.email!;
    if (currentUser.value == "null") {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Auth();
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    currentPageNotifier.value = 0;
    print("bye world");
    super.dispose();
  }

  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _handlePop();
        }
      },
      child: Scaffold(
        //sabari
        appBar: AppBar(
          title: ValueListenableBuilder(
            valueListenable: currentPageNotifier,
            builder: (context, value, child) {
              return value != 1 ? Text('Pop Home') : Text('Profile');
            },
          ),
          elevation: 20,
          shadowColor: const Color.fromARGB(83, 0, 0, 0),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ValueListenableBuilder(
                valueListenable: currentPageNotifier,
                builder: (context, value, child) {
                  return value != 1
                      ?  Avatar(seed: currentUser.value, r: 20)
                      : GestureDetector(
                          onTap: () {
                            //ADD POP UP WARNING HERE => sabarikasi
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Logout'),
                                  content: const Text(
                                    'Do you really want to leave us',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        //closes the dialgoues
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        //closes the dialgoues
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Auth(),
                                          ),
                                        );
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            width: 50,
                            child: Icon(Icons.logout_outlined),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: isSearch,
          builder: (BuildContext context, dynamic value, Widget? child) {
            return isSearch.value ? searchPage() : WidgetTree();
          },
        ),

        bottomNavigationBar: Navbar(),
      ),
    );
  }
}
