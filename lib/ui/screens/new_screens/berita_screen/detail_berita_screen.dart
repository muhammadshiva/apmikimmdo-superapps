import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;

// ignore: must_be_immutable
class DetailBeritaScreen extends StatelessWidget {
  final NewsActivity newsActivity;
  bool useLineProgress;
  bool isUpgradeUser;

  DetailBeritaScreen({
    Key key,
    @required this.newsActivity,
    this.useLineProgress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      AppImg.img_arrow,
                      fit: BoxFit.contain,
                      height: 12,
                      width: 12,
                    ),
                  ),
                  Text(
                    "Berita & Kegiatan",
                    style: AppTypo.LatoBold.copyWith(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Scrollbar(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${newsActivity.title}",
                            style: AppTypo.LatoBold.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${newsActivity.createdAt}",
                            style: TextStyle(
                              color: Color(0xFF939393),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            child: Image.network(
                              newsActivity.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Html(
                          data: newsActivity.description,
                          style: {
                            "body": Style(
                              fontSize: FontSize(17.0),
                              fontWeight: FontWeight.normal,
                              color: Color(
                                0xFF939393,
                              ),
                              lineHeight: 1.3,
                              textAlign: TextAlign.left,
                            )
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
