import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/data/blocs/fetch_news_activity/fetch_news_activity_cubit.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;

// class NewsActivityCard extends StatefulWidget {
//   final int newsActivityId;

//   const NewsActivityCard({
//     Key key,
//     @required this.newsActivityId,
//   }) : super(key: key);

//   @override
//   _NewsActivityCardState createState() => _NewsActivityCardState();
// }

// class _NewsActivityCardState extends State<NewsActivityCard> {
//   FetchNewsActivityCubit _fetchNewsActivityCubit;

//   List<NewsActivity> horizontalNewsActivity = [];
//   int newsActivityId = 0;

//   @override
//   void initState() {
//     newsActivityId = widget.newsActivityId;
//     _fetchNewsActivityCubit = FetchNewsActivityCubit()..load();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class NewsActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6, right: 5, left: 5),
        child: Container(
          height: 250,
          width: 140,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColor.black.withOpacity(0.08),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.asset(
                  AppImg.img_error,
                  width: 140,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 120,
                child: RichText(
                  maxLines: kIsWeb ? null : 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text:
                        "Deputi Menteri Usaha Mikro Edi Satria dukung Appmikimmdo...",
                    style: AppTypo.LatoBold.copyWith(
                        fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 120,
                child: RichText(
                  maxLines: kIsWeb ? null : 1,
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: "24 Mar 2022",
                    style: AppTypo.body1
                        .copyWith(fontSize: 10, color: Color(0xFF9D9D9D)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
