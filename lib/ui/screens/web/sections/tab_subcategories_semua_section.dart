// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:marketplace/api/api.dart';
// import 'package:marketplace/data/blocs/shipping/fetch_shipping_addresses/fetch_shipping_addresses_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/products/fetch_best_product_by_category/fetch_best_product_by_category_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/products/fetch_products_by_category/fetch_products_by_category_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:marketplace/ui/widgets/fetch_conditions.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;


// // final List<Map> myProducts =
// //     List.generate(100, (index) => {"id": index, "name": "Product $index"})
// //         .toList();

// class TabSubCategoriesSemuaSection extends StatefulWidget {
//   final int categoryId;
//   // final Recipent selectedAddress;
//   const TabSubCategoriesSemuaSection({Key key, this.categoryId})
//       : super(key: key);
//   @override
//   _TabSubCategoriesSemuaSectionState createState() =>
//       _TabSubCategoriesSemuaSectionState();
// }

// class _TabSubCategoriesSemuaSectionState
//     extends State<TabSubCategoriesSemuaSection> {
//   FetchProductsByCategoryCubit _fetchProductsByCategoryCubit;
//   FetchBestProductByCategoryCubit _fetchBestProductByCategoryCubit;

//   @override
//   void initState() {
//     _fetchProductsByCategoryCubit = FetchProductsByCategoryCubit()
//       ..fetchProductsByCategory(categoryId: widget.categoryId);
//     _fetchBestProductByCategoryCubit = FetchBestProductByCategoryCubit()
//       ..fetchBestProductByCategory(categoryId: widget.categoryId);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fetchProductsByCategoryCubit.close();
//     _fetchBestProductByCategoryCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double _screenWidth = MediaQuery.of(context).size.width;
//     final config = AAppConfig.of(context);
//     if (_screenWidth <= 975 || _screenWidth >= 1366) {
//       _fetchProductsByCategoryCubit.fetchProductsByCategory(categoryId: widget.categoryId);
//       _fetchBestProductByCategoryCubit.fetchBestProductByCategory(categoryId: widget.categoryId);
//     }
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
//         child: MultiBlocProvider(
//           providers: [
//             BlocProvider(
//               create: (_) => _fetchProductsByCategoryCubit,
//             ),
//             BlocProvider(
//               create: (_) => _fetchBestProductByCategoryCubit,
//             ),
//           ],
//           child: BlocBuilder(
//             cubit: _fetchProductsByCategoryCubit,
//             builder: (context, state) => BlocBuilder(
//               cubit: _fetchBestProductByCategoryCubit,
//               builder: (context, bestProductState) =>
//                   AppTrans.SharedAxisTransitionSwitcher(
//                 fillColor: Colors.transparent,
//                 transitionType: SharedAxisTransitionType.vertical,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     config.appType == AppType.panenpanen
//                         ? Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 82, vertical: 20),
//                             child: Text("Produk Terlaris",
//                                 style: AppTypo.h2.copyWith(
//                                     fontWeight: FontWeight.w700, fontSize: 24)),
//                           )
//                         : SizedBox(),
//                     config.appType == AppType.panenpanen
//                         ? bestProductState is FetchBestProductByCategoryLoading
//                             ? Center(
//                                 child: CircularProgressIndicator(),
//                               )
//                             : bestProductState
//                                     is FetchBestProductByCategoryFailure
//                                 ? Center(
//                                     child: state.type == ErrorType.network
//                                         ? NoConnection(onButtonPressed: () {
//                                             _fetchBestProductByCategoryCubit
//                                                 .fetchBestProductByCategory(
//                                                     categoryId:
//                                                         widget.categoryId);
//                                           })
//                                         : ErrorFetch(
//                                             message: state.message,
//                                             onButtonPressed: () {
//                                               _fetchBestProductByCategoryCubit
//                                                   .fetchBestProductByCategory(
//                                                       categoryId:
//                                                           widget.categoryId);
//                                             },
//                                           ),
//                                   )
//                                 : bestProductState
//                                         is FetchBestProductByCategorySuccess
//                                     ? bestProductState.products.length > 0
//                                         ? ProductListWeb(
//                                               products: bestProductState.products,
//                                               chunkSize: _screenWidth <= 975 && _screenWidth >= 875 ? 4 : _screenWidth <= 874 ? 3 : 5,
//                                             )
//                                         : Center(
//                                             child: EmptyData(
//                                               subtitle: "Nantikan updatenya segera, hanya di Bisnisomall!",
//                                                 // subtitle: "Belum ada produk"
//                                                 ),
//                                           )
//                                     : SizedBox.shrink()
//                         : SizedBox(),
//                     config.appType == AppType.panenpanen
//                         ? Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 82, vertical: 20),
//                             child: Text("Semua Produk",
//                                 style: AppTypo.h2.copyWith(
//                                     fontWeight: FontWeight.w700, fontSize: 24)),
//                           )
//                         : SizedBox(),
//                     config.appType == AppType.panenpanen
//                         ? state is FetchProductsByCategoryLoading
//                             ? Center(
//                                 child: CircularProgressIndicator(),
//                               )
//                             : state is FetchProductsByCategoryFailure
//                                 ? Center(
//                                     child: state.type == ErrorType.network
//                                         ? NoConnection(onButtonPressed: () {
//                                             _fetchProductsByCategoryCubit
//                                                 .fetchProductsByCategory(
//                                                     categoryId:
//                                                         widget.categoryId);
//                                           })
//                                         : ErrorFetch(
//                                             message: state.message,
//                                             onButtonPressed: () {
//                                               _fetchProductsByCategoryCubit
//                                                   .fetchProductsByCategory(
//                                                       categoryId:
//                                                           widget.categoryId);
//                                             },
//                                           ),
//                                   )
//                                 : state is FetchProductsByCategorySuccess
//                                     ? state.products.length > 0
//                                         ? GridView.builder(
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 82, vertical: 20),
//                                             shrinkWrap: true,
//                                             gridDelegate:
//                                                 SliverGridDelegateWithMaxCrossAxisExtent(
//                                                     maxCrossAxisExtent: 200,
//                                                     mainAxisExtent: 300,
//                                                     crossAxisSpacing: 20,
//                                                     mainAxisSpacing: 20),
//                                             itemCount: state.products.length,
//                                             itemBuilder:
//                                                 (BuildContext ctx, index) {
//                                               Products _item =
//                                                   state.products[index];
//                                               return ProductListItemWebOld(
//                                                 product: _item,
//                                                 isPromo: _item.disc != 0,
//                                                 titleLength: 40,
//                                                 // selectedAddress: widget.selectedAddress
//                                               );
//                                             })
//                                         : Center(
//                                             child: EmptyData(
//                                               subtitle: "Nantikan updatenya segera, hanya di Bisnisomall!",
//                                                 // subtitle: "Belum ada produk"
//                                                 ),
//                                           )
//                                     : SizedBox.shrink()
//                         : SizedBox.shrink(),
//                     if (config.appType == AppType.sumedang ||
//                         config.appType == AppType.ichc) ...[
//                       Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 82, vertical: 20),
//                         child: Text("Semua Produk",
//                             style: AppTypo.h2.copyWith(
//                                 fontWeight: FontWeight.w700, fontSize: 24)),
//                       ),
//                       if (bestProductState is FetchBestProductByCategoryLoading)
//                         Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       else if (bestProductState
//                           is FetchBestProductByCategoryFailure)
//                         Center(
//                           child: Builder(
//                             builder: (context) {
//                               if (bestProductState.type == ErrorType.network) {
//                                 return NoConnection(
//                                   onButtonPressed: () {
//                                     _fetchBestProductByCategoryCubit
//                                         .fetchBestProductByCategory(
//                                             categoryId: widget.categoryId);
//                                   },
//                                 );
//                               }
//                               return ErrorFetch(
//                                 message: bestProductState.message,
//                                 onButtonPressed: () {
//                                   _fetchBestProductByCategoryCubit
//                                       .fetchBestProductByCategory(
//                                     categoryId: widget.categoryId,
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         )
//                       else if (bestProductState
//                           is FetchBestProductByCategorySuccess)
//                         if (bestProductState.products.length > 0)
//                           GridView.builder(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 82, vertical: 20),
//                             shrinkWrap: true,
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 6,
//                                     childAspectRatio: 0.6,
//                                     crossAxisSpacing: 20,
//                                     mainAxisSpacing: 20),
//                             itemCount: bestProductState.products.length,
//                             itemBuilder: (BuildContext ctx, index) {
//                               Products _item =
//                                   bestProductState.products[index];
//                               return ProductListItemWebOld(
//                                 product: _item,
//                                 isPromo: _item.disc != 0,
//                                 // selectedAddress: widget.selectedAddress
//                               );
//                             },
//                           )
//                         else
//                           Center(
//                             child: EmptyData(
//                               subtitle: "Nantikan updatenya segera, hanya di Bisnisomall!",
//                               // subtitle: "Belum ada produk"
//                             ),
//                           )
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
// }
