// Alert dialog nativo
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pragma_prueba/theme/app_colors.dart';

class PlatformAlertDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
