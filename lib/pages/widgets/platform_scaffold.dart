import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pragma_prueba/theme/app_colors.dart';

class PlatformScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const PlatformScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: AppColors.white,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: AppColors.white,
          // El texto se centra automáticamente con middle
          middle: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17.0, // Tamaño estándar de iOS
            ),
            textAlign: TextAlign.center, // Asegurar centrado
          ),

          trailing: actions != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                )
              : null,

          automaticallyImplyMiddle: true, // Default: true
        ),
        child: body,
      );
    } else {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(title),
          actions: actions,
        ),
        body: body,
        floatingActionButton: floatingActionButton,
      );
    }
  }
}
