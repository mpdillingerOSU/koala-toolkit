import '../user_preferences.dart';
import 'data/koala_data_type.dart';

//TODO: Would eventually want a more optimized version of this that keeps track
// of the individual actions themselves... with a node containing an undo
// and redo action, and depending in which list it is, is the action that it
// actually performs...

class UndoRedoList<T extends KoalaDataType> {
  final List<T> _undos = [];
  late T _current;
  final List<T> _redos = [];

  UndoRedoList(T current){
    _current = current;
  }

  T get current => _current;
  bool get canUndo => _undos.isNotEmpty;
  bool get canRedo => _redos.isNotEmpty;
  bool get isEdited => canUndo && !current.equals(_undos[0]);

  void add(T item){
    _undos.add(_current);
    _current = item;
    _redos.clear();
    if(_undos.length > UserPreferences.getMaxUndos()){
      _undos.removeAt(0);
    }
  }

  T? undo(){
    if(canUndo) {
      _redos.insert(0, _current);
      _current = _undos.removeLast();
      return _current;
    }

    return null;
  }

  T? redo(){
    if(canRedo) {
      _undos.add(_current);
      _current = _redos.removeAt(0);
      return _current;
    }

    return null;
  }
}