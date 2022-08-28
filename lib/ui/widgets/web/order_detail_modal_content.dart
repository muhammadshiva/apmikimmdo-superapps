// import 'package:animations/animations.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:intl/intl.dart';
// import 'package:marketplace/data/blocs/fetch_order_detail/fetch_order_detail_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/ui/widgets/rounded_button.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/constants.dart' as AppConst;

// class OrderDetailModalContent extends StatefulWidget {
//   const OrderDetailModalContent(
//       {Key key, this.onPressed, this.orderId, this.ongkir})
//       : super(key: key);

//   final int orderId, ongkir;

//   final void Function() onPressed;

//   @override
//   _OrderDetailModalContentState createState() =>
//       _OrderDetailModalContentState();
// }

// class _OrderDetailModalContentState extends State<OrderDetailModalContent> {
//   FetchOrderDetailCubit _fetchOrderDetailCubit;

//   int subTotalSum = 0;

//   @override
//   void initState() {
//     _fetchOrderDetailCubit = FetchOrderDetailCubit()
//       ..load(orderId: widget.orderId);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fetchOrderDetailCubit.close();
//     super.dispose();
//   }

//   void _reload() {
//     _fetchOrderDetailCubit..load(orderId: widget.orderId);
//   }

//   void sumSubtotalList(List<OrderedProduct> products) {
//     List<int> subtotalList = [];
//     for (var i = 0; i < products.length; i++) {
//       subtotalList.add(products[i].productPrice * products[i].quantity);
//     }
//     setState(() {
//       subTotalSum = subtotalList.fold(
//           0, (previousValue, element) => previousValue + element);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => _fetchOrderDetailCubit,
//         ),
//       ],
//       child: MultiBlocListener(
//           listeners: [
//             BlocListener(
//               cubit: _fetchOrderDetailCubit,
//               listener: (context, state) {
//                 if (state is FetchOrderDetailSuccess) {
//                   sumSubtotalList(state.orderDetail.products);
//                 }
//                 if (state is FetchOrderDetailFailure) {
//                   ScaffoldMessenger.of(context)
//                     ..removeCurrentSnackBar()
//                     ..showSnackBar(
//                       new SnackBar(
//                         content: new Text(
//                           "Terjadi kesalahan",
//                         ),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                 }
//                 return;
//               },
//             ),
//           ],
//           child: BlocBuilder(
//               cubit: _fetchOrderDetailCubit,
//               builder: (context, state) =>
//                   AppTrans.SharedAxisTransitionSwitcher(
//                     transitionType: SharedAxisTransitionType.vertical,
//                     fillColor: Colors.transparent,
//                     child: state is FetchOrderDetailLoading
//                         ? Center(
//                             child: CircularProgressIndicator(
//                                 valueColor: new AlwaysStoppedAnimation<Color>(
//                                     AppColor.primary)),
//                           )
//                         : state is FetchOrderDetailFailure
//                             ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       FlutterIcons.error_outline_mdi,
//                                       size: 45,
//                                       color: AppColor.primaryDark,
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     SizedBox(
//                                       width: 250,
//                                       child: Text(
//                                         "Detail order gagal dimuat",
//                                         style: AppTypo.overlineAccent,
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 7,
//                                     ),
//                                     OutlineButton(
//                                       child: Text("Coba lagi"),
//                                       onPressed: _reload,
//                                       textColor: AppColor.primaryDark,
//                                       color: AppColor.danger,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : state is FetchOrderDetailSuccess
//                                 ? Padding(
//                                   padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
//                                   child: ListView(
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text("Status",style: AppTypo.caption
//                                                               .copyWith(
//                                                                   fontSize: 12),),
//                                                   Text(state.orderDetail
//                                                               .orderStatusId ==
//                                                           1
//                                                       ? "Permintaan Baru"
//                                                       : state.orderDetail
//                                                                   .orderStatusId ==
//                                                               2
//                                                           ? "Siap Kirim"
//                                                           : state.orderDetail
//                                                                       .orderStatusId ==
//                                                                   3
//                                                               ? "Dalam Perjalanan"
//                                                               : state.orderDetail
//                                                                           .orderStatusId ==
//                                                                       4
//                                                                   ? "Permintaan Selesai"
//                                                                   : "-", style: AppTypo
//                                                                 .subtitle2
//                                                                 .copyWith(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700,
//                                                                     color: AppColor
//                                                                         .primary)),
//                                                                         SizedBox(height: 16,),
//                                                   Text("Kode transaksi",style: AppTypo
//                                                                   .caption
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           12)),
//                                                   Text(state.orderDetail.payment[0]
//                                                       .transactionCode,style:AppTypo
//                                                                 .subtitle2
//                                                                 .copyWith(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700,
//                                                                     color: AppColor
//                                                                         .primary,fontSize: 13))
//                                                 ],
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text("Tanggal pemesanan",style:AppTypo
//                                                                   .caption
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           12)),
                                                                        
//                                                   Text(DateFormat(
//                                                     "d MMMM yyyy",
//                                                     "id_ID",
//                                                   ).format(
//                                                       state.orderDetail.orderDate),style: AppTypo
//                                                                   .subtitle2
//                                                                   .copyWith(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w700,
//                                                                       color: AppColor
//                                                                           .primary)),
//                                                                           SizedBox(height: 16,),
//                                                   Text("Nama pemesan",style:AppTypo
//                                                                   .caption
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           12)),
//                                                   Text(state.orderDetail.member,style: AppTypo
//                                                                   .subtitle2
//                                                                   .copyWith(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w700,
//                                                                       color: AppColor
//                                                                           .primary))
//                                                 ],
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text("Tanggal Pengiriman",style: AppTypo
//                                                                   .caption
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           12)),
//                                                   Text(state.orderDetail.sentDate !=
//                                                           null
//                                                       ? DateFormat(
//                                                           "d MMMM yyyy",
//                                                           "id_ID",
//                                                         ).format(state
//                                                           .orderDetail.sentDate)
//                                                       : '-',style: AppTypo
//                                                                   .subtitle2
//                                                                   .copyWith(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w700,
//                                                                       color: AppColor
//                                                                           .primary))
//                                                 ],
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   state.orderDetail.orderStatusId ==
//                                                               1 ||
//                                                           state.orderDetail
//                                                                   .orderStatusId ==
//                                                               2
//                                                       ? RoundedButton.contained(
//                                                         isSmall: true,
//                                                         isUpperCase: false,
//                                                           label: state.orderDetail
//                                                                       .orderStatusId ==
//                                                                   1
//                                                               ? "Proses"
//                                                               : "Kirim",
//                                                           onPressed: widget.onPressed
//                                                       )
//                                                       : SizedBox.shrink()
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(top: 32,bottom: 16),
//                                           child: Divider(
//                                             thickness: 1,
//                                             color: Colors.grey,
//                                             indent: 1,
//                                             endIndent: 1,
//                                           ),
//                                         ),
//                                         Text("Detail Produk",style: AppTypo.subtitle1.copyWith(
//                                             fontWeight: FontWeight.w700),),
//                                         SizedBox(height: 12,),
//                                         ListView.separated(
//                                             physics:
//                                                 new NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             itemCount:
//                                                 state.orderDetail.products.length,
//                                             separatorBuilder: (_, __) {
//                                               return SizedBox(
//                                                 height: 16,
//                                               );
//                                             },
//                                             itemBuilder: (context, index) {
//                                               OrderedProduct item = state
//                                                   .orderDetail.products[index];
//                                               return Row(
//                                                 children: [
//                                                   Expanded(
//                                                       child: Container(
//                                                           decoration:
//                                                               BoxDecoration(
//                                                                   // color: Colors.amber,
//                                                                   border: Border(
//                                                                       right: BorderSide(
//                                                                           color: Colors
//                                                                               .grey,
//                                                                           width:
//                                                                               1))),
//                                                           child: Row(
//                                                             children: [
//                                                               ClipRRect(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10),
//                                                                   child: Image(
//                                                                     image: NetworkImage(
//                                                                         "${AppConst.STORAGE_URL}/products/${item.productPhoto}"),
//                                                                     width: 70,
//                                                                     height: 50,
//                                                                     fit: BoxFit
//                                                                         .cover,
//                                                                     errorBuilder: (BuildContext
//                                                                             context,
//                                                                         Object
//                                                                             exception,
//                                                                         StackTrace
//                                                                             stackTrace) {
//                                                                       return Image
//                                                                           .asset(
//                                                                         AppImg
//                                                                             .img_error,
//                                                                         width: 70,
//                                                                         height:
//                                                                             50,
//                                                                         fit: BoxFit
//                                                                             .cover,
//                                                                       );
//                                                                     },
//                                                                     frameBuilder:
//                                                                         (context,
//                                                                             child,
//                                                                             frame,
//                                                                             wasSynchronouslyLoaded) {
//                                                                       if (wasSynchronouslyLoaded) {
//                                                                         return child;
//                                                                       } else {
//                                                                         return AnimatedSwitcher(
//                                                                           duration:
//                                                                               const Duration(milliseconds: 500),
//                                                                           child: frame !=
//                                                                                   null
//                                                                               ? child
//                                                                               : Container(
//                                                                                   width: 70,
//                                                                                   height: 50,
//                                                                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
//                                                                                 ),
//                                                                         );
//                                                                       }
//                                                                     },
//                                                                   )),
//                                                               SizedBox(
//                                                                 width: 10,
//                                                               ),
//                                                               Expanded(
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                         "${item.productName}",
//                                                                         style: AppTypo
//                                                                             .subtitle1
//                                                                             .copyWith(
//                                                                                 fontWeight: FontWeight
//                                                                                     .w700),
//                                                                         maxLines: kIsWeb? null :
//                                                                             1,
//                                                                         overflow:
//                                                                             TextOverflow
//                                                                                 .ellipsis),
//                                                                     SizedBox(
//                                                                       height: 5,
//                                                                     ),
//                                                                     Text(
//                                                                         "Rp ${AppExt.toRupiah(item.productPrice)}",
//                                                                         style: AppTypo
//                                                                             .caption
//                                                                             .copyWith(
//                                                                                 fontSize: 12)),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ))),
//                                                   Expanded(
//                                                       flex: 1,
//                                                       child: Container(
//                                                         // color: Colors.red,
//                                                         padding: EdgeInsets.only(
//                                                             left: 20),
//                                                         child: Row(
//                                                           children: [
//                                                             Expanded(
//                                                               child: Container(
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                       "Total pesanan",
//                                                                       style: AppTypo
//                                                                           .caption
//                                                                           .copyWith(
//                                                                               fontSize:
//                                                                                   12,
//                                                                               color:
//                                                                                   AppColor.grey),
//                                                                     ),
//                                                                     Text(
//                                                                       item.quantity
//                                                                           .toString(),
//                                                                       style: AppTypo
//                                                                           .subtitle1
//                                                                           .copyWith(
//                                                                               fontWeight:
//                                                                                   FontWeight.w700),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Expanded(
//                                                               child: Container(
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                       "Jumlah harga",
//                                                                       style: AppTypo
//                                                                           .caption
//                                                                           .copyWith(
//                                                                               fontSize:
//                                                                                   12,
//                                                                               color:
//                                                                                   AppColor.grey),
//                                                                     ),
//                                                                     Text(
//                                                                       "Rp ${AppExt.toRupiah(item.productPrice * item.quantity)}",
//                                                                       style: AppTypo
//                                                                           .subtitle1
//                                                                           .copyWith(
//                                                                               fontWeight:
//                                                                                   FontWeight.w700),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       )),
//                                                 ],
//                                               );
//                                             }),
//                                         Padding(
//                                           padding: const EdgeInsets.only(top: 24,bottom: 16),
//                                           child: Divider(
//                                             thickness: 1,
//                                             color: Colors.grey,
//                                             indent: 1,
//                                             endIndent: 1,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Detail Pembayaran",
//                                           style: AppTypo.subtitle1.copyWith(
//                                               fontWeight: FontWeight.w700),
//                                         ),
//                                         SizedBox(
//                                           height: 12,
//                                         ),
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                                 child: Container(
//                                                     decoration: BoxDecoration(
//                                                         // color: Colors.amber,
//                                                         border: Border(
//                                                             right: BorderSide(
//                                                                 color:
//                                                                     Colors.grey,
//                                                                 width: 1))),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                             "Subtotal (${state.orderDetail.totalProduct} item)",
//                                                             style: AppTypo.body1
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         14)),
//                                                         SizedBox(
//                                                           height: 12,
//                                                         ),
//                                                         Text("Ongkos Kirim",
//                                                             style: AppTypo.body1
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         14)),
//                                                         SizedBox(
//                                                           height: 12,
//                                                         ),
//                                                         Text("Total",
//                                                             style: AppTypo.body1
//                                                                 .copyWith(
//                                                                     fontSize: 14,
//                                                                     color: AppColor
//                                                                         .primary)),
//                                                       ],
//                                                     ))),
//                                             Expanded(
//                                                 child: Container(
//                                               // color: Colors.red,
//                                               padding: EdgeInsets.only(left: 20),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Expanded(
//                                                     child: Container(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                               "Rp. ${AppExt.toRupiah(subTotalSum)}",
//                                                               style: AppTypo.body1
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           14,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w700)),
//                                                           SizedBox(
//                                                             height: 12,
//                                                           ),
//                                                           Text(
//                                                               "Rp. ${AppExt.toRupiah(widget.ongkir)}",
//                                                               style: AppTypo.body1
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           14,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w700)),
//                                                           SizedBox(
//                                                             height: 12,
//                                                           ),
//                                                           Text(
//                                                               "Rp. ${AppExt.toRupiah(subTotalSum + widget.ongkir)}",
//                                                               style: AppTypo.body1
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           14,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w700,
//                                                                       color: AppColor
//                                                                           .primary)),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )),
//                                           ],
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               top: 24, bottom: 16),
//                                           child: Divider(
//                                             thickness: 1,
//                                             color: Colors.grey,
//                                             indent: 1,
//                                             endIndent: 1,
//                                           ),
//                                         ),
//                                         Text("Detail Pengiriman",
//                                             style: AppTypo.subtitle1.copyWith(
//                                                 fontWeight: FontWeight.w700)),
//                                         SizedBox(
//                                           height: 12,
//                                         ),
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                                 child: Container(
//                                                     decoration: BoxDecoration(
//                                                         // color: Colors.amber,
//                                                         border: Border(
//                                                             right: BorderSide(
//                                                                 color:
//                                                                     Colors.grey,
//                                                                 width: 1))),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text("Kurir Pengiriman",
//                                                             style: AppTypo.body1
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         14)),
//                                                         SizedBox(
//                                                           height: 12,
//                                                         ),
//                                                         Text("No resi",
//                                                             style: AppTypo.body1
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         14)),
//                                                         SizedBox(
//                                                           height: 12,
//                                                         ),
//                                                         Text("Alamat Pengiriman",
//                                                             style: AppTypo.body1
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         14)),
//                                                       ],
//                                                     ))),
//                                             Expanded(
//                                                 child: Container(
//                                               // color: Colors.red,
//                                               padding: EdgeInsets.only(left: 20),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Expanded(
//                                                     child: Container(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                               state.orderDetail
//                                                                   .shippingName,
//                                                               style: AppTypo.body1
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           14)),
//                                                           SizedBox(
//                                                             height: 12,
//                                                           ),
//                                                           Text(
//                                                               state.orderDetail
//                                                                   .noResi,
//                                                               style: AppTypo.body1
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           14)),
//                                                           SizedBox(
//                                                             height: 12,
//                                                           ),
//                                                           Text(state.orderDetail
//                                                                   .recipentAddress +
//                                                               ", " +
//                                                               state.orderDetail
//                                                                   .recipentSubdistrict +
//                                                               ", " +
//                                                               state.orderDetail
//                                                                   .recipentCity),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )),
//                                           ],
//                                         ),
//                                         SizedBox(height: 20,)
//                                       ],
//                                     ),
//                                 )
//                                 : SizedBox.shrink(),
//                   ))),
//     );
//   }
// }
