import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:beamer/beamer.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class BreadCumbItemWeb extends StatelessWidget {
  final MouseCursor mouseCursor;
  final InlineSpan inlineSpan;
  final Color color;
  final String route, title;
  const BreadCumbItemWeb(
      {Key key,
      this.mouseCursor,
      this.inlineSpan,
      this.route,
      this.title,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: mouseCursor,
        child: GestureDetector(
          onTap: () {
            route != null ? context.beamToNamed(route) : null;
          },
          child: Text(
            title,
            style: AppTypo.body1
                .copyWith(fontSize: 16, color: color ?? AppColor.primary),
          ),
        ));
  }
}
