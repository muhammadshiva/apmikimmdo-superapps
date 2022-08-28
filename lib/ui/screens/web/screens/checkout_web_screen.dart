// import 'package:beamer/beamer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_boxicons/flutter_boxicons.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'package:marketplace/api/api.dart';
// import 'package:marketplace/data/blocs/checkout/submit_checkout/submit_checkout_cubit.dart';
// import 'package:marketplace/data/blocs/payment/add_payment/add_payment_cubit.dart';
// import 'package:marketplace/data/blocs/payment/fetch_payment_detail/fetch_payment_detail_cubit.dart';
// import 'package:marketplace/data/blocs/shipping/fetch_shipping_addresses/fetch_shipping_addresses_cubit.dart';
// import 'package:marketplace/data/blocs/shipping/fetch_shipping_options/fetch_shipping_options_cubit.dart';
// import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/models/cart.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/data/models/payment.dart';
// import 'package:marketplace/data/models/v2/month.dart';
// import 'package:marketplace/data/models/v2/potency.dart';
// import 'package:marketplace/data/repositories/repositories.dart';
// import 'package:marketplace/ui/screens/address_entry_screen.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:marketplace/ui/widgets/web/payment_modal_content.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/typography.dart' as AppTypo;

// class CheckoutWebScreen extends StatefulWidget {
//   final List<CartProduct> cart;
//   final int sellerId;
//   final bool isPrediction;
//   final bool isBuyNow;

//   const CheckoutWebScreen({
//     Key key,
//     @required this.cart,
//     @required this.sellerId,
//     this.isPrediction = true,
//     this.isBuyNow = false,
//   }) : super(key: key);

//   @override
//   _CheckoutWebScreenState createState() => _CheckoutWebScreenState();
// }

// class _CheckoutWebScreenState extends State<CheckoutWebScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   final RecipentRepository _recipentRepo = RecipentRepository();
//   FetchShippingOptionsCubit _fetchShippingOptionsCubit;
//   FetchShippingAddressesCubit _fetchShippingAddressesCubit;
//   SubmitCheckoutCubit _submitCheckoutCubit;
//   AddPaymentCubit _addPaymentCubit;
//   int _selectedShippingOptId;
//   int _selectedShippingAddressId;
//   bool _showMonthDropDown;
 

//   PaymentType _paymentType;
//   List<Recipent> _addresses;

//   @override
//   void initState() {
//     BlocProvider.of<HandleTransactionRouteWebCubit>(context)
//         .changecheckCheckoutSuccessPage(false);
//     // debugPrint("STATUS SAAT checkoutsuccess :" + BlocProvider.of<HandleTransactionRouteWebCubit>(context).state.checkCheckoutSuccessPage.toString());
//     // debugPrint("STATUS SAAT checkout :" + BlocProvider.of<HandleTransactionRouteWebCubit>(context).state.checkCheckout.toString());
//     _paymentType = PaymentType.manual;
//     _fetchShippingOptionsCubit =
//         FetchShippingOptionsCubit(sellerId: widget.sellerId);
//     _fetchShippingAddressesCubit = FetchShippingAddressesCubit()..load();
//     _submitCheckoutCubit = SubmitCheckoutCubit(
//         userDataCubit: BlocProvider.of<UserDataCubit>(context));
//     _addPaymentCubit = AddPaymentCubit();
//     _month = List.castFrom(listMonth);
//     if (widget.isPrediction) {
//       _selectedMonth = widget.cart[0].prediction.monthId == null
//           ? null
//           : _month[widget.cart[0].prediction.monthId - 1];
//       _prediction = widget.cart[0].prediction;
//     }
//     _addresses = [];
//     _setDisabled();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fetchShippingOptionsCubit.close();
//     _fetchShippingAddressesCubit.close();
//     _submitCheckoutCubit.close();
//     super.dispose();
//   }

//   void _setDisabled() {
//     _month.forEach((month) {
//       if (month.id <= DateTime.now().month) {
//         setState(() {
//           month.isDisabled = true;
//         });
//       }
//     });
//   }

//   void _disabledRecipent() {
//     bool _sama = false;
//     _addresses.forEach((recipent) {
//       widget.cart.forEach((product) {
//         product.coverage.forEach((city) {
//           if (city.id == recipent.cityId) {
//             _sama = true;
//           }
//         });
//         setState(() {
//           recipent.isActive = _sama;
//         });
//         _sama = false;
//       });
//     });
//   }

//   _onSelectMonth(Month month) async {
//     // setSheetState(() {
//     //   _selectedMonth = month;
//     // });
//     setState(() {
//       _selectedMonth = month;
//       _showMonthDropDown = false;
//     });
//     await Future.delayed(Duration(milliseconds: 300));
//   }

//   void _handleAddAddress() async {
//     var isChanged = await AppExt.pushScreen(
//       context,
//       AddressEntryScreen(),
//     );
//     if (isChanged ?? false) {
//       _fetchShippingAddressesCubit.load();
//     }
//   }

//   _ValidationResult _validate() {
//     if (_selectedShippingOptId == null) {
//       return _ValidationResult(
//         isValid: false,
//         message: "Pilih kurir terlebih dahulu",
//       );
//     }
//     return _ValidationResult(isValid: true);
//   }

//   _launchUrl(String _url) async => await canLaunch(_url)
//       ? await launch(_url)
//       : BSFeedback.show(
//           context,
//           icon: Boxicons.bx_x_circle,
//           color: AppColor.red,
//           title: "Gagal mengakses halaman",
//           description: "Halaman atau koneksi internet bermasalah",
//         );

//   void _loadShippingOptions(
//       FetchShippingAddressesSuccess fetchShippingAddressesSuccessState) {
//     // product weight --> to be updated
//     final int totalWeight = widget.cart.fold(
//       0,
//       (previousValue, element) =>
//           previousValue + (element.weight * element.quantity),
//     );

//     _fetchShippingOptionsCubit.load(
//       totalWeight: totalWeight,
//       recipentId: fetchShippingAddressesSuccessState
//           .shippingAddresses[_selectedShippingAddressId].id,
//     );
//   }

//   void _setSelectedRecipent() {
//     int _activeIndex;
//     if (_addresses[_selectedShippingAddressId].isActive != true) {
//       _activeIndex = _addresses.indexWhere((element) => element.isActive);
//       if (_activeIndex == -1) {
//         setState(() {
//           _selectedShippingAddressId = null;
//         });
//       } else {
//         setState(() {
//           _selectedShippingAddressId = _activeIndex;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final config = AAppConfig.of(context);
//     final int totalItem = widget.cart.fold(
//       0,
//       (previousValue, element) => previousValue + element.quantity,
//     );
//     final int subtotalPrice = widget.cart.fold(
//       0,
//       (previousValue, element) =>
//           previousValue + (element.enduserPrice * element.quantity),
//     );

//     return MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => _fetchShippingOptionsCubit),
//           BlocProvider(create: (_) => _fetchShippingAddressesCubit),
//           BlocProvider(create: (_) => _submitCheckoutCubit),
//         ],
//         child: MultiBlocListener(
//             listeners: [
//               BlocListener(
//                 cubit: _fetchShippingAddressesCubit,
//                 listener: (_, state) async {
//                   // if (state is FetchShippingAddressesSuccess &&
//                   //     state.shippingAddresses.length > 0) {
//                   //   setState(() {
//                   //     _lastShippingAddressId =
//                   //         state.shippingAddresses.length - 1;
//                   //   });
//                   //   _loadShippingOptions(state);
//                   //   return;
//                   // }
//                   if (state is FetchShippingAddressesSuccess) {
//                     int _recipentIndex = await _recipentRepo
//                         .getRecipentIndex(state.shippingAddresses);
//                     setState(() {
//                       _selectedShippingAddressId = _recipentIndex;
//                       _addresses = state.shippingAddresses;
//                     });
//                     _disabledRecipent();
//                     _setSelectedRecipent();
//                     if (_selectedShippingAddressId != null) {
//                       _loadShippingOptions(state);
//                     }

//                     return;
//                   }

//                   if (state is FetchShippingAddressesFailure) {
//                     _scaffoldKey.currentState
//                       ..hideCurrentSnackBar()
//                       ..showSnackBar(
//                         SnackBar(
//                           duration: Duration(days: 365),
//                           action: SnackBarAction(
//                               textColor: AppColor.primaryLight2,
//                               label: "Retry",
//                               onPressed: () {
//                                 _fetchShippingAddressesCubit.load();
//                                 _scaffoldKey.currentState.hideCurrentSnackBar();
//                               }),
//                           content: Text('${state.message}'),
//                           backgroundColor: Colors.grey[900],
//                           behavior: SnackBarBehavior.floating,
//                         ),
//                       );
//                     return;
//                   }
//                 },
//               ),
//               BlocListener(
//                 cubit: _submitCheckoutCubit,
//                 listener: (_, state) async {
//                   if (state is SubmitCheckoutSuccess) {
//                     if (_paymentType == PaymentType.manual) {
//                       BlocProvider.of<HandleTransactionRouteWebCubit>(context)
//                           .changeCheckPaymentWeb(true);
//                       context.beamToNamed('/paymentweb/${state.orderId}');
//                       // showDialog(
//                       //     context: context,
//                       //     // useRootNavigator: false,
//                       //     barrierDismissible: false,
//                       //     builder: (BuildContext context) {
//                       //       return PaymentDialog(orderId: state.orderId);
//                       //     });
//                     } else {
//                       _addPaymentCubit.addPaymentMidtrans(
//                           orderId: state.orderId);
//                     }
//                     return;
//                   }

//                   if (state is SubmitCheckoutFailure) {
//                     // Navigator.pop(context);
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertFailureWeb(
//                               title: "Checkout Gagal",
//                               description: state.message,
//                               onPressClose: () {
//                                 AppExt.popScreen(context);
//                               });
//                         });
//                     return;
//                   }
//                 },
//               ),
              
//               BlocListener(
//                 cubit: _addPaymentCubit,
//                 listener: (_, state) async {
//                   if (state is AddPaymentMidtransSuccess) {
//                     _launchUrl(state.link);
//                     BlocProvider.of<HandleTransactionRouteWebCubit>(context)
//                         .changeCheckCheckout(false);
//                     context.beamBack();
//                     return;
//                   }
//                   if (state is AddPaymentFailure) {
//                     Navigator.pop(context);
//                     showDialog(
//                         context: context,
//                         // useRootNavigator: false,
//                         builder: (BuildContext context) {
//                           return AlertFailureWeb(
//                               title: "Pembayaran gagal",
//                               description: state.message,
//                               onPressClose: () {
//                                 AppExt.popScreen(context);
//                               });
//                         });
//                     return;
//                   }
//                 },
//               ),
//             ],
//             child: Center(
//               child: BlocBuilder(
//                   cubit: _submitCheckoutCubit,
//                   builder: (context, submitCheckoutState) => BlocBuilder(
//                       cubit: _fetchShippingAddressesCubit,
//                       builder: (context, fetchShippingAddressesState) =>
//                           BlocBuilder(
//                               cubit: _fetchShippingOptionsCubit,
//                               builder: (context, fetchShippingOptionsState) {
//                                 final int shippingPrice =
//                                     _selectedShippingOptId != null &&
//                                             fetchShippingOptionsState
//                                                 is FetchShippingOptionsSuccess
//                                         ? fetchShippingOptionsState
//                                             .data[_selectedShippingOptId].price
//                                         : 0;
//                                 return Scrollbar(
//                                   isAlwaysShown: true,
//                                   child: ListView(
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 180, vertical: 50),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               child: Padding(
//                                                 padding:
//                                                     EdgeInsets.only(right: 33),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Checkout",
//                                                         style:
//                                                             AppTypo.h2.copyWith(
//                                                           fontSize: 24,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                         )),
//                                                     SizedBox(
//                                                       height: 20,
//                                                     ),
//                                                     //======================== ADDRESS CONFIG ========================
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Text(
//                                                             "Alamat Pengiriman",
//                                                             style: AppTypo
//                                                                 .subtitle1
//                                                                 .copyWith(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700)),
//                                                         fetchShippingAddressesState
//                                                                 is FetchShippingAddressesSuccess
//                                                             ? RoundedButton
//                                                                 .outlined(
//                                                                 isSmall: true,
//                                                                 color: AppColor
//                                                                     .textSecondary2,
//                                                                 isUpperCase:
//                                                                     false,
//                                                                 label: fetchShippingAddressesState
//                                                                             .shippingAddresses
//                                                                             .length >
//                                                                         0
//                                                                     ? "Pilih Alamat Lain"
//                                                                     : "Tambah Alamat",
//                                                                 onPressed: fetchShippingAddressesState
//                                                                             .shippingAddresses
//                                                                             .length >
//                                                                         0
//                                                                     ? () {
//                                                                         _showShippingAddressesDialog(
//                                                                           addresses:
//                                                                               _addresses,
//                                                                           onSelected:
//                                                                               (id) {
//                                                                             setState(() {
//                                                                               _selectedShippingAddressId = id;
//                                                                               _selectedShippingOptId = null;
//                                                                             });
//                                                                             _loadShippingOptions(fetchShippingAddressesState);
//                                                                           },
//                                                                           lastSelectedId:
//                                                                               _selectedShippingAddressId,
//                                                                         );
//                                                                       }
//                                                                     : _handleAddAddress,
//                                                               )
//                                                             : RoundedButton.outlined(
//                                                                 isSmall: true,
//                                                                 color: AppColor
//                                                                     .textSecondary2,
//                                                                 isUpperCase:
//                                                                     false,
//                                                                 label:
//                                                                     "Tambah Alamat",
//                                                                 onPressed:
//                                                                     _handleAddAddress),
//                                                       ],
//                                                     ),
//                                                     SizedBox(
//                                                       height: 20,
//                                                     ),
//                                                     fetchShippingAddressesState
//                                                             is FetchShippingAddressesSuccess
//                                                         ? fetchShippingAddressesState
//                                                                         .shippingAddresses
//                                                                         .length >
//                                                                     0 &&
//                                                                 _selectedShippingAddressId !=
//                                                                     null
//                                                             ? BasicCard(
//                                                                 isBordered:
//                                                                     true,
//                                                                 child: Builder(
//                                                                   builder:
//                                                                       (context) {
//                                                                     final Recipent
//                                                                         latestAddress =
//                                                                         _addresses[
//                                                                             _selectedShippingAddressId];
//                                                                     return Padding(
//                                                                       padding: EdgeInsets.symmetric(
//                                                                           horizontal:
//                                                                               28,
//                                                                           vertical:
//                                                                               16),
//                                                                       child:
//                                                                           Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.stretch,
//                                                                         children: [
//                                                                           Text(
//                                                                             "${latestAddress.name}",
//                                                                             style:
//                                                                                 AppTypo.body1.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
//                                                                           ),
//                                                                           SizedBox(
//                                                                             height:
//                                                                                 15,
//                                                                           ),
//                                                                           Text(
//                                                                               "${latestAddress.address}, ${" Kec." + latestAddress.subdistrict}, ${latestAddress.city}, ${latestAddress.province}",
//                                                                               style: AppTypo.body1.copyWith(
//                                                                                 fontSize: 14,
//                                                                               )),
//                                                                           SizedBox(
//                                                                             height:
//                                                                                 15,
//                                                                           ),
//                                                                           Text(
//                                                                               "+${latestAddress.phone}",
//                                                                               style: AppTypo.body1.copyWith(
//                                                                                 fontSize: 14,
//                                                                               )),
//                                                                         ],
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                 ))
//                                                             : fetchShippingAddressesState
//                                                                             .shippingAddresses
//                                                                             .length >
//                                                                         0 &&
//                                                                     _selectedShippingAddressId ==
//                                                                         null
//                                                                 ? Center(
//                                                                     child:
//                                                                         Column(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: [
//                                                                         Icon(
//                                                                           FlutterIcons
//                                                                               .map_marker_plus_mco,
//                                                                           size:
//                                                                               45,
//                                                                           color:
//                                                                               AppColor.primary,
//                                                                         ),
//                                                                         SizedBox(
//                                                                           height:
//                                                                               10,
//                                                                         ),
//                                                                         Text(
//                                                                           "Produk tidak tersedia di wilayah anda",
//                                                                           style:
//                                                                               AppTypo.overlineAccent,
//                                                                           textAlign:
//                                                                               TextAlign.center,
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   )
//                                                                 : Center(
//                                                                     child:
//                                                                         Column(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: [
//                                                                         Icon(
//                                                                           FlutterIcons
//                                                                               .map_marker_plus_mco,
//                                                                           size:
//                                                                               45,
//                                                                           color:
//                                                                               AppColor.primary,
//                                                                         ),
//                                                                         SizedBox(
//                                                                           height:
//                                                                               10,
//                                                                         ),
//                                                                         Text(
//                                                                           "Alamat pengiriman anda kosong",
//                                                                           style:
//                                                                               AppTypo.overlineAccent,
//                                                                           textAlign:
//                                                                               TextAlign.center,
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   )
//                                                         : BasicCard(
//                                                             isBordered: true,
//                                                             child:
//                                                                 _ShimmerAddress(),
//                                                           ),
//                                                     Padding(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               vertical: 24),
//                                                       child: Divider(
//                                                         thickness: 1,
//                                                         color: AppColor
//                                                             .textSecondary2,
//                                                         // indent:3,endIndent:4,
//                                                       ),
//                                                     ),
//                                                     //======================== BOOKING DETAIL CONFIG ========================
//                                                     Text('Detail Pesanan',
//                                                         style: AppTypo.subtitle1
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700)),
//                                                     SizedBox(
//                                                       height: 15,
//                                                     ),
//                                                     ListView.separated(
//                                                       physics:
//                                                           NeverScrollableScrollPhysics(),
//                                                       shrinkWrap: true,
//                                                       itemCount:
//                                                           widget.cart.length,
//                                                       separatorBuilder:
//                                                           (_, index) {
//                                                         return SizedBox(
//                                                           height: 15,
//                                                         );
//                                                       },
//                                                       itemBuilder:
//                                                           (context, index) {
//                                                         CartProduct item =
//                                                             widget.cart[index];
//                                                         return CheckoutProductItem(
//                                                           isBuyNow:
//                                                               widget.isBuyNow,
//                                                           product: item,
//                                                           onUpdate:
//                                                               (qty, price) {
//                                                             setState(() {
//                                                               widget.cart[index]
//                                                                       .quantity =
//                                                                   qty;
//                                                               widget.cart[index]
//                                                                       .enduserPrice =
//                                                                   price;
//                                                               // widget.cart[index].prediction.monthId. = 1
//                                                             });
//                                                           },
//                                                           scaffoldKey:
//                                                               _scaffoldKey,
//                                                         );
//                                                       },
//                                                     ),
//                                                     SizedBox(
//                                                       height: 20,
//                                                     ),
//                                                     //======================== BULAN KETERSEDIAAN (PREDICTION) ========================
//                                                     widget.isPrediction
//                                                         ? Row(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                         "Bulan ketersediaan",
//                                                                         style: AppTypo
//                                                                             .body1
//                                                                             .copyWith(
//                                                                           fontSize:
//                                                                               14,
//                                                                           fontWeight:
//                                                                               FontWeight.w700,
//                                                                         )),
//                                                                     SizedBox(
//                                                                       height:
//                                                                           15,
//                                                                     ),
//                                                                     Container(
//                                                                       decoration:
//                                                                           BoxDecoration(
//                                                                         border: Border.all(
//                                                                             color:
//                                                                                 AppColor.grey,
//                                                                             width: 1),
//                                                                         borderRadius:
//                                                                             BorderRadius.circular(7.5),
//                                                                       ),
//                                                                       child:
//                                                                           ListTile(
//                                                                         onTap:
//                                                                             () {
//                                                                           setState(
//                                                                               () {
//                                                                             _showMonthDropDown == true
//                                                                                 ? _showMonthDropDown = false
//                                                                                 : _showMonthDropDown = true;
//                                                                           });
//                                                                         },
//                                                                         shape:
//                                                                             RoundedRectangleBorder(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(7.5),
//                                                                         ),
//                                                                         title:
//                                                                             Text(
//                                                                           "${DateFormat('MMMM', 'ID').format(DateTime(DateTime.now().year, _selectedMonth.id, 1))}",
//                                                                           style: AppTypo
//                                                                               .body1v2
//                                                                               .copyWith(
//                                                                             fontWeight:
//                                                                                 FontWeight.w700,
//                                                                           ),
//                                                                           overflow:
//                                                                               TextOverflow.ellipsis,
//                                                                           maxLines: kIsWeb? null :
//                                                                               1,
//                                                                         ),
//                                                                         trailing:
//                                                                             Icon(
//                                                                           FlutterIcons
//                                                                               .ios_arrow_down_ion,
//                                                                           color:
//                                                                               AppColor.black,
//                                                                           size:
//                                                                               26,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     _showMonthDropDown ==
//                                                                             true
//                                                                         ? Container(
//                                                                             // color: Colors
//                                                                             //     .amber,
//                                                                             child:
//                                                                                 ListView.separated(
//                                                                             padding:
//                                                                                 EdgeInsets.symmetric(horizontal: 20),
//                                                                             separatorBuilder:
//                                                                                 (_, __) {
//                                                                               return SizedBox(
//                                                                                 height: 8,
//                                                                               );
//                                                                             },
//                                                                             shrinkWrap:
//                                                                                 true,
//                                                                             itemCount:
//                                                                                 12,
//                                                                             itemBuilder:
//                                                                                 (context, index) {
//                                                                               Month item = _month[index];
//                                                                               return Container(
//                                                                                 decoration: BoxDecoration(
//                                                                                   color: item == _selectedMonth ? Color(0xFFD6FFBC) : Colors.transparent,
//                                                                                   borderRadius: BorderRadius.circular(5),
//                                                                                 ),
//                                                                                 child: InkWell(
//                                                                                     borderRadius: BorderRadius.circular(5),
//                                                                                     onTap: item.isDisabled ? null : () => _onSelectMonth(item),
//                                                                                     child: Padding(
//                                                                                       padding: EdgeInsets.all(8),
//                                                                                       child: Text("${item.name}", style: item.isDisabled ? AppTypo.subtitle2.copyWith(fontWeight: FontWeight.w400, color: AppColor.grey) : AppTypo.subtitle2.copyWith(fontWeight: FontWeight.w400, color: item == _selectedMonth ? AppColor.primary : AppColor.textPrimary)),
//                                                                                     )),
//                                                                               );
//                                                                             },
//                                                                           ))
//                                                                         : SizedBox()
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                   width: 25),
//                                                               Expanded(
//                                                                   child: Column(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   Padding(
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                             left:
//                                                                                 12),
//                                                                     child: Text(
//                                                                         "Jumlah",
//                                                                         style: AppTypo
//                                                                             .body1
//                                                                             .copyWith(
//                                                                           fontSize:
//                                                                               14,
//                                                                           fontWeight:
//                                                                               FontWeight.w700,
//                                                                         )),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     height: 27,
//                                                                   ),
//                                                                   CheckoutProductItem(
//                                                                     onlyQtyCounter:
//                                                                         true,
//                                                                     product: widget
//                                                                         .cart[0],
//                                                                     onUpdate: (qty,
//                                                                         price) {
//                                                                       setState(
//                                                                           () {
//                                                                         widget
//                                                                             .cart[0]
//                                                                             .quantity = qty;
//                                                                         widget
//                                                                             .cart[0]
//                                                                             .enduserPrice = price;
//                                                                         // widget.cart[index].prediction.monthId. = 1
//                                                                       });
//                                                                     },
//                                                                     scaffoldKey:
//                                                                         _scaffoldKey,
//                                                                   ),
//                                                                 ],
//                                                               ))
//                                                             ],
//                                                           )
//                                                         : SizedBox(),
//                                                     widget.isPrediction
//                                                         ? _prediction != null
//                                                             ? Text(
//                                                                 "${_prediction.prediction - _prediction.countBooked} ${widget.cart[0].unit} produk tersisa",
//                                                                 style: AppTypo
//                                                                     .body1
//                                                                     .copyWith(
//                                                                         fontSize:
//                                                                             14,
//                                                                         color: AppColor
//                                                                             .grey),
//                                                               )
//                                                             : Text(
//                                                                 "Prediksi pada bulan ini kosong",
//                                                                 style: AppTypo
//                                                                     .body1
//                                                                     .copyWith(
//                                                                         fontSize:
//                                                                             14,
//                                                                         color: AppColor
//                                                                             .grey))
//                                                         : SizedBox(),
//                                                     SizedBox(
//                                                       height:
//                                                           !widget.isPrediction
//                                                               ? 5
//                                                               : 24,
//                                                     ),
//                                                     Text("Catatan (opsional)",
//                                                         style: AppTypo.caption
//                                                             .copyWith(
//                                                                 fontSize: 12)),
//                                                     SizedBox(
//                                                       height: 15,
//                                                     ),
//                                                     EditText(
//                                                         fillColor:
//                                                             Color(0xFFF5F5F5),
//                                                         textStyle: AppTypo
//                                                             .caption
//                                                             .copyWith(
//                                                                 fontSize: 12),
//                                                         hintText:
//                                                             "Tambahkan catatan khusus",
//                                                         inputType:
//                                                             InputType.field),

//                                                     Padding(
//                                                         padding:
//                                                             EdgeInsets
//                                                                 .symmetric(
//                                                                     vertical:
//                                                                         17),
//                                                         child: Divider(
//                                                                 thickness: 1,
//                                                                 color: AppColor
//                                                                     .textSecondary2,
//                                                                 // indent:3,endIndent:4,
//                                                               )),
//                                                     //======================= COURIER CONFIG ========================
//                                                     !widget.isPrediction
//                                                         ? Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .stretch,
//                                                             children: [
//                                                               Text(
//                                                                 'Kurir Pengiriman',
//                                                                 style: AppTypo
//                                                                     .subtitle1
//                                                                     .copyWith(
//                                                                         fontWeight:
//                                                                             FontWeight.w700),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 15,
//                                                               ),
//                                                               Stack(
//                                                                 children: [
//                                                                   Container(
//                                                                       decoration:
//                                                                           BoxDecoration(
//                                                                         border: Border.all(
//                                                                             color:
//                                                                                 AppColor.line,
//                                                                             width: 1),
//                                                                         borderRadius:
//                                                                             BorderRadius.circular(7.5),
//                                                                       ),
//                                                                       child:
//                                                                           ListTile(
//                                                                         onTap: fetchShippingOptionsState
//                                                                                 is FetchShippingOptionsSuccess
//                                                                             ? () =>
//                                                                                 _showCourierChoicesWeb(context, items: fetchShippingOptionsState.data, onSelected: (id) {
//                                                                                   setState(() {
//                                                                                     _selectedShippingOptId = id;
//                                                                                   });
//                                                                                 })
//                                                                             : null,
//                                                                         shape:
//                                                                             RoundedRectangleBorder(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(7.5),
//                                                                         ),
//                                                                         title:
//                                                                             Text(
//                                                                           _selectedShippingOptId != null && fetchShippingOptionsState is FetchShippingOptionsSuccess
//                                                                               ? "${fetchShippingOptionsState.data[_selectedShippingOptId].name}"
//                                                                               : "Pilih Kurir",
//                                                                           style: AppTypo
//                                                                               .body2
//                                                                               .copyWith(
//                                                                             fontWeight: _selectedShippingOptId == null
//                                                                                 ? FontWeight.w500
//                                                                                 : FontWeight.w700,
//                                                                           ),
//                                                                           overflow:
//                                                                               TextOverflow.ellipsis,
//                                                                           maxLines: kIsWeb? null :
//                                                                               1,
//                                                                         ),
//                                                                         subtitle: _selectedShippingOptId != null &&
//                                                                                 fetchShippingOptionsState is FetchShippingOptionsSuccess
//                                                                             ? Text(
//                                                                                 "${fetchShippingOptionsState.data[_selectedShippingOptId].etd}",
//                                                                                 style: AppTypo.overlineAccent,
//                                                                               )
//                                                                             : null,
//                                                                         trailing:
//                                                                             Row(
//                                                                           crossAxisAlignment:
//                                                                               CrossAxisAlignment.center,
//                                                                           mainAxisSize:
//                                                                               MainAxisSize.min,
//                                                                           children: [
//                                                                             _selectedShippingOptId != null && fetchShippingOptionsState is FetchShippingOptionsSuccess
//                                                                                 ? Text(
//                                                                                     "Rp ${AppExt.toRupiah(fetchShippingOptionsState.data[_selectedShippingOptId].price)}",
//                                                                                   )
//                                                                                 : SizedBox.shrink(),
//                                                                             Icon(Icons.chevron_right),
//                                                                           ],
//                                                                         ),
//                                                                       )),
//                                                                   Positioned
//                                                                       .fill(
//                                                                     child: fetchShippingOptionsState
//                                                                             is FetchShippingOptionsSuccess
//                                                                         ? SizedBox
//                                                                             .shrink()
//                                                                         : Material(
//                                                                             color:
//                                                                                 AppColor.navScaffoldBg.withOpacity(0.6),
//                                                                           ),
//                                                                   ),
//                                                                   fetchShippingOptionsState
//                                                                           is FetchShippingOptionsLoading
//                                                                       ? Positioned
//                                                                           .fill(
//                                                                           child:
//                                                                               Center(
//                                                                             child: SizedBox(
//                                                                                 height: 25,
//                                                                                 width: 25,
//                                                                                 child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColor.primary))),
//                                                                           ),
//                                                                         )
//                                                                       : SizedBox
//                                                                           .shrink()
//                                                                 ],
//                                                               ),
//                                                               Padding(
//                                                                 padding: EdgeInsets
//                                                                     .symmetric(
//                                                                         vertical:
//                                                                             17),
//                                                                 child: Divider(
//                                                                   thickness: 1,
//                                                                   color: AppColor
//                                                                       .textSecondary2,
//                                                                   // indent:3,endIndent:4,
//                                                                 ),
//                                                               ),
//                                                               //======================== PAYMENT METHOD CONFIG ========================
//                                                               Text(
//                                                                 'Metode Verifikasi Pembayaran',
//                                                                 style: AppTypo
//                                                                     .subtitle1
//                                                                     .copyWith(
//                                                                         fontWeight:
//                                                                             FontWeight.w700),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 16,
//                                                               ),
//                                                               Row(
//                                                                 children: [
//                                                                   Expanded(
//                                                                     flex: 1,
//                                                                     child:
//                                                                         InkWell(
//                                                                       onTap: () =>
//                                                                           setState(
//                                                                               () {
//                                                                         _paymentType =
//                                                                             PaymentType.manual;
//                                                                       }),
//                                                                       child:
//                                                                           BasicCard(
//                                                                         isBordered:
//                                                                             true,
//                                                                         color: _paymentType ==
//                                                                                 PaymentType.manual
//                                                                             ? AppColor.primary
//                                                                             : Colors.white,
//                                                                         child:
//                                                                             Padding(
//                                                                           padding: EdgeInsets.symmetric(
//                                                                               vertical: 20,
//                                                                               horizontal: 30),
//                                                                           child:
//                                                                               Center(
//                                                                             child:
//                                                                                 Text('Manual', style: AppTypo.body1.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: Color(_paymentType == PaymentType.manual ? 0xFFFFFFFF : 0xFF777C7E))),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   // SizedBox(
//                                                                   //   width: 24,
//                                                                   // ),
//                                                                   // Expanded(
//                                                                   //   flex: 1,
//                                                                   //   child:
//                                                                   //       InkWell(
//                                                                   //     onTap: () =>
//                                                                   //         setState(
//                                                                   //             () {
//                                                                   //       _paymentType =
//                                                                   //           PaymentType.otomatis;
//                                                                   //     }),
//                                                                   //     child:
//                                                                   //         BasicCard(
//                                                                   //       isBordered:
//                                                                   //           true,
//                                                                   //       color: _paymentType ==
//                                                                   //               PaymentType.otomatis
//                                                                   //           ? AppColor.primary
//                                                                   //           : Colors.white,
//                                                                   //       child:
//                                                                   //           Padding(
//                                                                   //         padding: EdgeInsets.symmetric(
//                                                                   //             vertical: 20,
//                                                                   //             horizontal: 30),
//                                                                   //         child:
//                                                                   //             Center(
//                                                                   //           child:
//                                                                   //               Text('Otomatis', style: AppTypo.body1.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: Color(_paymentType == PaymentType.otomatis ? 0xFFFFFFFF : 0xFF777C7E))),
//                                                                   //         ),
//                                                                   //       ),
//                                                                   //     ),
//                                                                   //   ),
//                                                                   // ),
//                                                                   Expanded(
//                                                                     flex: 2,
//                                                                     child:
//                                                                         SizedBox(),
//                                                                   )
//                                                                 ],
//                                                               )
//                                                             ],
//                                                           )
//                                                         : SizedBox.shrink(),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             if (!widget.isPrediction)
//                                               Expanded(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       top: 20, left: 33),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       BasicCard(
//                                                           child: Padding(
//                                                         padding:
//                                                             EdgeInsets.all(20),
//                                                         child: Builder(
//                                                           builder: (context) {
//                                                             int totalPembayaran;

//                                                             List<Widget>
//                                                                 priceList = [];

//                                                             // ichc
//                                                             if (false) {
//                                                               int subtotal =
//                                                                   subtotalPrice;
//                                                               int pengirimanGudang =
//                                                                   30000;
//                                                               int pajakNegara =
//                                                                   40000;
//                                                               int hargaAsli =
//                                                                   subtotal +
//                                                                       pengirimanGudang +
//                                                                       pajakNegara;

//                                                               int beaMasuk =
//                                                                   100000;
//                                                               int ppn = 50000;
//                                                               int pph = 50000;
//                                                               int pajakImpor =
//                                                                   beaMasuk +
//                                                                       ppn +
//                                                                       pph;

//                                                               int pengirimanIntl =
//                                                                   120000;

//                                                               totalPembayaran =
//                                                                   hargaAsli +
//                                                                       pajakImpor +
//                                                                       pengirimanIntl;

//                                                               priceList = [
//                                                                 _buildPriceItem(
//                                                                   label:
//                                                                       "Harga asli",
//                                                                   price:
//                                                                       hargaAsli,
//                                                                   isSection:
//                                                                       true,
//                                                                 ),
//                                                                 _buildPriceItem(
//                                                                   label:
//                                                                       "Subtotal ( $totalItem item )",
//                                                                   price:
//                                                                       subtotal,
//                                                                 ),
//                                                                 _buildPriceItem(
//                                                                     label:
//                                                                         "Pengiriman ke gudang",
//                                                                     price:
//                                                                         pengirimanGudang),
//                                                                 _buildPriceItem(
//                                                                     label:
//                                                                         "Pajak negara asal (8,75%)",
//                                                                     price:
//                                                                         pajakNegara),
//                                                                 _buildPriceItem(
//                                                                     label:
//                                                                         "Pajak impor",
//                                                                     price:
//                                                                         pajakImpor,
//                                                                     isSection:
//                                                                         true),
//                                                                 _buildPriceItem(
//                                                                     label:
//                                                                         "Bea masuk(7,5%)",
//                                                                     price:
//                                                                         beaMasuk),
//                                                                 _buildPriceItem(
//                                                                     label:
//                                                                         "PPn(10%)",
//                                                                     price: ppn),
//                                                                 _buildPriceItem(
//                                                                     label:
//                                                                         "PPh(0%)",
//                                                                     price: pph),
//                                                                 _buildPriceItem(
//                                                                     label:
//                                                                         "Pengiriman internasional",
//                                                                     price:
//                                                                         pengirimanIntl,
//                                                                     isBoldPrice:
//                                                                         true),
//                                                               ];
//                                                             }
//                                                             // panen2 & sumedang
//                                                             else {
//                                                               totalPembayaran =
//                                                                   subtotalPrice +
//                                                                       shippingPrice;

//                                                               priceList = [
//                                                                 _buildPriceItem(
//                                                                   label:
//                                                                       "Subtotal ( $totalItem item )",
//                                                                   price:
//                                                                       subtotalPrice,
//                                                                 ),
//                                                                 _buildPriceItem(
//                                                                     label:
//                                                                         "Ongkos Kirim",
//                                                                     price: _selectedShippingOptId !=
//                                                                                 null &&
//                                                                             fetchShippingOptionsState
//                                                                                 is FetchShippingOptionsSuccess
//                                                                         ? fetchShippingOptionsState
//                                                                             .data[_selectedShippingOptId]
//                                                                             .price
//                                                                         : null),
//                                                               ];
//                                                             }

//                                                             return Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   "Ringkasan Pembayaran",
//                                                                   style: AppTypo
//                                                                       .subtitle1
//                                                                       .copyWith(
//                                                                           fontWeight:
//                                                                               FontWeight.w700),
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 23,
//                                                                 ),
//                                                                 for (var priceItem
//                                                                     in priceList) ...[
//                                                                   priceItem,
//                                                                   SizedBox(
//                                                                     height: 7,
//                                                                   ),
//                                                                 ],
//                                                                 Divider(
//                                                                   thickness: 1,
//                                                                   color: AppColor
//                                                                       .textSecondary2,
//                                                                   // indent:3,endIndent:4,
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 12,
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//                                                                     Text(
//                                                                         "Total Pembayaran",
//                                                                         style: AppTypo
//                                                                             .subtitle1
//                                                                             .copyWith(fontWeight: FontWeight.w700)),
//                                                                     SizedBox(
//                                                                       width: 20,
//                                                                     ),
//                                                                     Expanded(
//                                                                       child:
//                                                                           Builder(
//                                                                         builder:
//                                                                             (context) {
//                                                                           return Text(
//                                                                             "Rp ${AppExt.toRupiah(totalPembayaran)}",
//                                                                             textAlign:
//                                                                                 TextAlign.right,
//                                                                             style:
//                                                                                 AppTypo.subtitle1.copyWith(color: AppColor.primary, fontWeight: FontWeight.w700),
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                             maxLines: kIsWeb? null :
//                                                                                 1,
//                                                                           );
//                                                                         },
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 32,
//                                                                 ),
//                                                                 //         widget.isPrediction
//                                                                 // ? RoundedButton.contained(
//                                                                 //     disabled: widget.cart[0]
//                                                                 //             .quantity <=
//                                                                 //         0,
//                                                                 //     label: "Booking",
//                                                                 //     isUpperCase: false,
//                                                                 //     onPressed: () {
//                                                                 //       LoadingDialog.show(
//                                                                 //           context);
//                                                                 //       _addBookingCubit
//                                                                 //           .addBooking(
//                                                                 //               predictionId:
//                                                                 //                   widget
//                                                                 //                       .cart[0]
//                                                                 //                       .prediction
//                                                                 //                       .id,
//                                                                 //               quantity: widget
//                                                                 //                   .cart[0]
//                                                                 //                   .quantity);
//                                                                 //     })
//                                                                 // :
//                                                                 Theme(
//                                                                   data: ThemeData(
//                                                                       shadowColor:
//                                                                           Colors
//                                                                               .black38,
//                                                                       splashColor:
//                                                                           AppColor
//                                                                               .primary),
//                                                                   child: RoundedButton
//                                                                       .contained(
//                                                                     disabled: (_selectedShippingAddressId ==
//                                                                             null) ||
//                                                                         (fetchShippingAddressesState
//                                                                             is FetchShippingAddressesLoading),
//                                                                     label:
//                                                                         "Pembayaran",
//                                                                     isCompact:
//                                                                         true,
//                                                                     color: AppColor
//                                                                         .primary,
//                                                                     textColor:
//                                                                         Colors
//                                                                             .white,
//                                                                     isUpperCase:
//                                                                         false,
//                                                                     elevation:
//                                                                         6,
//                                                                     onPressed: fetchShippingAddressesState
//                                                                             is FetchShippingAddressesSuccess
//                                                                         ? () {
//                                                                             var validation =
//                                                                                 _validate();
//                                                                             if (!validation.isValid) {
//                                                                               showDialog(
//                                                                                   context: context,
//                                                                                   builder: (BuildContext context) {
//                                                                                     return AlertFailureWeb(
//                                                                                         title: "Pembayaran gagal",
//                                                                                         description: validation.message,
//                                                                                         onPressClose: () {
//                                                                                           AppExt.popScreen(context);
//                                                                                         });
//                                                                                   });
//                                                                               return;
//                                                                             }
//                                                                             // context.beamToNamed('/paymentweb/197');

//                                                                             if (fetchShippingOptionsState
//                                                                                 is FetchShippingOptionsSuccess) {
//                                                                               LoadingDialog.show(context);
//                                                                               if (widget.isBuyNow) {
//                                                                                 _submitCheckoutCubit.checkoutBuyNow(
//                                                                                   sellerId: widget.sellerId,
//                                                                                   shippingAddressId: _addresses[_selectedShippingAddressId].id,
//                                                                                   shippingCost: shippingPrice,
//                                                                                   serviceCode: fetchShippingOptionsState.data[_selectedShippingOptId].name,
//                                                                                   productId: widget.cart[0].id,
//                                                                                   quantity: widget.cart[0].quantity,
//                                                                                 );
//                                                                               } else {
//                                                                                 _submitCheckoutCubit.checkout(
//                                                                                   sellerId: widget.sellerId,
//                                                                                   shippingAddressId: _addresses[_selectedShippingAddressId].id,
//                                                                                   shippingCost: shippingPrice,
//                                                                                   serviceCode: fetchShippingOptionsState.data[_selectedShippingOptId].name,
//                                                                                   userId: BlocProvider.of<UserDataCubit>(context).state.user.id,
//                                                                                 );
//                                                                               }
//                                                                             }
//                                                                           }
//                                                                         : null,
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             );
//                                                           },
//                                                         ),
//                                                       ))
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                           ],
//                                         ),
//                                       ),
//                                       FooterWeb()
//                                     ],
//                                   ),
//                                 );
//                               }))),
//             )));
//   }

//   Widget _buildPriceItem({
//     @required String label,
//     @required int price,
//     bool isBoldPrice = false,
//     bool isSection = false,
//   }) {
//     return Row(
//       children: [
//         Text(label,
//             style: AppTypo.subtitle2
//                 .copyWith(color: AppColor.grey, fontWeight: FontWeight.w400)),
//         SizedBox(
//           width: 20,
//         ),
//         Expanded(
//           child: Text(
//             price == null ? "-" : "Rp ${AppExt.toRupiah(price)}",
//             textAlign: TextAlign.right,
//             style: AppTypo.subtitle2.copyWith(
//                 fontWeight: isSection || isBoldPrice
//                     ? FontWeight.w700
//                     : FontWeight.w400),
//             overflow: TextOverflow.ellipsis,
//             maxLines: kIsWeb? null : 1,
//           ),
//         ),
//         if (isSection) ...[
//           SizedBox(
//             width: 5,
//           ),
//           Icon(
//             Icons.keyboard_arrow_down_outlined,
//             color: AppColor.grey,
//             size: 27,
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildAddressesItem({
//     BuildContext context,
//     @required Recipent address,
//     @required void Function() onTap,
//     @required bool isActive,
//     @required bool isDisabled,
//   }) {
//     final double _screenWidth = MediaQuery.of(context).size.width;

//     return BasicCard(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 25),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 4,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     "${address.name}",
//                     style: AppTypo.body1.copyWith(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: isDisabled
//                             ? AppColor.textSecondary
//                             : AppColor.textPrimary),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "+${address.phone}",
//                     style: AppTypo.body1.copyWith(
//                         fontSize: 14,
//                         color: isDisabled
//                             ? AppColor.textSecondary
//                             : AppColor.textPrimary),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "${address.address}, ${" Kec." + address.subdistrict}, ${address.city}, ${address.province}",
//                     style: AppTypo.body1.copyWith(
//                         fontSize: 14,
//                         color: isDisabled
//                             ? AppColor.textSecondary
//                             : AppColor.textPrimary),
//                   ),
//                 ],
//               ),
//             ),
//             isActive ?
//             Expanded(
//               child: Icon(
//                 FlutterIcons.check_ant,
//                 color:isDisabled ? AppColor.textSecondary : AppColor.primary,
//                 size: 20,
//               ),
//             ):
//             Expanded(
//               child: RoundedButton.contained(
//                 label: "Pilih", 
//                 isSmall: true,
//                 disabled: isDisabled,
//                 isUpperCase: false,
//                 onPressed: onTap
//               ),
//             )
//             // Icon(
//             //   isActive
//             //       ? FlutterIcons.check_circle_mco
//             //       : FlutterIcons.checkbox_blank_circle_outline_mco,
//             //   color: isDisabled ? AppColor.textSecondary : AppColor.primary,
//             //   size: 35,
//             // ),
//             // SizedBox(
//             //   height: 15,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCourierChoicesWeb(
//     context, {
//     @required void Function(int id) onSelected,
//     @required List<ShippingOptionItem> items,
//   }) {
//     // final double _screenWidth = MediaQuery.of(context).size.width;
//     // final double _screenHeight = MediaQuery.of(context).size.height;
//     // final double _statusHeight = MediaQuery.of(context).padding.top;
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return DialogWeb(
//             onPressedClose: () {
//               AppExt.popScreen(context);
//             },
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Container(
//                 // height: 400,
//                 child: Scrollbar(
//                   isAlwaysShown: true,
//                   child: ListView.separated(
//                       physics: ScrollPhysics(),
//                       shrinkWrap: true,
//                       // padding: EdgeInsets.symmetric(
//                       //     horizontal: 10),
//                       itemBuilder: (context, index) {
//                         ShippingOptionItem item = items[index];
//                         return ListTile(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           title: Text(
//                             "${item.name}",
//                             style: AppTypo.body2
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           ),
//                           subtitle: Text(
//                               "Rp ${AppExt.toRupiah(item.price)} (${item.etd})",
//                               style: AppTypo.overline),
//                           trailing: _selectedShippingOptId == index
//                               ? Icon(FlutterIcons.check_mco)
//                               : null,
//                           onTap: () {
//                             onSelected(index);
//                             Navigator.pop(context);
//                           },
//                           // visualDensity: VisualDensity.compact,
//                         );
//                       },
//                       separatorBuilder: (_, index) {
//                         return Divider(
//                           height: 0.5,
//                           thickness: 0.5,
//                           color: Colors.grey[300],
//                         );
//                       },
//                       itemCount: items.length),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   void _showShippingAddressesDialog({
//     @required int lastSelectedId,
//     @required List<Recipent> addresses,
//     @required void Function(int id) onSelected,
//   }) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return DialogWeb(
//           width: 700,
//           onPressedClose: () {
//             AppExt.popScreen(context);
//           },
//           child: SingleChildScrollView(
//             physics: new BouncingScrollPhysics(),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                         'Dimana lokasi anda saat ini?',
//                         style: AppTypo.subtitle1
//                             .copyWith(fontWeight: FontWeight.w700),
//                       ),
//                   SizedBox(height: 6,),
//                   Text(
//                         'Agar kami bisa merekomendasikan produk yang sesuai, pilih alamat terlebih dahulu',
//                         style: AppTypo.caption.copyWith(fontSize: 12)
//                       ),
//                   SizedBox(height: 20),
//                   addresses.length > 0
//                       ? ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: addresses.length,
//                           separatorBuilder: (context, index) => SizedBox(
//                             height: 15,
//                           ),
//                           itemBuilder: (context, index) {
//                             return _buildAddressesItem(
//                               context: context,
//                               isActive: index == lastSelectedId,
//                               isDisabled: !addresses[index].isActive,
//                               address: addresses[index],
//                               onTap: () {
//                                 onSelected(index);
//                                 Navigator.pop(context);
//                               },
//                             );
//                           },
//                         )
//                       : Center(
//                           child: Text("Alamat kosong",
//                               style: AppTypo.body1v2Accent)),
//                   SizedBox(height: 30),
//                   RoundedButton.contained(
//                     isCompact: true,
//                     label: "Tambah Alamat Baru",
//                     onPressed: () {
//                       AppExt.popScreen(context);
//                       _handleAddAddress();
//                     },
//                     isUpperCase: false,
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class CheckoutProductItem extends StatefulWidget {
//   final CartProduct product;
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   final void Function(int, int) onUpdate;
//   final bool isBuyNow;
//   final bool onlyQtyCounter;

//   const CheckoutProductItem({
//     Key key,
//     @required this.product,
//     @required this.scaffoldKey,
//     @required this.onUpdate,
//     this.isBuyNow,
//     this.onlyQtyCounter = false,
//   }) : super(key: key);

//   @override
//   _CheckoutProductItemState createState() => _CheckoutProductItemState();
// }

// class _CheckoutProductItemState extends State<CheckoutProductItem> {
//   TextEditingController _quantityController;

//   @override
//   void initState() {
//     super.initState();
//     _quantityController =
//         TextEditingController(text: "${widget.product.quantity}");
//     _initPrice();
//   }

//   _initPrice() async {
//     int _price = await _wholesalePrice(widget.product.quantity);
//     widget.onUpdate(widget.product.quantity, _price);
//   }

//   _wholesalePrice(int _quantity) {
//     if (widget.product.wholesale.length > 0) {
//       int resultPrice;
//       for (var i = widget.product.wholesale.length - 1; i >= 0; i--) {
//         if (_quantity >= widget.product.wholesale[i].from &&
//             _quantity <= widget.product.wholesale[i].to) {
//           return resultPrice = widget.product.wholesale[i].wholesalePrice;
//         }
//         resultPrice = widget.product.initialPrice;
//       }
//       return resultPrice;
//     } else {
//       return widget.product.initialPrice;
//     }
//   }

//   _onQuantityChange(String value, int max) async {
//     try {
//       if (int.parse(value) <= 0 && widget.product.stock > 0) {
//         widget.scaffoldKey.currentState.showSnackBar(
//           new SnackBar(
//             content: new Text(
//               "Jumlah minimal 1",
//             ),
//             duration: Duration(seconds: 1),
//           ),
//         );
//         int _price = await _wholesalePrice(1);
//         widget.onUpdate(1, _price);
//         return;
//       } else if (int.parse(value) > max) {
//         widget.scaffoldKey.currentState.hideCurrentSnackBar();
//         ErrorDialog.show(
//             context: context,
//             type: ErrorType.general,
//             message: "Stok ${widget.product.name} tersisa $max",
//             onTry: () {},
//             onBack: () {
//               AppExt.popScreen(context);
//             });
//         int _price = await _wholesalePrice(max);
//         widget.onUpdate(max, _price);
//         return;
//       }
//       int _price = await _wholesalePrice(int.parse(value));
//       widget.onUpdate(int.parse(value), _price);
//     } catch (e) {
//       widget.scaffoldKey.currentState.showSnackBar(
//         new SnackBar(
//           content: new Text(
//             "Jumlah tidak valid",
//           ),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }
//   }

//   void _onPlus() async {
//     try {
//       setState(() {
//         _quantityController.text = "${widget.product.quantity + 1}";
//         _quantityController.selection = TextSelection.fromPosition(
//             TextPosition(offset: _quantityController.text.length));
//       });
//       int _price = await _wholesalePrice(widget.product.quantity + 1);
//       widget.onUpdate(widget.product.quantity + 1, _price);
//     } catch (e) {
//       widget.scaffoldKey.currentState.showSnackBar(
//         new SnackBar(
//           content: new Text(
//             "Jumlah tidak valid",
//           ),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }
//   }

//   void _onMin() async {
//     try {
//       setState(() {
//         _quantityController.text = "${widget.product.quantity - 1}";
//         _quantityController.selection = TextSelection.fromPosition(
//             TextPosition(offset: _quantityController.text.length));
//       });
//       int _price = await _wholesalePrice(widget.product.quantity - 1);
//       widget.onUpdate(widget.product.quantity - 1, _price);
//     } catch (e) {
//       widget.scaffoldKey.currentState.showSnackBar(
//         new SnackBar(
//           content: new Text(
//             "Jumlah tidak valid",
//           ),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _quantityController.text = "${widget.product.quantity}" ?? '';
//       _quantityController.selection = TextSelection.fromPosition(
//           TextPosition(offset: _quantityController.text.length));
//     });

//     Widget quantityCounter(
//       int stock,
//     ) {
//       return Row(children: [
//         Material(
//           color: Colors.transparent,
//           child: IconButton(
//             disabledColor: AppColor.primary.withOpacity(0.3),
//             icon: Icon(FlutterIcons.minus_circle_outline_mco),
//             onPressed: widget.product.quantity > 1 ? _onMin : null,
//             color: AppColor.primary,
//             iconSize: 30,
//             splashRadius: 18,
//           ),
//         ),
//         Container(
//           constraints: BoxConstraints(maxWidth: 60),
//           child: IntrinsicWidth(
//             child: TextFormField(
//               onChanged: (value) => _onQuantityChange(value, stock),
//               controller: _quantityController,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 counter: SizedBox.shrink(),
//                 isDense: true,
//                 contentPadding: EdgeInsets.only(
//                   bottom: 2,
//                 ),
//               ),
//               style: AppTypo.subtitle2.copyWith(
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ),
//         Material(
//           color: Colors.transparent,
//           child: IconButton(
//             disabledColor: AppColor.primary.withOpacity(0.3),
//             icon: Icon(FlutterIcons.plus_circle_outline_mco),
//             onPressed: stock > widget.product.quantity ? _onPlus : null,
//             color: AppColor.primary,
//             iconSize: 30,
//             splashRadius: 18,
//           ),
//         ),
//       ]);
//     }

//     return widget.onlyQtyCounter == true
//         ? quantityCounter(widget.product.prediction.prediction -
//             widget.product.prediction.countBooked)
//         : Table(
//             columnWidths: {
//               0: IntrinsicColumnWidth(),
//               1: IntrinsicColumnWidth(),
//               2: FlexColumnWidth(),
//               3: IntrinsicColumnWidth(),
//             },
//             defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//             children: [
//               TableRow(
//                 children: [
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image(
//                         image: NetworkImage(
//                           "${AppConst.STORAGE_URL}/products/${widget.product.productPhoto}",
//                         ),
//                         width: 71,
//                         height: 53,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, object, stack) => Image.asset(
//                           AppImg.img_error,
//                           width: 71,
//                           height: 53,
//                         ),
//                         frameBuilder:
//                             (context, child, frame, wasSynchronouslyLoaded) {
//                           if (wasSynchronouslyLoaded) {
//                             return child;
//                           } else {
//                             return AnimatedSwitcher(
//                               duration: const Duration(milliseconds: 500),
//                               child: frame != null
//                                   ? child
//                                   : Container(
//                                       width: 71,
//                                       height: 53,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10)),
//                                         color: Colors.grey[200],
//                                       ),
//                                     ),
//                             );
//                           }
//                         },
//                       )),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.product.name,
//                         style: AppTypo.subtitle1,
//                         maxLines: kIsWeb? null : 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       widget.product.prediction == null
//                           ? Column(
//                               children: [
//                                 SizedBox(
//                                   height: 7,
//                                 ),
//                                 RichText(
//                                   text: TextSpan(
//                                     style: AppTypo.subtitle1
//                                         .copyWith(fontWeight: FontWeight.w700),
//                                     children: [
//                                       TextSpan(
//                                         text:
//                                             'Rp ${AppExt.toRupiah(widget.product.enduserPrice)}',
//                                       ),
//                                       // TextSpan(
//                                       //   text: '/box',
//                                       //   style: TextStyle(
//                                       //       color: AppColor.textSecondary,
//                                       //       fontWeight: FontWeight.w400),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : SizedBox.shrink(),
//                     ],
//                   ),
//                   widget.product.prediction != null
//                       ? SizedBox()
//                       : widget.isBuyNow
//                           ? quantityCounter(widget.product.stock)
//                           : Text(
//                               "x${widget.product.quantity}",
//                               style: AppTypo.subtitle2.copyWith(
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             )
//                 ],
//               ),
//             ],
//           );
//   }
// }

// class _ShimmerAddress extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Widget _unShim = Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 15,
//             width: 90,
//             color: Colors.grey[200],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             height: 10,
//             width: 150,
//             color: Colors.grey[200],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 10,
//             width: 130,
//             color: Colors.grey[200],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 10,
//             width: 140,
//             color: Colors.grey[200],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             height: 10,
//             width: 140,
//             color: Colors.grey[200],
//           ),
//         ],
//       ),
//     );

//     return _unShim;
//   }
// }

// // class PaymentDialog extends StatefulWidget {
// //   const PaymentDialog({Key key, this.orderId}) : super(key: key);
// //   final int orderId;

// //   @override
// //   _PaymentDialogState createState() => _PaymentDialogState();
// // }

// // class _PaymentDialogState extends State<PaymentDialog> {
// //   int _paymentId;
// //   bool _isPaymentModal = true;
// //   bool _isPaymentDetailModal = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return DialogWeb(
// //         width: 400,
// //         hasTitle: true,
// //         onPressedClose: () {
// //           AppExt.popScreen(context);
// //           context.beamToNamed('/');
// //         },
// //         title: _isPaymentModal == true ? "Metode Pembayaran" : "Pembayaran",
// //         child: _isPaymentModal == true
// //             ? PaymentModalContent(
// //                 orderId: widget.orderId,
// //                 onPayment: (value) {
// //                   setState(() {
// //                     _isPaymentModal = false;
// //                     _isPaymentDetailModal = true;
// //                     _paymentId = value;
// //                   });
// //                 },
// //               )
// //             : _isPaymentDetailModal == true
// //                 ? PaymentDetailModalContent(
// //                     paymentId: _paymentId,
// //                   )
// //                 : SizedBox());
// //   }
// // }

// class _ValidationResult {
//   const _ValidationResult({@required this.isValid, this.message});

//   final bool isValid;
//   final String message;
// }
