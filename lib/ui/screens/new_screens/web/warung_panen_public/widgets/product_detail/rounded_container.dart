import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer(
      {Key key,
      @required this.child,
      this.fillColor = Colors.white,
      this.padding = const EdgeInsets.all(8)})
      : super(key: key);

  final Color fillColor;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: fillColor),
        child: child);
  }
}
