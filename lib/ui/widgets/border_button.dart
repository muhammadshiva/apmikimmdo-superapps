import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    Key key,
    @required this.color,
    @required this.child,
    @required this.onPressed,
    this.height,
    this.rounded = 50.0,
  }) : super(key: key);

  final Widget child;
  final double rounded;
  final Color color;
  final double height;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rounded),
          side: BorderSide(color: color)),
      onPressed: onPressed,
      child: child,
    );
  }
}
