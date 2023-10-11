import 'package:test/expect.dart';
import 'package:zadania/zadania.dart' as zadania;
import '../warcaby/Field.dart';
import '../warcaby/Movement.dart';
import '../warcaby/Piece.dart';
import '../warcaby/Player.dart';
import '../warcaby/deska.dart';
import 'dart:io';
import 'Player.dart';
import 'deska.dart';


void main(List<String> arguments) {
  print("Start Game");
  Player player1 = Player(playersName());
  Player player2 = Player(playersName());
  BeatOrMove beatOrMovePlayer1;
  BeatOrMove beatOrMovePlayer2;
  // print(player1.nickname);
  bool endGame= false;
  Board checkersBoard = board(player1, player2);
  while(endGame == false) {
    beatOrMovePlayer1 = canPlayerMove(1, checkersBoard, player1, player2);
    checkersBoard =
        whereToMove(player1, player2, beatOrMovePlayer1, checkersBoard);
    beatOrMovePlayer2 = canPlayerMove(2, checkersBoard, player2, player1);
    checkersBoard =
        whereToMove(player2, player1, beatOrMovePlayer2, checkersBoard);
    if (checkersBoard.capturedPlayer1Pieces.capturedPieces.length >= 12 || checkersBoard.capturedPlayer2Pieces.capturedPieces.length >=12){
      endGame = true;
    }
  }
}
