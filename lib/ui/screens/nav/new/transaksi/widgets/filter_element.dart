import 'package:flutter/material.dart';

class FilterElement extends StatelessWidget {
  const FilterElement(
      {Key key,
      @required this.onTap,
      @required this.child,
      this.allowedIcon = true,
      this.isFilterFilled = false})
      : super(key: key);

  final Function() onTap;
  final Widget child;
  final bool isFilterFilled;
  final bool allowedIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: isFilterFilled ? Color(0xFFFDF7EC) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isFilterFilled
                    ? Theme.of(context).primaryColor
                    : Colors.grey)),
        child: Row(
          children: [
            child,
            allowedIcon
                ? Icon(
                    Icons.keyboard_arrow_down,
                    color: isFilterFilled
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
