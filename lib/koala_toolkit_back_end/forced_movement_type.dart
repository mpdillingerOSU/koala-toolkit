enum ForcedMovementType {
  origin._('Origin'), //TODO: icon will be a small circle with fat arrows pointing in either all four cardinal directions or in the eight primary direction, or maybe in six directions...
  direction._('Direction'); //TODO: icon will be a small circle with a single very fat arrow moving northward...

  final String name;

  const ForcedMovementType._(this.name);

  static List<String> allNames() {
    List<String> names = [];
    for (ForcedMovementType type in values) {
      names.add(type.name);
    }
    return names;
  }

  @override
  String toString() {
    return name;
  }
}
