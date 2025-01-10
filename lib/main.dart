import 'package:chess_game/mainhome.dart';
import 'package:chess_game/splash_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:get_it/get_it.dart';
import 'game_logic.dart';

void main() async{
  GetIt.instance.registerSingleton<GameLogic>(GameLogicImplementation(), signalsReady: true);

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb)
    {

         await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyA8DpSI7vF_PRsBwHIBojOL72-acWYpx0U",
              authDomain: "chess-dc220.firebaseapp.com",
              projectId: "chess-dc220",
              storageBucket: "chess-dc220.firebasestorage.app",
              messagingSenderId: "1012482118272",
              appId: "1:1012482118272:web:e5af2c0a15c26ee867cc65",
              measurementId: "G-1TPES8KD33"
          ));
    }
  else
    {
     await Firebase.initializeApp();
    }



  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: splash_screen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(


      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue)
                    ),
                      onPressed: ()
                      {
                        signInWithGoogle();
                      },
                      child: Text("Sign In With Google",style: TextStyle(color: Colors.white),)
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue)
                    ),
                      onPressed: ()
                      {
                         signInAsGuest(context);
                      },
                      child: Text("Play As Guest",style: TextStyle(color: Colors.white),)
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );


  }
  signInWithGoogle() async{
    GoogleSignInAccount? googleuser= await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleSignInAuthentication=await googleuser?.authentication;

    AuthCredential credential=GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken:googleSignInAuthentication?.idToken
    );

   UserCredential userCredential=await FirebaseAuth.instance.signInWithCredential(credential);
  }


  Future<void> signInAsGuest(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => mainhome()),
      );
    } catch (e) {
      print("Guest Sign-In Error: $e");
    }
  }
}
