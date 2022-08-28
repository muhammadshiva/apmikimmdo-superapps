import 'dart:async';
import 'package:animations/animations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/fetch_news_activity/fetch_news_activity_cubit.dart';
import 'package:marketplace/data/blocs/fetch_user/fetch_user_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_products_by_category/fetch_products_by_category_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/nav/nav.dart';
import 'package:marketplace/ui/screens/nav/new/home/widgets/bs_delivery_address.dart';
import 'package:marketplace/ui/screens/new_screens/berita_screen/berita_screen.dart';
import 'package:marketplace/ui/screens/new_screens/berita_screen/post_by_tag_screen.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/new_screens/product_by_category/product_by_category_screen.dart';
import 'package:marketplace/ui/screens/web/sections/web_sections.dart';
import 'package:marketplace/ui/widgets/grid_two_product_list_item.dart';
import 'package:marketplace/ui/widgets/horizontal_news_list.dart';
import 'package:marketplace/ui/widgets/horizontal_our_service_list.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:marketplace/data/blocs/fetch_home_slider/fetch_home_slider_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_products/fetch_products_cubit.dart';
import 'package:marketplace/data/models/new_models/category.dart'
    as categoryModel;
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/authentication_repository.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class HomeNav extends StatefulWidget {
  final BottomNavCubit bottomNavCubit;

  const HomeNav({
    Key key,
    @required this.bottomNavCubit,
  }) : super(key: key);

  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final AuthenticationRepository _authRepo = AuthenticationRepository();
  final RecipentRepository _recipentRepo = RecipentRepository();

  AnimationController _colorAnimationController;
  Animation<Color> _backgroundColorTween;

  FetchProductsCubit _fetchFlashSaleCubit,
      _fetchPromoCubit,
      _fetchBumdesCubit,
      _fetchBestSellCubit;

  FetchProductsByCategoryCubit _fetchProductsByCategoryCubit;
  FetchSelectedRecipentCubit _fetchSelectedRecipent;
  FetchHomeSliderCubit _fetchHomeSliderCubit;
  FetchCategoriesCubit _fetchCategoriesCubit;
  FetchUserCubit _fetchUserCubit;
  FetchNewsActivityCubit _fetchNewsActivityCubit;

  List<categoryModel.Category> categoryTemp = [];
  List<NewsActivity> newsActivityTemp = [];

  int categoryId = 0;

  @override
  void initState() {
    super.initState();
    _checkUser();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkHaveMainAddress();
    });*/

    _fetchHomeSliderCubit = FetchHomeSliderCubit()..fetchHomeSlider();
    _fetchFlashSaleCubit = FetchProductsCubit()..fetchProductsFlashSale();
    _fetchPromoCubit = FetchProductsCubit()..fetchProductsPromo();
    _fetchBestSellCubit = FetchProductsCubit()..fetchProductsBestSell();
    _fetchBumdesCubit = FetchProductsCubit()..fetchProductsBumdes();
    _fetchProductsByCategoryCubit = FetchProductsByCategoryCubit()
      ..fetchProductsByCategory(categoryId: categoryId);
    _fetchNewsActivityCubit = FetchNewsActivityCubit()..load();
    _fetchCategoriesCubit = FetchCategoriesCubit()..load();
    _fetchSelectedRecipent = FetchSelectedRecipentCubit()
      ..fetchSelectedRecipent();

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _backgroundColorTween =
        ColorTween(begin: AppColor.transparent, end: Color(0xFFF4406F))
            .animate(_colorAnimationController);
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 150);

      return true;
    }
  }

  void _checkUser() async {
    if (await _authRepo.hasToken()) {
      await BlocProvider.of<UserDataCubit>(context).loadUser();
    }
  }

  /*void _checkHaveMainAddress() async {
    RecipentObjectResponse userMainAddress =
        await _recipentRepo.getMainAddress();
    if (userMainAddress == null) {
      int mainAddressSubdistrictId =
          _recipentRepo.getSelectedSubdistrictIdStorage();
      if (mainAddressSubdistrictId == 0) {
        bool isRefresh = await AppExt.pushScreen(
            context,
            HandlingRecipentOverlay(
              isFromDeliverTo: false,
            ));
        if (isRefresh ?? true) {
          refreshData();
        }
      }
    }
  }*/

  Future refreshData() async {
    _checkUser();
    _fetchPromoCubit.fetchProductsPromo();
    _fetchBestSellCubit.fetchProductsBestSell();
    _fetchFlashSaleCubit.fetchProductsFlashSale();
    _fetchBumdesCubit.fetchProductsBumdes();
    _fetchHomeSliderCubit.fetchHomeSlider();
    _fetchProductsByCategoryCubit.fetchProductsByCategory(
        categoryId: categoryId);
    _fetchCategoriesCubit.load();
    _fetchNewsActivityCubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final userData = BlocProvider.of<UserDataCubit>(context).state.user != null
        ? BlocProvider.of<UserDataCubit>(context).state.user
        : null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _fetchFlashSaleCubit),
          BlocProvider(create: (_) => _fetchPromoCubit),
          BlocProvider(create: (_) => _fetchBestSellCubit),
          BlocProvider(create: (_) => _fetchHomeSliderCubit),
          BlocProvider(create: (_) => _fetchBumdesCubit),
          BlocProvider(create: (_) => _fetchCategoriesCubit),
          BlocProvider(create: (_) => _fetchSelectedRecipent),
          BlocProvider(create: (_) => _fetchProductsByCategoryCubit),
          BlocProvider(create: (_) => _fetchNewsActivityCubit),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener(
                cubit: _fetchCategoriesCubit,
                listener: (context, state) {
                  if (state is FetchCategoriesSuccess) {
                    categoryTemp.clear();
                    for (int i = 0; i < state.categories.length + 1; i++) {
                      if (i == 0) {
                        categoryTemp.add(categoryModel.Category(
                            id: 0,
                            name: "Semua Kategori",
                            slug: "semua-kategori",
                            icon: "allcategories.svg"));
                      } else {
                        categoryTemp.add(categoryModel.Category(
                            id: state.categories[i - 1].id,
                            name: state.categories[i - 1].name,
                            slug: state.categories[i - 1].slug,
                            icon: state.categories[i - 1].icon));
                      }
                    }
                  }
                })
          ],
          child: GestureDetector(
            onTap: () => AppExt.hideKeyboard(context),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColor.textPrimaryInverted,
              body: !context.isPhone
                  ? HomeNavWeb()
                  : BlocBuilder(
                      cubit: _fetchFlashSaleCubit,
                      builder: (context, fetchFlashSaleState) => BlocBuilder(
                        cubit: _fetchPromoCubit,
                        builder: (context, fetchPromoState) => BlocBuilder(
                          cubit: _fetchBestSellCubit,
                          builder: (context, fetchBestSellState) => BlocBuilder(
                            cubit: _fetchBumdesCubit,
                            builder: (context, fetchBumdesState) => BlocBuilder(
                              cubit: _fetchHomeSliderCubit,
                              builder: (context, fetchSlidersState) =>
                                  BlocBuilder(
                                cubit: _fetchProductsByCategoryCubit,
                                builder: (context, fetchProductCategoryState) =>
                                    BlocBuilder(
                                  cubit: _fetchSelectedRecipent,
                                  builder:
                                      (context, fetchSelectedRecipentState) =>
                                          BlocBuilder(
                                    cubit: _fetchCategoriesCubit,
                                    builder: (context, fetchCategoriesState) =>
                                        BlocBuilder(
                                      cubit: _fetchNewsActivityCubit,
                                      builder: (context,
                                              fetchNewsActivityState) =>
                                          //======================================MAIN LAYOUT======================================
                                          NotificationListener(
                                        onNotification: _scrollListener,
                                        child: RefreshIndicator(
                                          onRefresh: () {
                                            return refreshData();
                                          },
                                          child: Stack(
                                            children: [
                                              ListView(
                                                padding: EdgeInsets.zero,
                                                children: [
                                                  UiDebugSwitcher(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 10,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Text('Cihuy 🎉'),
                                                          Text(
                                                              AppConst.API_URL),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //===================================== HERO =====================================
                                                  fetchSlidersState
                                                          is FetchHomeSliderLoading
                                                      ? HeroSection(
                                                          //loading
                                                          isLoading: true)
                                                      : fetchSlidersState
                                                              is FetchHomeSliderSuccess
                                                          ? HeroSection(
                                                              sliders:
                                                                  fetchSlidersState
                                                                      .homeSliders,
                                                              user: userData)
                                                          : HeroSection(
                                                              useIndicator:
                                                                  false),
                                                  //============================RECIPENT=======================
                                                  userData != null
                                                      ? fetchSelectedRecipentState
                                                              is FetchSelectedRecipentLoading
                                                          ? Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      _screenWidth *
                                                                          (5 /
                                                                              100),
                                                                  vertical: 10),
                                                              child: Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        300],
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        200],
                                                                period: Duration(
                                                                    milliseconds:
                                                                        1000),
                                                                child:
                                                                    Container(
                                                                  width: _screenWidth *
                                                                      (17.5 /
                                                                          100),
                                                                  height: 10,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            )
                                                          : fetchSelectedRecipentState
                                                                  is FetchSelectedRecipentFailure
                                                              ? Center(
                                                                  child: Text(
                                                                      "terjadi kesalahan"),
                                                                )
                                                              : fetchSelectedRecipentState
                                                                      is FetchSelectedRecipentSuccess
                                                                  ? Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: _screenWidth *
                                                                              (5 /
                                                                                  100),
                                                                          vertical:
                                                                              10),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          BsDeliveryAddress.show(
                                                                              context,
                                                                              onTap: () async {
                                                                            _fetchSelectedRecipent.fetchSelectedRecipent();
                                                                            _fetchPromoCubit.fetchProductsPromo();
                                                                            _fetchBestSellCubit.fetchProductsBestSell();
                                                                            _fetchFlashSaleCubit.fetchProductsFlashSale();
                                                                            _fetchBumdesCubit.fetchProductsBumdes();
                                                                            _fetchProductsByCategoryCubit.fetchProductsByCategory(categoryId: categoryId);

                                                                            AppExt.popScreen(context);
                                                                          });
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(EvaIcons.pinOutline,
                                                                                color: Colors.black54,
                                                                                size: 18),
                                                                            SizedBox(width: 5),
                                                                            Text("Dikirim ke",
                                                                                style: AppTypo.caption),
                                                                            Container(
                                                                              constraints: const BoxConstraints(maxWidth: 150),
                                                                              child: Text(
                                                                                fetchSelectedRecipentState.recipent != null
                                                                                    ? fetchSelectedRecipentState.recipent.name == null
                                                                                        ? " ${fetchSelectedRecipentState.recipent.subdistrict}"
                                                                                        : " ${fetchSelectedRecipentState.recipent.name}"
                                                                                    : _recipentRepo.getSelectedSubdistrictStorage() != null
                                                                                        ? _recipentRepo.getSelectedSubdistrictStorage()['subdistrict']
                                                                                        : ' -',
                                                                                style: AppTypo.caption.copyWith(color: AppColor.primary, fontWeight: FontWeight.bold),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.clip,
                                                                              ),
                                                                            ),
                                                                            Icon(
                                                                              EvaIcons.chevronDownOutline,
                                                                              color: Colors.black38,
                                                                              size: 18,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ))
                                                                  : SizedBox
                                                                      .shrink()
                                                      : SizedBox.shrink(),
                                                  //===================================== KATEGORI =====================================
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 8),
                                                    color: AppColor.white,
                                                    padding: EdgeInsets.zero,
                                                    child: fetchCategoriesState
                                                            is FetchCategoriesLoading
                                                        ? Center(
                                                            child:
                                                                GridView.count(
                                                              shrinkWrap: true,
                                                              crossAxisCount: 5,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              childAspectRatio:
                                                                  1.0,
                                                              children:
                                                                  List.generate(
                                                                10,
                                                                (index) =>
                                                                    BuildMenuItemShimmer(),
                                                              ),
                                                            ),
                                                          )
                                                        : fetchCategoriesState
                                                                is FetchCategoriesFailure
                                                            ? Center(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      'Kategori produk gagal dimuat',
                                                                      style: AppTypo
                                                                          .body2,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    SizedBox(
                                                                      width: _screenWidth *
                                                                          (38 /
                                                                              100),
                                                                      child: RoundedButton
                                                                          .outlined(
                                                                        isSmall:
                                                                            true,
                                                                        isCompact:
                                                                            true,
                                                                        isUpperCase:
                                                                            false,
                                                                        label:
                                                                            "Coba Lagi",
                                                                        onPressed:
                                                                            () =>
                                                                                _fetchCategoriesCubit.load(),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : fetchCategoriesState
                                                                    is FetchCategoriesSuccess
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8),
                                                                    child: GridView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: categoryTemp.length >=
                                                                              10
                                                                          ? 10
                                                                          : categoryTemp
                                                                              .length,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      gridDelegate:
                                                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                        maxCrossAxisExtent:
                                                                            80,
                                                                        mainAxisExtent:
                                                                            90,
                                                                      ),
                                                                      itemBuilder:
                                                                          (context, index) =>
                                                                              buildMenuItem(
                                                                        context,
                                                                        "${categoryTemp[index].icon}",
                                                                        "${categoryTemp[index].slug}",
                                                                        "${categoryTemp[index].name}",
                                                                        () => AppExt
                                                                            .pushScreen(
                                                                          context,
                                                                          ProductByCategoryScreen(
                                                                            categoryId:
                                                                                categoryTemp[index].id,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox
                                                                    .shrink(),
                                                  ),

                                                  //===================================== LAYANAN KAMI =====================================
                                                  OurServiceList(
                                                    section: "Layanan Kami",
                                                  ),

                                                  //===================================================================================================
                                                  AppTrans
                                                      .SharedAxisTransitionSwitcher(
                                                          transitionType:
                                                              SharedAxisTransitionType
                                                                  .vertical,
                                                          fillColor: Colors
                                                              .transparent,
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                //===================================== FLASH SALE ===================================
                                                                fetchFlashSaleState
                                                                        is FetchProductsLoading
                                                                    ? ShimmerProductList(
                                                                        isPromo:
                                                                            false)
                                                                    : fetchFlashSaleState
                                                                            is FetchProductsFailure
                                                                        ? Center(
                                                                            child:
                                                                                Text(fetchFlashSaleState.message),
                                                                          )
                                                                        : fetchFlashSaleState
                                                                                is FetchProductsSuccess
                                                                            ? fetchFlashSaleState.products.length > 0
                                                                                ? HorizontalFlashSale(
                                                                                    section: "Flash Sale",
                                                                                    products: fetchFlashSaleState.products,
                                                                                    viewAll: fetchFlashSaleState.products.length >= 6
                                                                                        ? () => AppExt.pushScreen(
                                                                                              context,
                                                                                              ViewAllProductScreen(
                                                                                                isFlashSale: true,
                                                                                                productsType: FetchProductsType.flashSale,
                                                                                              ),
                                                                                            )
                                                                                        : null,
                                                                                  )
                                                                                : SizedBox.shrink()
                                                                            : SizedBox.shrink(),
                                                                //===================================== READY TO COOK ===================================

                                                                fetchBumdesState
                                                                        is FetchProductsLoading
                                                                    ? ShimmerProductList()
                                                                    : fetchBumdesState
                                                                            is FetchProductsFailure
                                                                        ? Center(
                                                                            child:
                                                                                Text(fetchBumdesState.message),
                                                                          )
                                                                        : fetchBumdesState
                                                                                is FetchProductsSuccess
                                                                            ? fetchBumdesState.products.length > 0
                                                                                ? ProductList(
                                                                                    section: "Produk Bumdes",
                                                                                    products: fetchBumdesState.products,
                                                                                    isBumdes: true,
                                                                                    viewAll: fetchBumdesState.products.length >= 7
                                                                                        ? () => AppExt.pushScreen(
                                                                                              context,
                                                                                              ViewAllProductScreen(
                                                                                                productsType: FetchProductsType.bumdes,
                                                                                              ),
                                                                                            )
                                                                                        : null,
                                                                                  )
                                                                                : SizedBox.shrink()
                                                                            : SizedBox.shrink(),
                                                                //===================================== PROMO ===================================

                                                                fetchPromoState
                                                                        is FetchProductsLoading
                                                                    ? ShimmerProductList(
                                                                        isPromo:
                                                                            true)
                                                                    : fetchPromoState
                                                                            is FetchProductsFailure
                                                                        ? Center(
                                                                            child:
                                                                                Text(fetchPromoState.message),
                                                                          )
                                                                        : fetchPromoState
                                                                                is FetchProductsSuccess
                                                                            ? fetchPromoState.products.length > 0
                                                                                ? ProductList(
                                                                                    section: "Promo",
                                                                                    products: fetchPromoState.products,
                                                                                    viewAll: fetchPromoState.products.length >= 6
                                                                                        ? () => AppExt.pushScreen(
                                                                                              context,
                                                                                              ViewAllProductScreen(
                                                                                                productsType: FetchProductsType.promo,
                                                                                              ),
                                                                                            )
                                                                                        : null,
                                                                                  )
                                                                                : SizedBox.shrink()
                                                                            : SizedBox.shrink(),
                                                                //===================================== PRODUK TERLARIS ===================================

                                                                fetchBestSellState
                                                                        is FetchProductsLoading
                                                                    ? ShimmerProductList(
                                                                        isPromo:
                                                                            false)
                                                                    : fetchBestSellState
                                                                            is FetchProductsFailure
                                                                        ? Center(
                                                                            child:
                                                                                Text(fetchBestSellState.message),
                                                                          )
                                                                        : fetchBestSellState
                                                                                is FetchProductsSuccess
                                                                            ? fetchBestSellState.products.length > 0
                                                                                ? ProductList(
                                                                                    section: "Produk Terlaris",
                                                                                    products: fetchBestSellState.products,
                                                                                    viewAll: fetchBestSellState.products.length >= 6
                                                                                        ? () => AppExt.pushScreen(
                                                                                              context,
                                                                                              ViewAllProductScreen(
                                                                                                productsType: FetchProductsType.bestSell,
                                                                                              ),
                                                                                            )
                                                                                        : null,
                                                                                  )
                                                                                : SizedBox.shrink()
                                                                            : SizedBox.shrink(),
                                                                //===================================== BERITA DAN KEGIATAN ======================================
                                                                SizedBox(
                                                                    height: 16),
                                                                fetchNewsActivityState
                                                                        is FetchNewsActivityLoading
                                                                    ? ShimmerProductList()
                                                                    : fetchNewsActivityState
                                                                            is FetchNewsActivityFailure
                                                                        ? Center(
                                                                            child:
                                                                                Text("Berita gagal dimuat"),
                                                                          )
                                                                        : fetchNewsActivityState
                                                                                is FetchNewsActivitySuccess
                                                                            ? fetchNewsActivityState.newsActivity.length > 0
                                                                                ? NewsList(
                                                                                    section: "Berita & Kegiatan",
                                                                                    news: fetchNewsActivityState.newsActivity,
                                                                                    viewAll: fetchNewsActivityState.newsActivity.length >= 3
                                                                                        ? () => AppExt.pushScreen(
                                                                                              context,
                                                                                              TagNewsActivityScreen(
                                                                                                tagId: 0,
                                                                                              ),
                                                                                            )
                                                                                        : null,
                                                                                  )
                                                                                : SizedBox.shrink()
                                                                            : SizedBox.shrink(),
                                                                //===================================== HEADER BOTTOM KATEGORI ===================================
                                                                StickyHeader(
                                                                  header:
                                                                      Container(
                                                                    color: AppColor
                                                                        .white,
                                                                    padding: EdgeInsets.only(
                                                                        top: 36,
                                                                        bottom:
                                                                            9),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Divider(
                                                                          thickness:
                                                                              10,
                                                                          height:
                                                                              26,
                                                                          color:
                                                                              AppColor.silverFlashSale,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              26,
                                                                        ),
                                                                        fetchCategoriesState
                                                                                is FetchCategoriesLoading
                                                                            ? Center(
                                                                                child: CircularProgressIndicator(),
                                                                              )
                                                                            : fetchCategoriesState is FetchCategoriesFailure
                                                                                ? Center(
                                                                                    child: Text('kategori gagal dimuat'),
                                                                                  )
                                                                                : fetchCategoriesState is FetchCategoriesSuccess
                                                                                    ? HorizontalCategory(
                                                                                        categoryIdSelected: categoryId,
                                                                                        category: categoryTemp,
                                                                                        onTap: (int idCategory) {
                                                                                          setState(() {
                                                                                            categoryId = idCategory;
                                                                                          });
                                                                                          _fetchProductsByCategoryCubit.fetchProductsByCategory(categoryId: idCategory);
                                                                                        },
                                                                                      )
                                                                                    : SizedBox.shrink(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  content:
                                                                      Container(
                                                                    color: Colors
                                                                        .white,
                                                                    child: fetchProductCategoryState
                                                                            is FetchProductsByCategoryLoading
                                                                        ? StaggeredGridView
                                                                            .countBuilder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            padding:
                                                                                EdgeInsets.symmetric(
                                                                              vertical: 13,
                                                                              horizontal: 15,
                                                                            ),
                                                                            crossAxisCount:
                                                                                2,
                                                                            itemCount:
                                                                                10,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              return ShimmerProductItem();
                                                                            },
                                                                            staggeredTileBuilder: (int index) =>
                                                                                new StaggeredTile.fit(1),
                                                                            mainAxisSpacing:
                                                                                13,
                                                                            crossAxisSpacing:
                                                                                13,
                                                                          )
                                                                        : fetchProductCategoryState
                                                                                is FetchProductsByCategoryFailure
                                                                            ? Center(child: Text("Produk gagal dimuat"))
                                                                            : fetchProductCategoryState is FetchProductsByCategorySuccess
                                                                                ? fetchProductCategoryState.products.length > 0
                                                                                    ? StaggeredGridView.countBuilder(
                                                                                        physics: NeverScrollableScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        padding: EdgeInsets.symmetric(
                                                                                          vertical: 15,
                                                                                          horizontal: 15,
                                                                                        ),
                                                                                        crossAxisCount: 2,
                                                                                        itemCount: fetchProductCategoryState.products.length,
                                                                                        itemBuilder: (BuildContext context, int index) {
                                                                                          Products _item = fetchProductCategoryState.products[index];
                                                                                          return GridTwoProductListItem(
                                                                                            product: _item,
                                                                                            isKomisi: _item.komisi != null && _item.komisi > 0,
                                                                                            isDiscount: _item.disc > 0,
                                                                                            isProductByCategory: true,
                                                                                          );
                                                                                        },
                                                                                        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                                                                                        mainAxisSpacing: 13,
                                                                                        crossAxisSpacing: 13,
                                                                                      )
                                                                                    : Center(
                                                                                        child: EmptyData(
                                                                                          title: "Produk belum tersedia",
                                                                                          subtitle: "Maaf, produk yang anda cari belum tersedia di wilayah anda",
                                                                                          labelBtn: "Cari Produk Lain",
                                                                                        ),
                                                                                      )
                                                                                : SizedBox.shrink(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                ],
                                              ),
                                              AnimatedBuilder(
                                                animation:
                                                    _colorAnimationController,
                                                builder: (BuildContext context,
                                                        Widget child) =>
                                                    _customAppbar(
                                                        backgroundColor:
                                                            _backgroundColorTween
                                                                .value),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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

  Material buildMenuItemNewsActivity(BuildContext context, String cover,
      String title, String slug, String description, VoidCallback onTap,
      [int flex = 1]) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6, right: 5, left: 5),
        child: Container(
          height: 250,
          width: 140,
          decoration: BoxDecoration(
              color: Color(0xFFFFFFF),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColor.black.withOpacity(0.08),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                )
              ]),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(
                  cover,
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
                    text: title,
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
                    style: AppTypo.body1.copyWith(
                      fontSize: 10,
                      color: Color(0xFF9D9D9D),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _customAppbar({Color backgroundColor}) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(top: 35, left: 10, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImg.ic_apmikimmdo_png,
            fit: BoxFit.contain,
            height: 33,
            width: 33,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 50,
              padding: EdgeInsets.only(top: 3),
              child: EditText(
                hintText: "Cari produk",
                inputType: InputType.search,
                readOnly: true,
                onTap: () => AppExt.pushScreen(context, SearchScreen()),
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                padding: EdgeInsets.only(left: 10, right: 10),
                constraints: BoxConstraints(),
                iconSize: 28,
                icon: Icon(EvaIcons.bell, color: Colors.white),
                onPressed: () {
                  /*AppExt.pushScreen(
                    context,
                    NotificationScreen(),
                  );*/
                },
              ),
              /* new Positioned(
                right: 6,
                top: -18,
                child: Chip(
                  shape: CircleBorder(side: BorderSide.none),
                  backgroundColor: AppColor.red,
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.all(4),
                  label: Text(
                    "1",
                    style: AppTypo.overlineInv.copyWith(fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ), */
            ],
          ),
          Stack(
            children: [
              IconButton(
                  padding: EdgeInsets.only(right: 10),
                  constraints: BoxConstraints(),
                  icon: Icon(EvaIcons.shoppingCart, color: Colors.white),
                  iconSize: 28,
                  onPressed: () {
                    AppExt.pushScreen(
                      context,
                      BlocProvider.of<UserDataCubit>(context).state.user != null
                          ? CartScreen()
                          : SignInScreen(),
                    );
                  }),
              BlocProvider.of<UserDataCubit>(context).state.countCart != null &&
                      BlocProvider.of<UserDataCubit>(context).state.countCart >
                          0
                  ? new Positioned(
                      right: 6,
                      top: -18,
                      child: Chip(
                        shape: CircleBorder(side: BorderSide.none),
                        backgroundColor: AppColor.red,
                        padding: EdgeInsets.zero,
                        labelPadding: BlocProvider.of<UserDataCubit>(context)
                                    .state
                                    .countCart >
                                99
                            ? EdgeInsets.all(2)
                            : EdgeInsets.all(4),
                        label: Text(
                          "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
                          style: AppTypo.overlineInv.copyWith(fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Material buildMenuItem(BuildContext context, String icon, String slug,
      String label, VoidCallback onTap,
      [int flex = 1]) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Column(
            children: [
              if (slug != "semua-kategori")
                Image.network(
                  icon,
                  height: 35,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    } else {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: frame != null
                            ? child
                            : Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                              ),
                      );
                    }
                  },
                )
              else
                SvgPicture.asset(
                  AppImg.ic_allcategory,
                  height: 35,
                  placeholderBuilder: (context) => Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              SizedBox(
                height: 7.5,
              ),
              FittedBox(
                child: Container(
                  width: 85,
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: AppTypo.overline,
                    textAlign: TextAlign.center,
                    maxLines: kIsWeb ? null : 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fetchFlashSaleCubit.close();
    _fetchPromoCubit.close();
    _fetchBestSellCubit.close();
    _fetchHomeSliderCubit.close();
    _fetchCategoriesCubit.close();
    _fetchBumdesCubit.close();
    _fetchProductsByCategoryCubit.close();
    _fetchNewsActivityCubit.close();
    super.dispose();
  }
}
