import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppProductDetailDescription extends StatefulWidget {
  const WppProductDetailDescription({Key key, @required this.description})
      : super(key: key);

  final String description;

  @override
  _WppProductDetailDescriptionState createState() => _WppProductDetailDescriptionState();
}

class _WppProductDetailDescriptionState extends State<WppProductDetailDescription> {
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
          maxLines: _expand ? 16 : 3,
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
                  style: AppTypo.caption.copyWith(color: Colors.orangeAccent),
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
