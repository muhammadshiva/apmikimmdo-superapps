import 'package:flutter/material.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;

class FilledButton extends StatelessWidget {
  const FilledButton({
    Key key,
    @required this.color,
    @required this.child,
    @required this.onPressed,
    this.rounded = 50,
    this.height,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final double rounded;
  final double height;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      height: height,
      disabledColor: AppColor.inactiveSwitch,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rounded),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
