import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaming_toolkit/pages/koala_toolkit_pages/popups/koala_alert.dart';
import 'package:gaming_toolkit/user_preferences.dart';

import '../../../components/popup.dart';
import '../../../components/tickers/ticker_dropdown.dart';
import '../../../components/tickers/ticker_text_field.dart';
import '../../../koala_toolkit_back_end/export/move_list_exporter.dart';
import '../../../koala_toolkit_back_end/export/unit_list_exporter.dart';

class ExportPopup extends StatefulWidget {
  static const nameValidationTitle = 'Invalid File Name';
  static const nameValidationText =
      'The file name is invalid, due to the field being empty.';

  late final String _initialName;
  late final FileType _initialFileType;

  ExportPopup(
    String initialName,
    FileType initialFileType, {
    super.key,
  }) {
    _initialName = initialName;
    _initialFileType = initialFileType;
  }

  @override
  State<ExportPopup> createState() => _ExportPopupState();
}

class _ExportPopupState extends State<ExportPopup> {
  late String _fileName;
  bool _isValidName = true;
  late FileType _fileType;

  @override
  initState() {
    super.initState();
    _fileName = widget._initialName;
    _fileType = widget._initialFileType;
  }

  @override
  Widget build(BuildContext context) {
    double sizeFactor = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Popup(
      context: context,
      onContinue: () {
        if (_isValidName) {
          Navigator.pop(
            context,
            UnitExportPacket(
              _fileName,
              _fileType,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => const KoalaSimpleAlert(
              title: ExportPopup.nameValidationTitle,
              text: ExportPopup.nameValidationText,
            ),
          );
        }
      },
      title: 'Export',
      borderRadius: 25,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TickerTextField(
            title: 'Package Name',
            lightingTheme: UserPreferences.getLightingTheme(),
            width: sizeFactor * .7,
            initialValue: _fileName,
            autofocus: true,
            onChange: (value) {
              _fileName = value;
            },
            validate: (value) {
              _isValidName = value.isNotEmpty;
              return _isValidName;
            },
            validationTextTitle: ExportPopup.nameValidationTitle,
            validationText: ExportPopup.nameValidationText,
          ),
          SizedBox(
            height: sizeFactor * .025,
          ),
          TickerDropdown(
            title: 'File Type',
            lightingTheme: UserPreferences.getLightingTheme(),
            width: sizeFactor * .7,
            selections: FileType.allNames(),
            currentSelection: _fileType.name,
            onChange: (value) {
              setState(() {
                _fileType = FileType.map[value]!;
              });
            },
          ),
        ],
      ),
    );
  }
}
