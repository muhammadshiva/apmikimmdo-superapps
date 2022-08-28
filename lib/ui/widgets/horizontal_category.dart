import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/category.dart';
import 'package:marketplace/ui/widgets/basic_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class HorizontalCategory extends StatefulWidget {
  const HorizontalCategory(
      {Key key, @required this.category, this.onTap, this.categoryIdSelected})
      : super(key: key);

  final List<Category> category;
  final Function(int idCategory) onTap;
  final int categoryIdSelected;

  @override
  _HorizontalCategoryState createState() => _HorizontalCategoryState();
}

class _HorizontalCategoryState extends State<HorizontalCategory> {
  @override
  Widget build(BuildContext context) {
    int idCategory = widget.categoryIdSelected;
    final double _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: _screenWidth * (3 / 100)),
        itemCount: widget.category.length,
        itemBuilder: (ctx, idx) {
          Category category = widget.category[idx];
          return InkWell(
            onTap: () {
              if (idCategory != category.id) {
                setState(() {
                  idCategory = category.id;
                });
                widget.onTap(category.id);
              }
            },
            child: Container(
              width: 130,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: _screenWidth * (2 / 100)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(listDecor[idx]), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  idCategory == category.id
                      ? Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: idCategory == category.id
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: idCategory == category.id ? 3 : 0,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        FittedBox(
                          child: Container(
                            width: 66,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              category.name,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: AppTypo.body2Lato
                                  .copyWith(color: Colors.white, fontSize: 14),
                            ),
                          ),
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

  List listDecor = [
    "https://images.tokopedia.net/img/cache/100/attachment/2019/10/8/40768394/40768394_8989ef25-ee3b-4510-89bb-fc894078954c.jpg",
    "https://images.tokopedia.net/img/cache/100/attachment/2019/10/8/40768394/40768394_1629133d-4c08-467c-aed0-bd8e82c7ea40.jpg",
    "https://images.tokopedia.net/img/cache/100/ndZFpx/2022/5/12/951b0dc7-c4ba-41b8-89eb-5177c6d273aa.jpg",
    "https://images.tokopedia.net/img/cache/100/ndZFpx/2022/3/10/bf82d076-cf05-48bf-a6cf-92a981091b0b.jpg",
    "https://images.tokopedia.net/img/cache/100/attachment/2019/11/7/75545163/75545163_f6ac6050-3872-48e8-b445-02a33e346061.jpg",
    "https://images.tokopedia.net/img/cache/100/attachment/2019/10/23/40768394/40768394_6a24460c-fbc2-40ab-bea6-3e557474f1d7.jpg",
    "https://images.tokopedia.net/img/cache/100/attachment/2019/10/23/40768394/40768394_7c9ad641-8a48-4b63-a4cc-cae37bbcaae1.jpg",
    "https://images.tokopedia.net/img/cache/100/attachment/2019/10/8/40768394/40768394_1629133d-4c08-467c-aed0-bd8e82c7ea40.jpg",
    "https://images.tokopedia.net/img/cache/100/ndZFpx/2022/3/10/bf82d076-cf05-48bf-a6cf-92a981091b0b.jpg",
    "https://images.tokopedia.net/img/cache/100/attachment/2019/11/7/75545163/75545163_f6ac6050-3872-48e8-b445-02a33e346061.jpg",
  ];
}

class ShimmerHorizontalCategory extends StatelessWidget {
  const ShimmerHorizontalCategory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        period: Duration(milliseconds: 1000),
        child: Container(
            width: 130,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: _screenWidth * (5 / 100)),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: SizedBox()));
  }
}
