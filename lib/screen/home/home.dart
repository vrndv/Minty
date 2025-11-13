import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SHADE/screen/auth/authenticate.dart';
import 'package:SHADE/screen/home/navbar.dart';
import 'package:SHADE/screen/views/pages/search.dart';
import 'package:SHADE/screen/views/tree.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/screen/views/widgets/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    getPfp();
    getTheme();
  }

  Future<void> getTheme() async {
    final pref = await SharedPreferences.getInstance();
    final val = pref.getBool("currentTheme") ?? false;
    currentTheme.value = val;
  }

  Future<void> getPfp() async {
    var data = await FirebaseFirestore.instance
        .collection("user")
        .where("uid", isEqualTo: userID.value)
        .get();
    var pfp = data.docs.first.data()["pfp"];
    currentPFP.value = pfp ?? currentUser.value;
  }

  @override
  void dispose() {
    currentPageNotifier.value = 0;
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
