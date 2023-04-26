import 'package:flutter/cupertino.dart';

class FlexBox extends StatelessWidget {
  final int flex;

  const FlexBox(
    this.flex, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: const SizedBox(),
    );
  }
}
