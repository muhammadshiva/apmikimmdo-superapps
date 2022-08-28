import 'package:flutter/material.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class BadgeCard extends StatelessWidget {
  const BadgeCard(
      {Key key,
      this.margin,
      this.padding,
      this.borderRadius,
      this.text,
      this.color, this.textColor, this.fontSize})
      : super(key: key);

  final EdgeInsets margin, padding;
  final double borderRadius,fontSize;
  final String text;
  final Color color,textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(5),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 2),
        color: color ?? AppExt.badgeColor(text).background,
      ),
      child: Text(
        text,
        style: AppTypo.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor ?? AppExt.badgeColor(text).text,
            fontSize: fontSize ?? 12),
      ),
    );
  }
}
