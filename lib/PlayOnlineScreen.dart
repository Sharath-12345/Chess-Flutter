import 'piece_widget.dart';
import 'package:flutter/material.dart';
import 'chess_board.dart';

import 'dart:math' as math;
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'game_logic.dart';
final logic = GetIt.instance<GameLogic>();

class PlayOnlineScreen extends StatefulWidget
{
  @override
  State<PlayOnlineScreen> createState() => _PlayOnlineScreenState();
}

class _PlayOnlineScreenState extends State<PlayOnlineScreen> {
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

  void _showSaveDialog(BuildContext context) {}

  void _showPromotionDialog(BuildContext context) {}

  void _showEndDialog(BuildContext context) {}
}