import 'package:gaming_toolkit/koala_toolkit_back_end/sorters/sorter.dart';

import '../data/units/unit.dart';
import '../data/unit_field.dart';

class UnitSorter {
  late UnitField type;
  late SortDirection direction;

  UnitSorter({
    required this.type,
    required this.direction,
  });

  List<Unit> sort(List<Unit> units) {
    List<Unit> sortedUnits = [...units];
    subsort(sortedUnits, 0, units.length - 1);
    return direction == SortDirection.ascending
        ? sortedUnits
        : sortedUnits.reversed.toList();
  }

  void subsort(List<Unit> units, int l, int r) {
    if (l < r) {
      int m = l + ((r - l) ~/ 2);
      subsort(units, l, m);
      subsort(units, m + 1, r);
      merge(units, l, m, r);
    }
  }

  void merge(List<Unit> units, int l, int m, int r) {
    int n1 = m - l + 1;
    List<Unit> L = [];
    for (int i = 0; i < n1; ++i) {
      L.add(units[l + i]);
    }

    int n2 = r - m;
    List<Unit> R = [];
    for (int j = 0; j < n2; ++j) {
      R.add(units[m + 1 + j]);
    }

    int i = 0, j = 0;

    int k = l;
    while (i < n1 && j < n2) {
      UnitFieldData? lData = L[i].get(type);
      UnitFieldData? rData = R[j].get(type);
      if ((lData != null && (rData == null || lData.compareTo(rData))) ||
          (lData == null && rData == null)) {
        units[k] = L[i];
        i++;
      } else {
        units[k] = R[j];
        j++;
      }
      k++;
    }

    while (i < n1) {
      units[k] = L[i];
      i++;
      k++;
    }

    while (j < n2) {
      units[k] = R[j];
      j++;
      k++;
    }
  }

  void flipDirection() {
    direction = direction == SortDirection.ascending
        ? SortDirection.descending
        : SortDirection.ascending;
  }
}
