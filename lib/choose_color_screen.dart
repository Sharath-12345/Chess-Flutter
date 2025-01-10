import 'package:chess_game/game_screen.dart';
import 'package:flutter/material.dart';
import 'piece_widget.dart';

import 'package:get_it/get_it.dart';
import 'game_logic.dart';
final logic = GetIt.instance<GameLogic>();


class ChooseColorScreen extends StatelessWidget {
  ChooseColorScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Text("You Play As",style: TextStyle(color: Colors.white,
                     fontSize: 25,fontWeight: FontWeight.bold)),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Flexible(
                          child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                              child: SizedBox(
                                  width: 150, height: 150,
                                  child: PieceWidget(piece: Piece(PieceType.KING, PieceColor.BLACK))
                              ),
                              onTap: () {
                                logic.args.asBlack = true;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GameScreen()),
                                );
                                logic.start();
                              }
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                              child: SizedBox(
                                  width: 150, height: 150,
                                  child: PieceWidget(piece: Piece(PieceType.KING, PieceColor.WHITE))
                              ),
                              onTap: () {
                                logic.args.asBlack = false;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>GameScreen()),
                                );
                                logic.start();
                              }
                          ),
                        )
                      ]
                  ),
                ],
              )
          ),
        ));
  }
}
