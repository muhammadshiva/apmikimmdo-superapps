import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketplace/api/api.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/fetch_news_activity_by_tag/fetch_news_activity_by_tag_cubit.dart';
// import 'package:marketplace/data/blocs/fetch_tag_news_activity/tag_news_activity_cubit.dart';
import 'package:marketplace/data/blocs/tag_news_activity/tag_news_activity_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/data/models/new_models/tag_news_activity.dart';
import 'package:marketplace/ui/screens/new_screens/berita_screen/widgets/horizontal_category_news.dart';
import 'package:marketplace/ui/screens/new_screens/berita_screen/widgets/vertical_category_news.dart';
import 'package:marketplace/ui/screens/new_screens/search/search_screen_news_activity.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/horizontal_category.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;

class TagNewsActivityScreen extends StatefulWidget {
  final int tagId;

  const TagNewsActivityScreen({
    Key key,
    @required this.tagId,
  }) : super(key: key);

  @override
  _TagNewsActivityScreenState createState() => _TagNewsActivityScreenState();
}

class _TagNewsActivityScreenState extends State<TagNewsActivityScreen> {
  FetchNewsActivityByTagCubit _fetchNewsActivityByTagCubit;
  FetchTagNewsActivityCubit _fetchTagNewsActivityCubit;

  List<TagNewsActivity> horizontalTagNews = [];
  int tagId = 0;

  @override
  void initState() {
    tagId = widget.tagId;
    _fetchNewsActivityByTagCubit = FetchNewsActivityByTagCubit()
      ..fetchNewsActivityByTag(tagId: widget.tagId);
    _fetchTagNewsActivityCubit = FetchTagNewsActivityCubit()..load();
    super.initState();
  }

  @override
  void dispose() {
    _fetchNewsActivityByTagCubit.close();
    _fetchTagNewsActivityCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final userData = BlocProvider.of<UserDataCubit>(context).state.user;

    return WillPopScope(
      onWillPop: () async {
        if (kIsWeb) {
          AppExt.popScreen(context);
          AppExt.popScreen(context);
          return false;
        } else {
          return true;
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => _fetchNewsActivityByTagCubit,
            ),
            BlocProvider(
              create: (_) => _fetchTagNewsActivityCubit,
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener(
                cubit: _fetchTagNewsActivityCubit,
                listener: (context, state) {
                  if (state is FetchTagNewsActivitySuccess) {
                    for (int i = 0; i < state.tagNewsActivity.length + 1; i++) {
                      if (i == 0) {
                        horizontalTagNews.add(TagNewsActivity(
                          id: 0,
                          name: "Semua Berita",
                          slug: "semua-berita",
                        ));
                      } else {
                        horizontalTagNews.add(TagNewsActivity(
                          id: state.tagNewsActivity[i - 1].id,
                          name: state.tagNewsActivity[i - 1].name,
                          slug: state.tagNewsActivity[i - 1].slug,
                        ));
                      }
                    }
                  }
                },
              ),
            ],
            child: Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
                child: Scaffold(
                  appBar: _buildAppBar(
                      context, _screenWidth, _fetchTagNewsActivityCubit),
                  body: BlocBuilder(
                    cubit: _fetchNewsActivityByTagCubit,
                    builder: (context, state) =>
                        AppTrans.SharedAxisTransitionSwitcher(
                      fillColor: Colors.transparent,
                      transitionType: SharedAxisTransitionType.vertical,
                      child: state is FetchNewsActivityByTagLoading
                          ? ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                              itemExtent: 110,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return ShimmerNewsActivity();
                              },
                            )
                          : state is FetchNewsActivityByTagFailure
                              ? Center(
                                  child: state.type == ErrorType.network
                                      ? NoConnection(onButtonPressed: () {
                                          _fetchNewsActivityByTagCubit
                                              .fetchNewsActivityByTag(
                                                  tagId: widget.tagId);
                                        })
                                      : ErrorFetch(
                                          message: state.message,
                                          onButtonPressed: () {
                                            _fetchNewsActivityByTagCubit
                                                .fetchNewsActivityByTag(
                                                    tagId: widget.tagId);
                                          },
                                        ))
                              : state is FetchNewsActivityByTagSuccess
                                  ? state.newsActivity.length > 0
                                      ? RefreshIndicator(
                                          color: AppColor.primary,
                                          backgroundColor: AppColor.white,
                                          strokeWidth: 3,
                                          onRefresh: () =>
                                              _fetchNewsActivityByTagCubit
                                                  .fetchNewsActivityByTag(
                                                      tagId: widget.tagId),
                                          child: new ListView.builder(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 15,
                                            ),
                                            itemExtent: 110,
                                            itemCount:
                                                state.newsActivity.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              NewsActivity _item =
                                                  state.newsActivity[index];
                                              return VerticalCategoryNews(
                                                  newsActivity: _item);
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: EmptyData(
                                            title:
                                                "Berita dan kegiatan tidak tersedia",
                                            subtitle:
                                                "Maaf berita dan kegiatan tidak ditemukan",
                                            labelBtn:
                                                "Cari berita dan kegiatan lain",
                                            onClick: () {
                                              BlocProvider.of<BottomNavCubit>(
                                                      context)
                                                  .navItemTapped(0);
                                              AppExt.popUntilRoot(context);
                                            },
                                          ),
                                        )
                                  : SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, double _screenWidth,
      FetchTagNewsActivityCubit fetchTagNewsActivityCub) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: AppColor.textPrimary),
      backgroundColor: AppColor.textPrimaryInverted,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      title: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
                ),
                Text(
                  "Berita & Kegiatan",
                  style: AppTypo.LatoBold.copyWith(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              // child: Expanded(
              child: Container(
                height: 50,
                padding: EdgeInsets.only(top: 3),
                child: EditText(
                  hintText: "Cari berita & kegiatan ...",
                  inputType: InputType.search,
                  readOnly: true,
                  onTap: () =>
                      AppExt.pushScreen(context, SearchScreenNewsActivity()),
                ),
              ),
              // ),
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder(
              cubit: _fetchTagNewsActivityCubit,
              builder: (context, fetchTagNewsActivityState) {
                return fetchTagNewsActivityState is FetchTagNewsActivityLoading
                    ? Container(
                        height: 60,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                EdgeInsets.only(left: _screenWidth * (5 / 100)),
                            itemCount: 6,
                            itemBuilder: (ctx, idx) {
                              return ShimmerHorizontalCategory();
                            }),
                      )
                    : fetchTagNewsActivityState is FetchTagNewsActivityFailure
                        ? Center(
                            child: Text('Tag berita gagal dimuat'),
                          )
                        : fetchTagNewsActivityState
                                is FetchTagNewsActivitySuccess
                            ? fetchTagNewsActivityState.tagNewsActivity.length >
                                    0
                                ? HorizontalCategoryNews(
                                    tagsIdSelected: tagId,
                                    tagNews: horizontalTagNews,
                                    onTap: (int idTag) {
                                      setState(() {
                                        tagId = idTag;
                                      });
                                      _fetchNewsActivityByTagCubit
                                          .fetchNewsActivityByTag(
                                              tagId: idTag ?? 0);
                                    },
                                  )
                                : null
                            : SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
