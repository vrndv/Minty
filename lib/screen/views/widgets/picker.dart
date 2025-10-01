import 'dart:math';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/database.dart';
import 'package:flutter/material.dart';

class AvatarPicker extends StatefulWidget {
  const AvatarPicker({super.key});

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  List seed = ["1", "2", "3", "4", "5", "7"];
  @override
  void initState() {
    super.initState();
    getSeed();
  }

  void getSeed() {
    const char =
        "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
    final random = Random();
    for (var i = 0; i < 6; i++) {
      seed[i] = List.generate(
        5,
        (index) => char[random.nextInt(char.length)],
      ).join();
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Column(
              spacing: 20,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(top: 20),
                    child: Text(
                      "CHOOSE YOUR AVATAR",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  spacing: 20,
                  children: [
                    AvatarItem(seed: seed[0]),
                    AvatarItem(seed: seed[1]),
                  ],
                ),
                Row(
                  spacing: 20,
                  children: [
                    AvatarItem(seed: seed[2]),
                    AvatarItem(seed: seed[3]),
                  ],
                ),
                Row(
                  spacing: 20,
                  children: [
                    AvatarItem(seed: seed[4]),
                    AvatarItem(seed: seed[5]),
                  ],
                ),
                TextButton(
                //style: TextButton.styleFrom(backgroundColor:const Color.fromARGB(200, 51, 77, 111) ),
                  child: CircleAvatar(child: Text("🎲",style: TextStyle(fontSize: 40),),radius: 33,),
                  onPressed: () {
                    getSeed();
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AvatarItem extends StatelessWidget {
  final String seed;
  const AvatarItem({Key? key, required this.seed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       currentPFP.value = seed;
       DatabaseService().pushAvatar(id: userID.value, seed: seed);
       Navigator.pop(context);
      },
      child: CircleAvatar(
        radius: 80,
        backgroundImage: NetworkImage(
          "https://api.dicebear.com/9.x/adventurer/png?seed=$seed&scale=100",
        ),
      ),
    );
  }
}
