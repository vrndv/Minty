import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';

class ProfileButoon extends StatefulWidget {
  final String title;
  final Function() function;
  const ProfileButoon({super.key , required Function() this.function  ,required String this.title});

  @override
  State<ProfileButoon> createState() => _ProfileButoonState();
}

class _ProfileButoonState extends State<ProfileButoon> {
  @override
  Widget build(BuildContext context) {
    return Container(

          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            color: currentTheme.value
                ? const Color.fromARGB(113, 163, 163, 163)
                : const Color.fromARGB(151, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),

          ),

          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
                onTap: widget.function,
              child: ListTile(
               
                title: Text(
                  widget.title,
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
        );
  }
}