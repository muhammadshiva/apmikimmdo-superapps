import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/ui/widgets/news_list_item.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:get/get.dart';

class NewsList extends StatelessWidget {
  final String section;
  final List<NewsActivity> news;
  final Function() viewAll;

  const NewsList(
      {Key key,
      @required this.section,
      @required this.news,
      @required this.viewAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    final bool isUpgradeUser =
        BlocProvider.of<UserDataCubit>(context).state.user != null &&
                BlocProvider.of<UserDataCubit>(context).state.user.reseller !=
                    null ||
            BlocProvider.of<UserDataCubit>(context).state.user != null &&
                BlocProvider.of<UserDataCubit>(context).state.user.supplier !=
                    null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _screenWidth * (5 / 100),
            vertical: 16
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section,
                style: AppTypo.LatoBold.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              viewAll != null
                  ? Material(
                      color: AppColor.transparent,
                      child: InkWell(
                        onTap: viewAll,
                        borderRadius: BorderRadius.circular(5),
                        child: Text(
                          "Lihat Semua",
                          textAlign: TextAlign.right,
                          style: AppTypo.LatoBold.copyWith(
                              color: AppColor.appPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: isUpgradeUser
              ? 265
              : isUpgradeUser
                  ? 265
                  : 265,
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (ctx, idx) => SizedBox(width: 10),
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: 5,
              left: !context.isPhone ? 18 : _screenWidth * (5 / 100),
            ),
            itemCount: news.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              NewsActivity _news = news[index];
              return Container(
                width: 150,
                child: NewsListItem(
                  newsActivity: _news,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
