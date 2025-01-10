import 'package:chess_game/choose_color_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'game_logic.dart';
final logic = GetIt.instance<GameLogic>();



class ChooseDifficultyScreen extends StatelessWidget {
  const ChooseDifficultyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const difficulties = [
      "Kid", "Easy", "Normal", "Hard", "Unreal"
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
         
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: Column(
               // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text("Choose Difficulty",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 27),),
                  ),
                  for (final difficulty in difficulties)
                    TextButton(
                        onPressed: () {
                          logic.args.difficultyOfAI = difficulty;
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseColorScreen()));
                        },
                        child: Text(difficulty, textScaleFactor: 2.0,style: TextStyle(color: Colors.white),)
                    ),
                ]
            ),
          ),
        )
    );
  }
}
