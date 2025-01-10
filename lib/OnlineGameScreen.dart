import 'package:chess_game/chess_board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OnlineGameScreen extends StatefulWidget {
  final String gameId;
  final String player1Id;
  final String player2Id;

  OnlineGameScreen({required this.gameId, required this.player1Id, required this.player2Id});

  @override
  _OnlineGameScreenState createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {


  void update() => setState(() => {});
  @override
  void initState() {
    logic.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    logic.removeListener(update);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play Online')),
      body: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: ChessBoard(),

            ),
          ),
        ),
      ),
    );
  }
}
