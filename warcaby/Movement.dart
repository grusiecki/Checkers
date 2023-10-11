import 'dart:ffi';
import 'dart:io';
import 'package:zadania/zadania.dart';
import 'Field.dart';
import 'Piece.dart';
import 'Player.dart';
import 'deska.dart';

class BeatOrMove {
  bool canBeat;
  bool canMove;
  List<Coordinates> pieceToBeat;
  List<Coordinates> goingToBeatPiece;
  List<Coordinates> moveOptions;
  List<Coordinates> movingPiece;
  int whichPlayerMoves;
  Player player;

  BeatOrMove(this.canBeat, this.canMove, this.pieceToBeat, this.moveOptions,
      this.whichPlayerMoves, this.goingToBeatPiece, this.movingPiece, this.player);
}




BeatOrMove canPlayerMove( int whichPlayerMove, Board board, Player player1,
    Player player2) //checking possible moves for both players
{

bool canBeat = false;
bool canMove = false;
List <Coordinates> pieceToBeat = [];
  List <Coordinates> moveOptions = [];
  List <Coordinates> goingToBeatPiece = [];
  List <Coordinates> movingPiece = [];
  int newWhichPlayerMove = whichPlayerMove;
  Player player = player1;
  Coordinates option1Coordinates;
  Coordinates option2Coordinates;
  List <Coordinates> realPlayer1Fields;
  List <Coordinates> realPlayer2Fields;
  if(whichPlayerMove==1){
    realPlayer1Fields = board.player1Fields;
    realPlayer2Fields = board.player2Fields;
  } else{
    realPlayer1Fields=board.player2Fields;
    realPlayer2Fields=board.player1Fields;
  }

  for (var field in realPlayer1Fields) {
    option1Coordinates = firstOptionToBeatMove(field, whichPlayerMove);
    option2Coordinates = secondOptionToBeatMove(field, whichPlayerMove);
    for (var opponentField in realPlayer2Fields) {
      if (option1Coordinates.coordinatesX == opponentField.coordinatesX && option1Coordinates.coordinatesY == opponentField.coordinatesY ) {
        canBeat = true;
        pieceToBeat.add(opponentField);
        goingToBeatPiece.add(field);
      } else if (option2Coordinates.coordinatesX == opponentField.coordinatesX && option2Coordinates.coordinatesY == opponentField.coordinatesY) {
        canBeat = true;
        pieceToBeat.add(opponentField);
        goingToBeatPiece.add(field);
      }
    }if(canBeat==false){
      for(var emptyField in board.emptyFields){
        if(option1Coordinates.coordinatesX == emptyField.coordinatesX && option1Coordinates.coordinatesY == emptyField.coordinatesY){
          canMove=true;
          moveOptions.add(emptyField);
          movingPiece.add(field);
        }else if (option2Coordinates.coordinatesX == emptyField.coordinatesX && option2Coordinates.coordinatesY == emptyField.coordinatesY) {
          canMove=true;
          moveOptions.add(emptyField);
          movingPiece.add(field);
        }
      }
    }
  }
  return BeatOrMove(canBeat, canMove, pieceToBeat, moveOptions, newWhichPlayerMove, goingToBeatPiece, movingPiece, player);
}

Board whereToMove(Player player1, Player player2, BeatOrMove info, Board board) {
  List<Coordinates>newPlayer1Fields = [];
  List<Coordinates>newPlayer2Fields = [];
  List<Coordinates>newEmptyFields= [];
  Board newBoard = board;
  String fakePlayer1;
  String fakePlayer2;
  if (info.canBeat) {
    if (info.pieceToBeat.length == 1)
    {
      newBoard = onlyOneOptionToBeat(board, info, player1, player2);
    }else if (info.pieceToBeat.length>1)
   {
      newBoard = moreThanOneOptionToBeat(board, info, player1, player2);
  }
} else {
    newBoard = optionsToMove(board, info, player1, player2);
  }
  if(info.whichPlayerMoves ==1){
   fakePlayer1 = player1.nickname;
   fakePlayer2 = player2.nickname;
  }else{
    fakePlayer1 = player2.nickname;
    fakePlayer2 = player1.nickname;
  }
  for (var row = 0; row < 8; row++)
      {
    for (var column =0; column < 8; column++) {
      if(newBoard.board[row][column]?.canBeOccupied == true) {
        if (newBoard.board[row][column]?.piece?.owner.nickname ==
            fakePlayer1) {
          newPlayer1Fields.add(
              Coordinates(coordinatesX: row, coordinatesY: column));
        } else if (newBoard.board[row][column]?.piece?.owner.nickname ==
            fakePlayer2) {
          newPlayer2Fields.add(
              Coordinates(coordinatesX: row, coordinatesY: column));
        } else if (newBoard.board[row][column]?.piece == null) {
          newEmptyFields.add(
              Coordinates(coordinatesX: row, coordinatesY: column));
        }
      }
    }
      }
  newBoard.player1Fields = newPlayer1Fields;
  newBoard.player2Fields = newPlayer2Fields;
  newBoard.emptyFields = newEmptyFields;

  return newBoard;
}
Coordinates firstOptionToBeatMove(Coordinates coordinates, int whichPlayerMove){
  Coordinates desirableFieldCoordinates;
  if (whichPlayerMove == 1){
     desirableFieldCoordinates = Coordinates (coordinatesX: coordinates.coordinatesX+1, coordinatesY: coordinates.coordinatesY-1);
    return desirableFieldCoordinates;
  }else {
    desirableFieldCoordinates = Coordinates(coordinatesX: coordinates.coordinatesX-1, coordinatesY: coordinates.coordinatesY-1);
    return desirableFieldCoordinates;
  }
}
Coordinates secondOptionToBeatMove(Coordinates coordinates, int whichPlayerMove){
  Coordinates desirableFieldCoordinates;
  if (whichPlayerMove == 1){
    desirableFieldCoordinates = Coordinates (coordinatesX: coordinates.coordinatesX+1, coordinatesY: coordinates.coordinatesY+1);
    return desirableFieldCoordinates;
  }else {
    desirableFieldCoordinates = Coordinates(coordinatesX: coordinates.coordinatesX-1, coordinatesY: coordinates.coordinatesY+1);
    return desirableFieldCoordinates;
  }
}
Board onlyOneOptionToBeat(Board board, BeatOrMove info, Player player1, Player player2){
 Board newBoard = board;
  print(
      '${info.player
          .nickname}: You must beat. You have only one option to beat. Piece from ${info
          .goingToBeatPiece[0].coordinatesX } ${info
          .goingToBeatPiece[0].coordinatesY } beat ${info.pieceToBeat[0].coordinatesX} ${info.pieceToBeat[0].coordinatesY}' ) ;
 Field? winField = newBoard.board[info.goingToBeatPiece[0].coordinatesX][info.goingToBeatPiece[0].coordinatesY];
 Field? loseField = newBoard.board[info.pieceToBeat[0].coordinatesX][info.pieceToBeat[0].coordinatesY];
  if(loseField?.piece?.owner.nickname == player1.nickname){
    newBoard.capturedPlayer1Pieces.capturedPieces.add(loseField?.piece);
  }else if(loseField?.piece?.owner.nickname == player2.nickname){
    newBoard.capturedPlayer2Pieces.capturedPieces.add(loseField?.piece);
  }
 newBoard.board[info.pieceToBeat[0].coordinatesX][info.pieceToBeat[0].coordinatesY]=winField;
 newBoard.board[info.goingToBeatPiece[0].coordinatesX][info.goingToBeatPiece[0].coordinatesY]=Field(piece: null, canBeOccupied: true);
  return newBoard;
    }
Board moreThanOneOptionToBeat(Board board, BeatOrMove info, Player player1, Player player2){
      print("${info.player.nickname}; You have to beat");
      int numberOfOptions=0;
      String answer = "";
      int answerInt = -1;
      bool rightAnswer = false;
      Board newBoard = board;
      for( numberOfOptions; numberOfOptions < info.pieceToBeat.length; numberOfOptions++){
        print("$numberOfOptions. Piece from ${info
            .goingToBeatPiece[numberOfOptions].coordinatesX } ${info
            .goingToBeatPiece[numberOfOptions].coordinatesY } beat ${info.pieceToBeat[numberOfOptions].coordinatesX} ${info.pieceToBeat[numberOfOptions].coordinatesY}");
      }
      while(rightAnswer == false) {
        print(
            "Which option to beat do you prefer? Write number from 0 to ${numberOfOptions-1}");
        answer = stdin.readLineSync() ?? "";
        try {
          answerInt = int.parse(answer);
        } catch (e) {
          answerInt = -1;
        }
        if (answerInt <= 0 && answerInt >= numberOfOptions-1) {
          Field? winField = newBoard.board[info.goingToBeatPiece[answerInt].coordinatesX][info.goingToBeatPiece[answerInt].coordinatesY];
          Field? loseField = newBoard.board[info.pieceToBeat[answerInt].coordinatesX][info.pieceToBeat[answerInt].coordinatesY];
          if(loseField?.piece?.owner.nickname == player1.nickname){
            newBoard.capturedPlayer1Pieces.capturedPieces.add(loseField?.piece);
          }else if(loseField?.piece?.owner.nickname == player2.nickname){
            newBoard.capturedPlayer2Pieces.capturedPieces.add(loseField?.piece);
          }
          newBoard.board[info.pieceToBeat[answerInt].coordinatesX][info.pieceToBeat[answerInt].coordinatesY]=winField;
          newBoard.board[info.goingToBeatPiece[answerInt].coordinatesX][info.goingToBeatPiece[answerInt].coordinatesY]=Field(piece: null, canBeOccupied: true);
          rightAnswer = true;
        } else {
          print("You answer must be a number from 0 to ${numberOfOptions-1}");
        }
      }
      return newBoard;
    }
Board optionsToMove(Board board, BeatOrMove info, Player player1, Player player2){
      print("${info.player.nickname}; You have to move");
      int numberOfOptions=0;
      String answer = "";
      int answerInt = -1;
      bool rightAnswer = false;
      Board newBoard = board;
      for(numberOfOptions; numberOfOptions < info.moveOptions.length; numberOfOptions++){
        print("$numberOfOptions. Piece from ${info
            .movingPiece[numberOfOptions].coordinatesX} ${info
            .movingPiece[numberOfOptions].coordinatesY} move ${info.moveOptions[numberOfOptions].coordinatesX} ${info.moveOptions[numberOfOptions].coordinatesY}");
      }
      while(rightAnswer == false ) {
        print(
            "Which option to move do you prefer? Write number from 0 to ${numberOfOptions-1}");
        answer = stdin.readLineSync() ?? "";
        try {
          answerInt = int.parse(answer);
        } catch (e) {
          answerInt = -1;
        }
        if (answerInt >= 0 && answerInt <= numberOfOptions-1) {
          Field? oldField = newBoard.board[info.movingPiece[answerInt].coordinatesX][info.movingPiece[answerInt].coordinatesY];
          Field? newField = newBoard.board[info.moveOptions[answerInt].coordinatesX][info.moveOptions[answerInt].coordinatesY];
          newBoard.board[info.moveOptions[answerInt].coordinatesX][info.moveOptions[answerInt].coordinatesY]=oldField;
          newBoard.board[info.movingPiece[answerInt].coordinatesX][info.movingPiece[answerInt].coordinatesY]=Field(piece: null, canBeOccupied: true);
          rightAnswer = true;

        } else {
          print("You answer must be a number from 0 to ${numberOfOptions-1}");
        }
      } return newBoard;
    }
// showMeTheBoard(Board board, List<Coordinates> playerCoordinates, List<Coordinates> opponentCoordinates, Player player1, Player player2){
//   for(var row = 0; row<board.board.length;row++){
//     List<String> wholeRow = [];
//     for(var column = 0; column<board.board[row].length; column++) {
//       if (board.board[row][column]?.canBeOccupied == false) {
//         wholeRow.add("+");
//       } else {
//         bool chosenPiece = false;
//         int numberOfVariant = 0;
//         bool chosenVariant = false;
//         for (numberOfVariant = 0; numberOfVariant <
//             opponentCoordinates.length; numberOfVariant++) {
//           if (opponentCoordinates[numberOfVariant].coordinatesX == row &&
//               opponentCoordinates[numberOfVariant].coordinatesY == column) {
//             chosenVariant = true;
//             break;
//           } else {
//             chosenVariant = false;
//           }
//         }
//       if( chosenVariant == true){
//         wholeRow.add(numberOfVariant.toString());
//       }else{
//         if(board.board[row][column]?.piece?.owner.nickname == player1.nickname){
//           wholeRow.add('A');
//         }else if(board.board[row][column]?.piece?.owner.nickname == player2.nickname){
//           wholeRow.add('B');
//         }else{
//           wholeRow.add("E");
//         }
//       }
//       }
//     }
//     print(wholeRow);
//   }
//
// }





