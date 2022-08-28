import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/ui/screens/new_screens/berita_screen/detail_berita_screen.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:path/path.dart';

class VerticalCategoryNews extends StatelessWidget {
  final NewsActivity newsActivity;

  const VerticalCategoryNews({
    Key key,
    @required this.newsActivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBeritaScreen(
                    newsActivity: this.newsActivity,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 96,
                    height: 96,
                    child: CachedNetworkImage(
                      imageUrl: newsActivity.cover,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 220,
                      height: 72,
                      child: Text(
                        "${newsActivity.title}",
                        style: AppTypo.LatoBold.copyWith(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      width: 220,
                      height: 20,
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            child: Image.asset(
                              AppImg.img_clock,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          // Text("${newsActivity.tags}"),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${newsActivity.createdAt}",
                            style: AppTypo.LatoBold.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF4E4B66),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
