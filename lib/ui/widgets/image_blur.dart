import 'dart:ui';

import 'package:flutter/material.dart';

class ImageBlur extends StatelessWidget {
  const ImageBlur({Key key, this.width, this.height, this.color, @required this.child})
      : super(key: key);

  final double height;
  final double width;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      child: child,
    );
  }
}
