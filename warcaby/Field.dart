import 'Piece.dart';

class Field {
  Piece? piece;
  bool canBeOccupied;

  bool get isOccupied => piece != null;

  Field({required this.piece, required this.canBeOccupied});
}
