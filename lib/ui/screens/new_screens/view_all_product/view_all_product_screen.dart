import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/api/api.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/new_models/category.dart'
    as categoryModel;
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/ticker.dart';
import 'package:marketplace/ui/screens/nav/new/home/home_nav.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_products/fetch_products_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/grid_two_product_list_item.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:beamer/beamer.dart';

class ViewAllProductScreen extends StatefulWidget {
  final bool isFlashSale;
  final FetchProductsType productsType;
  final bool isRecomProduct;
  final int phoneNumber;
  final categoryModel.Category category;

  const ViewAllProductScreen({
    Key key,
    this.isFlashSale,
    this.productsType,
    this.phoneNumber,
    this.isRecomProduct = false,
    this.category,
  }) : super(key: key);

  @override
  _ViewAllProductScreenState createState() => _ViewAllProductScreenState();
}

class _ViewAllProductScreenState extends State<ViewAllProductScreen> {
  FetchProductsCubit _fetchProductsCubit;

  int _duration(DateTime orderDate) {
    final expired = orderDate.add(const Duration(hours: 8));
    final now = DateTime.now();
    final diff = expired.difference(now);
    return diff.inSeconds;
  }

  Widget _containerTimer(String text) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFE7366B), borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Text(
        text,
        style: AppTypo.body2Lato.copyWith(color: AppColor.white),
      ),
    );
  }

  @override
  void initState() {
    if (!widget.isRecomProduct) {
      if (widget.productsType == FetchProductsType.promo) {
        _fetchProductsCubit = FetchProductsCubit()..fetchProductsPromo();
      } else if (widget.productsType == FetchProductsType.bestSell) {
        _fetchProductsCubit = FetchProductsCubit()..fetchProductsBestSell();
      } else if (widget.productsType == FetchProductsType.bumdes) {
        _fetchProductsCubit = FetchProductsCubit()..fetchProductsBumdes();
      } else {
        _fetchProductsCubit = FetchProductsCubit()..fetchProductsFlashSale();
      }
    } else {
      _fetchProductsCubit = FetchProductsCubit()
        ..fetchProductsRandomByCategory(categoryId: widget.category.id);
    }
    super.initState();
  }

  @override
  void dispose() {
    _fetchProductsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => _fetchProductsCubit,
            ),
          ],
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
              child: Scaffold(
                  appBar: _buildAppBar(context, _screenWidth),
                  body: BlocBuilder(
                    cubit: _fetchProductsCubit,
                    builder: (context, state) =>
                        AppTrans.SharedAxisTransitionSwitcher(
                            fillColor: Colors.transparent,
                            transitionType: SharedAxisTransitionType.vertical,
                            child: state is FetchProductsLoading
                                ? StaggeredGridView.countBuilder(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    crossAxisCount: 2,
                                    itemCount: 10,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ShimmerProductItem(
                                          isPromo: widget.productsType ==
                                              FetchProductsType.promo);
                                    },
                                    staggeredTileBuilder: (int index) =>
                                        new StaggeredTile.fit(1),
                                    mainAxisSpacing: 13,
                                    crossAxisSpacing: 13,
                                  )
                                : state is FetchProductsFailure
                                    ? Center(
                                        child: state.type == ErrorType.network
                                            ? NoConnection(
                                                onButtonPressed: () {
                                                  widget.isRecomProduct == true
                                                      ? _fetchProductsCubit
                                                          .fetchProductsRandomByCategory(
                                                              categoryId: widget
                                                                  .category.id)
                                                      : _fetchProductsCubit
                                                          .fetchProductsSpecialOffer();
                                                },
                                              )
                                            : ErrorFetch(
                                                message: state.message,
                                                onButtonPressed: () {
                                                  widget.isRecomProduct == true
                                                      ? _fetchProductsCubit
                                                          .fetchProductsRandomByCategory(
                                                              categoryId: widget
                                                                  .category.id)
                                                      : _fetchProductsCubit
                                                          .fetchProductsSpecialOffer();
                                                },
                                              ),
                                      )
                                    : state is FetchProductsSuccess
                                        ? state.products.length > 0
                                            ? RefreshIndicator(
                                                color: AppColor.primary,
                                                backgroundColor: Colors.white,
                                                strokeWidth: 3,
                                                onRefresh: () => widget
                                                            .isRecomProduct ==
                                                        true
                                                    ? _fetchProductsCubit
                                                        .fetchProductsRandomByCategory(
                                                            categoryId: widget
                                                                .category.id)
                                                    : _fetchProductsCubit
                                                        .fetchProductsSpecialOffer(),
                                                child: StaggeredGridView
                                                    .countBuilder(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15,
                                                  ),
                                                  crossAxisCount: 2,
                                                  itemCount:
                                                      state.products.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    Products _item =
                                                        state.products[index];
                                                    return GridTwoProductListItem(
                                                      product: _item,
                                                      isKomisi: _item.komisi !=
                                                              null &&
                                                          _item.komisi > 0,
                                                      isDiscount:
                                                          _item.disc > 0,
                                                      isProductByCategory: true,
                                                    );
                                                  },
                                                  staggeredTileBuilder: (int
                                                          index) =>
                                                      new StaggeredTile.fit(1),
                                                  mainAxisSpacing: 13,
                                                  crossAxisSpacing: 13,
                                                ),
                                              )
                                            : EmptyData(
                                                title: "Produk belum tersedia",
                                                subtitle:
                                                    "Maaf, produk yang anda cari belum tersedia di wilayah anda",
                                                labelBtn: "Cari Produk Lain",
                                                onClick: () {
                                                  BlocProvider.of<
                                                              BottomNavCubit>(
                                                          context)
                                                      .navItemTapped(0);
                                                  AppExt.popUntilRoot(context);
                                                },
                                              )
                                        : SizedBox.shrink()),
                  )),
            ),
          ),
        ));
  }

  AppBar _buildAppBar(BuildContext context, double _screenWidth) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: AppColor.textPrimary),
      backgroundColor: AppColor.textPrimaryInverted,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      title: Container(
        height: 50,
        padding: EdgeInsets.only(top: 3),
        child: EditText(
          hintText: "Cari produk ...",
          inputType: InputType.search,
          readOnly: true,
          onTap: () => AppExt.pushScreen(context, SearchScreen()),
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
                padding: EdgeInsets.only(left: 5, top: 10, right: 10),
                constraints: BoxConstraints(),
                icon: Icon(Icons.notifications),
                splashRadius: 2,
                onPressed: () {}),
            // BlocProvider.of<UserDataCubit>(context).state.countCart != null &&
            //         BlocProvider.of<UserDataCubit>(context).state.countCart > 0
            //     ?  Positioned(
            //         right: 10,
            //         top: -10,
            //         child: Chip(
            //           shape: CircleBorder(side: BorderSide.none),
            //           backgroundColor: AppColor.red,
            //           padding: EdgeInsets.zero,
            //           labelPadding: BlocProvider.of<UserDataCubit>(context)
            //                       .state
            //                       .countCart >
            //                   99
            //               ? EdgeInsets.all(2)
            //               : EdgeInsets.all(4),
            //           label: Text(
            //             "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
            //             style: AppTypo.overlineInv.copyWith(fontSize: 8),
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //       )
            //     : SizedBox.shrink(),
          ],
        ),
        Stack(
          children: [
            IconButton(
                padding: EdgeInsets.only(top: 10, right: 10),
                constraints: BoxConstraints(),
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  AppExt.pushScreen(
                    context,
                    BlocProvider.of<UserDataCubit>(context).state.user != null
                        ? CartScreen()
                        : SignInScreen(),
                  );
                }),
            BlocProvider.of<UserDataCubit>(context).state.countCart != null &&
                    BlocProvider.of<UserDataCubit>(context).state.countCart > 0
                ? new Positioned(
                    right: 6,
                    top: -10,
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
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight / 2.2),
        child: Padding(
          padding: EdgeInsets.only(right: _screenWidth * (5 / 100), bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isFlashSale == true
                  ? Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Berakhir dalam",
                            style: AppTypo.body2Lato,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          StreamBuilder<int>(
                              stream: Ticker()
                                  .tick(ticks: _duration(DateTime.now())),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final duration = snapshot.data;
                                  final hoursStr = ((duration / 3600) % 60)
                                      .floor()
                                      .toString()
                                      .padLeft(2, '0');
                                  final minutesStr = ((duration / 60) % 60)
                                      .floor()
                                      .toString()
                                      .padLeft(2, '0');
                                  final secondsStr = (duration % 60)
                                      .floor()
                                      .toString()
                                      .padLeft(2, '0');
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _containerTimer(hoursStr),
                                      Text(
                                        ":",
                                        style: AppTypo.body2Lato
                                            .copyWith(color: Color(0xFFE7366B)),
                                      ),
                                      _containerTimer(minutesStr),
                                      Text(
                                        ":",
                                        style: AppTypo.body2Lato
                                            .copyWith(color: Color(0xFFE7366B)),
                                      ),
                                      _containerTimer(secondsStr),
                                    ],
                                  );
                                }
                                return SizedBox();
                              }),
                        ],
                      ),
                    )
                  : Row(),
              InkWell(
                onTap: () {
                  BSFilterProduct.show(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Boxicons.bx_filter,
                      size: 30,
                      color: AppColor.primary,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Filter",
                      style: AppTypo.body1.copyWith(
                        fontSize: 12,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
