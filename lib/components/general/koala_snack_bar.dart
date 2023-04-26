import 'package:flutter/material.dart';

class KoalaSnackBar extends SnackBar {
  KoalaSnackBar(
    BuildContext context,
    String text, {
    super.key,
  }) : super(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .60,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    textWidthBasis: TextWidthBasis.longestLine,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
}
