import 'package:flutter/material.dart';
import 'package:popapp/screen/auth/login.dart';

class Register extends StatefulWidget {
  final IconData icon;
  final String barTitle;
  final String subText;
  const Register({super.key, required this.icon, required this.barTitle, required this.subText});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

   String textF(){
    if(widget.barTitle == "Login")
      return "Register";
    else{
       return "Register";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.barTitle)),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 SizedBox(height: 20),
                Icon(widget.icon , size: 50,color: Colors.black54 ,),
                SizedBox(height: 20),
                Text("Let's get you started ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                SizedBox(height: 80),

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
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm password",
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
                 SizedBox(height: 20),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.subText),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return Login(icon: Icons.login, barTitle: "Login",subText: "Don't have an account?");
                        },));
                      },
                      child:  Text((widget.barTitle == "Login") ? "  Register" : "  Login" , style: TextStyle(fontWeight: FontWeight.w600),),
                    )
                  ],
                 ),
                 SizedBox(height: 70),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
