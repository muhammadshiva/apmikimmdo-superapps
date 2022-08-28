import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/tag_news_activity.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class HorizontalCategoryNews extends StatefulWidget {
  // final bool isActive;
  final List<TagNewsActivity> tagNews;
  final Function(int idTags) onTap;
  final int tagsIdSelected;

  const HorizontalCategoryNews({
    Key key,
    @required this.tagNews,
    this.onTap,
    this.tagsIdSelected,
  }) : super(key: key);

  @override
  _HorizontalCategoryNewsState createState() => _HorizontalCategoryNewsState();
}

class _HorizontalCategoryNewsState extends State<HorizontalCategoryNews> {
  @override
  Widget build(BuildContext context) {
    int idTags = widget.tagsIdSelected;
    final double _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 34,
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (ctx, idx) => SizedBox(width: 20),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.tagNews.length,
        itemBuilder: (BuildContext context, int index) {
          TagNewsActivity _tag = widget.tagNews[index];
          return InkWell(
            onTap: () {
              if (idTags != _tag.id) {
                setState(() {
                  idTags = _tag.id;
                });
                widget.onTap(_tag.id);
              }
            },
            child: Container(
              height: 34,
              child: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          "${_tag.name}",
                          style: AppTypo.LatoBold.copyWith(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        idTags == _tag.id
                            ? Container(
                                height: 2,
                                width: 58,
                                decoration: BoxDecoration(
                                  color: idTags == _tag.id
                                      ? AppColor.appPrimary
                                      : AppColor.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: idTags == _tag.id ? 3 : 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
