import 'package:gaming_toolkit/koala_toolkit_back_end/data/unit_palette.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/move_element.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/move_list_builder.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/template.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/unit_list_builder.dart';

import '../data/unit_field.dart';

class EmptyTemplate extends Template {
  EmptyTemplate() : super('Empty');

  final UnitFieldInt _vitality = UnitFieldInt(
    name: 'Vitality',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _strength = UnitFieldInt(
    name: 'Strength',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _intelligence = UnitFieldInt(
    name: 'Intelligence',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _wisdom = UnitFieldInt(
    name: 'Wisdom',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _agility = UnitFieldInt(
    name: 'Agility',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldInt _luck = UnitFieldInt(
    name: 'Luck',
    defaultVal: 25,
    minVal: 10,
    maxVal: 150,
  );
  final UnitFieldBool _flying = UnitFieldBool(
    name: 'Flying',
    defaultVal: false,
  );
  final UnitFieldEnum _element = UnitFieldEnum(
    name: 'Element',
    vals: MoveElement.map.keys.toList(),
  );

  @override
  List<MoveListBuilder> generateMoves() {
    return [];
  }

  @override
  UnitPalette generateUnitPalette() {
    return UnitPalette(
      fields: [
        _vitality,
        _strength,
        _intelligence,
        _wisdom,
        _agility,
        _luck,
        _flying,
        _element,
      ],
    );
  }

  @override
  List<UnitListBuilder> generateUnits() {
    return [];
  }
}
