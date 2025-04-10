import 'package:flutter/material.dart';
import 'package:fairway/export.dart';

class BulletPointItem extends StatelessWidget {
  const BulletPointItem({
    required this.text,
    super.key,
    this.textStyle,
    this.bulletCharacter = '•',
    this.bulletSize = 16.0,
    this.bulletColor,
    this.spacing = 8.0,
    this.padding = const EdgeInsets.only(bottom: 8),
  });

  final String text;
  final TextStyle? textStyle;
  final String bulletCharacter;
  final double bulletSize;
  final Color? bulletColor;
  final double spacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bulletCharacter,
            style: TextStyle(
              fontSize: bulletSize,
              color: bulletColor ?? AppColors.black,
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Text(
              text,
              style: textStyle ?? context.b2.copyWith(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
