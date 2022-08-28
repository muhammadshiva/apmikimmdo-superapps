import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_products/fetch_products_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class HorizontalCategoryRecomProductList extends StatefulWidget {
  HorizontalCategoryRecomProductList(
      {Key key, @required this.category, this.viewAll})
      : super(key: key);

  final Category category;
  final Function() viewAll;

  @override
  _HorizontalCategoryRecomProductListState createState() =>
      _HorizontalCategoryRecomProductListState();
}

class _HorizontalCategoryRecomProductListState
    extends State<HorizontalCategoryRecomProductList> {
  FetchProductsCubit _fetchProductsCubit;

  @override
  void initState() {
    super.initState();
    // _fetchProductsCubit = FetchProductsCubit(type: FetchProductsType.randomRecom)
    //   ..fetchProductsRandomByCategory(categoryId: widget.category.id);
  }

  @override
  void dispose() {
    super.dispose();
    _fetchProductsCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _fetchProductsCubit,
          ),
        ],
        child: BlocBuilder(
            cubit: _fetchProductsCubit,
            builder: (context, productRecomState) {
              return productRecomState is FetchProductsLoading
                  ? ShimmerProductList()
                  : productRecomState is FetchProductsSuccess
                      ? productRecomState.products.length > 0
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: !context.isPhone
                                        ? 18
                                        : _screenWidth * (5 / 100),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Produk ${widget.category.name} Pilihan",
                                          style: AppTypo.subtitle1.copyWith(
                                              fontWeight: FontWeight.w700),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      widget.viewAll != null
                                          ? Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: widget.viewAll,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Text(
                                                  "Lihat Semua",
                                                  textAlign: TextAlign.right,
                                                  style:
                                                      AppTypo.overline.copyWith(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: AppColor.primary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 233,
                                  child: StaggeredGridView.countBuilder(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      left: !context.isPhone
                                          ? 18
                                          : _screenWidth * (5 / 100),
                                    ),
                                    crossAxisCount: 6,
                                    itemCount:
                                        productRecomState.products.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Products _item =
                                          productRecomState.products[index];
                                      return ProductListItem(
                                        product: _item,
                                        isDiscount: _item.disc != 0,
                                        // isFromShop: _item.badge == "Warung" || isFromShop == true,
                                        // isCatering: _item.badge == "Catering",
                                        // warungPhoneNumber: warungPhoneNumber
                                      );
                                    },
                                    staggeredTileBuilder: (int index) =>
                                        StaggeredTile.fit(4),
                                    mainAxisSpacing: 13,
                                    crossAxisSpacing: 13,
                                  ),
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                              ],
                            )
                          : SizedBox.shrink()
                      : SizedBox.shrink();
            }));
  }
}
