import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/general/advanced_scaffold.dart';
import 'package:gaming_toolkit/components/universal_nav_bar.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/rename_popup.dart';
import 'package:gaming_toolkit/koala_toolkit_back_end/validation_texts.dart';

import '../../../components/expandable_list.dart';
import '../../../components/general/koala_scrollbar.dart';
import '../../../components/general/tap_detector.dart';
import '../../../components/name_capsule.dart';
import '../../../koala_strings.dart';
import '../../../koala_toolkit_back_end/project_packet.dart';
import '../../../my_constants.dart';
import '../koala_page.dart';

class ProjectHomePage extends KoalaPage {
  final ProjectPacket project;

  const ProjectHomePage(
    this.project, {
    super.key,
  });

  @override
  KoalaPageState<ProjectHomePage> createState() => ProjectHomePageState();
}

class ProjectHomePageState extends KoalaPageState<ProjectHomePage> {
  @override
  Future<void> subRefresh() async {}

  @override
  initState(){
    super.initState();
    refreshPage(() async {});
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sizeFactor = max(screenWidth, screenHeight);
    final double buttonHeight = sizeFactor * .2625;
    final double buttonWidth = screenWidth * .425;

    return AdvancedScaffold(
      pageTitle: 'Home',
      barColor: Colors.blue,
      barTextColor: MyConstants.primaryColor,
      onWillPop: () async {
        await popToLandingPage();
        return false;
      },
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
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Visibility(
            visible: !isLoading,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight * .03,
                      ),
                      NameCapsule(
                        width: screenWidth * .91,
                        height: screenHeight * .1,
                        value: widget.project.project.name,
                        onTap: _renameProject,
                      ),
                      SizedBox(
                        height: screenHeight * .03,
                      ),
                      Container(
                        width: screenWidth * .75,
                        height: screenHeight * .00375,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        height: screenHeight * .03,
                      ),
                      SizedBox(
                        width: screenWidth * .91,
                        child: ExpandableList(
                          title: 'Summary',
                          items: [
                            'Move Lists: ${widget.project.moveListCount}',
                            'Moves: ${widget.project.moveCount}',
                            'Unit Lists: ${widget.project.unitListCount}',
                            'Units: ${widget.project.unitCount}',
                          ],
                          childrenHeight: sizeFactor * .065,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * .03,
                      ),
                      Container(
                        width: screenWidth * .75,
                        height: screenHeight * .00375,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        height: screenHeight * .03,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TapDetector(
                            onTap: () async => _exportProject(),
                            child: Container(
                              height: buttonHeight,
                              width: buttonWidth,
                              decoration: BoxDecoration(
                                color: lightingTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: lightingTheme.shadowColor,
                                    spreadRadius: 3.2,
                                    blurRadius: 3.2,
                                    offset: const Offset(
                                      0,
                                      3.2,
                                    ),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: buttonHeight * .65,
                                      height: buttonHeight * .65,
                                      child: Center(
                                        child: Icon(
                                          Icons.download_rounded,
                                          size: buttonHeight * .65,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'EXPORT\nPROJECT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: buttonHeight * .12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TapDetector(
                            onTap: popToLandingPage,
                            child: Container(
                              height: buttonHeight,
                              width: buttonWidth,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: lightingTheme.shadowColor,
                                    spreadRadius: 3.2,
                                    blurRadius: 3.2,
                                    offset: const Offset(
                                      0,
                                      3.2,
                                    ),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: buttonHeight * .65,
                                      height: buttonHeight * .65,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Center(
                                              child: Icon(
                                                Icons.circle_outlined,
                                                size: buttonHeight * .65,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: buttonHeight * .425,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'CLOSE\nPROJECT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: buttonHeight * .12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * .03,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          loadingScreen(),
        ],
      ),
      bottomNavigationBar: UniversalNavBar(
        context,
        project: widget.project,
        selection: 'Home',
        onWillPush: () async => true,
      ),
    );
  }

  Future<void> _renameProject() async {
    final String? result = await showDialog(
      context: context,
      builder: (context) => RenamePopup(
        title: 'Rename Project',
        initialValue: widget.project.project.name,
        validate: (value) {
          return removeWhitespace(value) != '' &&
              !(widget.project.isProjectNameTaken(value));
        },
        validationText: ValidationTexts.invalidProjectName,
      ),
    );

    if (result != null) {
      refreshPage(() async {
        await widget.project.renameProject(result);
      });
      displaySnackBar('Project Renamed: $result');
    }
  }

  Future<void> _exportProject() async {
    /*
    ProjectExporter exporter = ProjectExporter(project.project);
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

      displaySnackbar('Project Exported: ${project.project}');
    }

     */
  }
}
