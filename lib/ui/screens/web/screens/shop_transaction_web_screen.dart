// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:intl/intl.dart';
// import 'package:marketplace/data/blocs/add_receipt_number/add_receipt_number_cubit.dart';
// import 'package:marketplace/data/blocs/change_order_status/change_order_status_cubit.dart';
// import 'package:marketplace/data/blocs/transaction_history/fetch_transaction_history_cubit.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/ui/widgets/web/dialog_web.dart';
// import 'package:marketplace/ui/widgets/web/footer_web.dart';
// import 'package:marketplace/ui/widgets/web/order_detail_modal_content.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/validator.dart';

// class ShopTransactionWebScreen extends StatefulWidget {
//   const ShopTransactionWebScreen({Key key}) : super(key: key);

//   @override
//   _ShopTransactionWebScreenState createState() =>
//       _ShopTransactionWebScreenState();
// }

// class _ShopTransactionWebScreenState extends State<ShopTransactionWebScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   FetchTransactionHistoryCubit _fetchTransactionHistoryCubit;
//   AddReceiptNumberCubit _addReceiptNumberCubit;
//   ChangeOrderStatusCubit _changeOrderStatusCubit;

//   TextEditingController _receiptNumberController;

//   Completer<void> _refreshCompleter;

//   int categoryTransactionId = 0;
//   int _roleId;

//   @override
//   void initState() {
//     _fetchTransactionHistoryCubit = FetchTransactionHistoryCubit()..load();
//     _addReceiptNumberCubit = AddReceiptNumberCubit();
//     _changeOrderStatusCubit = ChangeOrderStatusCubit();
//     _receiptNumberController = TextEditingController(text: '');
//     _refreshCompleter = Completer<void>();
//     // _roleId = BlocProvider.of<UserDataCubit>(context).state.seller.roleId;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fetchTransactionHistoryCubit.close();
//     _addReceiptNumberCubit.close();
//     _changeOrderStatusCubit.close();
//     _receiptNumberController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => _fetchTransactionHistoryCubit),
//         BlocProvider(create: (_) => _addReceiptNumberCubit),
//         BlocProvider(create: (_) => _changeOrderStatusCubit),
//       ],
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener(
//             cubit: _fetchTransactionHistoryCubit,
//             listener: (_, state) {
//               if (state is FetchTransactionHistorySuccess) {
//                 _refreshCompleter?.complete();
//                 _refreshCompleter = Completer();
//               }
//               if (state is FetchTransactionHistoryFailure) {
//                 _refreshCompleter?.complete();
//                 _refreshCompleter = Completer();
//               }
//             },
//           ),
//           BlocListener(
//             cubit: _addReceiptNumberCubit,
//             listener: (context, state) {
//               if (state is AddReceiptNumberLoading) {
//                 LoadingDialog.show(context);
//                 return;
//               }
//               if (state is AddReceiptNumberSuccess) {
//                 AppExt.popScreen(context);
//                 _fetchTransactionHistoryCubit.reload();
//                 ScaffoldMessenger.of(context)
//                   ..removeCurrentSnackBar()
//                   ..showSnackBar(
//                     new SnackBar(
//                       content: new Text(
//                         "Tambah nomer resi berhasil",
//                       ),
//                       duration: Duration(seconds: 1),
//                     ),
//                   );
//                 return;
//               }
//               if (state is AddReceiptNumberFailure) {
//                 AppExt.popScreen(context);
//                 ScaffoldMessenger.of(context)
//                   ..removeCurrentSnackBar()
//                   ..showSnackBar(
//                     new SnackBar(
//                       content: new Text(
//                         "Terjadi Kesalahan",
//                       ),
//                       duration: Duration(seconds: 1),
//                     ),
//                   );
//                 return;
//               }
//             },
//           ),
//           BlocListener(
//             cubit: _changeOrderStatusCubit,
//             listener: (context, state) {
//               if (state is ChangeOrderStatusLoading) {
//                 LoadingDialog.show(context);
//                 return;
//               }
//               if (state is ChangeOrderStatusSuccess) {
//                 _fetchTransactionHistoryCubit.reload();
//                 AppExt.popScreen(context);
//                 ScaffoldMessenger.of(context)
//                   ..removeCurrentSnackBar()
//                   ..showSnackBar(
//                     new SnackBar(
//                       content: new Text(
//                         "Status pesanan berhasil diubah",
//                       ),
//                       duration: Duration(seconds: 1),
//                     ),
//                   );
//                 return;
//               }
//               if (state is ChangeOrderStatusFailure) {
//                 AppExt.popScreen(context);
//                 ScaffoldMessenger.of(context)
//                   ..removeCurrentSnackBar()
//                   ..showSnackBar(
//                     new SnackBar(
//                       content: new Text(
//                         "Terjadi Kesalahan",
//                       ),
//                       duration: Duration(seconds: 1),
//                     ),
//                   );
//                 return;
//               }
//             },
//           )
//         ],
//         child: Scrollbar(
//           isAlwaysShown: true,
//           child: ListView(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 82, vertical: 40),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         flex: 1,
//                         child: BasicCard(
//                             child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.all(15),
//                               child: Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(65),
//                                     child: Image.network(
//                                       "",
//                                       // "${AppConst.STORAGE_URL}/shop/${BlocProvider.of<UserDataCubit>(context).state.seller.shopPhoto}",
//                                       height: 50,
//                                       width: 50,
//                                       frameBuilder: (context, child, frame,
//                                           wasSynchronouslyLoaded) {
//                                         if (wasSynchronouslyLoaded) {
//                                           return child;
//                                         } else {
//                                           return AnimatedSwitcher(
//                                             duration:
//                                                 const Duration(milliseconds: 1000),
//                                             child: frame != null
//                                                 ? Container(
//                                                     width: 50,
//                                                     height: 50,
//                                                     color: Color(0xFFD1F5B9),
//                                                     child: child,
//                                                   )
//                                                 : Container(
//                                                     width: 50,
//                                                     height: 50,
//                                                     color: Color(0xFFD1F5B9),
//                                                     child: Image.asset(
//                                                       AppImg.img_empty_user,
//                                                       width: 50,
//                                                       height: 50,
//                                                     ),
//                                                   ),
//                                           );
//                                         }
//                                       },
//                                       errorBuilder: (context, url, error) =>
//                                           Container(
//                                         width: 50,
//                                         height: 50,
//                                         color: Color(0xFFD1F5B9),
//                                         child: Image.asset(
//                                           AppImg.img_empty_user,
//                                           width: 50,
//                                           height: 50,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 12,
//                                   ),
//                                   Text(
//                                     ""
//                                       // BlocProvider.of<UserDataCubit>(context)
//                                       //     .state
//                                       //     .seller
//                                       //     .nameSeller
//                                           ,
//                                       style: AppTypo.subtitle1.copyWith(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w700))
//                                 ],
//                               ),
//                             ),
//                             Divider(
//                               thickness: 1,
//                               color: Colors.grey,
//                               indent: 1,
//                               endIndent: 1,
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(15),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       context
//                                           .beamToNamed('/account/shop/productlist');
//                                     },
//                                     child: Text(
//                                       "Daftar produk",
//                                       style: AppTypo.subtitle2
//                                           .copyWith(fontWeight: FontWeight.w400),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   InkWell(
//                                     onTap: () {
//                                       context
//                                           .beamToNamed('/account/shop/transaction');
//                                     },
//                                     child: Text(
//                                       "Daftar pesanan",
//                                       style: AppTypo.subtitle2
//                                           .copyWith(fontWeight: FontWeight.w400),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   _roleId == 4 ?
//                                 InkWell(
//                                   onTap: (){
//                                     //  context.beamToNamed(
//                                     //     '/account/shop/config');
//                                   },
//                                   child: Text(
//                                     "Potensi Komoditas",
//                                     style: AppTypo.subtitle2
//                                         .copyWith(fontWeight: FontWeight.w400),
//                                   ),
//                                 ) : SizedBox(),
//                                 SizedBox(height: _roleId == 4 ? 8 : 0),
//                                   InkWell(
//                                     onTap: () {
//                                       context
//                                           .beamToNamed('/account/shop/config');
//                                     },
//                                     child: Text(
//                                        "Data ${_roleId == 4 ? 'supplier' : 'catering'}",
//                                       style: AppTypo.subtitle2
//                                           .copyWith(fontWeight: FontWeight.w400),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ))),
//                     SizedBox(width: 30),
//                     Expanded(
//                         flex: 3,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Daftar Pesanan",style: AppTypo.h2.copyWith(fontSize: 24),),
//                             SizedBox(height: 25,),
//                             //TAB INDICATOR
//                             Container(
//                               decoration: BoxDecoration(
//                                   color: AppColor.textPrimaryInverted,
//                                   border: Border(
//                                       bottom: BorderSide(color: AppColor.grey))),
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       if (categoryTransactionId != 0) {
//                                         _fetchTransactionHistoryCubit.load();
//                                         setState(() {
//                                           categoryTransactionId = 0;
//                                         });
                                        
//                                       }
//                                     },
//                                     child: Container(
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 bottom: BorderSide(
//                                                     color:
//                                                         categoryTransactionId == 0
//                                                             ? AppColor.primary
//                                                             : Colors.transparent))),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 30, vertical: 5),
//                                         // color: Colors.blue,
//                                         child: Center(
//                                           child: Text("Pesanan Baru",
//                                               style: AppTypo.subtitle1.copyWith(
//                                                   color: categoryTransactionId == 0
//                                                       ? AppColor.primary
//                                                       : AppColor.grey,
//                                                   fontWeight: FontWeight.bold)),
//                                         )),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       if (categoryTransactionId != 0) {
//                                         _fetchTransactionHistoryCubit.load();
//                                         setState(() {
//                                           categoryTransactionId = 0;
//                                         });
                                        
//                                       }
//                                     },
//                                     child: Container(
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 bottom: BorderSide(
//                                                     color:
//                                                         categoryTransactionId == 0
//                                                             ? AppColor.primary
//                                                             : Colors.transparent))),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 30, vertical: 5),
//                                         // color: Colors.blue,
//                                         child: Center(
//                                           child: Text("Pembayaran",
//                                               style: AppTypo.subtitle1.copyWith(
//                                                   color: categoryTransactionId == 0
//                                                       ? AppColor.primary
//                                                       : AppColor.grey,
//                                                   fontWeight: FontWeight.bold)),
//                                         )),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       if (categoryTransactionId != 1) {
//                                         // _fetchTransactionsOnProcessCubit.reload();
//                                         _fetchTransactionHistoryCubit.load();
//                                         setState(() {
//                                           categoryTransactionId = 1;
//                                         });
//                                       }
//                                     },
//                                     child: Container(
//                                         decoration: BoxDecoration(
//                                             // color: AppColor.textPrimaryInverted,
//                                             border: Border(
//                                                 bottom: BorderSide(
//                                                     color:
//                                                         categoryTransactionId == 1
//                                                             ? AppColor.primary
//                                                             : Colors.transparent))),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 30, vertical: 5),
//                                         // color: Colors.yellow,
//                                         child: Center(
//                                           child: Text("Dalam Proses",
//                                               style: AppTypo.subtitle1.copyWith(
//                                                   color: categoryTransactionId == 1
//                                                       ? AppColor.primary
//                                                       : AppColor.grey,
//                                                   fontWeight: FontWeight.bold)),
//                                         )),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       if (categoryTransactionId != 2) {
//                                         _fetchTransactionHistoryCubit.load();
//                                         setState(() {
//                                           categoryTransactionId = 2;
//                                         });
//                                       }
//                                       // setState(() {
//                                       //   categoryTransactionId = 2;
//                                       // });
//                                     },
//                                     child: Container(
//                                         decoration: BoxDecoration(
//                                             // color: AppColor.textPrimaryInverted,
//                                             border: Border(
//                                                 bottom: BorderSide(
//                                                     color:
//                                                         categoryTransactionId == 2
//                                                             ? AppColor.primary
//                                                             : Colors.transparent))),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 30, vertical: 5),
//                                         // color: Colors.yellow,
//                                         child: Center(
//                                           child: Text("Selesai",
//                                               style: AppTypo.subtitle1.copyWith(
//                                                   color: categoryTransactionId == 2
//                                                       ? AppColor.primary
//                                                       : AppColor.grey,
//                                                   fontWeight: FontWeight.bold)),
//                                         )),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       if (categoryTransactionId != 3) {
//                                         _fetchTransactionHistoryCubit.load();
//                                         setState(() {
//                                           categoryTransactionId = 3;
//                                         });
//                                       }
//                                       // setState(() {
//                                       //   categoryTransactionId = 3;
//                                       // });
//                                     },
//                                     child: Container(
//                                         decoration: BoxDecoration(
//                                             // color: AppColor.textPrimaryInverted,
//                                             border: Border(
//                                                 bottom: BorderSide(
//                                                     color:
//                                                         categoryTransactionId == 3
//                                                             ? AppColor.primary
//                                                             : Colors.transparent))),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 30, vertical: 5),
//                                         // color: Colors.yellow,
//                                         child: Center(
//                                           child: Text("Permintaan Selesai",
//                                               style: AppTypo.subtitle1.copyWith(
//                                                   color: categoryTransactionId == 3
//                                                       ? AppColor.primary
//                                                       : AppColor.grey,
//                                                   fontWeight: FontWeight.bold)),
//                                         )),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             //TAB CONTENT
//                             categoryTransactionId == 0
//                                 ? BlocBuilder<FetchTransactionHistoryCubit,
//                                     FetchTransactionHistoryState>(
//                                     cubit: _fetchTransactionHistoryCubit,
//                                     builder: (context, state) =>
//                                         AppTrans.SharedAxisTransitionSwitcher(
//                                       transitionType:
//                                           SharedAxisTransitionType.vertical,
//                                       fillColor: Colors.transparent,
//                                       child: _TransactionShopListWeb(
//                                         orders:
//                                             state is FetchTransactionHistorySuccess
//                                                 ? state.data.newRequest
//                                                 : [],
//                                         changeOrderStatusCubit:
//                                             _changeOrderStatusCubit,
//                                         // onScroll: (isTop) => setScrollToTop(isTop),
//                                         screenState: state
//                                                 is FetchTransactionHistorySuccess
//                                             ? GeneralScreenState.success
//                                             : state is FetchTransactionHistoryLoading
//                                                 ? GeneralScreenState.loading
//                                                 : GeneralScreenState.failure,
//                                         onReload: () =>
//                                             _fetchTransactionHistoryCubit.load(),
//                                         onRefresh: () {
//                                           _fetchTransactionHistoryCubit.reload();
//                                           return _refreshCompleter.future;
//                                         },
//                                         failureMessage:
//                                             state is FetchTransactionHistoryFailure
//                                                 ? state.message
//                                                 : null,
//                                       ),
//                                     ),
//                                   )
//                                 : categoryTransactionId == 1
//                                     ? BlocBuilder<FetchTransactionHistoryCubit,
//                                         FetchTransactionHistoryState>(
//                                         cubit: _fetchTransactionHistoryCubit,
//                                         builder: (context, state) =>
//                                             AppTrans.SharedAxisTransitionSwitcher(
//                                           transitionType:
//                                               SharedAxisTransitionType.vertical,
//                                           fillColor: Colors.transparent,
//                                           child: _TransactionShopListWeb(
//                                             orders: state
//                                                     is FetchTransactionHistorySuccess
//                                                 ? state.data.process
//                                                 : [],
//                                             addReceiptNumberCubit:
//                                                 _addReceiptNumberCubit,
//                                             scaffoldKey: _scaffoldKey,
//                                             screenState: state
//                                                     is FetchTransactionHistorySuccess
//                                                 ? GeneralScreenState.success
//                                                 : state is FetchTransactionHistoryLoading
//                                                     ? GeneralScreenState.loading
//                                                     : GeneralScreenState.failure,
//                                             onReload: () =>
//                                                 _fetchTransactionHistoryCubit
//                                                     .load(),
//                                             onRefresh: () {
//                                               _fetchTransactionHistoryCubit
//                                                   .reload();
//                                               return _refreshCompleter.future;
//                                             },
//                                             failureMessage: state
//                                                     is FetchTransactionHistoryFailure
//                                                 ? state.message
//                                                 : null,
//                                           ),
//                                         ),
//                                       )
//                                     : categoryTransactionId == 2
//                                         ? BlocBuilder<FetchTransactionHistoryCubit,
//                                             FetchTransactionHistoryState>(
//                                             cubit: _fetchTransactionHistoryCubit,
//                                             builder: (context, state) => AppTrans
//                                                 .SharedAxisTransitionSwitcher(
//                                               transitionType:
//                                                   SharedAxisTransitionType.vertical,
//                                               fillColor: Colors.transparent,
//                                               child: _TransactionShopListWeb(
//                                                 orders: state
//                                                         is FetchTransactionHistorySuccess
//                                                     ? state.data.onTheWay
//                                                     : [],
//                                                 screenState: state
//                                                         is FetchTransactionHistorySuccess
//                                                     ? GeneralScreenState.success
//                                                     : state
//                                                             is FetchTransactionHistoryLoading
//                                                         ? GeneralScreenState.loading
//                                                         : GeneralScreenState
//                                                             .failure,
//                                                 onReload: () =>
//                                                     _fetchTransactionHistoryCubit
//                                                         .load(),
//                                                 onRefresh: () {
//                                                   _fetchTransactionHistoryCubit
//                                                       .reload();
//                                                   return _refreshCompleter.future;
//                                                 },
//                                                 failureMessage: state
//                                                         is FetchTransactionHistoryFailure
//                                                     ? state.message
//                                                     : null,
//                                               ),
//                                             ),
//                                           )
//                                         : categoryTransactionId == 3
//                                             ? BlocBuilder<
//                                                 FetchTransactionHistoryCubit,
//                                                 FetchTransactionHistoryState>(
//                                                 cubit:
//                                                     _fetchTransactionHistoryCubit,
//                                                 builder: (context, state) => AppTrans
//                                                     .SharedAxisTransitionSwitcher(
//                                                   transitionType:
//                                                       SharedAxisTransitionType
//                                                           .vertical,
//                                                   fillColor: Colors.transparent,
//                                                   child: _TransactionShopListWeb(
//                                                     orders: state
//                                                             is FetchTransactionHistorySuccess
//                                                         ? state.data.complete
//                                                         : [],
//                                                     screenState: state
//                                                             is FetchTransactionHistorySuccess
//                                                         ? GeneralScreenState.success
//                                                         : state
//                                                                 is FetchTransactionHistoryLoading
//                                                             ? GeneralScreenState
//                                                                 .loading
//                                                             : GeneralScreenState
//                                                                 .failure,
//                                                     onReload: () =>
//                                                         _fetchTransactionHistoryCubit
//                                                             .load(),
//                                                     onRefresh: () {
//                                                       _fetchTransactionHistoryCubit
//                                                           .reload();
//                                                       return _refreshCompleter
//                                                           .future;
//                                                     },
//                                                     failureMessage: state
//                                                             is FetchTransactionHistoryFailure
//                                                         ? state.message
//                                                         : null,
//                                                   ),
//                                                 ),
//                                               )
//                                             : null
//                           ],
//                         ))
//                   ],
//                 ),
//               )
//               ,FooterWeb()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TransactionShopListWeb extends StatefulWidget {
//   const _TransactionShopListWeb(
//       {Key key,
//       @required this.orders,
//       @required this.screenState,
//       this.onReload,
//       this.onRefresh,
//       this.failureMessage = "Terjadi kesalahan",
//       this.onScroll,
//       this.changeOrderStatusCubit,
//       this.addReceiptNumberCubit,
//       this.scaffoldKey})
//       : super(key: key);

//   final List<Order> orders;
//   final void Function() onReload;
//   final Future<void> Function() onRefresh;
//   final GeneralScreenState screenState;
//   final String failureMessage;
//   final void Function(bool isScrollToTop) onScroll;
//   final ChangeOrderStatusCubit changeOrderStatusCubit;
//   final AddReceiptNumberCubit addReceiptNumberCubit;
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   @override
//   __TransactionShopListWebState createState() =>
//       __TransactionShopListWebState();
// }

// class __TransactionShopListWebState extends State<_TransactionShopListWeb> {
//   final _formAddReceipt = GlobalKey<FormState>();
//   final ValidatorCustom _v = ValidatorCustom();
//   TextEditingController _receiptNumberController;

//   @override
//   void initState() {
//     super.initState();
//     _receiptNumberController = TextEditingController(text: '');
//   }

//   @override
//   void dispose() {
//     _receiptNumberController.dispose();

//     super.dispose();
//   }

//   void _handleChangeOrderStatus(
//       {@required orderId, @required orderStatus}) async {
//     widget.changeOrderStatusCubit
//         .changeOrderStatus(orderId: orderId, orderStatus: orderStatus);
//   }

//   void _handleSubmitReceiptNumber({@required int orderId}) async {
//     if (_formAddReceipt.currentState.validate()) {
//       AppExt.popScreen(context);
//       widget.addReceiptNumberCubit.addReceiptNumber(
//           orderId: orderId, receiptNumber: _receiptNumberController.text);
//     } 
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double _screenWidth = MediaQuery.of(context).size.width;

//     if (widget.screenState == GeneralScreenState.success) {
//       if (widget.orders.length == 0) {
//         return Center(
//           child: Wrap(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Icon(
//                     SizedBox(
//                     height: 100,
//                   ),
//                   Icon(
//                     FlutterIcons.package_variant_mco,
//                     size: 60,
//                     color: AppColor.primary,
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "Belum Ada Transaksi",
//                     style: AppTypo.h3.copyWith(fontWeight: FontWeight.w500),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "Belum ada pembeli",
//                     style: AppTypo.body1v2,
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   // Container(
//                   //   width: _screenWidth * (80 / 100),
//                   //   child: RoundedButton.contained(
//                   //       isSmall: true,
//                   //       isUpperCase: false,
//                   //       label: "Cari Produk",
//                   //       onPressed: () {
//                   //         //
//                   //       }),
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }

//       return ListView.separated(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         padding: EdgeInsets.symmetric(
//           vertical: 20,
//         ),
//         itemCount: widget.orders.length,
//         separatorBuilder: (_, __) {
//           return SizedBox(
//             height: _screenWidth * (2 / 100),
//           );
//         },
//         itemBuilder: (context, index) {
//           Order item = widget.orders[index];
//           return _TransactionShopListItemWeb(
//             item: item,
//             onTap: () => {
//               showDialog(
//                   context: context,
//                   useRootNavigator: false,
//                   builder: (ctx) {
//                     return DialogWeb(
//                       width: 750,
//                       hasTitle: true,
//                       title: "Detail Pemesanan",
//                       onPressedClose: () {
//                         AppExt.popScreen(context);
//                       },
//                       child: OrderDetailModalContent(
//                         orderId: item.id,
//                         ongkir: item.ongkir,
//                         onPressed: () {
//                           if (item.orderStatus == 1) {
//                             AppExt.popScreen(context);
//                             _handleChangeOrderStatus(
//                                 orderId: item.id,
//                                 orderStatus: item.orderStatus + 1);
//                           } else {
//                             AppExt.popScreen(context);
//                             _showReceiptNumberDialog(orderId: item.id,key: _formAddReceipt,validator: _v.vAddReceiptNumber);
//                           }
//                         },
//                       ),
//                     );
//                   })
//             },
//             onPressed: item.orderStatus == 1
//                 ? () => _handleChangeOrderStatus(
//                     orderId: item.id, orderStatus: item.orderStatus + 1)
//                 : () => _showReceiptNumberDialog(orderId: item.id,key: _formAddReceipt,validator: _v.vAddReceiptNumber),
//           );
//         },
//       );
//     }

//     if (widget.screenState == GeneralScreenState.loading) {
//       return Center(
//         child: CircularProgressIndicator(
//             valueColor: new AlwaysStoppedAnimation<Color>(AppColor.primary)),
//       );
//     }

//     return Center(
//       child: Wrap(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Icon(
//               Icon(
//                 FlutterIcons.error_outline_mdi,
//                 size: 45,
//                 color: AppColor.primaryDark,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 width: 250,
//                 child: Text(
//                   widget.failureMessage,
//                   style: AppTypo.overlineAccent,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(
//                 height: 7,
//               ),
//               OutlineButton(
//                 child: Text("Coba lagi"),
//                 onPressed: widget.onReload,
//                 textColor: AppColor.primaryDark,
//                 color: AppColor.danger,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showReceiptNumberDialog({@required orderId,key,validator}) {
//     _receiptNumberController = TextEditingController(text: '');
//     showDialog(
//         context: context,
//         useRootNavigator: false,
//         builder: (BuildContext bcontext) {
//           return DialogWeb(
//             hasHeader: false,
//             height: 260,
//             onPressedClose: () {
//               AppExt.popScreen(context);
//             },
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Form(
//                   key: key,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Masukkan Nomor Resi",
//                         style: AppTypo.h2.copyWith(fontSize: 24,fontWeight: FontWeight.w600),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       EditText(
//                         autofocus: true,
                        
//                         validator: validator,
//                         autoValidateMode: AutovalidateMode.onUserInteraction,
//                         controller: this._receiptNumberController,
//                         hintText: "Contoh: AUR48273IC2",
//                         keyboardType: TextInputType.visiblePassword,
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       RoundedButton.contained(
//                         isUpperCase: false,
//                         isCompact: true,
//                         label: "Submit",
//                         onPressed: () =>
//                             _handleSubmitReceiptNumber(orderId: orderId),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }

// class _TransactionShopListItemWeb extends StatelessWidget {
//   const _TransactionShopListItemWeb({
//     Key key,
//     @required this.item,
//     this.changeOrderStatusCubit,
//     this.onPressed,
//     this.onTap,
//   }) : super(key: key);

//   final Order item;
//   final ChangeOrderStatusCubit changeOrderStatusCubit;
//   final void Function() onPressed;
//   final void Function() onTap;

//   @override
//   Widget build(BuildContext context) {
//     final double _screenWidth = MediaQuery.of(context).size.width;

//     return BasicCard(
//         child: Padding(
//       padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Text("Kode Transaksi : -", style: AppTypo.caption),
//                   SizedBox(width: 18,),
//                   Text(
//                     DateFormat(
//                       "d MMMM yyyy",
//                       "id_ID",
//                     ).format(item.orderDate),
//                     style: AppTypo.overlineAccent,
//                     maxLines: kIsWeb? null : 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                     color: Color(0xFFD6FFBC),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Text(
//                   item.orderStatus == 1
//                       ? "Permintaan Baru"
//                       : item.orderStatus == 2
//                           ? "Siap kirim"
//                           : item.orderStatus == 3
//                               ? "Dalam Perjalanan"
//                               : "Permintaan Selesai",
//                   style: AppTypo.caption.copyWith(
//                       fontWeight: FontWeight.w700, color: AppColor.primary),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                   child: Container(
//                       decoration: BoxDecoration(
//                           // color: Colors.amber,
//                           border: Border(
//                               right: BorderSide(color: Colors.grey, width: 1))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(item.buyerName,style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700)),
//                           SizedBox(height: 4,),
//                           Text("Kecamatan, Kota/Kab",style: AppTypo.body1.copyWith(fontSize: 14),),
//                           SizedBox(height: 15,),
//                           SizedBox(height: 15,),
//                         ],
//                       ))),
//               Expanded(
//                 flex: 2,
//                   child: Container(
//                 // color: Colors.red,
//                 padding: EdgeInsets.only(left: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Total ",
//                             style: AppTypo.caption
//                                 .copyWith(fontSize: 12, color: AppColor.grey),
//                           ),
//                           SizedBox(height: 4,),
//                           Text(
//                             "Rp ${AppExt.toRupiah(item.totalPayment)}",
//                             style: AppTypo.subtitle1
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Agen/Kurir ",
//                             style: AppTypo.caption
//                                 .copyWith(fontSize: 12, color: AppColor.grey),
//                           ),
//                           SizedBox(height: 4,),
//                           Text(
//                             item.shippingCode,
//                             style: AppTypo.subtitle1
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: MouseRegion(
//                               cursor: SystemMouseCursors.click,
//                               child: GestureDetector(
//                                 onTap: onTap,
//                                 child: Text("Lihat detail",
//                                     style: AppTypo.body1.copyWith(
//                                         fontSize: 14,
//                                         color: AppColor.primary,
//                                         fontWeight: FontWeight.w700)),
//                               ),
//                             ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: item.orderStatus == 1 || item.orderStatus == 2
//                                 ? RoundedButton.contained(
//                                     label: item.orderStatus == 1
//                                         ? "Proses"
//                                         : "Kirim",
//                                     isSmall: true,
//                                     isUpperCase: false,
//                                     onPressed: onPressed)
//                        : SizedBox.shrink(),
//                     )
//                   ],
//                 ),
//               )),
//             ],
//           )
//         ],
//       ),
//     ));
//   }
// }
