import 'package:flutter/material.dart';

class ScrollbarWrapper extends StatelessWidget {
  const ScrollbarWrapper({
    Key key,
    @required this.child,
    this.visible = true, this.isAlwaysShown = true,
  }) : super(key: key);

  final Widget child;
  final bool visible,isAlwaysShown;

  @override
  Widget build(BuildContext context) {
    if (visible)
      return Scrollbar(
        isAlwaysShown: isAlwaysShown,
        child: child,
      );

    return child;
  }
}
