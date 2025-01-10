import 'piece_widget.dart';
import 'package:flutter/material.dart';
import 'chess_board.dart';


import 'dart:math' as math;
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'game_logic.dart';
final logic = GetIt.instance<GameLogic>();

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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
    final mainPlayerColor = logic.args.asBlack ? PieceColor.BLACK : PieceColor.WHITE;
    final secondPlayerColor = logic.args.asBlack ? PieceColor.WHITE : PieceColor.BLACK;

    bool isMainTurn = mainPlayerColor == logic.turn();
    if (logic.isPromotion && (logic.args.isMultiplayer || isMainTurn)) {
      Timer(const Duration(milliseconds: 100), () => _showPromotionDialog(context));
    } else if (logic.gameOver()) {
      Timer(const Duration(milliseconds: 500), () => _showEndDialog(context));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Chess Game',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (!logic.gameOver()) {
              _showSaveDialog(context);
            } else {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
      ),
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


  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.save_alt_rounded,
                color: Colors.white,
                size: 60,
              ),
              const SizedBox(height: 10),
              const Text(
                "Saving",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Do you want to save this game?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      logic.clear();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      final game = logic.save();
                      logic.clear();
                      Navigator.popUntil(context, (route) => route.isFirst);
                      final snackBar = SnackBar(
                        backgroundColor:Colors.black,
                        content: Text(
                          "The game has been saved as ${game.name}",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }







  void _showEndDialog(BuildContext context) {
    var title = "";
    var subtitle = "";

    if (logic.inCheckmate()) {
      title = "Checkmate!";
      subtitle = (logic.turn() == PieceColor.WHITE ? "Black" : "White") + " Wins 🎉";
    } else if (logic.inDraw()) {
      title = "Draw!";
      if (logic.insufficientMaterial()) {
        subtitle = "By Insufficient Material";
      } else if (logic.inThreefoldRepetition()) {
        subtitle = "By Repetition";
      } else if (logic.inStalemate()) {
        subtitle = "By Stalemate";
      } else {
        subtitle = "By the 50-move Rule";
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      final args = logic.args;
                      logic.clear();
                      args.asBlack = !args.asBlack;
                      logic.args = args;
                      Navigator.pop(context);
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>GameScreen()));
                      logic.start();
                    },
                    child: const Text(
                      "Rematch",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      logic.clear();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      "Exit",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showPromotionDialog(BuildContext context) {
    var pieces = [
      PieceType.QUEEN,
      PieceType.ROOK,
      PieceType.BISHOP,
      PieceType.KNIGHT
    ].map((pieceType) => Piece(pieceType, logic.turn()));

    final asBlack = logic.args.asBlack;
    var futureValue = showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Transform.rotate(
          angle: (logic.turn() == PieceColor.BLACK) != asBlack ? math.pi : 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Promote to',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: pieces
                      .map(
                        (piece) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(piece),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          height: 64,
                          width: 64,
                          child: PieceWidget(piece: piece),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    futureValue.then((piece) => logic.promote(piece));
  }

}
