class Time{
  Time._();

  static String asClock(int seconds){
    return '${seconds ~/ 60}:${seconds % 60 < 10 ? '0' : ''}${seconds % 60}';
  }
}