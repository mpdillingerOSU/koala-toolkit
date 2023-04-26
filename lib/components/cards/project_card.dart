import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/aesthetics/ticker_lighting_theme.dart';

import '../../koala_toolkit_back_end/data/project.dart';
import '../dropdown_list.dart';
import '../general/tap_detector.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final double width;
  final double height;
  final TickerLightingTheme lightingTheme;

  final Future<void> Function() onOpen;
  final Future<void> Function() onRename;
  final Future<void> Function() onDuplicate;
  final Future<void> Function() onExport;
  final Future<void> Function() onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.width,
    required this.height,
    required this.lightingTheme,
    required this.onOpen,
    required this.onRename,
    required this.onDuplicate,
    required this.onExport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingVal = height * .15;

    return Container(
      width: width,
      height: height,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: paddingVal),
          Container(
            width: height * .70,
            height: height * .70,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Center(
              child: Text(
                project.initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * .375,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: paddingVal * 1.9),
          Expanded(
            child: TapDetector(
              onTap: onOpen,
              onDoubleTap: onRename,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * .035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * .05),
                    Text(
                      'Last Edited: ${_dateFormat(DateTime.parse(project.lastSavedDate).toLocal())}',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * .0225,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: paddingVal * .5),
          _buildDropdownMenu(context),
          SizedBox(width: paddingVal * .5),
        ],
      ),
    );
  }

  DropdownList<String> _buildDropdownMenu(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return DropdownList(
      padding: EdgeInsets.zero,
      color: Colors.white,
      borderWidth: 2,
      borderRadius: 15,
      child: Icon(
        Icons.adaptive.more_rounded,
        color: Colors.lightBlue,
        size: screenHeight * .055,
      ),
      itemBuilder: (context) => [
        DropdownSelection(
          value: 'Open',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Open',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.file_open_outlined,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Rename',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Rename',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.abc_rounded,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Duplicate',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Duplicate',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              Transform.rotate(
                angle: pi,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.copy_rounded,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        DropdownSelection(
          value: 'Export',
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Export',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.black,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.download_rounded,
                color: Colors.black,
              ),
            ],
          ),
        ),
        DropdownSelection(
          color: Colors.red,
          value: 'Delete',
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenHeight * .125,
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Sans Source Pro',
                    color: Colors.white,
                    fontSize: screenHeight * .025,
                  ),
                ),
              ),
              const Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'Open') {
          onOpen();
        } else if (value == 'Rename') {
          onRename();
        } else if (value == 'Duplicate') {
          onDuplicate();
        } else if (value == 'Export') {
          onExport();
        } else if (value == 'Delete') {
          onDelete();
        }
      },
    );
  }

  String _dateFormat(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day} ${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}';
  }
}
