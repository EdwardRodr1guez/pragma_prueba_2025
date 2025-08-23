import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pragma_prueba/theme/app_colors.dart';

/// App Bar adaptativa
class PlatformAppbar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  const PlatformAppbar(
      {super.key, required this.title, this.actions, this.centerTitle = true});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      
      return CupertinoNavigationBar(
        backgroundColor: AppColors.white,
        middle: Text(title),
        trailing: actions != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
      );
    } else {
      return AppBar(
        backgroundColor: AppColors.white,
        centerTitle: centerTitle,
        title: Text(title),
        actions: actions,
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight,
      );

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
