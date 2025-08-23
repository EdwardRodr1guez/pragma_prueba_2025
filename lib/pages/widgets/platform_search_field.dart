import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pragma_prueba/theme/app_colors.dart';

class PlatformSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;

  const PlatformSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onClear,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Platform.isIOS ? CupertinoColors.systemGrey6 : Colors.grey[100],
        borderRadius: BorderRadius.circular(Platform.isIOS ? 10 : 25),
        border: Platform.isIOS
            ? Border.all(color: CupertinoColors.systemGrey4, width: 1)
            : null,
      ),
      child: Platform.isIOS
          ? CupertinoTextField(
            placeholderStyle: TextStyle(color: AppColors.black),
              controller: controller,
              placeholder: hintText,
            style: TextStyle(color: AppColors.black) ,
              onChanged: onChanged,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(),
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.search,
                  color: CupertinoColors.systemGrey,
                  size: 30,
                ),
              ),
              suffix: controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: onClear,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                        Icons.clear,
                          color: CupertinoColors.systemGrey,
                          size: 20,
                        ),
                      ),
                    )
                  : null,
            )
          : TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: onClear,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
    );
  }
}
