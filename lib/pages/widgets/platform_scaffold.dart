import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pragma_prueba/theme/app_colors.dart';

class PlatformScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? leading;

  const PlatformScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.leading
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
   
        backgroundColor: AppColors.white,
        navigationBar: CupertinoNavigationBar(
          //automaticallyImplyLeading: true,
          leading:  leading ??null , //Icon(Icons.arrow_back_ios),
          backgroundColor: AppColors.white,

          // El texto se centra automáticamente con middle
          middle: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
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
