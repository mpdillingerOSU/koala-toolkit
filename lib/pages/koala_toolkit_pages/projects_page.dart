import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/cards/project_card.dart';
import 'package:gaming_toolkit/file_management.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/databases/projects_database.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/project_packet.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/empty_template.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/template.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/templates/trench_warfare_template.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/rename_popup.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/home/project_home_page.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/validation_texts.dart';

import '../../components/drag_drop_column.dart';
import '../../components/general/koala_scrollbar.dart';
import '../../components/general/tap_detector.dart';
import '../../components/popup.dart';
import '../../components/tickers/ticker_dropdown.dart';
import '../../components/tickers/ticker_text_field.dart';
import '../../koala_strings.dart';
import '../../koala_toolkit_back_end/data/project.dart';
import '../../koala_toolkit_back_end/templates/high_fantasy_template.dart';
import '../../koala_toolkit_back_end/templates/horror_template.dart';
import '../../koala_toolkit_back_end/templates/modern_military_template.dart';
import '../../koala_toolkit_back_end/templates/noir_template.dart';
import '../../koala_toolkit_back_end/templates/sci_fi_template.dart';
import '../../koala_toolkit_back_end/templates/superhero_template.dart';
import '../../koala_toolkit_back_end/templates/western_template.dart';
import '../../my_constants.dart';
import 'koala_page.dart';

class ProjectsPage extends KoalaPage {
  const ProjectsPage({
    super.key,
  });

  @override
  KoalaPageState<ProjectsPage> createState() => ProjectsPageState();
}

class ProjectsPageState extends KoalaPageState<ProjectsPage> {
  late List<Project> _projects = [];
  final ScrollController _scrollController = ScrollController();

  @override
  Future<void> subRefresh() async {
    _projects = await ProjectPacket.generateAllProjects();
    _projects.sort((a, b) => b.lastSavedDate.compareTo(a.lastSavedDate));
  }

  @override
  void initState() {
    super.initState();
    refreshPage(() async {});
  }

  @override
  void dispose() {
    _closeDatabases();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _closeDatabases() async {
    for (ProjectsDatabase db in (await ProjectsDatabase.allDatabases).values) {
      await db.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return AdvancedScaffold(
      pageTitle: 'Projects',
      barColor: Colors.blue,
      barTextColor: MyConstants.primaryColor,
      actions: [
        TapDetector(
          onTap: () async {
            await pushNamedPage('/settings');
          },
          child: const Center(
            child: Icon(
              Icons.settings_sharp,
              color: MyConstants.primaryColor,
              size: 32,
            ),
          ),
        ),
      ],
      body: Stack(
        children: [
          Visibility(
            visible: !isLoading,
            child: Scrollbar(
              child: Container(
                color: Colors.white,
                child: _projects.isEmpty
                    ? ListView(
                        controller: _scrollController,
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: screenHeight * .125,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * .01875,
                                    horizontal:
                                        MediaQuery.of(context).size.width * .1,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Project List is Empty',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Sans Source Pro',
                                        color: Colors.grey,
                                        fontSize: screenHeight * .0375,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * .005,
                                  width: MediaQuery.of(context).size.width * .6,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: _buildList(),
                        ),
                      ),
              ),
            ),
          ),
          loadingScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3415C0),
        onPressed: () => _addProject(context),
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'New Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  DragDropColumn _buildList() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth = screenWidth - screenHeight * .027;
    final double itemHeight = screenHeight * .15;

    List<ProjectCard> cards = [];
    for (int i = 0; i < _projects.length; i++) {
      Project project = _projects[i];
      cards.add(
        ProjectCard(
          project: project,
          width: itemWidth,
          height: itemHeight,
          lightingTheme: lightingTheme,
          onOpen: () async => await _openProject(project),
          onRename: () async => await _renameProject(project),
          onDuplicate: () async => await _duplicateProject(project),
          onExport: () async => await _exportProject(project),
          onDelete: () async => await _deleteProject(project),
        ),
      );
    }

    return DragDropColumn(
      context,
      dragEnabled: false,
      scrollController: _scrollController,
      itemMovementAxis: Axis.vertical,
      dragScrollSpeed: dragScrollSpeed,
      itemWidth: itemWidth,
      itemHeight: itemHeight,
      onDragEnd: (int oldIndex, int newIndex) async {},
      children: cards,
    );
  }

  bool isNameTaken(String name, {String? givenProject}) {
    if (givenProject != null && normativelyEqual(name, givenProject)) {
      return false;
    }

    for (Project project in _projects) {
      if (normativelyEqual(name, project.name)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _addProject(BuildContext context) async {
    String initialName = 'unnamed';
    if (isNameTaken(initialName)) {
      int num = 2;
      while (isNameTaken('$initialName$num')) {
        num++;
      }
      initialName = '$initialName$num';
    }

    final Project? result = await showDialog(
      context: context,
      builder: (context) => _NewProjectPopup(
        parent: this,
        initialName: initialName,
        title: 'New Project',
      ),
    );

    if (result != null) {
      displaySnackBar('Project Added: $result');
      _openProject(result);
    }
  }

  Future<void> _openProject(Project project) async {
    ProjectPacket? packet = await ProjectPacket.create(project);

    if (packet != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: 'Home'),
          builder: (context) => ProjectHomePage(packet),
        ),
        (route) => false,
      );
    } else {
      displaySnackBar('Error: \'Open\' Failed');
    }
  }

  Future<void> _renameProject(final Project project) async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename Project',
        initialValue: project.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !(isNameTaken(value, givenProject: project.name));
        },
        validationText: ValidationTexts.invalidProjectName,
      ),
    );

    if (result != null && result != project.name) {
      await refreshPage(() async {
        Project renamedProject = Project(
          name: result,
          createdDate: project.createdDate,
          lastSavedDate: DateTime.now().toUtc().toIso8601String(),
          version: project.version,
        );

        bool success = await FileManagement.renameProject(
            project.directoryName, renamedProject.directoryName);

        if (!success) return;

        ProjectsDatabase? db =
            await ProjectsDatabase.get(renamedProject.directoryName);

        if (db == null) return;

        await db.update(renamedProject);
        await (await ProjectsDatabase.get(renamedProject.directoryName))
            ?.updateLastEdited();
      });
      displaySnackBar('Project Renamed: $result');
    }
  }

  Future<void> _duplicateProject(Project project) async {
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => KoalaAlert(
            title: 'Duplicate Project',
            text: 'Do you wish to duplicate $project?',
          ),
        ) ??
        false;

    if (confirm) {
      await refreshPage(() async {
        String newName = project.name;
        do {
          newName += 'Copy';
        } while (isNameTaken(newName));

        await _subDuplicate(project, newName);
      });
      displaySnackBar('Project Duplicated: $project');
    }
  }

  Future<Project?> _subDuplicate(Project project, String newName) async {
    String createdTime = DateTime.now().toUtc().toIso8601String();
    Project duplicateProject = Project(
      name: newName,
      createdDate: createdTime,
      lastSavedDate: createdTime,
      version: project.version,
    );
    Directory? dir = await FileManagement.duplicateProject(
        project.directoryName, duplicateProject.directoryName);

    if (dir == null) return null;

    String oldFile = '${dir.path}/project.db';
    if (await File(oldFile).exists()) {
      await File(oldFile).delete();
    }

    ProjectsDatabase db = ProjectsDatabase(dir.path);
    await db.update(duplicateProject);
    return await db.read();
  }

  Future<void> _exportProject(Project project) async {
    /*
    ProjectExporter exporter = ProjectExporter(project);
    final ExportPacket? packet = await showDialog(
      context: context,
      builder: (context) => ExportPopup(
        exporter.fileName,
        exporter.fileType,
      ),
    );

    if (packet != null) {
      exporter.fileName = packet.fileName;
      exporter.fileType = packet.fileType;
      await exporter.writeFile();

      displaySnackbar('Project Exported: $moveList');
    }

     */
  }

  Future<void> _deleteProject(Project project) async {
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => KoalaAlert(
            title: 'Delete Project',
            text:
                'Do you wish to delete $project? This action cannot be undone.',
          ),
        ) ??
        false;

    if (confirm) {
      await refreshPage(() async {
        await FileManagement.deleteProject(project);
      });
      displaySnackBar('Project Deleted: $project');
    }
  }
}

class _NewProjectPopup extends StatefulWidget {
  final ProjectsPageState parent;
  final String initialName;
  final String title;

  const _NewProjectPopup({
    required this.parent,
    required this.initialName,
    required this.title,
  });

  @override
  State<_NewProjectPopup> createState() => _NewProjectPopupState();
}

class _NewProjectPopupState extends State<_NewProjectPopup> {
  late String _name;
  bool _isValidName = true;
  late Template _template;
  final List<Template> _templates = [
    EmptyTemplate(),
    HighFantasyTemplate(),
    SciFiTemplate(),
    WesternTemplate(),
    ModernMilitaryTemplate(),
    HorrorTemplate(),
    SuperheroTemplate(),
    NoirTemplate(),
    TrenchWarfareTemplate(),
  ];
  final List<String> _selections = [];

  @override
  initState() {
    super.initState();
    _name = widget.initialName;
    _template = _templates[0];
    for (Template template in _templates) {
      _selections.add(template.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeFactor = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Popup(
      context: context,
      onContinue: () async {
        if (_isValidName) {
          String createdTime = DateTime.now().toUtc().toIso8601String();
          Project project = Project(
            name: _name,
            createdDate: createdTime,
            lastSavedDate: createdTime,
            version: 0.1, //TODO: change to a getter for the current version held in the settings page...
          );

          Directory? dir = await FileManagement.addProject(project, _template);

          if (dir == null) {
            if (!mounted) return;
            Navigator.pop(context);
          } else {
            if (!mounted) return;
            Navigator.pop(
              context,
              await ProjectsDatabase(dir.path).read(),
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (context) => const KoalaSimpleAlert(
              title: ValidationTexts.title,
              text: ValidationTexts.invalidProjectName,
            ),
          );
        }
      },
      title: widget.title,
      borderRadius: 25,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TickerTextField(
              title: 'Name',
              lightingTheme: widget.parent.lightingTheme,
              width: sizeFactor * .7,
              initialValue: _name,
              autofocus: true,
              onChange: (value) {
                _name = value;
              },
              validate: (value) {
                _isValidName = removeWhitespace(value) != '' &&
                    !widget.parent
                        .isNameTaken(value, givenProject: widget.initialName);
                return _isValidName;
              },
              validationTextTitle: ValidationTexts.title,
              validationText: ValidationTexts.invalidProjectName,
            ),
            SizedBox(
              height: sizeFactor * .025,
            ),
            TickerDropdown(
              title: 'Template',
              lightingTheme: widget.parent.lightingTheme,
              width: sizeFactor * .7,
              selections: _selections,
              currentSelection: _template.name,
              onChange: (value) {
                setState(() {
                  for (Template template in _templates) {
                    if (template.name == value) {
                      _template = template;
                      break;
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
