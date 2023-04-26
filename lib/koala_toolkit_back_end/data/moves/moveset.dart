import 'move.dart';
import 'move_list.dart';

class Moveset {
  final List<MoveGroup> _groups = [];

  Moveset(List<MoveGroup> groups) {
    _groups.addAll(_copyGroups(groups));
  }

  List<MoveGroup> get groups => _copyGroups(_groups);

  List<MoveGroup> _copyGroups(List<MoveGroup> groups) {
    List<MoveGroup> copies = [];
    for(MoveGroup group in groups) {
      copies.add(group.copy());
    }
    return copies;
  }

  bool get isEmpty => _groups.isEmpty;

  bool get isNotEmpty => _groups.isNotEmpty;

  MoveGroup get first => _groups.first;

  MoveGroup get last => _groups.last;

  int get size => _groups.length;

  MoveGroup get(int index) => _groups[index];

  MoveGroup? getByName(String groupName) {
    for(MoveGroup group in _groups){
      if(groupName == group.name){
        return group.copy();
      }
    }
    return null;
  }

  bool equals(Moveset comp) {
    if (_groups.length != comp._groups.length) return false;

    for (int i = 0; i < _groups.length; i++) {
      if (!_groups[i].equals(comp._groups[i])) return false;
    }

    return true;
  }

  Moveset copy() {
    return Moveset(groups);
  }
}

class MoveGroup {
  final String name;
  final List<MoveGroupPair> _pairs = [];

  MoveGroup(this.name, List<MoveGroupPair> pairs) {
    _pairs.addAll(_copyPairs(pairs));
  }

  List<MoveGroupPair> get pairs => _copyPairs(_pairs);

  List<MoveGroupPair> _copyPairs(List<MoveGroupPair> pairs) {
    List<MoveGroupPair> copies = [];
    for(MoveGroupPair pair in pairs) {
      copies.add(pair.copy());
    }
    return copies;
  }

  bool get isEmpty => _pairs.isEmpty;

  bool get isNotEmpty => _pairs.isNotEmpty;

  MoveGroupPair get first => _pairs.first;

  MoveGroupPair get last => _pairs.last;

  int get size => _pairs.length;

  MoveGroupPair get(int index) => _pairs[index];

  bool equals(MoveGroup comp) {
    if (_pairs.length != comp._pairs.length) return false;

    for (int i = 0; i < _pairs.length; i++) {
      if (!_pairs[i].equals(comp._pairs[i])) return false;
    }

    return true;
  }

  bool contains(MoveGroupPair comp){
    for(MoveGroupPair pair in _pairs) {
      if(comp.equals(pair)) return true;
    }
    return false;
  }

  MoveGroup copy(){
    return MoveGroup(name, pairs);
  }
}

class MoveGroupPair {
  final Move move;
  final MoveList moveList;

  MoveGroupPair(this.move, this.moveList);

  bool equals(MoveGroupPair comp) =>
      move.equals(comp.move) && moveList.equals(comp.moveList);

  MoveGroupPair copy(){
    return MoveGroupPair(move.copy(), moveList.copy());
  }
}
