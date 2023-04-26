import '../data/moves/move.dart';

class MoveListBuilder {
  final String name;
  final List<Move> _moves = [];

  MoveListBuilder(this.name, List<Move> moves){
    for(int i = 0; i < moves.length; i++){
      _moves.add(moves[i].copy(moveNum: i + 1));
    }
  }

  List<Move> get moves => [..._moves];
}