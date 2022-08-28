import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer(
      {Key key,
      @required this.child,
      this.fillColor = Colors.white,
      this.padding = const EdgeInsets.all(8),
      this.margin})
      : super(key: key);

  final Color fillColor;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: fillColor),
        child: child);
  }
}
