// import 'package:animations/animations.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_boxicons/flutter_boxicons.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:intl/intl.dart';
// import 'package:marketplace/data/blocs/fetch_order_detail_user/fetch_order_detail_user_cubit.dart';
// import 'package:marketplace/data/blocs/payment/add_payment/add_payment_cubit.dart';
// import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/cart/add_to_cart/add_to_cart_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/data/models/order_detail_user.dart';
// import 'package:marketplace/route/beam_locations.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:beamer/beamer.dart';
// import 'package:url_launcher/url_launcher.dart';

// class OrderDetailUserModalContent extends StatefulWidget {
//   const OrderDetailUserModalContent({
//     Key key,
//     @required this.orderId,
//     this.transactionCode,
//     this.shopName,
//     this.isOrderReseller = false,
//     this.onPayment,
//     this.onReload,
//   })  : _isInvoice = isOrderReseller ? false : null,
//         super(key: key);

//   final int orderId;
//   final String transactionCode;
//   final String shopName;
//   final bool isOrderReseller;
//   final Function onPayment;
//   final Function onReload;

//   final bool _isInvoice;

//   @override
//   _OrderDetailUserModalContentState createState() =>
//       _OrderDetailUserModalContentState();
// }

// class _OrderDetailUserModalContentState
//     extends State<OrderDetailUserModalContent> {
//   FetchOrderDetailUserCubit _fetchOrderDetailUserCubit;
//   AddToCartCubit _addToCartCubit;
//   PaymentType _paymentType;
//   AddPaymentCubit _addPaymentCubit;

//   @override
//   void initState() {
//     _paymentType = PaymentType.manual;
//     _fetchOrderDetailUserCubit =
//         FetchOrderDetailUserCubit(isInvoice: widget._isInvoice)
//           ..load(
//             orderId: widget.orderId,
//           );
//     _addToCartCubit =
//         AddToCartCubit(userDataCubit: BlocProvider.of<UserDataCubit>(context));
//     _addPaymentCubit = AddPaymentCubit();
//     super.initState();
//   }

//   _handleAddToCart({@required int productId, @required int sellerId}) {
//     LoadingDialog.show(context);
//     _addToCartCubit.addToCart(productId: productId, sellerId: sellerId);
//   }

//   _handleAddToCartList(
//       {@required List<DetailOrder> orderList, @required int sellerId}) {
//     LoadingDialog.show(context);
//     List<int> productId = orderList.map((e) => e.productId).toList();
//     _addToCartCubit.addToCartByList(productId: productId, sellerId: sellerId);
//   }

//   _handlePayment() {
//     if (_paymentType == PaymentType.manual) {
//       widget.onPayment();
//     } else {
//       LoadingDialog.show(context);
//       _addPaymentCubit.addPaymentMidtrans(orderId: widget.orderId);
//     }
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

//   @override
//   void dispose() {
//     _fetchOrderDetailUserCubit.close();
//     _addToCartCubit.close();
//     super.dispose();
//   }

//   void _reload() {
//     _fetchOrderDetailUserCubit
//       ..load(
//         orderId: widget.orderId,
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (_) => _fetchOrderDetailUserCubit,
//           ),
//           BlocProvider(
//             create: (_) => _addToCartCubit,
//           ),
//           BlocProvider(
//             create: (_) => _addPaymentCubit,
//           ),
//         ],
//         child: MultiBlocListener(
//             listeners: [
//               BlocListener(
//                 cubit: _fetchOrderDetailUserCubit,
//                 listener: (_, state) {
//                   if (state is FetchOrderDetailFailure) {
//                     ScaffoldMessenger.of(context)
//                       ..removeCurrentSnackBar()
//                       ..showSnackBar(new SnackBar(
//                         content: new Text(
//                           "Terjadi Kesalahan",
//                         ),
//                         duration: Duration(seconds: 1),
//                       ));
//                     return;
//                   }
//                 },
//               ),
//               BlocListener(
//                 cubit: _addToCartCubit,
//                 listener: (_, state) {
//                   if (state is AddToCartFailure) {
//                     AppExt.popScreen(context);
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return DialogWeb(
//                             onPressedClose: () {
//                               AppExt.popScreen(context);
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 120),
//                               child: Column(
//                                 // mainAxisSize: MainAxisSize.,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Boxicons.bx_x_circle,
//                                     color: AppColor.danger,
//                                     size: 100,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     "Produk gagal ditambahkan ke keranjang",
//                                     textAlign: TextAlign.center,
//                                     style: AppTypo.h3,
//                                   ),
//                                   Text("${state.message}",
//                                       textAlign: TextAlign.center,
//                                       style: AppTypo.subtitle2Accent)
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//                     return;
//                   }
//                   if (state is AddToCartSuccess) {
//                     AppExt.popScreen(context);
//                     showDialog(
//                         context: context,
//                         useRootNavigator: false,
//                         builder: (BuildContext context) {
//                           return DialogWeb(
//                             height: 300,
//                             onPressedClose: () {
//                               AppExt.popScreen(context);
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 20),
//                               child: Column(
//                                 // mainAxisSize: MainAxisSize.,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.check_circle_outline,
//                                     color: AppColor.primary,
//                                     size: 100,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     "Produk ditambahkan ke keranjang",
//                                     textAlign: TextAlign.center,
//                                     style: AppTypo.h3,
//                                   ),
//                                   Text(
//                                       "Silakan checkout untuk melakukan pembelian",
//                                       textAlign: TextAlign.center,
//                                       style: AppTypo.subtitle2Accent),
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//                     return;
//                   }
//                 },
//               ),
//               BlocListener(
//                 cubit: _addPaymentCubit,
//                 listener: (_, state) async {
//                   if (state is AddPaymentMidtransSuccess) {
//                     Navigator.pop(context);
//                     await widget.onReload();
//                     Navigator.pop(context);
//                     _launchUrl(state.link);

//                     return;
//                   }
//                   if (state is AddPaymentFailure) {
//                     Navigator.pop(context);
//                     showDialog(
//                         context: context,
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
//             child: BlocBuilder(
//                 cubit: _fetchOrderDetailUserCubit,
//                 builder: (context, state) =>
//                     AppTrans.SharedAxisTransitionSwitcher(
//                         transitionType: SharedAxisTransitionType.vertical,
//                         fillColor: Colors.transparent,
//                         child: state is FetchOrderDetailSuccess
//                             ? Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 15),
//                                 child: Scrollbar(
//                                   isAlwaysShown: false,
//                                   child: ListView(
//                                     children: [
//                                       !widget.isOrderReseller
//                                           ? Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Expanded(
//                                                       child: Container(
//                                                           child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         children: [
//                                                           Expanded(
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   "Status",
//                                                                   style: AppTypo
//                                                                       .caption
//                                                                       .copyWith(
//                                                                           fontSize:
//                                                                               12),
//                                                                 ),
//                                                                 Text(
//                                                                     state
//                                                                         .orderDetail
//                                                                         .orderstatus
//                                                                         .name,
//                                                                     style: AppTypo
//                                                                         .subtitle2
//                                                                         .copyWith(
//                                                                             fontWeight:
//                                                                                 FontWeight.w700,
//                                                                             color: AppColor.primary)),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           Expanded(
//                                                             child: Padding(
//                                                               padding: EdgeInsets
//                                                                   .only(
//                                                                       left: 50),
//                                                               child: Column(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   Text(
//                                                                       "Tanggal Pembelian",
//                                                                       style: AppTypo
//                                                                           .caption
//                                                                           .copyWith(
//                                                                               fontSize: 12)),
//                                                                   Text(
//                                                                       state.orderDetail.paymentdate ==
//                                                                               null
//                                                                           ? '-'
//                                                                           : DateFormat(
//                                                                               "d MMMM yyyy",
//                                                                               "id_ID",
//                                                                             ).format(state
//                                                                               .orderDetail
//                                                                               .paymentdate),
//                                                                       style: AppTypo.subtitle2.copyWith(
//                                                                           fontWeight: FontWeight
//                                                                               .w700,
//                                                                           color:
//                                                                               AppColor.primary)),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           )
//                                                         ],
//                                                       )),
//                                                     ),
//                                                     Expanded(
//                                                         child: Container(
//                                                       padding: EdgeInsets.only(
//                                                           left: 20),
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         children: [
//                                                           Expanded(
//                                                               flex: 1,
//                                                               child: Container(
//                                                                 // color: Colors.red,
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .spaceBetween,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child: Container(
//                                                                           child:
//                                                                               SizedBox()),
//                                                                     ),
//                                                                     SizedBox(
//                                                                         width:
//                                                                             65),
//                                                                     Expanded(
//                                                                       flex: 2,
//                                                                       child:
//                                                                           Container(
//                                                                         child:
//                                                                             MouseRegion(
//                                                                           cursor:
//                                                                               SystemMouseCursors.click,
//                                                                           child:
//                                                                               GestureDetector(
//                                                                             // onTap: onTap,
//                                                                             child:
//                                                                                 RoundedButton.contained(
//                                                                               elevation: 0,
//                                                                               isCompact: true,
//                                                                               label: "Beli Lagi",
//                                                                               isSmall: true,
//                                                                               isUpperCase: false,
//                                                                               onPressed: () => _handleAddToCartList(orderList: state.orderDetail.detailorders, sellerId: state.orderDetail.sellerId),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               )),
//                                                         ],
//                                                       ),
//                                                     )),
//                                                   ],
//                                                 ),
//                                                 SizedBox(
//                                                   height: 16,
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Expanded(
//                                                       flex: 3,
//                                                       child: Container(
//                                                         child: Row(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             Expanded(
//                                                               flex: 2,
//                                                               child: Column(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   Text(
//                                                                     "Kode Transaksi",
//                                                                     style: AppTypo
//                                                                         .caption
//                                                                         .copyWith(
//                                                                       fontSize:
//                                                                           12,
//                                                                     ),
//                                                                   ),
//                                                                   Row(
//                                                                     crossAxisAlignment:
//                                                                         CrossAxisAlignment
//                                                                             .start,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child:
//                                                                             Text(
//                                                                           widget.transactionCode == null
//                                                                               ? '-'
//                                                                               : widget.transactionCode,
//                                                                           style: AppTypo
//                                                                               .subtitle2
//                                                                               .copyWith(
//                                                                             fontWeight:
//                                                                                 FontWeight.w700,
//                                                                             color:
//                                                                                 AppColor.primary,
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       SizedBox(
//                                                                         width:
//                                                                             20,
//                                                                       ),
//                                                                       MouseRegion(
//                                                                         cursor:
//                                                                             SystemMouseCursors.click,
//                                                                         child:
//                                                                             GestureDetector(
//                                                                           onTap:
//                                                                               () {
//                                                                             context.beamTo(InvoiceLocation(data: state.orderDetail));
//                                                                           },
//                                                                           child:
//                                                                               Text(
//                                                                             "Lihat Detail",
//                                                                             style:
//                                                                                 AppTypo.caption.copyWith(color: AppColor.primary),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                             Expanded(
//                                                               child: Padding(
//                                                                 padding: EdgeInsets
//                                                                     .only(
//                                                                         left:
//                                                                             50),
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                         "Nama Toko",
//                                                                         style: AppTypo
//                                                                             .caption
//                                                                             .copyWith(fontSize: 12)),
//                                                                     Text(
//                                                                         widget
//                                                                             .shopName,
//                                                                         style: AppTypo.subtitle2.copyWith(
//                                                                             fontWeight:
//                                                                                 FontWeight.w700,
//                                                                             color: AppColor.primary)),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Spacer(
//                                                       flex: 1,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                   padding: EdgeInsets.only(
//                                                       top: 32, bottom: 16),
//                                                   child: Divider(
//                                                     thickness: 1,
//                                                     color: Colors.grey,
//                                                     indent: 1,
//                                                     endIndent: 1,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "Detail Pesanan",
//                                                   style: AppTypo.subtitle1
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w700),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 12,
//                                                 ),
//                                               ],
//                                             )
//                                           : SizedBox.shrink(),
//                                       ListView.separated(
//                                           physics:
//                                               new NeverScrollableScrollPhysics(),
//                                           shrinkWrap: true,
//                                           itemCount: state
//                                               .orderDetail.detailorders.length,
//                                           separatorBuilder: (_, __) {
//                                             return SizedBox(
//                                               height: 16,
//                                             );
//                                           },
//                                           itemBuilder: (context, index) {
//                                             DetailOrder item = state.orderDetail
//                                                 .detailorders[index];
//                                             return DetailOrderItem(
//                                               detailOrderUser: item,
//                                               isOrderReseller:
//                                                   widget.isOrderReseller,
//                                               onPressed: () {
//                                                 _handleAddToCart(
//                                                     productId: item.productId,
//                                                     sellerId: state
//                                                         .orderDetail.sellerId);
//                                               },
//                                               // handleAddToCart:
//                                               // _handleAddToCart(
//                                               //     productId: item.productId,
//                                               //     sellerId:
//                                               //         state.orderDetail.sellerId),
//                                             );
//                                           }),
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             top: 24, bottom: 16),
//                                         child: Divider(
//                                           thickness: 1,
//                                           color: Colors.grey,
//                                           indent: 1,
//                                           endIndent: 1,
//                                         ),
//                                       ),
//                                       Text(
//                                         "Detail Pembayaran",
//                                         style: AppTypo.subtitle1.copyWith(
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                       SizedBox(
//                                         height: 12,
//                                       ),
//                                       DetailPaymentOrder(
//                                         orderDetail: state.orderDetail,
//                                         isOrderReseller: widget.isOrderReseller,
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             top: 24, bottom: 16),
//                                         child: Divider(
//                                           thickness: 1,
//                                           color: Colors.grey,
//                                           indent: 1,
//                                           endIndent: 1,
//                                         ),
//                                       ),
//                                       Text("Detail Pengiriman",
//                                           style: AppTypo.subtitle1.copyWith(
//                                               fontWeight: FontWeight.w700)),
//                                       SizedBox(
//                                         height: 12,
//                                       ),
//                                       DetailDelivery(
//                                         orderDetail: state.orderDetail,
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             top: 24, bottom: 16),
//                                         child: Divider(
//                                           thickness: 1,
//                                           color: Colors.grey,
//                                           indent: 1,
//                                           endIndent: 1,
//                                         ),
//                                       ),
//                                       widget.isOrderReseller
//                                           ? Column(
//                                               children: [
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       'Metode Verifikasi Pembayaran',
//                                                       style: AppTypo.subtitle1
//                                                           .copyWith(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w700),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 12,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: InkWell(
//                                                             onTap: () =>
//                                                                 setState(() {
//                                                               _paymentType =
//                                                                   PaymentType
//                                                                       .manual;
//                                                             }),
//                                                             child: BasicCard(
//                                                               isBordered: true,
//                                                               color: _paymentType ==
//                                                                       PaymentType
//                                                                           .manual
//                                                                   ? AppColor
//                                                                       .primary
//                                                                   : Colors
//                                                                       .white,
//                                                               child: Padding(
//                                                                 padding: EdgeInsets
//                                                                     .symmetric(
//                                                                         vertical:
//                                                                             15,
//                                                                         horizontal:
//                                                                             30),
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                       'Manual',
//                                                                       style: AppTypo.body1.copyWith(
//                                                                           fontSize:
//                                                                               14,
//                                                                           fontWeight: FontWeight
//                                                                               .w700,
//                                                                           color: Color(_paymentType == PaymentType.manual
//                                                                               ? 0xFFFFFFFF
//                                                                               : 0xFF777C7E))),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 24,
//                                                         ),
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: InkWell(
//                                                             onTap: () =>
//                                                                 setState(() {
//                                                               _paymentType =
//                                                                   PaymentType
//                                                                       .otomatis;
//                                                             }),
//                                                             child: BasicCard(
//                                                               isBordered: true,
//                                                               color: _paymentType ==
//                                                                       PaymentType
//                                                                           .otomatis
//                                                                   ? AppColor
//                                                                       .primary
//                                                                   : Colors
//                                                                       .white,
//                                                               child: Padding(
//                                                                 padding: EdgeInsets
//                                                                     .symmetric(
//                                                                         vertical:
//                                                                             15,
//                                                                         horizontal:
//                                                                             30),
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                       'Otomatis',
//                                                                       style: AppTypo.body1.copyWith(
//                                                                           fontSize:
//                                                                               14,
//                                                                           fontWeight: FontWeight
//                                                                               .w700,
//                                                                           color: Color(_paymentType == PaymentType.otomatis
//                                                                               ? 0xFFFFFFFF
//                                                                               : 0xFF777C7E))),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: SizedBox(),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Container(
//                                                   padding: EdgeInsets.only(
//                                                       top: 40, bottom: 25),
//                                                   child: MouseRegion(
//                                                     cursor: SystemMouseCursors
//                                                         .click,
//                                                     child: GestureDetector(
//                                                       child: RoundedButton
//                                                           .contained(
//                                                               elevation: 0,
//                                                               isCompact: true,
//                                                               label:
//                                                                   "Pembayaran",
//                                                               isUpperCase:
//                                                                   false,
//                                                               onPressed: () =>
//                                                                   _handlePayment()),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             )
//                                           : SizedBox.shrink(),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             : state is FetchOrderDetailLoading
//                                 ? Center(
//                                     child: CircularProgressIndicator(
//                                         valueColor:
//                                             new AlwaysStoppedAnimation<Color>(
//                                                 AppColor.primary)),
//                                   )
//                                 : Center(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         // Icon(
//                                         Icon(
//                                           FlutterIcons.error_outline_mdi,
//                                           size: 45,
//                                           color: AppColor.primaryDark,
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         SizedBox(
//                                           width: 250,
//                                           child: Text(
//                                             "Terjadi Kesalahan",
//                                             style: AppTypo.overlineAccent,
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 7,
//                                         ),
//                                         OutlineButton(
//                                           child: Text("Coba lagi"),
//                                           onPressed: _reload,
//                                           textColor: AppColor.primaryDark,
//                                           color: AppColor.danger,
//                                         ),
//                                       ],
//                                     ),
//                                   )))));
//   }
// }

// class DetailOrderItem extends StatelessWidget {
//   const DetailOrderItem(
//       {Key key,
//       this.detailOrderUser,
//       this.onPressed,
//       this.isOrderReseller = false})
//       : super(key: key);

//   final DetailOrder detailOrderUser;
//   final Function onPressed;
//   final bool isOrderReseller;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//             child: Container(
//                 decoration: BoxDecoration(
//                     // color: Colors.amber,
//                     border: Border(
//                         right: BorderSide(color: Colors.grey, width: 1))),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image(
//                           image: NetworkImage(
//                               "${AppConst.STORAGE_URL}/products/${detailOrderUser.productPhoto}"),
//                           width: 70,
//                           height: 50,
//                           fit: BoxFit.cover,
//                           errorBuilder: (BuildContext context, Object exception,
//                               StackTrace stackTrace) {
//                             return Image.asset(
//                               AppImg.img_error,
//                               width: 70,
//                               height: 50,
//                               fit: BoxFit.cover,
//                             );
//                           },
//                           frameBuilder:
//                               (context, child, frame, wasSynchronouslyLoaded) {
//                             if (wasSynchronouslyLoaded) {
//                               return child;
//                             } else {
//                               return AnimatedSwitcher(
//                                 duration: const Duration(milliseconds: 500),
//                                 child: frame != null
//                                     ? child
//                                     : Container(
//                                         width: 70,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             color: Colors.grey[200]),
//                                       ),
//                               );
//                             }
//                           },
//                         )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${detailOrderUser.productName}",
//                             style: AppTypo.subtitle1
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                               detailOrderUser.quantity.toString() +
//                                   " Produk " +
//                                   " x " +
//                                   "Rp ${AppExt.toRupiah(detailOrderUser.subtotal ~/ detailOrderUser.quantity)}",
//                               style: AppTypo.caption.copyWith(fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ))),
//         Expanded(
//             flex: 1,
//             child: Container(
//               // color: Colors.red,
//               padding: EdgeInsets.only(left: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Jumlah harga",
//                             style: AppTypo.caption
//                                 .copyWith(fontSize: 12, color: AppColor.grey),
//                           ),
//                           Text(
//                             "Rp ${AppExt.toRupiah(detailOrderUser.subtotal)}",
//                             style: AppTypo.subtitle1
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   !isOrderReseller
//                       ? Expanded(
//                           flex: 2,
//                           child: Container(
//                             child: MouseRegion(
//                               cursor: SystemMouseCursors.click,
//                               child: GestureDetector(
//                                 // onTap: onTap,
//                                 child: RoundedButton.contained(
//                                     elevation: 0,
//                                     isCompact: true,
//                                     label: "Beli Lagi",
//                                     isSmall: true,
//                                     isUpperCase: false,
//                                     onPressed: onPressed),
//                               ),
//                             ),
//                           ),
//                         )
//                       : SizedBox.shrink(),
//                 ],
//               ),
//             )),
//       ],
//     );
//   }
// }

// class DetailPaymentOrder extends StatelessWidget {
//   const DetailPaymentOrder(
//       {Key key, this.orderDetail, this.isOrderReseller = false})
//       : super(key: key);

//   final OrderDetailUser orderDetail;
//   final bool isOrderReseller;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//             child: Container(
//                 decoration: BoxDecoration(
//                     // color: Colors.amber,
//                     border: Border(
//                         right: BorderSide(color: Colors.grey, width: 1))),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Subtotal (${orderDetail.subtotalProduct} item)",
//                         style: AppTypo.body1.copyWith(fontSize: 14)),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Text("Ongkos Kirim",
//                         style: AppTypo.body1.copyWith(fontSize: 14)),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Text("Total",
//                         style: AppTypo.body1
//                             .copyWith(fontSize: 14, color: AppColor.primary)),
//                   ],
//                 ))),
//         Expanded(
//             child: Container(
//           // color: Colors.red,
//           padding: EdgeInsets.only(left: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Rp ${AppExt.toRupiah(orderDetail.subtotalPrice)}",
//                           style: AppTypo.body1.copyWith(
//                               fontSize: 14, fontWeight: FontWeight.w700)),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Text("Rp ${AppExt.toRupiah(orderDetail.ongkir)}",
//                           style: AppTypo.body1.copyWith(
//                               fontSize: 14, fontWeight: FontWeight.w700)),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Text("Rp ${AppExt.toRupiah(orderDetail.total)}",
//                           style: AppTypo.body1.copyWith(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: AppColor.primary)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )),
//       ],
//     );
//   }
// }

// class DetailDelivery extends StatelessWidget {
//   const DetailDelivery({Key key, this.orderDetail}) : super(key: key);

//   final OrderDetailUser orderDetail;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//             child: Container(
//                 child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Kurir Pengiriman",
//                 style: AppTypo.body1.copyWith(fontSize: 14)),
//             SizedBox(
//               height: 12,
//             ),
//             Text("No resi", style: AppTypo.body1.copyWith(fontSize: 14)),
//             SizedBox(
//               height: 12,
//             ),
//             Text("Alamat Pengiriman",
//                 style: AppTypo.body1.copyWith(fontSize: 14)),
//           ],
//         ))),
//         Expanded(
//             child: Container(
//           decoration: BoxDecoration(
//               border: Border(left: BorderSide(color: Colors.grey, width: 1))),
//           padding: EdgeInsets.only(left: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(orderDetail.shippingName ?? '-',
//                           style: AppTypo.body1.copyWith(fontSize: 14)),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Text(orderDetail.noresi ?? '-',
//                           style: AppTypo.body1.copyWith(fontSize: 14)),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Text(orderDetail.recipentName +
//                           '\n' +
//                           orderDetail.recipentPhone +
//                           '\n' +
//                           orderDetail.address +
//                           ", " +
//                           orderDetail.recipentSubdistrict +
//                           ", " +
//                           orderDetail.recipentCity),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )),
//       ],
//     );
//   }
// }
