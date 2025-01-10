import 'package:chess_game/main.dart';
import 'package:chess_game/mainhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class splash_screen extends StatefulWidget
{
  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {

  @override
  void initState() {
    super.initState();
    checksignin();
  }






  @override
  Widget build(BuildContext context) {


    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);



    return Scaffold(
       body: Container(
   child: Center(
child: Image(
height: double.infinity,
fit: BoxFit.fitHeight,
image: AssetImage('assets/images/chess_splash.png'))
),
)
,
   );
  }

  void checksignin() async{
    await Future.delayed(Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => mainhome()),
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Chess")),
      );
    }

  }
}