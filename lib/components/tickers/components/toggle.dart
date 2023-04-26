import 'package:flutter/cupertino.dart';

abstract class Toggle<T extends Object> extends StatefulWidget {
  final String title;

  const Toggle({
    super.key,
    required this.title,
  });

  T getValue();
}
