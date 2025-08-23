import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Componente nativo adaptativo
class PlatformButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const PlatformButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            color: isPrimary ? CupertinoColors.activeBlue : null,
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                color: isPrimary
                    ? CupertinoColors.white
                    : CupertinoColors.activeBlue,
              ),
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isPrimary ? Theme.of(context).primaryColor : null,
            ),
            onPressed: onPressed,
            child: Text(text),
          );
  }
}
