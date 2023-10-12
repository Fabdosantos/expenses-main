import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptativeButton extends StatelessWidget {
  final String label;
  final dynamic onPressed;

  const AdaptativeButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: onPressed,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            color: Theme.of(context).primaryColor,
            child: Text(label),
          )
        : ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => Theme.of(context).textTheme.labelLarge?.color),
              iconColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColor),
            ),
            onPressed: onPressed,
            child: Text(label),
          );
  }
}
