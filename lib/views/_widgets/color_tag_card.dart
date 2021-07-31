import 'package:flutter/material.dart';

class ColorTagCard extends StatelessWidget {
  final String colorName;
  final Color? textColor;
  final Color? backgroundColor;
  final double? borderRadius;

  const ColorTagCard({
    Key? key,
    required this.colorName,
    this.backgroundColor,
    this.borderRadius,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Theme.of(context).primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 15),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
        child: Text(
          colorName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
