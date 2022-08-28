import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketplace/api/api.dart';
import 'package:get/get.dart';
import 'package:beamer/beamer.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_products_by_category/fetch_products_by_category_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/category.dart'
    as categoryModel;
import 'package:marketplace/ui/screens/nav/new/home/home_nav.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/web/screens/web_screens.dart';
import 'package:marketplace/ui/widgets/grid_two_product_list_item.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/web/navbar_web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/constants.dart' as AppConst;

class ProductByCategoryScreen extends StatefulWidget {
  final int categoryId;

  const ProductByCategoryScreen({
    Key key,
    @required this.categoryId,
  }) : super(key: key);

  @override
  _ProductByCategoryScreenState createState() =>
      _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> {
  FetchProductsByCategoryCubit _fetchProductsByCategoryCubit;
  FetchCategoriesCubit _fetchCategoriesCubit;

  List<categoryModel.Category> horizontalCategory = [];
  int categoryId = 0;

  @override
  void initState() {
    categoryId = widget.categoryId;
    _fetchProductsByCategoryCubit = FetchProductsByCategoryCubit()
      ..fetchProductsByCategory(categoryId: widget.categoryId);
    _fetchCategoriesCubit = FetchCategoriesCubit()..load();
    super.initState();
  }

  @override
  void dispose() {
    _fetchProductsByCategoryCubit.close();
    _fetchCategoriesCubit.close();
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
        value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => _fetchProductsByCategoryCubit,
            ),
            BlocProvider(
              create: (_) => _fetchCategoriesCubit,
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener(
                  cubit: _fetchCategoriesCubit,
                  listener: (context, state) {
                    if (state is FetchCategoriesSuccess) {
                      for (int i = 0; i < state.categories.length + 1; i++) {
                        if (i == 0) {
                          horizontalCategory.add(categoryModel.Category(
                              id: 0,
                              name: "Semua Kategori",
                              slug: "semua-kategori",
                              icon: "allcategory.svg"));
                        } else {
                          horizontalCategory.add(categoryModel.Category(
                              id: state.categories[i - 1].id,
                              name: state.categories[i - 1].name,
                              slug: state.categories[i - 1].slug,
                              icon: state.categories[i - 1].icon));
                        }
                      }
                    }
                  })
            ],
            child: Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
                child: Scaffold(
                  appBar: _buildAppBar(
                      context, _screenWidth, _fetchCategoriesCubit),
                  body: BlocBuilder(
                    cubit: _fetchProductsByCategoryCubit,
                    builder: (context, state) =>
                        AppTrans.SharedAxisTransitionSwitcher(
                      fillColor: Colors.transparent,
                      transitionType: SharedAxisTransitionType.vertical,
                      child: state is FetchProductsByCategoryLoading
                          ? StaggeredGridView.countBuilder(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                              crossAxisCount: 2,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return ShimmerProductItem();
                              },
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.fit(1),
                              mainAxisSpacing: 13,
                              crossAxisSpacing: 13,
                            )
                          : state is FetchProductsByCategoryFailure
                              ? Center(
                                  child: state.type == ErrorType.network
                                      ? NoConnection(onButtonPressed: () {
                                          _fetchProductsByCategoryCubit
                                              .fetchProductsByCategory(
                                                  categoryId:
                                                      widget.categoryId);
                                        })
                                      : ErrorFetch(
                                          message: state.message,
                                          onButtonPressed: () {
                                            _fetchProductsByCategoryCubit
                                                .fetchProductsByCategory(
                                                    categoryId:
                                                        widget.categoryId);
                                          },
                                        ),
                                )
                              : state is FetchProductsByCategorySuccess
                                  ? state.products.length > 0
                                      ? RefreshIndicator(
                                          color: AppColor.primary,
                                          backgroundColor: AppColor.white,
                                          strokeWidth: 3,
                                          onRefresh: () =>
                                              _fetchProductsByCategoryCubit
                                                  .fetchProductsByCategory(
                                                      categoryId:
                                                          widget.categoryId),
                                          child: new StaggeredGridView
                                              .countBuilder(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 15,
                                            ),
                                            crossAxisCount: 2,
                                            itemCount: state.products.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Products _item =
                                                  state.products[index];
                                              return GridTwoProductListItem(product: _item,isKomisi: _item.komisi != null && _item.komisi > 0, isDiscount:_item.disc > 0,isProductByCategory: true,);
                                            },
                                            staggeredTileBuilder: (int index) =>
                                                new StaggeredTile.fit(1),
                                            mainAxisSpacing: 13,
                                            crossAxisSpacing: 13,
                                          ),
                                        )
                                      : Center(
                                          child: EmptyData(
                                            title: "Produk belum tersedia",
                                            subtitle:
                                                "Maaf, produk yang anda cari belum tersedia di wilayah anda",
                                            labelBtn: "Cari Produk Lain",
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
      FetchCategoriesCubit fetchCategoriesCub) {
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
                    right: 10,
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
        preferredSize: Size.fromHeight(80),
        child: Column(
          children: [
            BlocBuilder(
                cubit: _fetchCategoriesCubit,
                builder: (context, fetchCategoriesState) {
                  return fetchCategoriesState is FetchCategoriesLoading
                      ? Container(
                          height: 60,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(
                                  left: _screenWidth * (5 / 100)),
                              itemCount: 6,
                              itemBuilder: (ctx, idx) {
                                return ShimmerHorizontalCategory();
                              }),
                        )
                      : fetchCategoriesState is FetchCategoriesFailure
                          ? Center(
                              child: Text('kategori gagal dimuat'),
                            )
                          : fetchCategoriesState is FetchCategoriesSuccess
                              ? HorizontalCategory(
                                  categoryIdSelected: categoryId,
                                  category: horizontalCategory,
                                  onTap: (int idCategory) {
                                    setState(() {
                                      categoryId = idCategory;
                                    });
                                    _fetchProductsByCategoryCubit
                                        .fetchProductsByCategory(
                                            categoryId: idCategory ?? 0);
                                  },
                                )
                              : SizedBox.shrink();
                }),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: _screenWidth * (5 / 100), vertical: 10),
              /*child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      BSFilterProduct.show(context, onFilter: (String sortBy,
                          String lowPriceRange, String highPriceRange, String cityId) {
                        debugPrint(sortBy.toString());
                        _fetchProductsByCategoryCubit.fetchFilterProducts(
                            sortByLowestPrice: sortBy == '0' ? 'true' : '',
                            sortByHighestPrice: sortBy == '1' ? 'true' : '',
                            sortByLatest: sortBy == '2' ? 'true' : '',
                            sortByReview: sortBy == '3' ? 'true' : '',
                            lowestPrice: lowPriceRange,
                            highestPrice: highPriceRange,
                            cityId: cityId ?? '');
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Boxicons.bx_filter,
                          size: 30,
                          color: AppColor.primary,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Filter",
                            style: AppTypo.body1.copyWith(
                              fontSize: 12,
                              color: AppColor.primary,
                            ))
                      ],
                    ),
                  )
                ],
              ),*/
            ),
          ],
        ),
      ),
    );
  }
}
