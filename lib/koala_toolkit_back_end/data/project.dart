import 'package:gaming_toolkit/koala_strings.dart';

const String tableProjects = 'projects';

class ProjectFields {
  ProjectFields._();

  static const String id = '_id';
  static const String name = 'name';
  static const String directoryName = 'directoryName';
  static const String createdDate = 'createdDate';
  static const String lastSavedDate = 'lastSavedDate';
  static const String version = 'version';

  static final List<String> values = [
    id,
    name,
    directoryName,
    createdDate,
    lastSavedDate,
    version,
  ];
}

class Project {
  static const int staticID = 1;
  static const String defaultName = 'unnamed';

  final String name;
  late final String directoryName;
  final String createdDate;
  final String lastSavedDate;
  final double version;

  late final Map<String, Object?> _map;

  Project({
    required this.name,
    required this.createdDate,
    required this.lastSavedDate,
    required this.version,
  }) {
    directoryName = toCamelCase(name);
    _map = {
      ProjectFields.name: name,
      ProjectFields.directoryName: directoryName,
      ProjectFields.createdDate: createdDate,
      ProjectFields.lastSavedDate: lastSavedDate,
      ProjectFields.version : version,
    };
  }

  Map<String, Object?> get map => {..._map};

  String get initials {
    String str = directoryName[0].toUpperCase();
    if (directoryName.length > 1) {
      for (int i = 1; i < directoryName.length; i++) {
        if (directoryName[i].toUpperCase() == directoryName[i]) {
          return str + directoryName[i].toUpperCase();
        }
      }
      return str + directoryName[1].toUpperCase();
    }
    return str;
  }

  Project copyWith({
    String? name,
    double? version,
  }) {
    return Project(
      name: name ?? this.name,
      createdDate: createdDate,
      lastSavedDate: lastSavedDate,
      version: version ?? this.version,
    );
  }

  bool equals(Project comp) {
    return name == comp.name &&
        directoryName == comp.directoryName &&
        createdDate == comp.createdDate &&
        lastSavedDate == comp.lastSavedDate &&
        version == comp.version;
  }

  @override
  String toString() {
    return name;
  }
}
