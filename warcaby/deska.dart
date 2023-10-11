import 'Field.dart';
import 'Player.dart';
import 'Piece.dart';

class Coordinates {
  int coordinatesX;
  int coordinatesY;

  Coordinates({required this.coordinatesX, required this.coordinatesY});
}
class Board{
  Deska board;
  List<Coordinates> emptyFields;
  List<Coordinates> player1Fields;
  List<Coordinates> player2Fields;
  CapturedPieces capturedPlayer1Pieces;
  CapturedPieces capturedPlayer2Pieces;

  Board(this.board, this.emptyFields, this.player1Fields, this.player2Fields, this.capturedPlayer1Pieces, this.capturedPlayer2Pieces);
}
typedef Deska = List<List<Field?>>;
Board board(Player player1, Player player2){
Deska newBoard = [];
List<Coordinates> player1Fields = [];
List<Coordinates> player2Fields = [];
List<Coordinates> emptyFields = [];
CapturedPieces capturedPlayer1Pieces = CapturedPieces([]);
CapturedPieces capturedPlayer2Pieces = CapturedPieces([]);
for (var row = 0; row < 8; row++) // creating checkers board
{
  newBoard.add([]);
  for (var column =0; column < 8; column++){
  var canBeOccupied = (row%2==0&& column%2!=0) || (row %2 != 0 && column %2 ==0);
  if (canBeOccupied == true && row<=2){
    newBoard[row].add(Field(
        piece: Piece(player1),
        canBeOccupied: canBeOccupied));
    player1Fields.add(Coordinates(coordinatesX: row, coordinatesY: column));

  }else if(canBeOccupied == true && row >=3 && row<=4){
    newBoard[row].add(Field(
        piece: null,
        canBeOccupied: canBeOccupied));
    emptyFields.add(Coordinates(coordinatesX: row, coordinatesY: column));
  }else if(canBeOccupied == true && row>=5){
    newBoard[row]
            .add(Field(piece: Piece(player2), canBeOccupied: canBeOccupied));
    player2Fields.add(Coordinates(coordinatesX: row, coordinatesY: column));
      }else{
      newBoard[row].add(Field(
        piece: null,
        canBeOccupied: canBeOccupied
      ));
  }
  }
}
  return Board(newBoard,emptyFields,player1Fields,player2Fields,capturedPlayer1Pieces,capturedPlayer2Pieces);
}
