import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketplace/api/api.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/new_cubit/search_news_activity/search_news_activity_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/search/search_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/ui/screens/new_screens/berita_screen/widgets/vertical_category_news.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/cart_screen.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/screens/nav/new/home/home_nav.dart';
import 'package:marketplace/ui/screens/web/screens/web_screens.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/news_card.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class SearchScreenNewsActivity extends StatefulWidget {
  final String keyword;
  const SearchScreenNewsActivity({
    Key key,
    this.keyword,
  }) : super(key: key);

  @override
  _SearchScreenNewsActivityState createState() =>
      _SearchScreenNewsActivityState();
}

class _SearchScreenNewsActivityState extends State<SearchScreenNewsActivity> {
  SearchNewsActivityCubit _searchCubit;
  Timer _debounce;
  // BERITA & KEGIATAN
  List<String> _categoriesNews = [""];

  TextEditingController _searchController;
  Completer<void> _refreshCompleter;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _refreshCompleter = Completer<void>();
    _searchCubit = SearchNewsActivityCubit();
    _searchController = TextEditingController(text: "");
  }

  _onSearchChanged(String keyword) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      AppExt.hideKeyboard(context);
      if (keyword.isNotEmpty) {
        _searchCubit.search(keyword: keyword.toString());
      }
    });
  }

  @override
  void dispose() {
    _searchCubit.close();
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _searchCubit,
          ),
        ],
        child: !context.isPhone
            ? Scaffold(
                body: ParentSearchWeb(keyword: widget.keyword),
              )
            : GestureDetector(
                onTap: () => AppExt.hideKeyboard(context),
                child: DefaultTabController(
                  length: _categoriesNews.length,
                  initialIndex: 0,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      brightness: Brightness.light,
                      iconTheme: IconThemeData(color: AppColor.black),
                      backgroundColor: Colors.white,
                      elevation: 10,
                      titleSpacing: 0,
                      shadowColor: AppColor.black.withOpacity(0.05),
                      centerTitle: false,
                      title: Container(
                        height: 50,
                        child: EditText(
                          controller: _searchController,
                          hintText: "Cari berita dan kegiatan ...",
                          autofocus: true,
                          focusNode: _focusNode,
                          inputType: InputType.search,
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      actions: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            BlocProvider.of<UserDataCubit>(context)
                                            .state
                                            .countCart !=
                                        null &&
                                    BlocProvider.of<UserDataCubit>(context)
                                            .state
                                            .countCart >
                                        0
                                ? new Positioned(
                                    right: 5,
                                    top: -10,
                                    child: Chip(
                                      shape:
                                          CircleBorder(side: BorderSide.none),
                                      backgroundColor: AppColor.red,
                                      padding: EdgeInsets.zero,
                                      labelPadding:
                                          BlocProvider.of<UserDataCubit>(
                                                          context)
                                                      .state
                                                      .countCart >
                                                  99
                                              ? EdgeInsets.all(2)
                                              : EdgeInsets.all(4),
                                      label: Text(
                                        "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
                                        style: AppTypo.overlineInv
                                            .copyWith(fontSize: 8),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                    body: BlocBuilder(
                      cubit: _searchCubit,
                      builder: (context, state) =>
                          AppTrans.SharedAxisTransitionSwitcher(
                        fillColor: Colors.transparent,
                        transitionType: SharedAxisTransitionType.vertical,
                        child: state is SearchNewsActivityLoading
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
                            : state is SearchNewsActivityFailure
                                ? Center(
                                    child: state.type == ErrorType.network
                                        ? NoConnection(onButtonPressed: () {
                                            if (_searchController
                                                .text.isNotEmpty) {
                                              _searchCubit.search(
                                                  keyword:
                                                      _searchController.text);
                                            }
                                          })
                                        : ErrorFetch(
                                            message: state.message,
                                            onButtonPressed: () {
                                              if (_searchController
                                                  .text.isNotEmpty) {
                                                _searchCubit.search(
                                                    keyword:
                                                        _searchController.text);
                                              }
                                            },
                                          ),
                                  )
                                : state is SearchNewsActivitySuccess
                                    ? state.result.length > 0
                                        ? RefreshIndicator(
                                            color: AppColor.primary,
                                            backgroundColor: Colors.white,
                                            strokeWidth: 3,
                                            onRefresh: () {
                                              if (_searchController
                                                  .text.isNotEmpty) {
                                                _searchCubit.search(
                                                    keyword:
                                                        _searchController.text);
                                              }
                                              return _refreshCompleter.future;
                                            },
                                            child: ListView.builder(
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    _screenWidth * (5 / 100),
                                                horizontal:
                                                    _screenWidth * (5 / 100),
                                              ),
                                              itemExtent: 110,
                                              itemCount: state.result.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                NewsActivity _item =
                                                    state.result[index];
                                                return VerticalCategoryNews(
                                                  newsActivity: _item,
                                                );
                                              },
                                            ),
                                          )
                                        : Center(
                                            child: EmptyData(
                                              title: "Produk tidak ditemukan",
                                              subtitle:
                                                  "Silahkan coba kata kunci lain",
                                              labelBtn: "Ubah Kata Kunci",
                                              onClick: () {
                                                _focusNode.requestFocus();
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
    );
  }
}
