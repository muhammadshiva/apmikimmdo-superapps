import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/ui/screens/new_screens/berita_screen/detail_berita_screen.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/product_detail_screen.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/bs_bagikan_produk.dart';
import 'package:marketplace/ui/widgets/bs_feedback.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:shimmer/shimmer.dart';
import 'package:websafe_svg/websafe_svg.dart';

// ignore: must_be_immutable
class NewsListItem extends StatelessWidget {
  final NewsActivity newsActivity;
  bool useLineProgress;
  bool isUpgradeUser;

  NewsListItem({
    Key key,
    @required this.newsActivity,
    this.useLineProgress = false,
    this.isUpgradeUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final isUser = BlocProvider.of<UserDataCubit>(context).state.user != null
        ? BlocProvider.of<UserDataCubit>(context).state.user
        : null;
    isUpgradeUser = isUser != null ? isUser.reseller != null : false;

    return InkWell(
        onTap: () {
          AppExt.pushScreen(
              context,
              DetailBeritaScreen(
                newsActivity: this.newsActivity,
              ));
        },
        child: cardProduct(context, isUser, _screenHeight));
  }

  Align cardProduct(BuildContext context, User userData, double screenHeight) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: Container(
          height: isUpgradeUser
              ? 342
              : isUpgradeUser
                  ? 342
                  : isUpgradeUser
                      ? 332
                      : 245,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColor.black.withOpacity(0.08),
                blurRadius: 5,
                // spreadRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl: newsActivity.cover ??
                            'https://v2end.panenpanen.id/images/blank.png',
                        memCacheHeight: Get.height > 350
                            ? (Get.height * 0.25).toInt()
                            : Get.height,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[200],
                          period: Duration(milliseconds: 1000),
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                color: Colors.white),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          AppImg.img_error,
                          width: double.infinity,
                          height: 115,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${newsActivity.title}",
                        maxLines: kIsWeb ? 2 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypo.caption.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${newsActivity.createdAt}",
                          maxLines: kIsWeb ? null : 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypo.caption.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColor.grey),
                        ),
                      ),
                    ],
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
