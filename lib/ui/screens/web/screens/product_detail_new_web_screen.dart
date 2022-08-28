// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:aligned_dialog/aligned_dialog.dart';
// import 'package:animations/animations.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_boxicons/flutter_boxicons.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:intl/intl.dart';
// import 'package:marketplace/data/blocs/fetch_categories/fetch_categories_cubit.dart';
// import 'package:provider/provider.dart';

// import 'package:marketplace/api/api.dart';
// import 'package:marketplace/data/blocs/shipping/shipping_address/shipping_address_cubit.dart';
// import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/cart/add_to_cart/add_to_cart_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/cart/add_to_cart_web/add_to_cart_web_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/cart/update_quantity/update_quantity_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/products/fetch_product_detail/fetch_product_detail_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/products/fetch_product_recom/fetch_product_recom_cubit.dart';
// import 'package:marketplace/data/models/models.dart' as models;
// import 'package:marketplace/ui/screens/nav/nav.dart';
// import 'package:marketplace/ui/screens/screens.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:marketplace/ui/widgets/basic_card.dart';
// import 'package:marketplace/ui/widgets/fetch_conditions.dart';
// import 'package:marketplace/ui/widgets/web/breadcumb_item_web.dart';
// import 'package:marketplace/ui/widgets/web/footer_web.dart';
// import 'package:marketplace/ui/widgets/web/navbar_web.dart';
// import 'package:marketplace/ui/widgets/web/product_list_web.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/text.dart' as AppText;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/decorations.dart' as AppDecor;

// class ProductDetailNewWeb extends StatefulWidget {
//   final int productId;
//   final int categoryId;
//   final int monthId;
//   final bool isCatering;
//   final bool isPrediction;
//   final String sellerName;
//   // final Recipent selectedAddress;

//   const ProductDetailNewWeb({
//     Key key,
//     this.productId,
//     this.categoryId,
//     this.isCatering = false,
//     this.sellerName,
//     this.isPrediction = false,
//     this.monthId,
//     // @required this.selectedAddress
//   }) : super(key: key);
//   @override
//   _ProductDetailNewWebState createState() => _ProductDetailNewWebState();
// }

// class _ProductDetailNewWebState extends State<ProductDetailNewWeb> {
//   final addCartKey = GlobalKey();
//   FetchProductRecomCubit _fetchProductRecomCubit;
//   FetchProductDetailCubit _fetchProductDetailCubit;
//   FetchCategoriesCubit _fetchCategoriesCubit;
//   // HandlePaymentRouteWebCubit _handlePaymentRouteWebCubit;
//   AddToCartWebCubit _addToCartWebCubit;
//   UpdateQuantityCubit _updateQuantityCubit;
//   TextEditingController _qtyCtrl;
 

//   List<models.Category> _categoryWeb = [];
//   List<models.Category> _categoryWebSelection = [];

//   //For Grocir
//   models.Wholesale _grocir;
//   List<models.Wholesale> _grocir2 = [];
//   bool isGrocirNow = false;
//   int priceGrocir, grocirId;

//   @override
//   void initState() {
//     _fetchProductDetailCubit = FetchProductDetailCubit()
//       ..load(
//           productId: widget.productId,
//           isWarung: BlocProvider.of<UserDataCubit>(context).state.user != null
//               ? BlocProvider.of<UserDataCubit>(context).state.user.roleId == "5"
//                   ? 1
//                   : 0
//               : 0);
//     _fetchProductRecomCubit = FetchProductRecomCubit()
//       ..fetchProductRecom(productId: widget.productId);
//     _addToCartWebCubit = AddToCartWebCubit(
//         userDataCubit: BlocProvider.of<UserDataCubit>(context));
//     _fetchCategoriesCubit = FetchCategoriesCubit()..load();
//     // _handlePaymentRouteWebCubit=HandlePaymentRouteWebCubit();
//     _updateQuantityCubit = UpdateQuantityCubit();
//     _qtyCtrl = TextEditingController(text: "1");
   
//     // _fetchPotencyDetailCubit = FetchPotencyDetailCubit();
    
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fetchProductRecomCubit.close();
//     _fetchProductDetailCubit.close();
//     _addToCartWebCubit.close();
//     _updateQuantityCubit.close();
//     super.dispose();
//   }

  
//   _handleAddToCart({@required int sellerId}) {
//     LoadingDialog.show(context);
//     _addToCartWebCubit.addCartWeb(
//         productId: widget.productId, sellerId: sellerId);
//   }

//   _onQuantityChange(String value) {
//     try {
//       if (int.parse(value) <= 0) {
//         ScaffoldMessenger.of(context)
//           ..removeCurrentSnackBar()
//           ..showSnackBar(
//             new SnackBar(
//               content: new Text(
//                 "Jumlah tidak boleh kosong",
//               ),
//               duration: Duration(seconds: 1),
//             ),
//           );
//         setState(() {
//           _qtyCtrl.text = "1";
//         });
//         AppExt.hideKeyboard(context);
//       }
//       setState(() {});
//       // widget.onUpdate(int.parse(value));
//     } catch (e) {
//       setState(() {
//         _qtyCtrl.text = "1";
//       });
//       AppExt.hideKeyboard(context);
//       ScaffoldMessenger.of(context)
//         ..removeCurrentSnackBar()
//         ..showSnackBar(
//           new SnackBar(
//             content: new Text(
//               "Jumlah tidak valid",
//             ),
//             duration: Duration(seconds: 1),
//           ),
//         );
//     }
//   }

//   void grocirFunc(List<models.Wholesale> grocir, int qty) {
//     if (grocir.length > 0) {
//       if (qty <= grocir[0].to) {
//         setState(() {
//           isGrocirNow = false;
//           grocirId = 0;
//         });
//       }
//       for (var i = 0; i < grocir.length; i++) {
//         if (qty >= grocir[i].from && qty <= grocir[i].to) {
//           setState(() {
//             isGrocirNow = true;
//             priceGrocir = grocir[i].wholesalePrice;
//             grocirId = grocir[i].id;
//           });
//         }
//       }
//     }
//   }

//   _onMin() {
//     setState(() => _qtyCtrl.text = "${int.parse(_qtyCtrl.text) - 1}");
//     _onQuantityChange(_qtyCtrl.text);
//     _grocir2.length > 0 ? grocirFunc(_grocir2, int.parse(_qtyCtrl.text)) : null;
//   }

//   _onPlus() {
//     setState(() => _qtyCtrl.text = "${int.parse(_qtyCtrl.text) + 1}");
//     _onQuantityChange(_qtyCtrl.text);
//     _grocir2.length > 0 ? grocirFunc(_grocir2, int.parse(_qtyCtrl.text)) : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final config = AAppConfig.of(context);
//     final double _screenWidth = MediaQuery.of(context).size.width;
//     int _qty = int.parse(_qtyCtrl.text);
//     // if (_screenWidth <= 975 || _screenWidth >= 1366) {
//     //   _fetchProductRecomCubit.fetchProductRecom(productId: widget.productId);
//     // }

//     final bool isWarung =
//         BlocProvider.of<UserDataCubit>(context).state.user?.roleId == "5"
//             ? true
//             : false;
//     final bool isSignedIn =
//         BlocProvider.of<UserDataCubit>(context).state.user != null;
//     final bool isPanenPanen = config.appType == AppType.panenpanen;

//     // return MultiBlocProvider(
//     //   providers: [
//     //     BlocProvider(
//     //       create: (_) => _fetchProductRecomCubit,
//     //     ),
//     //     BlocProvider(
//     //       create: (_) => _fetchProductDetailCubit,
//     //     ),
//     //     BlocProvider(
//     //       create: (_) => _addToCartWebCubit,
//     //     ),
//     //     BlocProvider(create: (_) => _updateQuantityCubit),
//     //   ],
//     //   child: MultiBlocListener(
//     //     listeners: [
//     //       BlocListener(
//     //         cubit: _addToCartWebCubit,
//     //         listener: (_, state) {
//     //           if (state is AddToCartWebFailure) {
//     //             AppExt.popScreen(context);
//     //             showDialog(
//     //                 context: context,
//     //                 builder: (BuildContext context) {
//     //                   return AlertFailureWeb(
//     //                       title: "Produk gagal ditambahkan ke keranjang",
//     //                       description: state.message,
//     //                       onPressClose: () {
//     //                         AppExt.popScreen(context);
//     //                       });
//     //                 });
//     //             // BottomSheetFeedback.show(
//     //             //   context,
//     //             //   icon: Boxicons.bx_x_circle,
//     //             //   color: AppColor.red,
//     //             //   title: "Produk gagal ditambahkan ke keranjang",
//     //             //   description: "${state.message}",
//     //             // );

//     //             return;
//     //           }
//     //           if (state is AddToCartWebSuccess) {
//     //             // AppExt.popScreen(context);
//     //             // debugPrint(state.cartProductUpdated.id);
//     //             AppExt.popScreen(context);
//     //             _updateQuantityCubit.updateQuantity(
//     //                 cartId: [state.cartProductUpdated.id],
//     //                 quantity: [state.cartProductUpdated.quantity + _qty - 1]);
//     //             showDialog(
//     //                 context: context,
//     //                 useRootNavigator: false,
//     //                 builder: (BuildContext context) {
//     //                   return AlertAddCartWeb(
//     //                       title: "Produk ditambahkan ke keranjang",
//     //                       description:
//     //                           "Silakan checkout untuk melakukan pembelian",
//     //                       onPressClose: () {
//     //                         AppExt.popScreen(context);
//     //                       });
//     //                 });

//     //             // BottomSheetFeedback.show(
//     //             //   context,
//     //             //   title: "Produk ditambahkan ke keranjang",
//     //             //   description: "Silakan checkout untuk melakukan pembelian",
//     //             // );
//     //             _fetchProductDetailCubit.reload(
//     //                 productId: widget.productId,
//     //                 isWarung: isWarung == true ? 1 : 0);
//     //             return;
//     //           }
//     //         },
//     //       ),
//     //       BlocListener(
//     //         cubit: _fetchProductDetailCubit,
//     //         listener: (_, state) {
//     //           if (state is FetchProductDetailSuccess) {
//     //             if (state.product.prediction != null &&
//     //                 (widget.monthId == state.product.prediction.monthId)) {
//     //               setState(() {
//     //                 _prediction = state.product.prediction;
//     //               });
//     //             }
//     //             return;
//     //           }
//     //         },
//     //       ),
//     //       BlocListener(
//     //         cubit: _fetchCategoriesCubit,
//     //         listener: (context, state) {
//     //           if (state is FetchCategoriesSuccess) {
//     //             for (var i = 0; i < state.categories.length; i++) {
//     //               _categoryWeb.add(models.Category(
//     //                   index: i,
//     //                   id: state.categories[i].id,
//     //                   name: state.categories[i].name,
//     //                   code: state.categories[i].code,
//     //                   icon: state.categories[i].icon));
//     //             }
//     //             for (var i = 0; i < _categoryWeb.length; i++) {
//     //               if (_categoryWeb[i].id == widget.categoryId) {
//     //                 _categoryWebSelection.add(models.Category(
//     //                     index: _categoryWeb[i].index,
//     //                     id: _categoryWeb[i].id,
//     //                     name: _categoryWeb[i].name,
//     //                     code: _categoryWeb[i].code,
//     //                     icon: _categoryWeb[i].icon));
//     //               }
//     //             }
//     //           }
//     //           return;
//     //         },
//     //       ),
//     //     ],
//     //     child: BlocBuilder(
//     //         cubit: _fetchProductDetailCubit,
//     //         builder: (context, fetchProductDetailState) {
//     //           return BlocBuilder(
//     //               cubit: _fetchProductRecomCubit,
//     //               builder: (context, fetchRecomState) {
//     //                 return AppTrans.SharedAxisTransitionSwitcher(
//     //                     fillColor: Colors.transparent,
//     //                     transitionType: SharedAxisTransitionType.vertical,
//     //                     child:
//     //                         fetchProductDetailState is FetchProductDetailLoading
//     //                             ? Center(child: CircularProgressIndicator())
//     //                             : fetchProductDetailState
//     //                                     is FetchProductDetailFailure
//     //                                 ? Center(
//     //                                     child: ErrorFetch(
//     //                                       message:
//     //                                           fetchProductDetailState.message,
//     //                                       onButtonPressed: () {
//     //                                         _fetchProductDetailCubit =
//     //                                             FetchProductDetailCubit()
//     //                                               ..load(
//     //                                                   productId:
//     //                                                       widget.productId,
//     //                                                   isWarung: isWarung == true
//     //                                                       ? 1
//     //                                                       : 0);
//     //                                       },
//     //                                     ),
//     //                                   )
//     //                                 : fetchProductDetailState
//     //                                         is FetchProductDetailSuccess
//     //                                     ? Builder(builder: (context) {
//     //                                         final bool hasKomisi =
//     //                                             fetchProductDetailState
//     //                                                     .product.komisi !=
//     //                                                 null;

//     //                                         return Title(
//     //                                           color: AppColor.primary,
//     //                                           title:
//     //                                               "${fetchProductDetailState.product.name} | Bisniso.id",
//     //                                           child: Scrollbar(
//     //                                             isAlwaysShown: true,
//     //                                             child: Center(
//     //                                               child: ConstrainedBox(
//     //                                                 constraints: BoxConstraints(
//     //                                                   maxWidth: 1366,
//     //                                                 ),
//     //                                                 child: ListView(
//     //                                                   shrinkWrap: true,
//     //                                                   children: [
//     //                                                     Padding(
//     //                                                       padding:
//     //                                                           EdgeInsets.only(
//     //                                                               top: 40,
//     //                                                               bottom: 30,
//     //                                                               left: 82),
//     //                                                       child: !widget
//     //                                                               .isPrediction
//     //                                                           ? Row(
//     //                                                               children: [
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .click,
//     //                                                                   title:
//     //                                                                       "Home",
//     //                                                                   route:
//     //                                                                       "/",
//     //                                                                 ),
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .basic,
//     //                                                                   title:
//     //                                                                       " - ",
//     //                                                                   color: AppColor
//     //                                                                       .textPrimary,
//     //                                                                 ),
//     //                                                                 BreadCumbItemWeb(
//     //                                                                     mouseCursor:
//     //                                                                         SystemMouseCursors
//     //                                                                             .click,
//     //                                                                     title: fetchProductDetailState
//     //                                                                         .product
//     //                                                                         .categoryName,
//     //                                                                     route:
//     //                                                                         "/product/${fetchProductDetailState.product.categoryName.toLowerCase()}/${fetchProductDetailState.product.categoryId}/${_categoryWebSelection[0].index}/?recid=${BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent != null ? AppExt.encryptMyData(jsonEncode(BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent.id)) : AppExt.encryptMyData(jsonEncode(null))}"),
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .basic,
//     //                                                                   title:
//     //                                                                       " - ",
//     //                                                                   color: AppColor
//     //                                                                       .textPrimary,
//     //                                                                 ),
//     //                                                                 // config.appType ==
//     //                                                                 //         AppType
//     //                                                                 //             .panenpanen
//     //                                                                 //     ? BreadCumbItemWeb(
//     //                                                                 //         mouseCursor: SystemMouseCursors
//     //                                                                 //             .click,
//     //                                                                 //         title: widget.isCatering
//     //                                                                 //             ? widget.sellerName
//     //                                                                 //             : fetchProductDetailState.product.subcategoryName,
//     //                                                                 //         route: widget.isCatering
//     //                                                                 //             ? "/product/${fetchProductDetailState.product.categoryId}"
//     //                                                                 //             : config.appType == AppType.panenpanen
//     //                                                                 //                 ? "/product/${fetchProductDetailState.product.categoryName.toLowerCase()}/${fetchProductDetailState.product.categoryId}/${_categoryWebSelection[0].index}/?recid=${BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent != null ? AppExt.encryptMyData(jsonEncode(BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent.id)) : AppExt.encryptMyData(jsonEncode(null))}"
//     //                                                                 //                 : "/productsumedang/${fetchProductDetailState.product.categoryId}")
//     //                                                                 //     : SizedBox(),
//     //                                                                 // config.appType ==
//     //                                                                 //         AppType.panenpanen
//     //                                                                 //     ? BreadCumbItemWeb(
//     //                                                                 //         mouseCursor:
//     //                                                                 //             SystemMouseCursors.basic,
//     //                                                                 //         title:
//     //                                                                 //             " - ",
//     //                                                                 //         color:
//     //                                                                 //             AppColor.textPrimary,
//     //                                                                 //       )
//     //                                                                 //     : SizedBox(),
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .basic,
//     //                                                                   title: fetchProductDetailState
//     //                                                                       .product
//     //                                                                       .name,
//     //                                                                 ),
//     //                                                               ],
//     //                                                             )
//     //                                                           : Row(
//     //                                                               children: [
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .click,
//     //                                                                   title:
//     //                                                                       "Home",
//     //                                                                   route:
//     //                                                                       "/",
//     //                                                                 ),
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .basic,
//     //                                                                   title:
//     //                                                                       " - ",
//     //                                                                   color: AppColor
//     //                                                                       .textPrimary,
//     //                                                                 ),
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .click,
//     //                                                                   title:
//     //                                                                       "Home",
//     //                                                                   route:
//     //                                                                       "/potency",
//     //                                                                 ),
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .basic,
//     //                                                                   title:
//     //                                                                       " - ",
//     //                                                                   color: AppColor
//     //                                                                       .textPrimary,
//     //                                                                 ),
//     //                                                                 BreadCumbItemWeb(
//     //                                                                   mouseCursor:
//     //                                                                       SystemMouseCursors
//     //                                                                           .click,
//     //                                                                   title: fetchProductDetailState
//     //                                                                       .product
//     //                                                                       .name,
//     //                                                                 ),
//     //                                                               ],
//     //                                                             ),
//     //                                                     ),
//     //                                                     Padding(
//     //                                                       padding: EdgeInsets
//     //                                                           .symmetric(
//     //                                                               horizontal:
//     //                                                                   82),
//     //                                                       child: Row(
//     //                                                         mainAxisAlignment:
//     //                                                             MainAxisAlignment
//     //                                                                 .spaceBetween,
//     //                                                         crossAxisAlignment:
//     //                                                             CrossAxisAlignment
//     //                                                                 .start,
//     //                                                         children: [
//     //                                                           Expanded(
//     //                                                             flex: 1,
//     //                                                             child:
//     //                                                                 Container(
//     //                                                               // color: Colors.red,
//     //                                                               child: Column(
//     //                                                                 children: [
//     //                                                                   CarouselProductWeb(
//     //                                                                       images: [
//     //                                                                         fetchProductDetailState.product.productPhoto,
//     //                                                                       ],
//     //                                                                       isLoading:
//     //                                                                           false),
//     //                                                                   // ClipRRect(
//     //                                                                   //     borderRadius:
//     //                                                                   //         BorderRadius.circular(
//     //                                                                   //             10),
//     //                                                                   //     child:
//     //                                                                   //         Image(
//     //                                                                   //       image:
//     //                                                                   //           NetworkImage(
//     //                                                                   //         "${AppConst.STORAGE_URL}/products/${fetchProductDetailState.product.productPhoto}",
//     //                                                                   //       ),
//     //                                                                   //       width:
//     //                                                                   //           300,
//     //                                                                   //       height:
//     //                                                                   //           300,
//     //                                                                   //       fit: BoxFit
//     //                                                                   //           .cover,
//     //                                                                   //       errorBuilder: (context, object, stack) =>
//     //                                                                   //           Image.asset(
//     //                                                                   //         AppImg.img_error,
//     //                                                                   //         width:
//     //                                                                   //             double.infinity,
//     //                                                                   //         height:
//     //                                                                   //             300,
//     //                                                                   //       ),
//     //                                                                   //       frameBuilder: (context,
//     //                                                                   //           child,
//     //                                                                   //           frame,
//     //                                                                   //           wasSynchronouslyLoaded) {
//     //                                                                   //         if (wasSynchronouslyLoaded) {
//     //                                                                   //           return child;
//     //                                                                   //         } else {
//     //                                                                   //           return AnimatedSwitcher(
//     //                                                                   //             duration: const Duration(milliseconds: 500),
//     //                                                                   //             child: frame != null
//     //                                                                   //                 ? child
//     //                                                                   //                 : Container(
//     //                                                                   //                     width: double.infinity,
//     //                                                                   //                     height: 300,
//     //                                                                   //                     decoration: BoxDecoration(
//     //                                                                   //                       borderRadius: BorderRadius.circular(10),
//     //                                                                   //                       color: Colors.grey[200],
//     //                                                                   //                     ),
//     //                                                                   //                   ),
//     //                                                                   //           );
//     //                                                                   //         }
//     //                                                                   //       },
//     //                                                                   //     )),
//     //                                                                   widget.isPrediction
//     //                                                                       ? Padding(
//     //                                                                           padding: EdgeInsets.only(top: 20),
//     //                                                                           child: Container(
//     //                                                                             decoration: BoxDecoration(
//     //                                                                               border: Border.all(color: AppColor.grey, width: 1),
//     //                                                                               borderRadius: BorderRadius.circular(7.5),
//     //                                                                             ),
//     //                                                                             child: ListTile(
//     //                                                                               onTap: () => _showMonthDialog(context),
//     //                                                                               shape: RoundedRectangleBorder(
//     //                                                                                 borderRadius: BorderRadius.circular(7.5),
//     //                                                                               ),
//     //                                                                               title: Text(
//     //                                                                                 "${DateFormat('MMMM', 'ID').format(DateTime(DateTime.now().year, _selectedMonth.id, 1))}",
//     //                                                                                 style: AppTypo.body1v2.copyWith(
//     //                                                                                   fontWeight: FontWeight.w700,
//     //                                                                                 ),
//     //                                                                                 overflow: TextOverflow.ellipsis,
//     //                                                                                 maxLines: kIsWeb ? null : 1,
//     //                                                                               ),
//     //                                                                               trailing: Icon(
//     //                                                                                 Icons.chevron_right,
//     //                                                                                 color: AppColor.black,
//     //                                                                                 size: 26,
//     //                                                                               ),
//     //                                                                             ),
//     //                                                                           ),
//     //                                                                         )
//     //                                                                       : SizedBox(),
//     //                                                                   Padding(
//     //                                                                     padding: EdgeInsets.symmetric(
//     //                                                                         vertical:
//     //                                                                             15,
//     //                                                                         horizontal: !widget.isPrediction
//     //                                                                             ? 50
//     //                                                                             : 0),
//     //                                                                     child:
//     //                                                                         IntrinsicHeight(
//     //                                                                       child:
//     //                                                                           Row(
//     //                                                                         mainAxisAlignment:
//     //                                                                             MainAxisAlignment.spaceBetween,
//     //                                                                         children: [
//     //                                                                           Expanded(
//     //                                                                             flex: 2,
//     //                                                                             child: Container(
//     //                                                                                 // color: Colors.blue,
//     //                                                                                 child: !widget.isPrediction
//     //                                                                                     ? Column(
//     //                                                                                         children: [
//     //                                                                                           Text(fetchProductDetailState.product.sold.toString(), style: AppTypo.h3),
//     //                                                                                           SizedBox(
//     //                                                                                             height: 2,
//     //                                                                                           ),
//     //                                                                                           Text("Terjual", style: AppTypo.subtitle2.copyWith(color: AppColor.grey))
//     //                                                                                         ],
//     //                                                                                       )
//     //                                                                                     : SizedBox()),
//     //                                                                           ),
//     //                                                                           Expanded(
//     //                                                                             flex: 1,
//     //                                                                             child: Container(
//     //                                                                               // color: Colors.green,
//     //                                                                               child: VerticalDivider(
//     //                                                                                 thickness: 1,
//     //                                                                                 color: AppColor.grey,
//     //                                                                                 indent: 3,
//     //                                                                                 endIndent: 4,
//     //                                                                               ),
//     //                                                                             ),
//     //                                                                           ),
//     //                                                                           Expanded(
//     //                                                                             flex: 2,
//     //                                                                             child: Container(
//     //                                                                                 // color: Colors.indigo,
//     //                                                                                 child: !widget.isPrediction
//     //                                                                                     ? Column(
//     //                                                                                         children: [
//     //                                                                                           Text(fetchProductDetailState.product.stock.toString(), style: AppTypo.h3),
//     //                                                                                           SizedBox(
//     //                                                                                             height: 2,
//     //                                                                                           ),
//     //                                                                                           Text("Stok", style: AppTypo.subtitle2.copyWith(color: AppColor.grey))
//     //                                                                                         ],
//     //                                                                                       )
//     //                                                                                     : SizedBox()),
//     //                                                                           ),
//     //                                                                         ],
//     //                                                                       ),
//     //                                                                     ),
//     //                                                                   )
//     //                                                                 ],
//     //                                                               ),
//     //                                                             ),
//     //                                                           ),
//     //                                                           Expanded(
//     //                                                             flex: 2,
//     //                                                             child:
//     //                                                                 Container(
//     //                                                               // color: Colors.blue,
//     //                                                               child:
//     //                                                                   Padding(
//     //                                                                 padding: const EdgeInsets
//     //                                                                         .symmetric(
//     //                                                                     horizontal:
//     //                                                                         40),
//     //                                                                 child:
//     //                                                                     Column(
//     //                                                                   crossAxisAlignment:
//     //                                                                       CrossAxisAlignment
//     //                                                                           .start,
//     //                                                                   children: [
//     //                                                                     Text(
//     //                                                                       "${fetchProductDetailState.product.name}",
//     //                                                                       style:
//     //                                                                           AppTypo.h1,
//     //                                                                     ),
//     //                                                                     SizedBox(
//     //                                                                       height: widget.isPrediction
//     //                                                                           ? 8
//     //                                                                           : 0,
//     //                                                                     ),
//     //                                                                     widget.isPrediction
//     //                                                                         ? Text("Harga saat ini",
//     //                                                                             style: AppTypo.body1.copyWith(fontSize: 14))
//     //                                                                         : SizedBox(),
//     //                                                                     RichText(
//     //                                                                       text:
//     //                                                                           TextSpan(
//     //                                                                         text:
//     //                                                                             "Rp ${AppExt.toRupiah(fetchProductDetailState.product.enduserPrice)}",
//     //                                                                         style:
//     //                                                                             AppTypo.h1.copyWith(color: AppColor.primary),
//     //                                                                         // children: [
//     //                                                                         //   TextSpan(
//     //                                                                         //       text: config.appType == AppType.panenpanen ? "/box" : "/pcs",
//     //                                                                         //       style: AppTypo.captionAccent),
//     //                                                                         // ],
//     //                                                                       ),
//     //                                                                     ),
//     //                                                                     fetchProductDetailState.product.disc >
//     //                                                                             0
//     //                                                                         ? SizedBox(height: 3)
//     //                                                                         : SizedBox.shrink(),
//     //                                                                     fetchProductDetailState.product.disc >
//     //                                                                             0
//     //                                                                         ? Row(
//     //                                                                             children: [
//     //                                                                               Container(
//     //                                                                                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//     //                                                                                 decoration: BoxDecoration(
//     //                                                                                   borderRadius: BorderRadius.circular(2),
//     //                                                                                   color: AppColor.red.withOpacity(0.25),
//     //                                                                                 ),
//     //                                                                                 child: Text(
//     //                                                                                   "${fetchProductDetailState.product.disc}%",
//     //                                                                                   style: AppTypo.subtitle2.copyWith(fontWeight: FontWeight.w700, color: AppColor.red),
//     //                                                                                 ),
//     //                                                                               ),
//     //                                                                               SizedBox(width: 3),
//     //                                                                               Expanded(
//     //                                                                                 child: Text("Rp ${AppExt.toRupiah(fetchProductDetailState.product.price)} ", maxLines: kIsWeb ? null : 1, overflow: TextOverflow.ellipsis, style: AppTypo.body1.copyWith(color: AppColor.grey, decoration: TextDecoration.lineThrough)),
//     //                                                                               ),
//     //                                                                             ],
//     //                                                                           )
//     //                                                                         : SizedBox.shrink(),
//     //                                                                     Padding(
//     //                                                                       padding:
//     //                                                                           EdgeInsets.symmetric(vertical: 10),
//     //                                                                       child: Divider(
//     //                                                                           thickness: 1,
//     //                                                                           color: AppColor.grey,
//     //                                                                           indent: 3,
//     //                                                                           endIndent: 4),
//     //                                                                     ),
//     //                                                                     if (isPanenPanen &&
//     //                                                                         isSignedIn)
//     //                                                                       if (isWarung &&
//     //                                                                           hasKomisi) ...[
//     //                                                                         Column(
//     //                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//     //                                                                           children: [
//     //                                                                             Row(
//     //                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                                                                               children: [
//     //                                                                                 Text(
//     //                                                                                   "Bayar ke Bisniso",
//     //                                                                                   style: AppTypo.body1v2,
//     //                                                                                 ),
//     //                                                                                 SizedBox(height: 5),
//     //                                                                                 Text(
//     //                                                                                   "Rp ${AppExt.toRupiah(fetchProductDetailState.product?.resellerPrice)}",
//     //                                                                                   style: AppTypo.body1v2.copyWith(color: AppColor.primary),
//     //                                                                                 ),
//     //                                                                               ],
//     //                                                                             ),
//     //                                                                             SizedBox(height: 5),
//     //                                                                             Row(
//     //                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                                                                               children: [
//     //                                                                                 Text(
//     //                                                                                   "Keuntungan Anda",
//     //                                                                                   style: AppTypo.body1v2,
//     //                                                                                 ),
//     //                                                                                 SizedBox(height: 5),
//     //                                                                                 Text(
//     //                                                                                   "Rp ${AppExt.toRupiah(fetchProductDetailState.product.komisi)}",
//     //                                                                                   style: AppTypo.body1v2.copyWith(color: Color(0xFFF18C2E)),
//     //                                                                                 ),
//     //                                                                               ],
//     //                                                                             ),
//     //                                                                             Padding(
//     //                                                                               padding: EdgeInsets.symmetric(vertical: 10),
//     //                                                                               child: Divider(thickness: 1, color: AppColor.grey, indent: 3, endIndent: 4),
//     //                                                                             ),
//     //                                                                           ],
//     //                                                                         ),
//     //                                                                       ],
//     //                                                                     Visibility(
//     //                                                                       visible: fetchProductDetailState.product.wholesale.length > 0
//     //                                                                           ? true
//     //                                                                           : false,
//     //                                                                       child:
//     //                                                                           Column(
//     //                                                                         crossAxisAlignment:
//     //                                                                             CrossAxisAlignment.start,
//     //                                                                         children: [
//     //                                                                           Padding(
//     //                                                                             padding: EdgeInsets.symmetric(vertical: 13),
//     //                                                                             child: Text("Harga Grosir", style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700)),
//     //                                                                           ),
//     //                                                                           GridView.builder(
//     //                                                                               shrinkWrap: true,
//     //                                                                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     //                                                                                 crossAxisCount: 3,
//     //                                                                                 childAspectRatio: 2.7,
//     //                                                                                 crossAxisSpacing: 5,
//     //                                                                                 // mainAxisSpacing: 10
//     //                                                                               ),
//     //                                                                               itemCount: fetchProductDetailState.product.wholesale.length,
//     //                                                                               itemBuilder: (BuildContext ctx, index) {
//     //                                                                                 _grocir = fetchProductDetailState.product.wholesale[index];
//     //                                                                                 _grocir2 = fetchProductDetailState.product.wholesale;
//     //                                                                                 return Container(
//     //                                                                                     // color: Colors.amber,
//     //                                                                                     padding: EdgeInsets.all(10),
//     //                                                                                     child: Column(
//     //                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
//     //                                                                                       children: [
//     //                                                                                         Text("Rp ${AppExt.toRupiah(_grocir.wholesalePrice)}", style: AppTypo.body1.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
//     //                                                                                         SizedBox(height: 4),
//     //                                                                                         Text("Min Pembelian ${_grocir.from}", style: AppTypo.caption),
//     //                                                                                       ],
//     //                                                                                     ),
//     //                                                                                     decoration: BoxDecoration(
//     //                                                                                       color: _grocir.id == grocirId ? AppColor.grey.withOpacity(0.25) : AppColor.textPrimaryInverted,
//     //                                                                                       border: Border(
//     //                                                                                         bottom: _grocir.id == grocirId ? BorderSide(width: 2.0, color: AppColor.primary) : BorderSide.none,
//     //                                                                                         left: index % 2 == 1 ? BorderSide(width: 2.0, color: AppColor.grey) : BorderSide.none,
//     //                                                                                         right: index % 2 == 1 ? BorderSide(width: 2.0, color: AppColor.grey) : BorderSide.none,
//     //                                                                                       ),
//     //                                                                                     ));
//     //                                                                               }),
//     //                                                                           Padding(
//     //                                                                             padding: EdgeInsets.symmetric(vertical: 20),
//     //                                                                             child: Divider(thickness: 1, color: AppColor.grey, indent: 3, endIndent: 4),
//     //                                                                           )
//     //                                                                         ],
//     //                                                                       ),
//     //                                                                     ),
//     //                                                                     Text(
//     //                                                                         "Detail Produk",
//     //                                                                         style:
//     //                                                                             AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700)),
//     //                                                                     SizedBox(
//     //                                                                         height:
//     //                                                                             12),
//     //                                                                     Text(
//     //                                                                         "Berat :"),
//     //                                                                     Text(
//     //                                                                       "${fetchProductDetailState.product.weight}${fetchProductDetailState.product.unit}",
//     //                                                                       style: AppTypo
//     //                                                                           .caption
//     //                                                                           .copyWith(
//     //                                                                         color:
//     //                                                                             AppColor.primary,
//     //                                                                         fontWeight:
//     //                                                                             FontWeight.w700,
//     //                                                                       ),
//     //                                                                     ),
//     //                                                                     SizedBox(
//     //                                                                         height:
//     //                                                                             12),
//     //                                                                     Text(
//     //                                                                         "Kota Distribusi :"),
//     //                                                                     Text(
//     //                                                                       "${fetchProductDetailState.product.coverageCitiesString ?? '-'}",
//     //                                                                       style: AppTypo
//     //                                                                           .caption
//     //                                                                           .copyWith(
//     //                                                                         color:
//     //                                                                             AppColor.primary,
//     //                                                                         fontWeight:
//     //                                                                             FontWeight.w700,
//     //                                                                       ),
//     //                                                                     ),
//     //                                                                     SizedBox(
//     //                                                                         height:
//     //                                                                             12),
//     //                                                                     Text(
//     //                                                                         fetchProductDetailState
//     //                                                                             .product.description,
//     //                                                                         style:
//     //                                                                             AppTypo.body1.copyWith(fontSize: 14))
//     //                                                                   ],
//     //                                                                 ),
//     //                                                               ),
//     //                                                             ),
//     //                                                           ),
//     //                                                           Expanded(
//     //                                                             flex: 1,
//     //                                                             child: Container(
//     //                                                                 // color: Colors.amber,
//     //                                                                 child:
//     //                                                                     // fetchProductDetailState.product.wholesale.length > 0
//     //                                                                     //             ? Column(
//     //                                                                     //                 crossAxisAlignment: CrossAxisAlignment.start,
//     //                                                                     //                 children: [
//     //                                                                     //                   Text("Harga Grosir", style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700)),
//     //                                                                     //                   SizedBox(height: 13),
//     //                                                                     //                   ListView.separated(
//     //                                                                     //                     shrinkWrap: true,
//     //                                                                     //                     physics: NeverScrollableScrollPhysics(),
//     //                                                                     //                     separatorBuilder: (context, idx) {
//     //                                                                     //                       return Divider(thickness: 1, color: AppColor.grey, indent: 3, endIndent: 4);
//     //                                                                     //                     },
//     //                                                                     //                     itemCount: fetchProductDetailState.product.wholesale.length,
//     //                                                                     //                     itemBuilder: (context, idx) {
//     //                                                                     //                       _grocir = fetchProductDetailState.product.wholesale[idx];
//     //                                                                     //                       return Container(
//     //                                                                     //                         child: Column(
//     //                                                                     //                           crossAxisAlignment: CrossAxisAlignment.start,
//     //                                                                     //                           children: [
//     //                                                                     //                             Text("Rp ${AppExt.toRupiah(_grocir.wholesalePrice)}", style: AppTypo.body1.copyWith(fontWeight: FontWeight.w700)),
//     //                                                                     //                             Text("Min Pembelian ${_grocir.from}", style: AppTypo.caption),
//     //                                                                     //                           ],
//     //                                                                     //                         ),
//     //                                                                     //                       );
//     //                                                                     //                     },
//     //                                                                     //                   ),
//     //                                                                     //                 ],
//     //                                                                     //               )
//     //                                                                     //             : SizedBox.shrink()
//     //                                                                     BasicCard(
//     //                                                                         child: Padding(
//     //                                                                             padding: EdgeInsets.all(20),
//     //                                                                             child: !widget.isPrediction
//     //                                                                                 ? Column(
//     //                                                                                     crossAxisAlignment: CrossAxisAlignment.start,
//     //                                                                                     children: [
//     //                                                                                       Text("Pembelian", style: AppTypo.h3.copyWith(fontWeight: FontWeight.w600)),
//     //                                                                                       SizedBox(
//     //                                                                                         height: 10,
//     //                                                                                       ),
//     //                                                                                       Row(
//     //                                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                                                                                         children: [
//     //                                                                                           Expanded(
//     //                                                                                             child: Text(
//     //                                                                                               "Jumlah",
//     //                                                                                               style: AppTypo.body1.copyWith(fontSize: 14, color: AppColor.grey),
//     //                                                                                             ),
//     //                                                                                           ),
//     //                                                                                           Expanded(
//     //                                                                                             child: Row(
//     //                                                                                               // crossAxisAlignment: CrossAxisAlignment.end,
//     //                                                                                               children: [
//     //                                                                                                 Spacer(),
//     //                                                                                                 Material(
//     //                                                                                                   color: Colors.transparent,
//     //                                                                                                   child: IconButton(
//     //                                                                                                     // disabledColor: AppColor.primary.withOpacity(0.3),
//     //                                                                                                     icon: Icon(FlutterIcons.minus_circle_outline_mco),
//     //                                                                                                     onPressed: fetchProductDetailState.product.stock != 0 && _qty != 1 ? _onMin : null,
//     //                                                                                                     color: AppColor.primary,
//     //                                                                                                     iconSize: 20,
//     //                                                                                                     splashRadius: 20,
//     //                                                                                                   ),
//     //                                                                                                 ),
//     //                                                                                                 Container(
//     //                                                                                                   constraints: BoxConstraints(maxWidth: 60),
//     //                                                                                                   child: IntrinsicWidth(
//     //                                                                                                     child: TextFormField(
//     //                                                                                                       showCursor: false,
//     //                                                                                                       readOnly: true,
//     //                                                                                                       onChanged: _onQuantityChange,
//     //                                                                                                       controller: _qtyCtrl,
//     //                                                                                                       inputFormatters: [
//     //                                                                                                         FilteringTextInputFormatter.digitsOnly,
//     //                                                                                                       ],
//     //                                                                                                       textAlign: TextAlign.center,
//     //                                                                                                       keyboardType: TextInputType.number,
//     //                                                                                                       decoration: InputDecoration(
//     //                                                                                                         // counter: SizedBox.shrink(),
//     //                                                                                                         isDense: true,
//     //                                                                                                         contentPadding: EdgeInsets.only(
//     //                                                                                                           bottom: 2,
//     //                                                                                                         ),
//     //                                                                                                       ),
//     //                                                                                                       style: AppTypo.body1.copyWith(
//     //                                                                                                         fontWeight: FontWeight.w700,
//     //                                                                                                       ),
//     //                                                                                                     ),
//     //                                                                                                   ),
//     //                                                                                                 ),
//     //                                                                                                 Material(
//     //                                                                                                   color: Colors.transparent,
//     //                                                                                                   child: IconButton(
//     //                                                                                                     disabledColor: AppColor.primary.withOpacity(0.3),
//     //                                                                                                     icon: Icon(FlutterIcons.plus_circle_outline_mco),
//     //                                                                                                     onPressed: fetchProductDetailState.product.stock > _qty ? _onPlus : null,
//     //                                                                                                     color: AppColor.primary,
//     //                                                                                                     iconSize: 20,
//     //                                                                                                     splashRadius: 20,
//     //                                                                                                   ),
//     //                                                                                                 ),
//     //                                                                                               ],
//     //                                                                                             ),
//     //                                                                                           ),
//     //                                                                                         ],
//     //                                                                                       ),
//     //                                                                                       SizedBox(
//     //                                                                                         height: 18,
//     //                                                                                       ),
//     //                                                                                       Row(
//     //                                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                                                                                         children: [
//     //                                                                                           Text("Subtotal", style: AppTypo.body1.copyWith(fontSize: 14, color: AppColor.grey)),
//     //                                                                                           isGrocirNow == true ? Text("Rp ${AppExt.toRupiah(priceGrocir * _qty)}", style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700)) : Text("Rp ${AppExt.toRupiah(fetchProductDetailState.product.enduserPrice * _qty)}", style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700)),
//     //                                                                                         ],
//     //                                                                                       ),
//     //                                                                                       SizedBox(
//     //                                                                                         height: 5,
//     //                                                                                       ),
//     //                                                                                       Row(
//     //                                                                                         mainAxisAlignment: MainAxisAlignment.end,
//     //                                                                                         children: [
//     //                                                                                           isGrocirNow == true ? Text("Harga Grosir Rp $priceGrocir", style: AppTypo.caption.copyWith(fontSize: 12, color: AppColor.grey)) : SizedBox.shrink(),
//     //                                                                                         ],
//     //                                                                                       ),
//     //                                                                                       SizedBox(
//     //                                                                                         height: 10,
//     //                                                                                       ),
//     //                                                                                       RoundedButton.contained(
//     //                                                                                           elevation: 0,
//     //                                                                                           label: "Beli",
//     //                                                                                           isUpperCase: false,
//     //                                                                                           textColor: AppColor.textPrimaryInverted,
//     //                                                                                           onPressed: fetchProductDetailState.product.stock == 0
//     //                                                                                               ? null
//     //                                                                                               : BlocProvider.of<UserDataCubit>(context).state.user == null
//     //                                                                                                   ? () => showDialog(
//     //                                                                                                       context: context,
//     //                                                                                                       builder: (BuildContext context) {
//     //                                                                                                         return Dialog(
//     //                                                                                                           shape: RoundedRectangleBorder(
//     //                                                                                                             borderRadius: BorderRadius.circular(20.0),
//     //                                                                                                           ), //this right here
//     //                                                                                                           child: Container(
//     //                                                                                                             constraints: BoxConstraints(
//     //                                                                                                               maxWidth: 500,
//     //                                                                                                             ),
//     //                                                                                                             // height: 200,
//     //                                                                                                             child: AuthDialog(),
//     //                                                                                                           ),
//     //                                                                                                         );
//     //                                                                                                       })
//     //                                                                                                   : () {
//     //                                                                                                       context.beamToNamed('/checkout/detail/${fetchProductDetailState.product.sellerId}?c=${AppExt.encryptMyData(json.encode(new models.CartProduct(id: fetchProductDetailState.product.id, cartId: null, name: fetchProductDetailState.product.name, productPhoto: fetchProductDetailState.product.productPhoto, enduserPrice: BlocProvider.of<UserDataCubit>(context).state.user.roleId == '5' ? fetchProductDetailState.product.resellerPrice : fetchProductDetailState.product.enduserPrice, initialPrice: BlocProvider.of<UserDataCubit>(context).state.user.roleId == '5' ? fetchProductDetailState.product.resellerPrice : fetchProductDetailState.product.enduserPrice, stock: fetchProductDetailState.product.stock, weight: fetchProductDetailState.product.weight, quantity: _qty, wholesale: fetchProductDetailState.product.wholesale, coverage: fetchProductDetailState.product.coverage)))}', data: {'isBuyNow': true});
//     //                                                                                                       // BlocProvider.of<HandleTransactionRouteWebCubit>(context).changeCheckChoosePayment(true);
//     //                                                                                                       // BlocProvider.of<HandleTransactionRouteWebCubit>(context).changeCheckCheckout(true);
//     //                                                                                                     }),
//     //                                                                                       SizedBox(
//     //                                                                                         height: 10,
//     //                                                                                       ),
//     //                                                                                       RoundedButton.outlined(
//     //                                                                                         elevation: 0,
//     //                                                                                         disabled: fetchProductDetailState.product.stock == 0,
//     //                                                                                         label: "+ Keranjang",
//     //                                                                                         isUpperCase: false,
//     //                                                                                         onPressed: fetchProductDetailState.product.stock == 0
//     //                                                                                             ? null
//     //                                                                                             : BlocProvider.of<UserDataCubit>(context).state.user == null
//     //                                                                                                 ? () => showDialog(
//     //                                                                                                     context: context,
//     //                                                                                                     builder: (BuildContext context) {
//     //                                                                                                       return Dialog(
//     //                                                                                                         shape: RoundedRectangleBorder(
//     //                                                                                                           borderRadius: BorderRadius.circular(20.0),
//     //                                                                                                         ), //this right here
//     //                                                                                                         child: Container(
//     //                                                                                                           constraints: BoxConstraints(
//     //                                                                                                             maxWidth: 500,
//     //                                                                                                           ),
//     //                                                                                                           // height: 200,
//     //                                                                                                           child: AuthDialog(),
//     //                                                                                                         ),
//     //                                                                                                       );
//     //                                                                                                     })
//     //                                                                                                 : () => _handleAddToCart(
//     //                                                                                                       sellerId: fetchProductDetailState.product.sellerId,
//     //                                                                                                     ),
//     //                                                                                       ),
//     //                                                                                     ],
//     //                                                                                   )
//     //                                                                                 : RoundedButton.contained(
//     //                                                                                     elevation: 0,
//     //                                                                                     disabled: _prediction == null || _prediction.countBooked >= _prediction.prediction,
//     //                                                                                     label: "Booking",
//     //                                                                                     isUpperCase: false,
//     //                                                                                     onPressed: fetchProductDetailState.product.stock == 0
//     //                                                                                         ? null
//     //                                                                                         : () => context.beamToNamed('/checkout/booking/${fetchProductDetailState.product.id}?c=${AppExt.encryptMyData(json.encode([
//     //                                                                                               fetchProductDetailState.product.id,
//     //                                                                                               null,
//     //                                                                                               fetchProductDetailState.product.name,
//     //                                                                                               fetchProductDetailState.product.productPhoto,
//     //                                                                                               fetchProductDetailState.product.enduserPrice,
//     //                                                                                               fetchProductDetailState.product.enduserPrice,
//     //                                                                                               fetchProductDetailState.product.stock,
//     //                                                                                               fetchProductDetailState.product.weight,
//     //                                                                                               fetchProductDetailState.product.unit,
//     //                                                                                               _prediction,
//     //                                                                                               1,
//     //                                                                                               fetchProductDetailState.product.wholesale,
//     //                                                                                               fetchProductDetailState.product.coverage
//     //                                                                                             ]))}'))))),
//     //                                                           ),
//     //                                                         ],
//     //                                                       ),
//     //                                                     ),
//     //                                                     Padding(
//     //                                                       padding: EdgeInsets
//     //                                                           .symmetric(
//     //                                                               vertical: 30,
//     //                                                               horizontal:
//     //                                                                   82),
//     //                                                       child: Divider(
//     //                                                           thickness: 1,
//     //                                                           color:
//     //                                                               AppColor.grey,
//     //                                                           indent: 3,
//     //                                                           endIndent: 4),
//     //                                                     ),
//     //                                                     fetchRecomState
//     //                                                             is FetchProductRecomLoading
//     //                                                         ? Center(
//     //                                                             child:
//     //                                                                 CircularProgressIndicator())
//     //                                                         : fetchRecomState
//     //                                                                 is FetchProductRecomFailure
//     //                                                             ? Center(
//     //                                                                 child: fetchRecomState.type ==
//     //                                                                         ErrorType
//     //                                                                             .network
//     //                                                                     ? NoConnection(onButtonPressed:
//     //                                                                         () {
//     //                                                                         _fetchProductRecomCubit = FetchProductRecomCubit()
//     //                                                                           ..fetchProductRecom(productId: widget.productId);
//     //                                                                       })
//     //                                                                     : ErrorFetch(
//     //                                                                         message:
//     //                                                                             fetchRecomState.message,
//     //                                                                         onButtonPressed:
//     //                                                                             () {
//     //                                                                           _fetchProductRecomCubit = FetchProductRecomCubit()..fetchProductRecom(productId: widget.productId);
//     //                                                                         },
//     //                                                                       ),
//     //                                                               )
//     //                                                             : fetchRecomState
//     //                                                                     is FetchProductRecomSuccess
//     //                                                                 ? fetchRecomState.products.length >
//     //                                                                         0
//     //                                                                     ? widget
//     //                                                                             .isCatering
//     //                                                                         ? LargeCardListWeb
//     //                                                                             .catering(
//     //                                                                             titleSection: "Produk Terkait",
//     //                                                                             products: fetchRecomState.products,
//     //                                                                           )
//     //                                                                         : ProductListWeb(
//     //                                                                             isTitleSection: true,
//     //                                                                             titleSection: "Produk Terkait",
//     //                                                                             products: fetchRecomState.products,
//     //                                                                             // chunkSize: _screenWidth <= 975 && _screenWidth >= 875 ? 4 : _screenWidth <= 874 ? 3 : 5,
//     //                                                                           )
//     //                                                                     : Center(
//     //                                                                         child:
//     //                                                                             EmptyData(
//     //                                                                           subtitle: "Nantikan updatenya segera, hanya di Bisnisomall!",
//     //                                                                           // subtitle: "Belum ada produk"
//     //                                                                         ),
//     //                                                                       )
//     //                                                                 : SizedBox
//     //                                                                     .shrink(),
//     //                                                     SizedBox(height: 30),
//     //                                                     FooterWeb()
//     //                                                   ],
//     //                                                 ),
//     //                                               ),
//     //                                             ),
//     //                                           ),
//     //                                         );
//     //                                       })
//     //                                     : SizedBox.shrink());
//     //               });
//     //         }),
//     //   ),
//     // );
//   }

//   // _showMonthDialog(BuildContext context) {
//   //   return showDialog(
//   //       context: context,
//   //       useRootNavigator: false,
//   //       builder: (BuildContext context) {
//   //         return DialogWeb(
//   //             width: 250,
//   //             hasMargin: true,
//   //             hasHeader: false,
//   //             marginValue: EdgeInsets.only(right: 280),
//   //             onPressedClose: () {
//   //               AppExt.popScreen(context);
//   //             },
//   //             child: Scrollbar(
//   //               isAlwaysShown: true,
//   //               child: StatefulBuilder(
//   //                 builder: (BuildContext context, StateSetter setSheetState) {
//   //                   return ListView.separated(
//   //                     padding: EdgeInsets.symmetric(horizontal: 20),
//   //                     separatorBuilder: (_, __) {
//   //                       return SizedBox(
//   //                         height: 8,
//   //                       );
//   //                     },
//   //                     shrinkWrap: true,
//   //                     itemCount: 12,
//   //                     itemBuilder: (context, index) {
//   //                       Month item = _month[index];
//   //                       return Container(
//   //                         decoration: BoxDecoration(
//   //                           color: item == _selectedMonth
//   //                               ? Color(0xFFD6FFBC)
//   //                               : Colors.transparent,
//   //                           borderRadius: BorderRadius.circular(5),
//   //                         ),
//   //                         child: InkWell(
//   //                             borderRadius: BorderRadius.circular(5),
//   //                             onTap: item.isDisabled
//   //                                 ? null
//   //                                 : () => _onSelectMonth(item, setSheetState),
//   //                             child: Padding(
//   //                               padding: EdgeInsets.all(8),
//   //                               child: Text("${item.name}",
//   //                                   style: item.isDisabled
//   //                                       ? AppTypo.subtitle2.copyWith(
//   //                                           fontWeight: FontWeight.w400,
//   //                                           color: AppColor.grey)
//   //                                       : AppTypo.subtitle2.copyWith(
//   //                                           fontWeight: FontWeight.w400,
//   //                                           color: item == _selectedMonth
//   //                                               ? AppColor.primary
//   //                                               : AppColor.textPrimary)),
//   //                             )),
//   //                       );
//   //                     },
//   //                   );
//   //                 },
//   //               ),
//   //             ));
//   //       });
//   // }
// }
