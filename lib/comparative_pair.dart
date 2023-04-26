class ComparativePair{
  final Comparative comparative;
  final int value;

  ComparativePair(this.comparative, this.value);

  bool passesCheck(int num){
    if(comparative == Comparative.equalTo){
      return num == value;
    }
    if(comparative == Comparative.lessThan){
      return num < value;
    }
    if(comparative == Comparative.lessThanOrEqualTo){
      return num <= value;
    }
    if(comparative == Comparative.greaterThan){
      return num > value;
    }
    if(comparative == Comparative.greaterThanOrEqualTo){
      return num >= value;
    }
    return false;
  }

  @override
  String toString(){
    return '$comparative $value';
  }
}

enum Comparative{
  equalTo('='),
  lessThan('<'),
  lessThanOrEqualTo('<='),
  greaterThan('>'),
  greaterThanOrEqualTo('>=');

  final String operator;

  const Comparative(this.operator);

  @override
  String toString(){
    return operator;
  }
}