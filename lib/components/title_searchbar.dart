import 'package:flutter/material.dart';

import 'general/tap_detector.dart';

class TitleSearchbar extends StatefulWidget {
  final Function(String) onChanged;
  _TitleSearchbarState? _currentState;
  final String hintText;

  TitleSearchbar({
    super.key,
    required this.onChanged,
    required this.hintText,
  });

  String get value => _currentState?._textController.text ?? '';

  @override
  State<TitleSearchbar> createState() => _TitleSearchbarState();
}

class _TitleSearchbarState extends State<TitleSearchbar> {
  final TextEditingController _textController = TextEditingController();
  String? _checkValue;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._currentState = this;
    _checkValue = _textController.text;
    return Container(
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: Colors.lightBlue,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.5, right: 7.5),
              child: TapDetector(
                child: TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.lightBlue,
                  ),
                  onChanged: (value) {
                    if (value != _checkValue) {
                      _checkValue = value;
                      setState(() {
                        widget.onChanged(value);
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: _textController.text.isNotEmpty,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Center(
                child: TapDetector(
                  onTap: () {
                    setState(() {
                      _textController.clear();
                      widget.onChanged('');
                    });
                  },
                  child: const CircleAvatar(
                    radius: 12.5,
                    backgroundColor: Colors.lightBlue,
                    child: Icon(
                      Icons.clear_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
