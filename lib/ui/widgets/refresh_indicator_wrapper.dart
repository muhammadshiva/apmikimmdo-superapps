import 'package:flutter/material.dart';

import 'package:marketplace/utils/colors.dart' as AppColor;

class RefreshIndicatorWrapper extends StatelessWidget {
  const RefreshIndicatorWrapper({
    Key key,
    @required this.child,
    this.visible = true,
    this.onRefresh,
  }) : super(key: key);

  final Widget child;
  final bool visible;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (visible)
      return RefreshIndicator(
        color: AppColor.primary,
        backgroundColor: Colors.white,
        strokeWidth: 3,
        onRefresh: onRefresh,
        child: child,
      );

    return child;
  }
}
