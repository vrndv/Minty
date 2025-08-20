import 'package:flutter/material.dart';

class LoginorReg extends StatefulWidget {
  final IconData icon;
  final String barTitle;
  const LoginorReg({super.key, required this.icon, required this.barTitle});

  @override
  State<LoginorReg> createState() => _LoginorRegState();
}

class _LoginorRegState extends State<LoginorReg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.barTitle)),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon),
              SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 1.5)),
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(55, 0, 0, 0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 1.5)),
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(55, 0, 0, 0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              Center(
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(5)),
                  child: Center(child: Text(widget.barTitle , style:TextStyle(color: Colors.white,),)),
                ),
              ),
               SizedBox(height: 250),
             
            ],
          ),
        ),
      ),
    );
  }
}
