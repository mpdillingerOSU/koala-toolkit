import '../file_management.dart';
import '../koala_strings.dart';
import 'data/moves/move.dart';
import 'data/moves/move_list.dart';
import 'data/moves/moveset.dart';
import 'data/project.dart';
import 'data/unit_field.dart';
import 'data/unit_palette.dart';
import 'data/units/unit.dart';
import 'data/units/unit_list.dart';
import 'databases/move_lists_database.dart';
import 'databases/moves_database.dart';
import 'databases/projects_database.dart';
import 'databases/unit_lists_database.dart';
import 'databases/unit_palettes_database.dart';
import 'databases/units_database.dart';

class ProjectPacket {
  late Project _project;
  late List<Project> _allProjects;
  late MoveListsDatabase _moveListsDatabase;
  late List<MoveList> _moveLists;
  late Map<String, MovesDatabase> _moveDatabases;
  late Map<String, List<Move>> _moveMap;
  late UnitPalettesDatabase _unitPaletteDatabase;
  late UnitPalette _unitPalette;
  late UnitListsDatabase _unitListsDatabase;
  late List<UnitList> _unitLists;
  late Map<String, UnitsDatabase> _unitDatabases;
  late Map<String, List<Unit>> _unitMap;

  ProjectPacket._create({
    required Project project,
    required List<Project> allProjects,
    required MoveListsDatabase moveListsDatabase,
    required List<MoveList> moveLists,
    required Map<String, MovesDatabase> moveDatabases,
    required Map<String, List<Move>> moveMap,
    required UnitPalettesDatabase unitPaletteDatabase,
    required UnitPalette unitPalette,
    required UnitListsDatabase unitListsDatabase,
    required List<UnitList> unitLists,
    required Map<String, UnitsDatabase> unitDatabases,
    required Map<String, List<Unit>> unitMap,
  }) {
    _project = project;
    _allProjects = [...allProjects];
    _moveListsDatabase = moveListsDatabase;
    _moveLists = moveLists;
    _moveDatabases = moveDatabases;
    _moveMap = moveMap;
    _unitPaletteDatabase = unitPaletteDatabase;
    _unitPalette = unitPalette;
    _unitListsDatabase = unitListsDatabase;
    _unitLists = unitLists;
    _unitDatabases = unitDatabases;
    _unitMap = unitMap;
  }

  static Future<List<Project>> generateAllProjects() async {
    List<Project> list = [];
    Map<String, ProjectsDatabase> allDbs = await ProjectsDatabase.allDatabases;
    List<String> keys = allDbs.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      Project? project = await allDbs[keys[i]]?.read();
      if (project == null) {
        String createdTime = DateTime.now().toUtc().toIso8601String();
        project = Project(
          name: keys[i],
          createdDate: createdTime,
          lastSavedDate: createdTime,
          version: 0.1, //TODO: change to a getter for the current version held in the settings page...
        );
        allDbs[keys[i]]?.update(project);
      }
      list.add(project);
    }
    return list;
  }

  ///Public factory method for construction of an instance of ProjectPacket.
  static Future<ProjectPacket?> create(Project project) async {
    List<Project> allProjects = await generateAllProjects();

    MoveListsDatabase? moveListsDatabase = await MoveListsDatabase.get(project);
    if (moveListsDatabase == null) return null;

    List<MoveList> moveLists = await moveListsDatabase.readAll();

    Map<String, MovesDatabase> moveDatabases =
        await MovesDatabase.getAll(project);

    Map<String, List<Move>> moveMap = await _createMoveLists(
      project,
      moveDatabases,
    );

    UnitPalettesDatabase? unitPaletteDatabase =
        await UnitPalettesDatabase.get(project);
    if (unitPaletteDatabase == null) return null;

    UnitPalette unitPalette = await _createUnitPalette(unitPaletteDatabase);

    UnitListsDatabase? unitListsDatabase = await UnitListsDatabase.get(project);
    if (unitListsDatabase == null) return null;

    List<UnitList> unitLists = await unitListsDatabase.readAll();

    Map<String, UnitsDatabase> unitDatabases =
        await UnitsDatabase.getAll(project);

    Map<String, List<Unit>> unitMap = await _createUnitLists(
      project,
      unitDatabases,
    );

    return ProjectPacket._create(
      project: project,
      allProjects: allProjects,
      moveListsDatabase: moveListsDatabase,
      moveLists: moveLists,
      moveDatabases: moveDatabases,
      moveMap: moveMap,
      unitPaletteDatabase: unitPaletteDatabase,
      unitPalette: unitPalette,
      unitListsDatabase: unitListsDatabase,
      unitLists: unitLists,
      unitDatabases: unitDatabases,
      unitMap: unitMap,
    );
  }

  Future<void> renameProject(String name) async {
    Project renamedProject = Project(
      name: name,
      createdDate: project.createdDate,
      lastSavedDate: DateTime.now().toUtc().toIso8601String(),
      version: project.version,
    );

    bool success = await FileManagement.renameProject(
        project.directoryName, renamedProject.directoryName);

    if (!success) return;

    _project = renamedProject;

    ProjectsDatabase? db = await ProjectsDatabase.get(_project.directoryName);

    if (db == null) return;

    await db.update(_project);
    await _updateLastEdit();
    _refresh();
  }

  bool isProjectNameTaken(String name) {
    if(normativelyEqual(name, project.name)) return false;

    for (Project project in _allProjects) {
      if (normativelyEqual(name, project.name)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _refresh() async {
    _refreshMoves();
    _refreshUnits();
  }

  Future<void> _refreshMoves() async {
    MoveListsDatabase? moveListsDatabase = await MoveListsDatabase.get(project);
    if (moveListsDatabase == null) return;

    _moveListsDatabase = moveListsDatabase;
    _moveLists = await _moveListsDatabase.readAll();
    _moveDatabases = await MovesDatabase.getAll(project);
    _moveMap = await _createMoveLists(
      project,
      _moveDatabases,
    );
  }

  Future<void> _refreshUnits() async {
    UnitPalettesDatabase? unitPaletteDatabase =
        await UnitPalettesDatabase.get(project);
    if (unitPaletteDatabase == null) return;

    UnitListsDatabase? unitListsDatabase = await UnitListsDatabase.get(project);
    if (unitListsDatabase == null) return;

    _unitPaletteDatabase = unitPaletteDatabase;
    _unitPalette = await _createUnitPalette(unitPaletteDatabase);
    _unitListsDatabase = unitListsDatabase;
    _unitLists = await _unitListsDatabase.readAll();
    _unitDatabases = await UnitsDatabase.getAll(project);
    _unitMap = await _createUnitLists(
      project,
      _unitDatabases,
    );
  }

  static Future<Map<String, List<Move>>> _createMoveLists(
    Project project,
    Map<String, MovesDatabase> databases,
  ) async {
    Map<String, List<Move>> returnMap = {};
    for (String list in databases.keys) {
      returnMap[list] = await (databases[list])?.readAll() ?? [];
    }
    return returnMap;
  }

  static Future<UnitPalette> _createUnitPalette(
          UnitPalettesDatabase database) async =>
      await database.read();

  static Future<Map<String, List<Unit>>> _createUnitLists(
    Project project,
    Map<String, UnitsDatabase> databases,
  ) async {
    Map<String, List<Unit>> returnMap = {};
    for (String list in databases.keys) {
      returnMap[list] = await (databases[list])?.readAll() ?? [];
    }
    return returnMap;
  }

  Project get project => _project;

  List<Move>? getMoves(MoveList list) {
    List<Move>? returnList = _moveMap[list.fileName];
    return returnList == null ? null : [...returnList];
  }

  List<MoveList> get moveLists => [..._moveLists];

  bool get hasMoveLists => _moveMap.isNotEmpty;

  int get moveCount {
    int count = 0;
    for(List<Move> list in _moveMap.values){
      count += list.length;
    }
    return count;
  }

  int get moveListCount => _moveMap.length;

  UnitPalette get unitPalette => _unitPalette;

  List<Unit>? getUnits(UnitList list) {
    List<Unit>? returnList = _unitMap[list.fileName];
    return returnList == null ? null : [...returnList];
  }

  List<UnitList> get unitLists => [..._unitLists];

  bool get hasUnitLists => _unitMap.isNotEmpty;

  int get unitCount {
    int count = 0;
    for(List<Unit> list in _unitMap.values){
      count += list.length;
    }
    return count;
  }

  int get unitListCount => _unitMap.length;

  Future<void> _updateLastEdit() async {
    _project = await (await ProjectsDatabase.get(_project.directoryName))
            ?.updateLastEdited() ??
        _project;
    _allProjects = await generateAllProjects();
  }

  Future<Move?> addMove(Move move, MoveList moveList) async {
    MovesDatabase? database = _moveDatabases[moveList.fileName];
    if (database != null) {
      Move addedMove = await database.create(move);
      await _updateLastEdit();
      await _refreshMoves();
      return addedMove;
    }
    return null;
  }

  Future<Move?> updateMove(Move move, MoveList moveList) async {
    MovesDatabase? database = _moveDatabases[moveList.fileName];
    if (database != null) {
      Move? oldMove = await database.read(move.id);
      if (oldMove != null) {
        await database.update(move);
        await _updateLastEdit();
        await _refreshMoves();
        Move? newMove = await database.read(move.id);
        if (newMove != null) {
          _changeMoveReferences(oldMove, newMove, moveList);
          await _refreshUnits();
        }
        return newMove;
      }
    }
    return null;
  }

  void _changeMoveReferences(Move oldMove, Move newMove, MoveList moveList) {
    for (UnitList unitList in _unitLists) {
      for (Unit unit in _unitMap[unitList.fileName] ?? []) {
        List<MoveGroup> groups = [];
        for (MoveGroup group in unit.moveset.groups) {
          List<MoveGroupPair> pairs = [];
          for (MoveGroupPair pair in group.pairs) {
            if (pair.moveList.name == moveList.name &&
                pair.move.name == oldMove.name) {
              pairs.add(MoveGroupPair(newMove, moveList));
            } else {
              pairs.add(pair);
            }
          }
          groups.add(MoveGroup(group.name, pairs));
        }
        updateUnit(unit.copyWith(moveset: Moveset(groups)), unitList);
      }
    }
  }

  void _removeMoveReferences(Move move, MoveList moveList) {
    for (UnitList unitList in _unitLists) {
      for (Unit unit in _unitMap[unitList.fileName] ?? []) {
        List<MoveGroup> groups = [];
        for (MoveGroup group in unit.moveset.groups) {
          List<MoveGroupPair> pairs = [];
          for (MoveGroupPair pair in group.pairs) {
            if (pair.moveList.name != moveList.name ||
                pair.move.name != move.name) {
              pairs.add(pair);
            }
          }
          groups.add(MoveGroup(group.name, pairs));
        }
        updateUnit(unit.copyWith(moveset: Moveset(groups)), unitList);
      }
    }
  }

  void _shiftMoveReferences(
    Move oldMove,
    Move newMove,
    MoveList oldMoveList,
    MoveList newMoveList,
  ) {
    for (UnitList unitList in _unitLists) {
      for (Unit unit in _unitMap[unitList.fileName] ?? []) {
        List<MoveGroup> groups = [];
        for (MoveGroup group in unit.moveset.groups) {
          List<MoveGroupPair> pairs = [];
          for (MoveGroupPair pair in group.pairs) {
            if (pair.moveList.name == oldMoveList.name &&
                pair.move.name == oldMove.name) {
              pairs.add(MoveGroupPair(newMove, newMoveList));
            } else {
              pairs.add(pair);
            }
          }
          groups.add(MoveGroup(group.name, pairs));
        }
        updateUnit(unit.copyWith(moveset: Moveset(_reorganizeGroups(groups))),
            unitList);
      }
    }
  }

  void _changeMovelistReferences(MoveList oldMoveList, MoveList newMoveList) {
    for (UnitList unitList in _unitLists) {
      for (Unit unit in _unitMap[unitList.fileName] ?? []) {
        List<MoveGroup> groups = [];
        for (MoveGroup group in unit.moveset.groups) {
          List<MoveGroupPair> pairs = [];
          for (MoveGroupPair pair in group.pairs) {
            if (pair.moveList.name == oldMoveList.name) {
              pairs.add(MoveGroupPair(pair.move, newMoveList));
            } else {
              pairs.add(pair);
            }
          }
          groups.add(MoveGroup(group.name, pairs));
        }
        updateUnit(unit.copyWith(moveset: Moveset(_reorganizeGroups(groups))),
            unitList);
      }
    }
  }

  void _removeMovelistReferences(MoveList moveList) {
    for (UnitList unitList in _unitLists) {
      for (Unit unit in _unitMap[unitList.fileName] ?? []) {
        List<MoveGroup> groups = [];
        for (MoveGroup group in unit.moveset.groups) {
          List<MoveGroupPair> pairs = [];
          for (MoveGroupPair pair in group.pairs) {
            if (pair.moveList.name != moveList.name) {
              pairs.add(pair);
            }
          }
          groups.add(MoveGroup(group.name, pairs));
        }
        updateUnit(unit.copyWith(moveset: Moveset(_reorganizeGroups(groups))),
            unitList);
      }
    }
  }

  void _shiftMovelistReferences(MoveList oldMoveList, MoveList newMoveList) {
    for (UnitList unitList in _unitLists) {
      for (Unit unit in _unitMap[unitList.fileName] ?? []) {
        List<MoveGroup> groups = [];
        for (MoveGroup group in unit.moveset.groups) {
          List<MoveGroupPair> pairs = [];
          for (MoveGroupPair pair in group.pairs) {
            if (pair.moveList.name == oldMoveList.name) {
              pairs.add(MoveGroupPair(pair.move, newMoveList));
            } else {
              pairs.add(pair);
            }
          }
          groups.add(MoveGroup(group.name, pairs));
        }
        updateUnit(
          unit.copyWith(moveset: Moveset(_reorganizeGroups(groups))),
          unitList,
        );
      }
    }
  }

  //TODO: Once users can create personalized groups, this must be deleted, as it
  // is meant to ensure that moves are all grouped correctly by movelist...
  List<MoveGroup> _reorganizeGroups(List<MoveGroup> groups) {
    List<MoveGroup> returnGroups = [];
    List<MoveGroupPair> pairs = [];
    for (MoveGroup group in groups) {
      pairs.addAll(group.pairs);
    }
    for (MoveList list in _moveLists) {
      List<MoveGroupPair> returnPairs = [];
      for (MoveGroupPair pair in pairs) {
        if (pair.moveList.name == list.name) {
          returnPairs.add(pair);
        }
      }
      returnGroups.add(MoveGroup(list.name, returnPairs));
    }
    return returnGroups;
  }

  Future<void> changeMoveIndex(
    int oldIndex,
    int newIndex,
    MoveList moveList,
  ) async {
    MovesDatabase? database = _moveDatabases[moveList.fileName];
    if (database != null) {
      await database.shift(oldIndex, newIndex);
      await _updateLastEdit();
      await _refreshMoves();
    }
  }

  Future<Move> renameMove(Move move, String newName, MoveList moveList) async {
    MovesDatabase? database = _moveDatabases[moveList.fileName];
    if (database != null) {
      await database.update(move.copy(name: newName));
      Move? renamedMove = await database.read(move.id);
      if (renamedMove != null) {
        await _updateLastEdit();
        await _refreshMoves();
        _changeMoveReferences(move, renamedMove, moveList);
        await _refreshUnits();
        return renamedMove;
      }
    }
    return move;
  }

  Future<void> duplicateMove(Move move, MoveList moveList) async {
    MovesDatabase? database = _moveDatabases[moveList.fileName];
    if (database != null) {
      String newName = move.name;
      do {
        newName += 'Copy';
      } while (isMoveNameTaken(newName, moveList));

      await database.create(
        move.copy(
          nullifyID: true,
          moveNum: (await database.size) + 1,
          name: newName,
        ),
      );
      await _updateLastEdit();
      await _refreshMoves();
    }
  }

  Future<void> copyMove(
    Move move,
    MoveList from,
    MoveList to,
    bool allowRedundancies,
  ) async {
    MovesDatabase? fromDatabase = _moveDatabases[from.fileName];
    if (fromDatabase != null) {
      MovesDatabase? toDatabase = _moveDatabases[to.fileName];
      if (toDatabase != null &&
          (allowRedundancies || !(await toDatabase.contains(move)))) {
        await toDatabase.create(
          move.copy(
            nullifyID: true,
            moveNum: (await toDatabase.size) + 1,
            name: await toDatabase.safeName(move.name),
          ),
        );
        await _updateLastEdit();
        await _refreshMoves();
      }
    }
  }

  Future<void> moveMove(
    Move move,
    MoveList from,
    MoveList to,
    bool allowRedundancies,
  ) async {
    MovesDatabase? fromDatabase = _moveDatabases[from.fileName];
    if (fromDatabase != null) {
      MovesDatabase? toDatabase = _moveDatabases[to.fileName];
      if (toDatabase != null &&
          (allowRedundancies || !(await toDatabase.contains(move)))) {
        ///[newMove] allows for the proper reference if the name of the move
        /// has changed, in the case the new list already has a move with the
        /// same name
        Move newMove = await toDatabase.create(
          move.copy(
            nullifyID: true,
            moveNum: (await toDatabase.size) + 1,
            name: await toDatabase.safeName(move.name),
          ),
        );
        await fromDatabase.delete(move.id);
        await _updateLastEdit();
        await _refreshMoves();
        _shiftMoveReferences(move, newMove, from, to);
        await _refreshUnits();
      }
    }
  }

  Future<void> deleteMove(Move move, MoveList moveList) async {
    MovesDatabase? database = _moveDatabases[moveList.fileName];
    if (database != null) {
      await database.delete(move.id);
      await _updateLastEdit();
      await _refreshMoves();
      _removeMoveReferences(move, moveList);
      await _refreshUnits();
    }
  }

  Future<MoveList> addMoveList(String name) async {
    MoveList newList = await _moveListsDatabase.create(
      MoveList(
        name: name,
        listNum: moveListCount + 1,
      ),
    );
    await _updateLastEdit();
    await _refreshMoves();
    return newList;
  }

  ///Changes the index of the MoveList from oldIndex to newIndex.
  Future<void> changeMoveListIndex(int oldIndex, int newIndex) async {
    await _moveListsDatabase.shift(oldIndex, newIndex);
    await _updateLastEdit();
    await _refreshMoves();
  }

  Future<MoveList> renameMoveList(MoveList moveList, String newName) async {
    MoveList renamedList = await _moveListsDatabase.create(
      moveList.copy(
        nullifyID: true,
        name: newName,
      ),
    );

    await _copyMoveList(moveList, renamedList, true);
    await _moveListsDatabase.delete(moveList);
    await _updateLastEdit();
    await _refreshMoves();
    _changeMovelistReferences(moveList, renamedList);
    await _refreshUnits();
    return renamedList;
  }

  Future<void> duplicateMoveList(MoveList moveList) async {
    String newName = moveList.name;
    do {
      newName += 'Copy';
    } while (isMoveListNameTaken(newName));

    MoveList duplicateMoveList = await _moveListsDatabase.create(
      moveList.copy(
        nullifyID: true,
        listNum: moveListCount + 1,
        name: newName,
      ),
    );

    await _copyMoveList(moveList, duplicateMoveList, true);
    await _updateLastEdit();
    await _refreshMoves();
  }

  Future<void> copyAllMoves(
    MoveList from,
    MoveList to,
    bool allowRedundancies,
  ) async {
    await _copyMoveList(from, to, allowRedundancies);
    await _updateLastEdit();
    await _refreshMoves();
  }

  Future<void> mergeMoveList(
    MoveList from,
    MoveList to,
    bool allowRedundancies,
  ) async {
    await _copyMoveList(from, to, allowRedundancies);
    await _moveListsDatabase.delete(from);
    await _updateLastEdit();
    await _refreshMoves();
    _shiftMovelistReferences(from, to);
    await _refreshUnits();
  }

  Future<void> deleteMoveList(MoveList moveList) async {
    await _moveListsDatabase.delete(moveList);
    await _updateLastEdit();
    await _refreshMoves();
    _removeMovelistReferences(moveList);
    await _refreshUnits();
  }

  bool isMoveNameTaken(String name, MoveList list, {String? givenMove}) {
    if (givenMove != null && normativelyEqual(name, givenMove)) {
      return false;
    }

    List<Move>? moves = _moveMap[list.fileName];
    if (moves != null) {
      for (Move move in moves) {
        if (normativelyEqual(name, move.name)) {
          return true;
        }
      }
    }
    return false;
  }

  bool isMoveListNameTaken(String name, {String? givenMoveList}) {
    if (givenMoveList != null && normativelyEqual(name, givenMoveList)) {
      return false;
    }

    for (MoveList moveList in _moveLists) {
      if (normativelyEqual(name, moveList.name)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _copyMoveList(
      MoveList from, MoveList to, bool allowRedundancies) async {
    Map<String, MovesDatabase> moveDatabases =
        await MovesDatabase.getAll(project);
    MovesDatabase? fromDatabase = moveDatabases[from.fileName];
    MovesDatabase? toDatabase = moveDatabases[to.fileName];
    if (fromDatabase != null && toDatabase != null) {
      for (Move move in await fromDatabase.readAll()) {
        if (allowRedundancies || !(await toDatabase.contains(move))) {
          await toDatabase.create(
            move.copy(
              nullifyID: true,
              moveNum: await toDatabase.size + 1,
              name: await toDatabase.safeName(move.name),
            ),
          );
        }
      }
    }
  }

  Future<Unit?> addUnit(String name, UnitList unitList) async {
    UnitsDatabase? database = _unitDatabases[unitList.fileName];
    if (database != null) {
      List<UnitFieldData> fields = [];
      for (UnitField field in _unitPalette.fields) {
        fields.add(UnitFieldData(field, field.defaultVal));
      }

      List<MoveGroup> groups = [];
      for (MoveList list in _moveLists) {
        groups.add(MoveGroup(list.name, []));
      }

      Unit unit = await database.create(
        Unit(
          name: minimizeWhitespace(name),
          description: '',
          unitNum: (await database.size) + 1,
          moveset: Moveset(groups),
          fields: fields,
        ),
      );
      await _updateLastEdit();
      await _refreshUnits();
      return unit;
    }
    return null;
  }

  Future<Unit?> updateUnit(Unit unit, UnitList unitList) async {
    UnitsDatabase? database = _unitDatabases[unitList.fileName];
    if (database != null) {
      await database.update(unit);
      await _updateLastEdit();
      await _refreshUnits();
      return database.read(unit.id);
    }
    return null;
  }

  Future<void> changeUnitIndex(
    int oldIndex,
    int newIndex,
    UnitList unitList,
  ) async {
    UnitsDatabase? database = _unitDatabases[unitList.fileName];
    if (database != null) {
      await database.shift(oldIndex, newIndex);
      await _updateLastEdit();
      await _refreshUnits();
    }
  }

  Future<Unit> renameUnit(Unit unit, String newName, UnitList unitList) async {
    UnitsDatabase? database = _unitDatabases[unitList.fileName];
    if (database != null) {
      await database.update(unit.copyWith(name: newName));
      Unit? renamedUnit = await database.read(unit.id);
      if (renamedUnit != null) {
        await _updateLastEdit();
        await _refreshUnits();
        return renamedUnit;
      }
    }
    return unit;
  }

  Future<void> duplicateUnit(Unit unit, UnitList unitList) async {
    UnitsDatabase? database = _unitDatabases[unitList.fileName];
    if (database != null) {
      String newName = unit.name;
      do {
        newName += 'Copy';
      } while (isUnitNameTaken(newName, unitList));

      await database.create(
        unit.copyWith(
          nullifyID: true,
          unitNum: (await database.size) + 1,
          name: newName,
        ),
      );
      await _updateLastEdit();
      await _refreshUnits();
    }
  }

  Future<void> copyUnit(
    Unit unit,
    UnitList from,
    UnitList to,
    bool allowRedundancies,
  ) async {
    UnitsDatabase? fromDatabase = _unitDatabases[from.fileName];
    if (fromDatabase != null) {
      UnitsDatabase? toDatabase = _unitDatabases[to.fileName];
      if (toDatabase != null &&
          (allowRedundancies || !(await toDatabase.contains(unit)))) {
        await toDatabase.create(
          unit.copyWith(
            nullifyID: true,
            unitNum: (await toDatabase.size) + 1,
            name: await toDatabase.safeName(unit.name),
          ),
        );
        await _updateLastEdit();
        await _refreshUnits();
      }
    }
  }

  Future<void> moveUnit(
    Unit unit,
    UnitList from,
    UnitList to,
    bool allowRedundancies,
  ) async {
    UnitsDatabase? fromDatabase = _unitDatabases[from.fileName];
    if (fromDatabase != null) {
      UnitsDatabase? toDatabase = _unitDatabases[to.fileName];
      if (toDatabase != null &&
          (allowRedundancies || !(await toDatabase.contains(unit)))) {
        await toDatabase.create(
          unit.copyWith(
            nullifyID: true,
            unitNum: (await toDatabase.size) + 1,
            name: await toDatabase.safeName(unit.name),
          ),
        );
        await fromDatabase.delete(unit.id);
        await _updateLastEdit();
        await _refreshUnits();
      }
    }
  }

  Future<void> deleteUnit(Unit unit, UnitList unitList) async {
    UnitsDatabase? database = _unitDatabases[unitList.fileName];
    if (database != null) {
      await database.delete(unit.id);
      await _updateLastEdit();
      await _refreshUnits();
    }
  }

  Future<UnitList> addUnitList(String name) async {
    UnitList newList = await _unitListsDatabase.create(
      UnitList(
        name: name,
        listNum: unitListCount + 1,
      ),
    );
    await _updateLastEdit();
    await _refreshUnits();
    return newList;
  }

  ///Changes the index of the UnitList from oldIndex to newIndex.
  Future<void> changeUnitListIndex(int oldIndex, int newIndex) async {
    await _unitListsDatabase.shift(oldIndex, newIndex);
    await _updateLastEdit();
    await _refreshUnits();
  }

  Future<UnitList> renameUnitList(UnitList unitList, String newName) async {
    UnitList renamedList = await _unitListsDatabase.create(
      unitList.copy(
        nullifyID: true,
        name: newName,
      ),
    );

    await _copyUnitList(unitList, renamedList, true);
    await _unitListsDatabase.delete(unitList);
    await _updateLastEdit();
    await _refreshUnits();
    return renamedList;
  }

  Future<void> duplicateUnitList(UnitList unitList) async {
    String newName = unitList.name;
    do {
      newName += 'Copy';
    } while (isUnitListNameTaken(newName));

    UnitList duplicateUnitList = await _unitListsDatabase.create(
      unitList.copy(
        nullifyID: true,
        listNum: unitListCount + 1,
        name: newName,
      ),
    );

    await _copyUnitList(unitList, duplicateUnitList, true);
    await _updateLastEdit();
    await _refreshUnits();
  }

  Future<void> copyAllUnits(
    UnitList from,
    UnitList to,
    bool allowRedundancies,
  ) async {
    await _copyUnitList(from, to, allowRedundancies);
    await _updateLastEdit();
    await _refreshUnits();
  }

  Future<void> mergeUnitList(
    UnitList from,
    UnitList to,
    bool allowRedundancies,
  ) async {
    await _copyUnitList(from, to, allowRedundancies);
    await _unitListsDatabase.delete(from);
    await _updateLastEdit();
    await _refreshUnits();
  }

  Future<void> deleteUnitList(UnitList unitList) async {
    await _unitListsDatabase.delete(unitList);
    await _updateLastEdit();
    await _refreshUnits();
  }

  bool isUnitNameTaken(String name, UnitList list, {String? givenUnit}) {
    if (givenUnit != null && normativelyEqual(name, givenUnit)) {
      return false;
    }

    List<Unit>? units = _unitMap[list.fileName];
    if (units != null) {
      for (Unit unit in units) {
        if (normativelyEqual(name, unit.name)) {
          return true;
        }
      }
    }
    return false;
  }

  bool isUnitListNameTaken(String name, {String? givenUnitList}) {
    if (givenUnitList != null && normativelyEqual(name, givenUnitList)) {
      return false;
    }

    for (UnitList unitList in _unitLists) {
      if (normativelyEqual(name, unitList.name)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _copyUnitList(
      UnitList from, UnitList to, bool allowRedundancies) async {
    Map<String, UnitsDatabase> unitDatabases =
        await UnitsDatabase.getAll(project);
    UnitsDatabase? fromDatabase = unitDatabases[from.fileName];
    UnitsDatabase? toDatabase = unitDatabases[to.fileName];
    if (fromDatabase != null && toDatabase != null) {
      for (Unit unit in await fromDatabase.readAll()) {
        if (allowRedundancies || !(await toDatabase.contains(unit))) {
          await toDatabase.create(
            unit.copyWith(
              nullifyID: true,
              unitNum: await toDatabase.size + 1,
              name: await toDatabase.safeName(unit.name),
            ),
          );
        }
      }
    }
  }

  Map<UnitList, List<Unit>> unitsWithMove(Move move, MoveList moveList) {
    Map<UnitList, List<Unit>> map = {};
    for (UnitList list in _unitLists) {
      List<Unit> qualified = [];
      for (Unit unit in _unitMap[list.fileName] ?? []) {
        bool found = false;
        for (MoveGroup group in unit.moveset.groups) {
          for (MoveGroupPair pair in group.pairs) {
            if (pair.move.name == move.name &&
                pair.moveList.name == moveList.name) {
              qualified.add(unit);
              found = true;
              break;
            }
          }
          if(found) break;
        }
      }
      map[list] = qualified;
    }
    return map;
  }

  Map<UnitList, List<Unit>> unitsWithMoveList(MoveList moveList) {
    Map<UnitList, List<Unit>> map = {};
    for (UnitList list in _unitLists) {
      List<Unit> qualified = [];
      for (Unit unit in _unitMap[list.fileName] ?? []) {
        bool found = false;
        for (MoveGroup group in unit.moveset.groups) {
          for (MoveGroupPair pair in group.pairs) {
            if (pair.moveList.name == moveList.name) {
              qualified.add(unit);
              found = true;
              break;
            }
          }
          if(found) break;
        }
      }
      map[list] = qualified;
    }
    return map;
  }

  Future<void> closeAllDatabases() async {
    await (await ProjectsDatabase.allDatabases)[_project.directoryName]
        ?.close();
    await _moveListsDatabase.close();
    for(MovesDatabase db in _moveDatabases.values){
      await db.close();
    }
    await _unitPaletteDatabase.close();
    await _unitListsDatabase.close();
    for(UnitsDatabase db in _unitDatabases.values){
      await db.close();
    }
  }
}
