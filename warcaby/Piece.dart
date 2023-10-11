import 'dart:ffi';

import 'Field.dart';
import 'Player.dart';

class Piece {
  Player owner;

  Piece(this.owner);
}
class CapturedPieces{
List<Piece?> capturedPieces = [];
CapturedPieces(this.capturedPieces);
}

