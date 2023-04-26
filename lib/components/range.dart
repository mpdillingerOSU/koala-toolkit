import 'dart:math';

class Range {
  final int? lowerBound;
  late final int? upperBound;

  static final Range unbounded = Range(null, null);

  Range(this.lowerBound, int? upperBound) {
    this.upperBound = (lowerBound == null || upperBound == null)
        ? upperBound
        : max(lowerBound!, upperBound);
  }

  bool contains(int val) {
    return (lowerBound == null || val >= lowerBound!) &&
        (upperBound == null || val <= upperBound!);
  }

  int? bound(int? val){
    if(val != null){
      if(lowerBound != null && val < lowerBound!){
        return lowerBound;
      } else if(upperBound != null && val > upperBound!){
        return upperBound;
      }
    }
    return val;
  }

  bool equals(Range comp){
    return lowerBound == comp.lowerBound && upperBound == comp.upperBound;
  }

  @override
  String toString() {
    return '$lowerBound - $upperBound';
  }
}
