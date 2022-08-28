import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class ProductDescription extends StatefulWidget {
  const ProductDescription({Key key, @required this.description})
      : super(key: key);

  final String description;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    const int _limit = 10;
    final desc = widget.description;
    final expanded = _expanded(desc);
    debugPrint("isExpanded $expanded");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          desc,
          style: AppTypo.caption,
          overflow: TextOverflow.fade,
          maxLines: _expand ? 35 : 3,
        ),
        expanded
            ? TextButton(
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
                child: Text(
                  !_expand ? "Lihat Selengkapnya" : "Sembunyikan",
                  style: AppTypo.caption.copyWith(color: AppColor.primary),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  bool _expanded(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: AppTypo.caption),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width - 32);
    return textPainter.didExceedMaxLines;
  }
}
