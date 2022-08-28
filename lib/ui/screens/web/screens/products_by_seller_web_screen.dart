// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:marketplace/api/api.dart';
// import 'package:marketplace/data/blocs/shipping/shipping_address/shipping_address_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/products/fetch_product_by_seller/fetch_products_by_seller_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/ui/screens/screens.dart';
// import 'package:marketplace/ui/widgets/basic_card.dart';
// import 'package:marketplace/ui/widgets/fetch_conditions.dart';
// import 'package:marketplace/ui/widgets/web/breadcumb_item_web.dart';
// import 'package:marketplace/ui/widgets/web/footer_web.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/decorations.dart' as AppDecor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;

// class ProductsBySellerWeb extends StatefulWidget {
//   final bool isCatering;
//   final bool isFromShop;
//   final int sellerId;
//   // final Recipent selectedAddress;

//   const ProductsBySellerWeb({
//     Key key,
//     this.isCatering = false,

//     this.isFromShop = false,
//     this.sellerId,
//   }) : super(key: key);
//   @override
//   _ProductsBySellerWebState createState() => _ProductsBySellerWebState();
// }

// class _ProductsBySellerWebState extends State<ProductsBySellerWeb> {
//   FetchProductsBySellerCubit _fetchProductsBySellerCubit;
//   FetchProductsBySellerCubit _fetchBestProductBySellerCubit;

//   @override
//   void initState() {
//     // _fetchProductsBySellerCubit = FetchProductsBySellerCubit()
//     //   ..load(
//     //       sellerId: widget.seller == null ? widget.sellerId : widget.seller.id);
//     // _fetchBestProductBySellerCubit = FetchProductsBySellerCubit()
//     //   ..fetchBestProductBySeller(
//     //       sellerId: widget.seller == null ? widget.sellerId : widget.seller.id);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fetchProductsBySellerCubit?.close();
//     _fetchBestProductBySellerCubit?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double _screenHeight = MediaQuery.of(context).size.height;
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => _fetchProductsBySellerCubit,
//         ),
//         BlocProvider(
//           create: (_) => _fetchBestProductBySellerCubit,
//         )
//       ],
//       child: Scrollbar(
//         isAlwaysShown: true,
//         child: Center(),
//         // child: Center(
//         //   child: ConstrainedBox(
//         //     constraints: BoxConstraints(
//         //       maxWidth: 1366,
//         //     ),
//         //     child: ListView(
//         //       children: [
//         //         Padding(
//         //             padding: EdgeInsets.only(top: 40, bottom: 30, left: 82),
//         //             child: Row(
//         //               children: [
//         //                 BreadCumbItemWeb(
//         //                   mouseCursor: SystemMouseCursors.click,
//         //                   title: "Home",
//         //                   route: "/",
//         //                 ),
//         //                 BreadCumbItemWeb(
//         //                   mouseCursor: SystemMouseCursors.basic,
//         //                   title: " - ",
//         //                   color: AppColor.textPrimary,
//         //                 ),
//         //                 BreadCumbItemWeb(
//         //                   mouseCursor: SystemMouseCursors.click,
//         //                   title: widget.isCatering ? "Catering" : "Warung",
//         //                   route:
//         //                       "/product/${widget.isCatering ? 'catering' : 'warung'}/6?recid=${BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent != null ? AppExt.encryptMyData(jsonEncode(BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent.id)) : AppExt.encryptMyData(jsonEncode(null))}",
//         //                 ),
//         //                 BreadCumbItemWeb(
//         //                   mouseCursor: SystemMouseCursors.basic,
//         //                   title: " - ",
//         //                   color: AppColor.textPrimary,
//         //                 ),
//         //                 BreadCumbItemWeb(
//         //                   mouseCursor: SystemMouseCursors.basic,
//         //                   title: widget.seller.nameSeller,
//         //                 ),
//         //               ],
//         //             )),
//         //         Padding(
//         //           padding: EdgeInsets.symmetric(horizontal: 82),
//         //           child: Row(
//         //             crossAxisAlignment: CrossAxisAlignment.start,
//         //             children: [
//         //               Expanded(
//         //                 flex: 1,
//         //                 child: BasicCard(
//         //                   child: Padding(
//         //                     padding: EdgeInsets.symmetric(
//         //                         vertical: 20, horizontal: 80),
//         //                     child: Column(
//         //                       children: [
//         //                         ClipRRect(
//         //                             borderRadius: BorderRadius.circular(10),
//         //                             child: Image(
//         //                               image: NetworkImage(
//         //                                 "${AppConst.STORAGE_URL}/shop/${widget.seller.shopPhoto}",
//         //                               ),
//         //                               width: 165,
//         //                               height: 165,
//         //                               fit: BoxFit.cover,
//         //                               errorBuilder: (context, object, stack) =>
//         //                                   Image.asset(
//         //                                 AppImg.img_error,
//         //                                 width: 165,
//         //                                 height: 165,
//         //                               ),
//         //                               frameBuilder: (context, child, frame,
//         //                                   wasSynchronouslyLoaded) {
//         //                                 if (wasSynchronouslyLoaded) {
//         //                                   return child;
//         //                                 } else {
//         //                                   return AnimatedSwitcher(
//         //                                     duration: const Duration(
//         //                                         milliseconds: 500),
//         //                                     child: frame != null
//         //                                         ? child
//         //                                         : Container(
//         //                                             width: 165,
//         //                                             height: 165,
//         //                                             decoration: BoxDecoration(
//         //                                               borderRadius:
//         //                                                   BorderRadius.circular(
//         //                                                       10),
//         //                                               color: Colors.grey[200],
//         //                                             ),
//         //                                           ),
//         //                                   );
//         //                                 }
//         //                               },
//         //                             )),
//         //                         SizedBox(
//         //                           height: 22,
//         //                         ),
//         //                         Text(
//         //                           widget.seller.nameSeller,
//         //                           textAlign: TextAlign.center,
//         //                           style: AppTypo.h2,
//         //                         ),
//         //                         SizedBox(
//         //                           height: 6,
//         //                         ),
//         //                         RichText(
//         //                             text: TextSpan(
//         //                                 text: '${widget.seller.city}, ',
//         //                                 style: AppTypo.body1.copyWith(
//         //                                     fontSize: 14,
//         //                                     color: AppColor.textPrimary),
//         //                                 children: <TextSpan>[
//         //                               TextSpan(
//         //                                 text: '${widget.seller.province}',
//         //                               ),
//         //                             ])),
//         //                         SizedBox(
//         //                           height: 6,
//         //                         ),
//         //                         Text(
//         //                             widget.isFromShop == true
//         //                                 ? "Lihat Peta"
//         //                                 : "",
//         //                             style: AppTypo.body1.copyWith(
//         //                                 fontSize: 14,
//         //                                 color: AppColor.primary,
//         //                                 fontWeight: FontWeight.w700,
//         //                                 decoration: TextDecoration.underline)),
//         //                       ],
//         //                     ),
//         //                   ),
//         //                 ),
//         //               ),
//         //               Expanded(
//         //                 flex: 2,
//         //                 child: Padding(
//         //                   padding: EdgeInsets.symmetric(horizontal: 30),
//         //                   child: Column(
//         //                     crossAxisAlignment: CrossAxisAlignment.start,
//         //                     children: [
//         //                       Text(
//         //                           widget.isCatering
//         //                               ? "Paket Catering Terlaris"
//         //                               : "Menu Warung Terlaris",
//         //                           style: AppTypo.h2.copyWith(fontSize: 24)),
//         //                       BlocBuilder(
//         //                           cubit: _fetchBestProductBySellerCubit,
//         //                           builder: (context, state) => state
//         //                                   is FetchProductsBySellerLoading
//         //                               ? Center(
//         //                                   child: CircularProgressIndicator())
//         //                               : state is FetchProductsBySellerFailure
//         //                                   ? Column(
//         //                                       children: [
//         //                                         SizedBox(
//         //                                             height: _screenHeight *
//         //                                                 (7 / 100)),
//         //                                         state.type == ErrorType.network
//         //                                             ? NoConnection(
//         //                                                 onButtonPressed: () {
//         //                                                 _fetchProductsBySellerCubit
//         //                                                     .load(
//         //                                                         sellerId: widget
//         //                                                             .seller.id);
//         //                                               })
//         //                                             : ErrorFetch(
//         //                                                 message: state.message,
//         //                                                 onButtonPressed: () {
//         //                                                   _fetchProductsBySellerCubit
//         //                                                       .load(
//         //                                                           sellerId:
//         //                                                               widget
//         //                                                                   .seller
//         //                                                                   .id);
//         //                                                 },
//         //                                               ),
//         //                                       ],
//         //                                     )
//         //                                   : state
//         //                                           is FetchProductsBySellerSuccess
//         //                                       ? state.products.length > 0
//         //                                           ? GridView.builder(
//         //                                               padding:
//         //                                                   EdgeInsets.symmetric(
//         //                                                       vertical: 36),
//         //                                               shrinkWrap: true,
//         //                                               physics:
//         //                                                   NeverScrollableScrollPhysics(),
//         //                                               gridDelegate:
//         //                                                   SliverGridDelegateWithFixedCrossAxisCount(
//         //                                                       crossAxisCount: 2,
//         //                                                       childAspectRatio:
//         //                                                           3 / 2,
//         //                                                       crossAxisSpacing:
//         //                                                           20,
//         //                                                       mainAxisSpacing:
//         //                                                           20),
//         //                                               itemCount: state
//         //                                                   .products.length
//         //                                                   .clamp(0, 2),
//         //                                               itemBuilder:
//         //                                                   (BuildContext ctx,
//         //                                                       index) {
//         //                                                 Products _item = state
//         //                                                     .products[index];
//         //                                                 return ProductsBySellerItemWeb(
//         //                                                   product: _item,
//         //                                                   isCatering:
//         //                                                       widget.isCatering,
//         //                                                   isFromShop:
//         //                                                       widget.isFromShop,
//         //                                                   // selectedAddress: widget
//         //                                                   //     .selectedAddress,
//         //                                                 );
//         //                                               })
//         //                                           : Column(
//         //                                               children: [
//         //                                                 SizedBox(
//         //                                                     height:
//         //                                                         _screenHeight *
//         //                                                             (7 / 100)),
//         //                                                 EmptyData(
//         //                                                   subtitle: "Nantikan updatenya segera, hanya di Bisnisomall!",
//         //                                                     // subtitle:
//         //                                                     //     "Belum ada paket catering terlaris"
//         //                                                         ),
//         //                                               ],
//         //                                             )
//         //                                       : SizedBox())
//         //                     ],
//         //                   ),
//         //                 ),
//         //               )
//         //             ],
//         //           ),
//         //         ),
//         //         Padding(
//         //           padding: EdgeInsets.symmetric(horizontal: 82, vertical: 50),
//         //           child: Column(
//         //             crossAxisAlignment: CrossAxisAlignment.start,
//         //             children: [
//         //               Text("Semua ${widget.isCatering ? 'Paket' : 'Menu'}",
//         //                   style: AppTypo.h2.copyWith(
//         //                       fontWeight: FontWeight.w700, fontSize: 24)),
//         //               BlocBuilder(
//         //                   cubit: _fetchProductsBySellerCubit,
//         //                   builder: (context, state) => state
//         //                           is FetchProductsBySellerLoading
//         //                       ? Center(child: CircularProgressIndicator())
//         //                       : state is FetchProductsBySellerFailure
//         //                           ? Column(
//         //                               children: [
//         //                                 SizedBox(
//         //                                     height: _screenHeight * (7 / 100)),
//         //                                 state.type == ErrorType.network
//         //                                     ? NoConnection(onButtonPressed: () {
//         //                                         _fetchProductsBySellerCubit
//         //                                             .load(
//         //                                                 sellerId:
//         //                                                     widget.seller.id);
//         //                                       })
//         //                                     : ErrorFetch(
//         //                                         message: state.message,
//         //                                         onButtonPressed: () {
//         //                                           _fetchProductsBySellerCubit
//         //                                               .load(
//         //                                                   sellerId:
//         //                                                       widget.seller.id);
//         //                                         },
//         //                                       ),
//         //                               ],
//         //                             )
//         //                           : state is FetchProductsBySellerSuccess
//         //                               ? state.products.length > 0
//         //                                   ? GridView.builder(
//         //                                       padding: EdgeInsets.symmetric(
//         //                                           vertical: 20),
//         //                                       shrinkWrap: true,
//         //                                       physics:
//         //                                           NeverScrollableScrollPhysics(),
//         //                                       gridDelegate:
//         //                                           SliverGridDelegateWithFixedCrossAxisCount(
//         //                                               crossAxisCount: 3,
//         //                                               childAspectRatio: 1.6,
//         //                                               crossAxisSpacing: 20,
//         //                                               mainAxisSpacing: 20),
//         //                                       itemCount: state.products.length,
//         //                                       itemBuilder:
//         //                                           (BuildContext ctx, index) {
//         //                                         Products _item =
//         //                                             state.products[index];
//         //                                         return ProductsBySellerItemWeb(
//         //                                           product: _item,
//         //                                           isCatering: widget.isCatering,
//         //                                           isFromShop: widget.isFromShop,
//         //                                           // selectedAddress:
//         //                                           //     widget.selectedAddress,
//         //                                         );
//         //                                       })
//         //                                   : Column(
//         //                                       children: [
//         //                                         SizedBox(
//         //                                             height: _screenHeight *
//         //                                                 (7 / 100)),
//         //                                         EmptyData(
//         //                                           subtitle: "Nantikan updatenya segera, hanya di Bisnisomall!",
//         //                                             // subtitle:
//         //                                             //     "Belum ada produk"
//         //                                                 ),
//         //                                       ],
//         //                                     )
//         //                               : SizedBox.shrink()),
//         //             ],
//         //           ),
//         //         ),
//         //         FooterWeb()
//         //       ],
//         //     ),
//         //   ),
//         // ),
//       ),
//     );
//   }
// }

// class ProductsBySellerItemWeb extends StatelessWidget {
//   final bool isCatering, isFromShop;
//   final String title, image;
//   final Products product;
//   final int id;
//   // final Recipent selectedAddress;

//   const ProductsBySellerItemWeb({
//     Key key,
//     this.isCatering,
//     this.title,
//     this.image,
//     this.product,
//     this.id,
//     this.isFromShop,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: AppDecor.customElevation.copyWith(
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//         elevation: 0,
//         child: InkWell(
//           onTap: () {
//             context.beamToNamed(
//               '');
//                 // '/product/detail/${isFromShop == true ? 'is' : isCatering == true ? 'ic' : 'ig'}/${product.nameSeller.replaceAll(' ', '-') ?? product.name.replaceAll(' ', '-')}/${product.id}/${product.categoryId ?? 0}');
//           },
//           // : isRecipe
//           //     ? {
//           //         AppExt.pushScreen(
//           //           context,
//           //           RecipeDetailScreen(
//           //             recipeId: id,
//           //           ),
//           //         ),
//           //       }
//           //     : {},
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10)),
//                   child: Image(
//                     image: NetworkImage(
//                       "${AppConst.STORAGE_URL}/products/${product.productPhoto}",
//                     ),
//                     width: double.infinity,
//                     height: 180,
//                     fit: BoxFit.cover,
//                     errorBuilder: (BuildContext context, Object exception,
//                         StackTrace stackTrace) {
//                       return Image.asset(
//                         AppImg.img_error,
//                         width: double.infinity,
//                         height: 180,
//                         fit: BoxFit.contain,
//                       );
//                     },
//                     frameBuilder:
//                         (context, child, frame, wasSynchronouslyLoaded) {
//                       if (wasSynchronouslyLoaded) {
//                         return child;
//                       } else {
//                         return AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 300),
//                           child: frame != null
//                               ? child
//                               : Container(
//                                   width: double.infinity,
//                                   height: 180,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.vertical(
//                                         top: Radius.circular(10)),
//                                     color: Colors.grey[200],
//                                   ),
//                                 ),
//                         );
//                       }
//                     },
//                   )),
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${product.name}",
//                           maxLines: kIsWeb? null : 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: AppTypo.caption
//                               .copyWith(fontWeight: FontWeight.w700),
//                         ),
//                         Text(
//                           "",
//                           // "${product.nameSeller}",
//                           maxLines: kIsWeb? null : 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: AppTypo.caption,
//                         ),
//                       ],
//                     ),
//                     Text(
//                       "",
//                       // "Rp ${AppExt.toRupiah(product.enduserPrice)}",
//                       style: AppTypo.body1v2.copyWith(
//                           fontWeight: FontWeight.w700, color: AppColor.primary),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
