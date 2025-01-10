

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'OnlineGameScreen.dart';
import 'game_logic.dart';
 String? roomId;

final logic = GetIt.instance<GameLogic>();

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({Key? key}) : super(key: key);

  @override
  _MatchmakingScreenState createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  bool isLoading = true; // Show loader during matchmaking
  // To track the created/joined room
  static String player1Id="";
  static String player2Id="";
  String? userId; // User ID from Firebase Authentication

  @override
  void initState() {
    super.initState();
    fetchUserIdAndStartMatchmaking();
  }

  Future<void> fetchUserIdAndStartMatchmaking() async {
    try {
      // Fetch the current user's ID
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid; // Get the unique user ID
        print('User ID: $userId');
        await findOrCreateRoom(userId!); // Start matchmaking
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to retrieve user details.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> findOrCreateRoom(String userId) async {
    try {
      final roomsCollection = FirebaseFirestore.instance.collection('rooms');

      // Step 1: Check for a waiting room
      final querySnapshot = await roomsCollection
          .where('isWaiting', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // A waiting room is found
        final roomDoc = querySnapshot.docs.first;
        await roomDoc.reference.update({
          'player2Id': userId,
          'isWaiting': false,
          'currentPlayer': roomDoc['player1Id'], // Player 1 starts
          'gameStatus': 'ongoing', // Start the game
        });
        roomId = roomDoc.id;
        print('Joined existing room: $roomId');
        player2Id=userId;
        navigateToGameScreenWhenReady();
      } else {
        // No waiting room, create a new one
        List<String> board=[
          'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r',
          'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
          '', '', '', '', '', '', '', '',
          '', '', '', '', '', '', '', '',
          '', '', '', '', '', '', '', '',
          '', '', '', '', '', '', '', '',
          'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
          'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'
        ];


        final newRoomDoc = await roomsCollection.add({
          'player1Id': userId,
          'player2Id': null,
          'isWaiting': true,
          'createdAt': FieldValue.serverTimestamp(),
          'currentPlayer': userId, // Player 1 starts
          'boardState': board, // Flattened chessboard
          'gameStatus': 'ongoing', // Game is ongoing
        });

        roomId = newRoomDoc.id;
        player1Id=userId;
        print('Created new room: $roomId');
        navigateToGameScreenWhenReady();
      }
    } catch (e) {
      print('Error during matchmaking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to matchmake. Please try again.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }


  void navigateToGameScreenWhenReady() {
    // Listen for changes in the current room

    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['player2Id'] != null && data['isWaiting'] == false) {
          // Opponent joined the room
          final bool isWhite = data['player1Id'] == userId;
          logic.args.isMultiplayer=true;
            logic.start();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnlineGameScreen(
                gameId: roomId!,
                player1Id: data['player1Id'],
                player2Id: data['player2Id'],
              ),
            ),
          );
        }
      }
    });

    // Update the UI to show "Waiting for opponent..."
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.black,
        child: Center(
          child: isLoading
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                'Finding an opponent...',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                'Waiting for opponent...',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'Room ID: $roomId',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
