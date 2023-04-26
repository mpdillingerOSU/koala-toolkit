enum Priority {
  pre._('Pre'),
  post._('Post');

  final String name;

  const Priority._(this.name);

  static List<String> allNames() {
    List<String> names = [];
    for (Priority timing in values) {
      names.add(timing.name);
    }
    return names;
  }

  @override
  String toString() => name;
}
