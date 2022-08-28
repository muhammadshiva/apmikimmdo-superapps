import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_products/fetch_products_cubit.dart';
import 'package:marketplace/data/models/new_models/category.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/widgets/horizontal_product_list.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/web/product_list_web.dart';

class CategoryRecomProductListWeb extends StatefulWidget {
  CategoryRecomProductListWeb(
      {Key key, this.category, this.isWithBottomDivider})
      : super(key: key);

  final Category category;
  final bool isWithBottomDivider;

  @override
  _CategoryRecomProductListWebState createState() =>
      _CategoryRecomProductListWebState();
}

class _CategoryRecomProductListWebState
    extends State<CategoryRecomProductListWeb> {
  FetchProductsCubit _fetchProductsCubit;

  @override
  void initState() {
    // _fetchProductsCubit =
    //     FetchProductsCubit(type: FetchProductsType.randomRecom)
    //       ..fetchProductsRandomByCategory(categoryId: widget.category.id);
    super.initState();
  }

  @override
  void dispose() {
    _fetchProductsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _fetchProductsCubit,
        ),
      ],
      child: BlocBuilder(
          cubit: _fetchProductsCubit,
          builder: (context, stateproducts) {
            return stateproducts is FetchProductsLoading
                ? ShimmerProductList()
                : stateproducts is FetchProductsSuccess
                    ? stateproducts.products.length > 0
                        ? ProductListWeb(
                            isTitleSection: true,
                            titleSection:
                                "Produk ${widget.category.name} Pilihan",
                            products: stateproducts.products,
                            isWithBottomDivider: widget.isWithBottomDivider,
                          )
                        : SizedBox.shrink()
                    : SizedBox.shrink();
          }),
    );
  }
}
