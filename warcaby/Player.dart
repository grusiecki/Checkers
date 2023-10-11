import 'dart:io';

class Player {
  String nickname = "Joe";

  Player(this.nickname);
}

playersName() {
  String playerName;
  print("Write your nickname");
  playerName = (stdin.readLineSync() ?? "");
  return playerName;
}
