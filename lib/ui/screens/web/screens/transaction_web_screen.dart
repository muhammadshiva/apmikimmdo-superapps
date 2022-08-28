// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_boxicons/flutter_boxicons.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:beamer/beamer.dart';
// import 'package:intl/intl.dart';
// import 'package:marketplace/data/blocs/transaction/cubit/fetch_transactions_cubit.dart';
// import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/cart/add_to_cart/add_to_cart_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:marketplace/ui/widgets/basic_card.dart';
// import 'package:marketplace/ui/widgets/loading_dialog.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:url_launcher/url_launcher.dart';

// class TransactionWebScreen extends StatefulWidget {
//   const TransactionWebScreen({Key key}) : super(key: key);

//   @override
//   _TransactionWebScreenState createState() => _TransactionWebScreenState();
// }

// class _TransactionWebScreenState extends State<TransactionWebScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   FetchTransactionsCubit _fetchTransactionsPaymentCubit;
//   FetchTransactionsCubit _fetchTransactionsOnProcessCubit;
//   FetchTransactionsCubit _fetchTransactionsCompletedCubit;
//   FetchTransactionsCubit _confirmTransactionsCubit;
//   FetchTransactionsCubit _fetchTransactionsResellerCubit;
//   AddToCartCubit _addToCartCubit;
//   UserDataCubit _userDataCubit;
//   Completer<void> _paymentRefreshCompleter;
//   Completer<void> _onProgressRefreshCompleter;
//   Completer<void> _completedRefreshCompleter;
//   Completer<void> _resellerRefreshCompleter;

//   int categoryTransactionId;

//   @override
//   void initState() {
//     _userDataCubit = BlocProvider.of<UserDataCubit>(context);
//     _fetchTransactionsPaymentCubit =
//         FetchTransactionsCubit(type: FetchTransactionsType.payment)..load();
//     _fetchTransactionsOnProcessCubit =
//         FetchTransactionsCubit(type: FetchTransactionsType.onProcess)..load();
//     _fetchTransactionsCompletedCubit =
//         FetchTransactionsCubit(type: FetchTransactionsType.completed)..load();
//     _confirmTransactionsCubit =
//         FetchTransactionsCubit(type: FetchTransactionsType.onProcess);
//     _fetchTransactionsResellerCubit =
//         FetchTransactionsCubit(type: FetchTransactionsType.orderReseller);
//     _addToCartCubit =
//         AddToCartCubit(userDataCubit: BlocProvider.of<UserDataCubit>(context));
//     _paymentRefreshCompleter = Completer<void>();
//     _onProgressRefreshCompleter = Completer<void>();
//     _completedRefreshCompleter = Completer<void>();
//     _resellerRefreshCompleter = Completer<void>();
//     Future.delayed(Duration.zero, () {
//       if (_userDataCubit.state.user?.roleId == '5' &&
//           AAppConfig.of(context).appType == AppType.panenpanen) {
//         setState(() {
//           categoryTransactionId = 0;
//         });
//         _fetchTransactionsResellerCubit.load();
//       } else {
//         setState(() {
//           categoryTransactionId = 1;
//         });
//       }
//     });
//     BlocProvider.of<HandleTransactionRouteWebCubit>(context)
//         .changeCheckPaymentWeb(false);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fetchTransactionsPaymentCubit.close();
//     _fetchTransactionsOnProcessCubit.close();
//     _fetchTransactionsCompletedCubit.close();
//     _confirmTransactionsCubit.close();
//     _fetchTransactionsResellerCubit.close();
//     _addToCartCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final config = AAppConfig.of(context);

//     return MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => _fetchTransactionsPaymentCubit),
//           BlocProvider(create: (_) => _fetchTransactionsOnProcessCubit),
//           BlocProvider(create: (_) => _fetchTransactionsCompletedCubit),
//           BlocProvider(create: (_) => _confirmTransactionsCubit),
//           BlocProvider(create: (_) => _fetchTransactionsResellerCubit),
//           BlocProvider(create: (_) => _addToCartCubit),
//         ],
//         child: MultiBlocListener(
//             listeners: [
//               BlocListener(
//                 cubit: _fetchTransactionsPaymentCubit,
//                 listener: (_, state) {
//                   if (state is FetchTransactionsPaymentSuccess) {
//                     _paymentRefreshCompleter?.complete();
//                     _paymentRefreshCompleter = Completer();
//                   }
//                 },
//               ),
//               BlocListener(
//                 cubit: _fetchTransactionsOnProcessCubit,
//                 listener: (_, state) {
//                   if (state is FetchTransactionsOnProcessSuccess) {
//                     _onProgressRefreshCompleter?.complete();
//                     _onProgressRefreshCompleter = Completer();
//                   }
//                 },
//               ),
//               BlocListener(
//                 cubit: _fetchTransactionsCompletedCubit,
//                 listener: (_, state) {
//                   if (state is FetchTransactionsCompletedSuccess) {
//                     _completedRefreshCompleter?.complete();
//                     _completedRefreshCompleter = Completer();
//                   }
//                 },
//               ),
//               BlocListener(
//                 cubit: _confirmTransactionsCubit,
//                 listener: (_, state) {
//                   if (state is ConfirmTransactionsLoading) {
//                     LoadingDialog.show(context);
//                   }
//                   if (state is ConfirmTransactionsSuccess) {
//                     AppExt.popScreen(context);
//                     _fetchTransactionsOnProcessCubit.load();
//                     _fetchTransactionsCompletedCubit.load();
//                     _onProgressRefreshCompleter?.complete();
//                     _onProgressRefreshCompleter = Completer();
//                   }
//                 },
//               ),
//               BlocListener(
//                 cubit: _fetchTransactionsResellerCubit,
//                 listener: (_, state) {
//                   if (state is FetchTransactionsResellerSuccess) {
//                     _resellerRefreshCompleter?.complete();
//                     _resellerRefreshCompleter = Completer();
//                   }
//                   if (state is RejectOrderLoading) {
//                     LoadingDialog.show(context);
//                   }
//                   if (state is RejectOrderSuccess) {
//                     AppExt.popScreen(context);
//                     _fetchTransactionsResellerCubit.load();
//                     _fetchTransactionsPaymentCubit.load();
//                     _resellerRefreshCompleter?.complete();
//                     _resellerRefreshCompleter = Completer();
//                   }
//                 },
//               ),
//               BlocListener(
//                 cubit: _addToCartCubit,
//                 listener: (_, state) {
//                   if (state is AddToCartLoading) {
//                     LoadingDialog.show(context);
//                     return;
//                   }
//                   if (state is AddToCartSuccess) {
//                     AppExt.popScreen(context);
//                     showDialog(
//                         context: context,
//                         useRootNavigator: false,
//                         builder: (BuildContext context) {
//                           return AlertSuccessWeb(
//                               title: "Produk ditambahkan ke keranjang",
//                               description:
//                                   "Silakan checkout untuk melakukan pembelian",
//                               onPressClose: () {
//                                 AppExt.popScreen(context);
//                               });
//                         });
//                     return;
//                   }
//                   if (state is AddToCartFailure) {
//                     AppExt.popScreen(context);
//                     ScaffoldMessenger.of(context)
//                       ..removeCurrentSnackBar()
//                       ..showSnackBar(
//                         new SnackBar(
//                           content: new Text(
//                             state.message,
//                           ),
//                           duration: Duration(seconds: 1),
//                         ),
//                       );

//                     return;
//                   }
//                   if (state is AddToCartSuccess) {
//                     AppExt.popScreen(context);
//                     // BottomSheetFeedback.show(
//                     //   context,
//                     //   title: "Produk ditambahkan ke keranjang",
//                     //   description:
//                     //       "Silakan checkout untuk melakukan pembelian",
//                     // );
//                     return;
//                   }
//                 },
//               ),
//             ],
//             child: Scrollbar(
//               isAlwaysShown: true,
//               child: ListView(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 82, vertical: 40),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: BasicCard(
//                               child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(16),
//                                 child: Row(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(17),
//                                       child: Image.network(
//                                         "${AppConst.STORAGE_URL}/user/avatar/${BlocProvider.of<UserDataCubit>(context).state.user?.avatar}",
//                                         height: 34,
//                                         width: 34,
//                                         frameBuilder: (context, child, frame,
//                                             wasSynchronouslyLoaded) {
//                                           if (wasSynchronouslyLoaded) {
//                                             return child;
//                                           } else {
//                                             return AnimatedSwitcher(
//                                               duration: const Duration(
//                                                   milliseconds: 1000),
//                                               child: frame != null
//                                                   ? Container(
//                                                       width: 34,
//                                                       height: 34,
//                                                       color: Color(0xFFD1F5B9),
//                                                       child: child,
//                                                     )
//                                                   : Container(
//                                                       width: 34,
//                                                       height: 34,
//                                                       color: Color(0xFFD1F5B9),
//                                                       child: Image.asset(
//                                                         AppImg.img_empty_user,
//                                                         width: 34,
//                                                         height: 34,
//                                                       ),
//                                                     ),
//                                             );
//                                           }
//                                         },
//                                         errorBuilder: (context, url, error) =>
//                                             Container(
//                                           width: 34,
//                                           height: 34,
//                                           color: Color(0xFFD1F5B9),
//                                           child: Image.asset(
//                                             AppImg.img_empty_user,
//                                             width: 34,
//                                             height: 34,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 12),
//                                     Text(
//                                         "${BlocProvider.of<UserDataCubit>(context).state.user?.name}",
//                                         style: AppTypo.subtitle1.copyWith(
//                                             fontWeight: FontWeight.w700))
//                                   ],
//                                 ),
//                               ),
//                               Divider(
//                                 thickness: 1,
//                                 color: Colors.grey,
//                                 indent: 1,
//                                 endIndent: 1,
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 15),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "Koin Bisniso",
//                                           style: AppTypo.body1
//                                               .copyWith(fontSize: 14),
//                                         ),
//                                         Text("Rp ${AppExt.toRupiah(0)}",
//                                             style: AppTypo.body1.copyWith(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w700)),
//                                       ],
//                                     ),
//                                     SizedBox(height: 12),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "Voucher",
//                                           style: AppTypo.body1
//                                               .copyWith(fontSize: 14),
//                                         ),
//                                         Text("0",
//                                             style: AppTypo.body1.copyWith(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w700)),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           )),
//                         ),
//                         SizedBox(width: 30),
//                         Expanded(
//                             flex: 3,
//                             child: BlocBuilder(
//                               cubit: _userDataCubit,
//                               builder: (context, userDataState) => Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Daftar Transaksi",
//                                       style: AppTypo.h2.copyWith(fontSize: 24)),
//                                   SizedBox(height: 15),
//                                   //TAB INDICATOR
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         color: AppColor.textPrimaryInverted,
//                                         border: Border(
//                                             bottom: BorderSide(
//                                                 color: AppColor.grey))),
//                                     width: double.infinity,
//                                     child: Row(
//                                       children: [
//                                         userDataState.user?.roleId == '5' &&
//                                                 config.appType ==
//                                                     AppType.panenpanen
//                                             ? InkWell(
//                                                 onTap: () {
//                                                   if (categoryTransactionId !=
//                                                       0) {
//                                                     _fetchTransactionsResellerCubit
//                                                         .load();
//                                                     setState(() {
//                                                       categoryTransactionId = 0;
//                                                     });
//                                                   }
//                                                 },
//                                                 child: Container(
//                                                     decoration: BoxDecoration(
//                                                         border: Border(
//                                                             bottom: BorderSide(
//                                                                 color: categoryTransactionId ==
//                                                                         0
//                                                                     ? AppColor
//                                                                         .primary
//                                                                     : Colors
//                                                                         .transparent))),
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 30,
//                                                             vertical: 5),
//                                                     // color: Colors.blue,
//                                                     child: Center(
//                                                       child: Text(
//                                                           "Pesanan Baru",
//                                                           style: AppTypo
//                                                               .subtitle1
//                                                               .copyWith(
//                                                                   color: categoryTransactionId ==
//                                                                           0
//                                                                       ? AppColor
//                                                                           .primary
//                                                                       : AppColor
//                                                                           .grey,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold)),
//                                                     )),
//                                               )
//                                             : SizedBox.shrink(),
//                                         InkWell(
//                                           onTap: () {
//                                             if (categoryTransactionId != 1) {
//                                               _fetchTransactionsPaymentCubit
//                                                   .load();
//                                               setState(() {
//                                                 categoryTransactionId = 1;
//                                               });
//                                             }
//                                           },
//                                           child: Container(
//                                               decoration: BoxDecoration(
//                                                   border: Border(
//                                                       bottom: BorderSide(
//                                                           color: categoryTransactionId ==
//                                                                   1
//                                                               ? AppColor.primary
//                                                               : Colors
//                                                                   .transparent))),
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 30, vertical: 5),
//                                               // color: Colors.blue,
//                                               child: Center(
//                                                 child: Text("Pembayaran",
//                                                     style: AppTypo.subtitle1
//                                                         .copyWith(
//                                                             color:
//                                                                 categoryTransactionId ==
//                                                                         1
//                                                                     ? AppColor
//                                                                         .primary
//                                                                     : AppColor
//                                                                         .grey,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold)),
//                                               )),
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             if (categoryTransactionId != 2) {
//                                               _fetchTransactionsOnProcessCubit
//                                                   .load();
//                                               // _fetchTransactionsOnProcessCubit.reload();
//                                               setState(() {
//                                                 categoryTransactionId = 2;
//                                               });
//                                             }
//                                           },
//                                           child: Container(
//                                               decoration: BoxDecoration(
//                                                   // color: AppColor.textPrimaryInverted,
//                                                   border: Border(
//                                                       bottom: BorderSide(
//                                                           color: categoryTransactionId ==
//                                                                   2
//                                                               ? AppColor.primary
//                                                               : Colors
//                                                                   .transparent))),
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 30, vertical: 5),
//                                               // color: Colors.yellow,
//                                               child: Center(
//                                                 child: Text("Dalam Proses",
//                                                     style: AppTypo.subtitle1
//                                                         .copyWith(
//                                                             color:
//                                                                 categoryTransactionId ==
//                                                                         2
//                                                                     ? AppColor
//                                                                         .primary
//                                                                     : AppColor
//                                                                         .grey,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold)),
//                                               )),
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             if (categoryTransactionId != 3) {
//                                               setState(() {
//                                                 categoryTransactionId = 3;
//                                               });
//                                               _fetchTransactionsCompletedCubit
//                                                   .load();
//                                             }
//                                             // setState(() {
//                                             //   categoryTransactionId = 2;
//                                             // });
//                                           },
//                                           child: Container(
//                                               decoration: BoxDecoration(
//                                                   // color: AppColor.textPrimaryInverted,
//                                                   border: Border(
//                                                       bottom: BorderSide(
//                                                           color: categoryTransactionId ==
//                                                                   3
//                                                               ? AppColor.primary
//                                                               : Colors
//                                                                   .transparent))),
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 30, vertical: 5),
//                                               // color: Colors.yellow,
//                                               child: Center(
//                                                 child: Text("Selesai",
//                                                     style: AppTypo.subtitle1
//                                                         .copyWith(
//                                                             color:
//                                                                 categoryTransactionId ==
//                                                                         3
//                                                                     ? AppColor
//                                                                         .primary
//                                                                     : AppColor
//                                                                         .grey,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold)),
//                                               )),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   categoryTransactionId == 0 &&
//                                           userDataState.user?.roleId == '5' &&
//                                           config.appType == AppType.panenpanen
//                                       ? BlocBuilder(
//                                           cubit:
//                                               _fetchTransactionsResellerCubit,
//                                           builder: (context, state) =>
//                                               _TransactionListWeb(
//                                             transactions: state
//                                                     is FetchTransactionsResellerSuccess
//                                                 ? state.data
//                                                 : [],
//                                             onTap: (id) => debugPrint(id),
//                                             isOrderReseller: true,
//                                             transactionsCubit:
//                                                 _fetchTransactionsResellerCubit,
//                                             screenState: state
//                                                     is FetchTransactionsResellerSuccess
//                                                 ? GeneralScreenState.success
//                                                 : state
//                                                         is FetchTransactionsLoading
//                                                     ? GeneralScreenState.loading
//                                                     : state
//                                                             is RejectOrderLoading
//                                                         ? GeneralScreenState
//                                                             .loading
//                                                         : state
//                                                                 is RejectOrderFailure
//                                                             ? GeneralScreenState
//                                                                 .failure
//                                                             : GeneralScreenState
//                                                                 .failure,
//                                             onReload: () {
//                                               _fetchTransactionsResellerCubit
//                                                   .load();
//                                             },
//                                             failureMessage: state
//                                                     is FetchTransactionsPaymentFailure
//                                                 ? state.message
//                                                 : null,
//                                           ),
//                                         )
//                                       : categoryTransactionId == 1
//                                           ? BlocBuilder(
//                                               cubit:
//                                                   _fetchTransactionsPaymentCubit,
//                                               builder: (context, state) =>
//                                                   _TransactionListWeb(
//                                                 transactions: state
//                                                         is FetchTransactionsPaymentSuccess
//                                                     ? state.data
//                                                     : [],
//                                                 onTap: (id) => debugPrint(id),
//                                                 isPayment: true,
//                                                 // bottomNavCubit:
//                                                 //     BlocProvider.of<BottomNavCubit>(context),
//                                                 transactionsCubit:
//                                                     _fetchTransactionsPaymentCubit,
//                                                 screenState: state
//                                                         is FetchTransactionsPaymentSuccess
//                                                     ? GeneralScreenState.success
//                                                     : state
//                                                             is FetchTransactionsLoading
//                                                         ? GeneralScreenState
//                                                             .loading
//                                                         : state
//                                                                 is ConfirmTransactionsLoading
//                                                             ? GeneralScreenState
//                                                                 .loading
//                                                             : state
//                                                                     is ConfirmTransactionsFailure
//                                                                 ? GeneralScreenState
//                                                                     .failure
//                                                                 : GeneralScreenState
//                                                                     .failure,
//                                                 onReload: () {
//                                                   _fetchTransactionsPaymentCubit
//                                                       .load();
//                                                 },
//                                                 failureMessage: state
//                                                         is FetchTransactionsPaymentFailure
//                                                     ? state.message
//                                                     : null,
//                                               ),
//                                             )
//                                           : categoryTransactionId == 2
//                                               ? BlocBuilder(
//                                                   cubit:
//                                                       _fetchTransactionsOnProcessCubit,
//                                                   builder: (context, state) =>
//                                                       _TransactionListWeb(
//                                                     transactions: state
//                                                             is FetchTransactionsOnProcessSuccess
//                                                         ? state.data
//                                                         : [],
//                                                     onTap: (id) => debugPrint(id),
//                                                     onConfirm: (id) =>
//                                                         debugPrint(id),
//                                                     transactionsCubit:
//                                                         _confirmTransactionsCubit,
//                                                     screenState: state
//                                                             is FetchTransactionsOnProcessSuccess
//                                                         ? GeneralScreenState
//                                                             .success
//                                                         : state
//                                                                 is FetchTransactionsLoading
//                                                             ? GeneralScreenState
//                                                                 .loading
//                                                             : state
//                                                                     is ConfirmTransactionsLoading
//                                                                 ? GeneralScreenState
//                                                                     .loading
//                                                                 : state
//                                                                         is ConfirmTransactionsFailure
//                                                                     ? GeneralScreenState
//                                                                         .failure
//                                                                     : GeneralScreenState
//                                                                         .failure,
//                                                     onReload: () {
//                                                       _fetchTransactionsOnProcessCubit
//                                                           .load();
//                                                     },
//                                                     failureMessage: state
//                                                             is FetchTransactionsOnProcessFailure
//                                                         ? state.message
//                                                         : null,
//                                                   ),
//                                                 )
//                                               : categoryTransactionId == 3
//                                                   ? BlocBuilder(
//                                                       cubit:
//                                                           _fetchTransactionsCompletedCubit,
//                                                       builder: (context,
//                                                               state) =>
//                                                           _TransactionListWeb(
//                                                         transactions: state
//                                                                 is FetchTransactionsCompletedSuccess
//                                                             ? state.data
//                                                             : [],
//                                                         onTap: (id) =>
//                                                             debugPrint(id),
//                                                         addToCartCubit:
//                                                             _addToCartCubit,
//                                                         screenState: state
//                                                                 is FetchTransactionsCompletedSuccess
//                                                             ? GeneralScreenState
//                                                                 .success
//                                                             : state
//                                                                     is FetchTransactionsLoading
//                                                                 ? GeneralScreenState
//                                                                     .loading
//                                                                 : GeneralScreenState
//                                                                     .failure,
//                                                         onReload: () {
//                                                           _fetchTransactionsCompletedCubit
//                                                               .load();
//                                                         },
//                                                         failureMessage: state
//                                                                 is FetchTransactionsCompletedFailure
//                                                             ? state.message
//                                                             : null,
//                                                       ),
//                                                     )
//                                                   : SizedBox.shrink(),
//                                 ],
//                               ),
//                             ))
//                       ],
//                     ),
//                   ),
//                   FooterWeb()
//                 ],
//               ),
//             )));
//   }
// }

// class _TransactionListWeb extends StatelessWidget {
//   const _TransactionListWeb({
//     Key key,
//     @required this.transactions,
//     @required this.onTap,
//     @required this.screenState,
//     // this.bottomNavCubit,
//     this.transactionsCubit,
//     this.onConfirm,
//     this.addToCartCubit,
//     this.onReload,
//     this.onRefresh,
//     this.failureMessage = "Terjadi kesalahan",
//     this.isPayment = false,
//     this.isOrderReseller = false,
//   }) : super(key: key);

//   final List<Transaction> transactions;
//   final void Function(int id) onTap;
//   final void Function(int id) onConfirm;
//   final AddToCartCubit addToCartCubit;
//   final void Function() onReload;
//   final Future<void> Function() onRefresh;
//   // final BottomNavCubit bottomNavCubit;
//   final FetchTransactionsCubit transactionsCubit;
//   final GeneralScreenState screenState;
//   final String failureMessage;
//   final bool isPayment;
//   final bool isOrderReseller;

//   @override
//   Widget build(BuildContext context) {
//     // _handleAddToCartList(
//     //     {@required List<int> productId, @required int sellerId}) {
//     //   addToCartCubit.addToCartByList(productId: productId, sellerId: sellerId);
//     // }

//     _launchUrl(String _url) async =>
//         await canLaunch(_url) ? await launch(_url) : debugPrint("gagal mengakses");

//     final double _screenWidth = MediaQuery.of(context).size.width;

//     if (screenState == GeneralScreenState.success) {
//       if (transactions.length == 0) {
//         return Center(
//           child: Wrap(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 30,
//                   ),
//                   // Icon(
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
//                     !isOrderReseller
//                         ? "Ketika sudah melakukan pembelian anda dapat memantaunya disini"
//                         : "Pembelian pelanggan warung anda dapat dipantau disini",
//                     style: AppTypo.body1v2,
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 150),
//                     child: RoundedButton.contained(
//                         isSmall: true,
//                         isUpperCase: false,
//                         label: "Cari Produk",
//                         onPressed: () {
//                           context.beamToNamed('/');
//                         }),
//                   ),
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
//         itemCount: transactions.length,
//         separatorBuilder: (_, __) {
//           return SizedBox(
//             height: _screenWidth * (2 / 100),
//           );
//         },
//         itemBuilder: (context, index) {
//           Transaction item = transactions[index];
//           return isOrderReseller
//               ? _NewOrderResellerListItemWeb(
//                   transactionsCubit: transactionsCubit,
//                   transaction: item,
//                   onConfirm: () => showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return TransactionListDialog.detailOrderReseller(
//                           orderId: item.orderId,
//                           onReload: onReload,
//                         );
//                       }),
//                 )
//               : isPayment
//                   ? _PaymentListItemWeb(
//                       transaction: item,
//                       transactionsCubit: transactionsCubit,
//                       paymentDetail: item.paymentDetail,
//                       onTap: item.paymentDetail == null
//                           ? () async {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (BuildContext context) {
//                                     return TransactionListDialog.payment(
//                                       orderId: item.orderId,
//                                       onReload: onReload,
//                                     );
//                                   });
//                             }
//                           : item.paymentDetail != null &&
//                                   item.paymentDetail.paymentStatusId == 1 &&
//                                   item.paymentDetail.paymentVariant == 1
//                               ? () async {
//                                   showDialog(
//                                       context: context,
//                                       barrierDismissible: false,
//                                       builder: (BuildContext context) {
//                                         return TransactionListDialog
//                                             .paymentDetail(
//                                                 paymentId:
//                                                     item.paymentDetail.id,
//                                                 onReload: onReload);
//                                       });
//                                 }
//                               : item.paymentDetail != null &&
//                                       item.paymentDetail.paymentVariant == 2 &&
//                                       item.paymentDetail.link != null
//                                   ? () =>
//                                       _launchUrl("${item.paymentDetail.link}")
//                                   : null,
//                     )
//                   : _TransactionListItemWeb(
//                       transaction: item,
//                       onTap: () => {
//                         showDialog(
//                             context: context,
//                             barrierDismissible: false,
//                             builder: (BuildContext context) {
//                               return TransactionListDialog.detailBuy(
//                                 orderId: item.orderId,
//                                 // paymentMethodId: item.paymentDetail.,
//                                 transactionCode: item.transactionCode,
//                                 shopName: item.shopName,
//                               );
//                             })
//                       },
//                       onConfirm: onConfirm == null
//                           ? null
//                           : () => transactionsCubit
//                             ..confirmTransactions(
//                               orderId: item.orderId,
//                             ),
//                       onAddToCart: addToCartCubit == null
//                           ? null
//                           : () => addToCartCubit
//                             ..addToCartByList(
//                                 productId: item.productId,
//                                 sellerId: item.sellerId),
//                     );
//         },
//       );
//     }

//     if (screenState == GeneralScreenState.loading) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: CircularProgressIndicator(
//               valueColor: new AlwaysStoppedAnimation<Color>(AppColor.primary)),
//         ),
//       );
//     }

//     return Center(
//       child: Wrap(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 30,
//               ),
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
//                   failureMessage,
//                   style: AppTypo.overlineAccent,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(
//                 height: 7,
//               ),
//               OutlineButton(
//                 child: Text("Coba lagi"),
//                 onPressed: onReload,
//                 textColor: AppColor.primaryDark,
//                 color: AppColor.danger,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TransactionListItemWeb extends StatelessWidget {
//   const _TransactionListItemWeb({
//     Key key,
//     @required this.transaction,
//     this.transactionsCubit,
//     this.onTap,
//     this.onConfirm,
//     this.onAddToCart,
//   }) : super(key: key);

//   final Transaction transaction;
//   final FetchTransactionsCubit transactionsCubit;
//   final void Function() onTap;
//   final void Function() onConfirm;
//   final void Function() onAddToCart;

//   @override
//   Widget build(BuildContext context) {
//     final double _screenWidth = MediaQuery.of(context).size.width;

//     return BasicCard(
//         child: Padding(
//       padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Kode Transaksi : ${transaction.transactionCode}",
//                   style: AppTypo.caption),
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                     color: Color(0xFFD6FFBC),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Text(
//                   transaction.orderStatusId == 4 ? "Selesai" : "Dalam Proses",
//                   style: AppTypo.caption.copyWith(
//                       fontWeight: FontWeight.w700, color: AppColor.primary),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: [
//               Expanded(
//                   child: Container(
//                       decoration: BoxDecoration(
//                           // color: Colors.amber,
//                           border: Border(
//                               right: BorderSide(color: Colors.grey, width: 1))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(transaction.shopName,
//                               style: AppTypo.body1.copyWith(
//                                   fontSize: 14, fontWeight: FontWeight.w700)),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             children: [
//                               ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image(
//                                     image: NetworkImage(
//                                         "${AppConst.STORAGE_URL}/products/${transaction.shopPhoto}"),
//                                     width: 70,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (BuildContext context,
//                                         Object exception,
//                                         StackTrace stackTrace) {
//                                       return Image.asset(
//                                         AppImg.img_error,
//                                         width: 70,
//                                         height: 50,
//                                         fit: BoxFit.cover,
//                                       );
//                                     },
//                                     frameBuilder: (context, child, frame,
//                                         wasSynchronouslyLoaded) {
//                                       if (wasSynchronouslyLoaded) {
//                                         return child;
//                                       } else {
//                                         return AnimatedSwitcher(
//                                           duration:
//                                               const Duration(milliseconds: 500),
//                                           child: frame != null
//                                               ? child
//                                               : Container(
//                                                   width: 70,
//                                                   height: 50,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       color: Colors.grey[200]),
//                                                 ),
//                                         );
//                                       }
//                                     },
//                                   )),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("${transaction.productName[0]}",
//                                         style: AppTypo.subtitle1.copyWith(
//                                             fontWeight: FontWeight.w700),
//                                         maxLines: kIsWeb ? null : 1,
//                                         overflow: TextOverflow.ellipsis),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     transaction.productName.length > 1
//                                         ? Text(
//                                             "+${transaction.productName.length - 1} produk lainnya",
//                                             style: AppTypo.overline,
//                                             maxLines: kIsWeb ? null : 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           )
//                                         : SizedBox.shrink(),
//                                     transaction.productName.length > 1
//                                         ? SizedBox(
//                                             height: 7.5,
//                                           )
//                                         : SizedBox.shrink(),
//                                     Text(
//                                       transaction.orderDate == null
//                                           ? '-'
//                                           : DateFormat(
//                                               "d MMM yyyy",
//                                               "id_ID",
//                                             ).format(transaction.orderDate),
//                                       style: AppTypo.caption,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ))),
//               Expanded(
//                   child: Container(
//                 // color: Colors.red,
//                 padding: EdgeInsets.only(left: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Total harga",
//                           style: AppTypo.caption
//                               .copyWith(fontSize: 12, color: AppColor.grey),
//                         ),
//                         Text(
//                           "Rp ${AppExt.toRupiah(transaction.totalPrice)}",
//                           style: AppTypo.subtitle1
//                               .copyWith(fontWeight: FontWeight.w700),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       child: Row(
//                         children: [
//                           MouseRegion(
//                             cursor: SystemMouseCursors.click,
//                             child: GestureDetector(
//                               onTap: onTap,
//                               child: Text("Lihat detail",
//                                   style: AppTypo.body1.copyWith(
//                                       fontSize: 14,
//                                       color: AppColor.primary,
//                                       fontWeight: FontWeight.w700)),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 24,
//                           ),
//                           onConfirm == null
//                               ? SizedBox.shrink()
//                               : Theme(
//                                   data: ThemeData(
//                                       shadowColor: Colors.black38,
//                                       splashColor: AppColor.primary),
//                                   child: BlocBuilder<FetchTransactionsCubit,
//                                       FetchTransactionsState>(
//                                     cubit: transactionsCubit,
//                                     builder: (context, state) {
//                                       return RoundedButton.contained(
//                                         label: "Pesanan Sampai",
//                                         isSmall: true,
//                                         isCompact: true,
//                                         disabled: state
//                                                 is ConfirmTransactionsLoading ||
//                                             transaction.orderStatusId == 1 ||
//                                             transaction.orderStatusId == 2,
//                                         color: AppColor.primaryLight2,
//                                         textColor: Colors.white,
//                                         isUpperCase: false,
//                                         elevation: 6,
//                                         onPressed: onConfirm == null
//                                             ? null
//                                             : () => _showConfirmationDialog(
//                                                 context: context,
//                                                 sellerName:
//                                                     transaction.shopName,
//                                                 onYes: onConfirm),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                           onAddToCart == null
//                               ? SizedBox.shrink()
//                               : RoundedButton.contained(
//                                   label: "Beli Lagi",
//                                   isSmall: true,
//                                   isCompact: true,
//                                   color: AppColor.primaryLight2,
//                                   textColor: Colors.white,
//                                   isUpperCase: false,
//                                   elevation: 6,
//                                   onPressed:
//                                       onAddToCart == null ? null : onAddToCart,
//                                 ),
//                         ],
//                       ),
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

//   void _showConfirmationDialog(
//       {@required BuildContext context,
//       @required String sellerName,
//       @required void Function() onYes}) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return DialogWeb(
//             height: 250,
//             onPressedClose: () {
//               AppExt.popScreen(context);
//             },
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         style: AppTypo.body2.copyWith(fontSize: 20),
//                         children: [
//                           TextSpan(
//                             text:
//                                 'Apakah kamu yakin telah menerima pesanan dari ',
//                           ),
//                           TextSpan(
//                             text: '$sellerName?',
//                             style: AppTypo.body2.copyWith(
//                                 fontWeight: FontWeight.w700, fontSize: 20),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: RoundedButton.outlined(
//                             isUpperCase: false,
//                             isCompact: true,
//                             label: "Ya",
//                             onPressed: () {
//                               Navigator.pop(context);
//                               onYes();
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: RoundedButton.contained(
//                             isUpperCase: false,
//                             isCompact: true,
//                             label: "Tidak",
//                             onPressed: () => Navigator.pop(context),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }

// class _PaymentListItemWeb extends StatelessWidget {
//   const _PaymentListItemWeb({
//     Key key,
//     @required this.transaction,
//     @required this.paymentDetail,
//     this.transactionsCubit,
//     this.onTap,
//   }) : super(key: key);

//   final Transaction transaction;
//   final FetchTransactionsCubit transactionsCubit;
//   final PaymentDetail paymentDetail;
//   final void Function() onTap;

//   @override
//   Widget build(BuildContext context) {
//     return BasicCard(
//         child: Padding(
//       padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               transaction.paymentDetail != null &&
//                       transaction.paymentDetail.transactionCode != "-"
//                   ? Text(
//                       "Kode Transaksi : ${transaction.paymentDetail.transactionCode}",
//                       style: AppTypo.caption)
//                   : SizedBox.shrink(),
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                     color: Color(0xFFD6FFBC),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: paymentDetail != null
//                     ? Text(paymentDetail.paymentStatus,
//                         style: AppTypo.caption.copyWith(
//                             fontWeight: FontWeight.w700,
//                             color: AppColor.primary))
//                     : Text(
//                         "Tentukan Pembayaran",
//                         style: AppTypo.caption.copyWith(
//                             fontWeight: FontWeight.w700,
//                             color: AppColor.primary),
//                       ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                   child: Container(
//                       decoration: BoxDecoration(
//                           // color: Colors.amber,
//                           border: Border(
//                               right: BorderSide(color: Colors.grey, width: 1))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(transaction.shopName,
//                               style: AppTypo.body1.copyWith(
//                                   fontSize: 14, fontWeight: FontWeight.w700)),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Row(
//                             children: [
//                               ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image(
//                                     image: NetworkImage(
//                                         "${AppConst.STORAGE_URL}/products/${transaction.shopPhoto}"),
//                                     width: 70,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (BuildContext context,
//                                         Object exception,
//                                         StackTrace stackTrace) {
//                                       return Image.asset(
//                                         AppImg.img_error,
//                                         width: 70,
//                                         height: 50,
//                                         fit: BoxFit.cover,
//                                       );
//                                     },
//                                     frameBuilder: (context, child, frame,
//                                         wasSynchronouslyLoaded) {
//                                       if (wasSynchronouslyLoaded) {
//                                         return child;
//                                       } else {
//                                         return AnimatedSwitcher(
//                                           duration:
//                                               const Duration(milliseconds: 500),
//                                           child: frame != null
//                                               ? child
//                                               : Container(
//                                                   width: 70,
//                                                   height: 50,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       color: Colors.grey[200]),
//                                                 ),
//                                         );
//                                       }
//                                     },
//                                   )),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("${transaction.productName[0]}",
//                                         style: AppTypo.subtitle1.copyWith(
//                                             fontWeight: FontWeight.w700),
//                                         maxLines: kIsWeb ? null : 1,
//                                         overflow: TextOverflow.ellipsis),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     transaction.productName.length > 1
//                                         ? Text(
//                                             "+${transaction.productName.length - 1} produk lainnya",
//                                             style: AppTypo.overline,
//                                             maxLines: kIsWeb ? null : 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           )
//                                         : SizedBox.shrink(),
//                                     transaction.productName.length > 1
//                                         ? SizedBox(
//                                             height: 7.5,
//                                           )
//                                         : SizedBox.shrink(),
//                                     Text(
//                                         DateFormat(
//                                           "d MMM yyyy",
//                                           "id_ID",
//                                         ).format(transaction.orderDate),
//                                         style: AppTypo.caption),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ))),
//               Expanded(
//                   child: Container(
//                 padding: EdgeInsets.only(left: 24),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Total harga",
//                             style: AppTypo.caption
//                                 .copyWith(fontSize: 12, color: AppColor.grey)),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "Rp ${AppExt.toRupiah(transaction.totalPrice)}",
//                           style: AppTypo.subtitle1
//                               .copyWith(fontWeight: FontWeight.w700),
//                         ),
//                       ],
//                     ),
//                     paymentDetail != null && paymentDetail.paymentVariant == 1
//                         ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               paymentDetail.norek != null
//                                   ? Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(height: 5),
//                                         Text(
//                                           "Rekening Tujuan",
//                                           style: AppTypo.caption.copyWith(
//                                               color: AppColor.grey,
//                                               fontSize: 12),
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           "${paymentDetail.norek}",
//                                           style: AppTypo.subtitle1.copyWith(
//                                               fontWeight: FontWeight.w700),
//                                         ),
//                                         Text(
//                                           "a/n ${paymentDetail.an}",
//                                           style: AppTypo.caption.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               fontSize: 12),
//                                         ),
//                                       ],
//                                     )
//                                   : SizedBox.shrink(),
//                             ],
//                           )
//                         : paymentDetail != null &&
//                                 paymentDetail.paymentVariant == 2
//                             ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     "Payment Service",
//                                     style: AppTypo.caption
//                                         .copyWith(fontWeight: FontWeight.w700),
//                                   ),
//                                 ],
//                               )
//                             : SizedBox.shrink(),
//                     MouseRegion(
//                         cursor: SystemMouseCursors.click,
//                         child: GestureDetector(
//                             onTap: onTap,
//                             child: paymentDetail != null &&
//                                     paymentDetail.paymentStatusId == 2
//                                 ? SizedBox.shrink()
//                                 : paymentDetail != null &&
//                                         paymentDetail.paymentStatusId == 3
//                                     ? SizedBox.shrink()
//                                     : paymentDetail != null &&
//                                             paymentDetail.paymentVariant == 1
//                                         ? Text("Lihat detail",
//                                             style: AppTypo.body1.copyWith(
//                                                 fontSize: 14,
//                                                 color: AppColor.primary,
//                                                 fontWeight: FontWeight.w700))
//                                         : paymentDetail != null &&
//                                                 paymentDetail.paymentVariant ==
//                                                     2 // Belum dibayar
//                                             ? Text("Lihat detail",
//                                                 style: AppTypo.body1.copyWith(
//                                                     fontSize: 14,
//                                                     color: AppColor.primary,
//                                                     fontWeight:
//                                                         FontWeight.w700))
//                                             : Text("Pilih Pembayaran",
//                                                 style: AppTypo.body1.copyWith(
//                                                     fontSize: 14,
//                                                     color: AppColor.primary,
//                                                     fontWeight:
//                                                         FontWeight.w700))))
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

// class _NewOrderResellerListItemWeb extends StatelessWidget {
//   const _NewOrderResellerListItemWeb({
//     Key key,
//     @required this.transaction,
//     this.transactionsCubit,
//     this.onConfirm,
//   }) : super(key: key);

//   final Transaction transaction;
//   final FetchTransactionsCubit transactionsCubit;
//   final void Function() onConfirm;

//   @override
//   Widget build(BuildContext context) {
//     final double _screenWidth = MediaQuery.of(context).size.width;

//     return BasicCard(
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 15),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image(
//                               image: NetworkImage(
//                                   "${AppConst.STORAGE_URL}/products/${transaction.shopPhoto}"),
//                               width: 100,
//                               height: 80,
//                               fit: BoxFit.cover,
//                               errorBuilder: (BuildContext context,
//                                   Object exception, StackTrace stackTrace) {
//                                 return Image.asset(
//                                   AppImg.img_error,
//                                   width: 100,
//                                   height: 80,
//                                   fit: BoxFit.cover,
//                                 );
//                               },
//                               frameBuilder: (context, child, frame,
//                                   wasSynchronouslyLoaded) {
//                                 if (wasSynchronouslyLoaded) {
//                                   return child;
//                                 } else {
//                                   return AnimatedSwitcher(
//                                     duration: const Duration(milliseconds: 500),
//                                     child: frame != null
//                                         ? child
//                                         : Container(
//                                             width: 100,
//                                             height: 80,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 color: Colors.grey[200]),
//                                           ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             width: _screenWidth * (3 / 100),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("${transaction.productName[0]}",
//                                     style: AppTypo.body1
//                                         .copyWith(fontWeight: FontWeight.w700),
//                                     maxLines: kIsWeb ? null : 1,
//                                     overflow: TextOverflow.ellipsis),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 transaction.productName.length > 1
//                                     ? Text(
//                                         "+${transaction.productName.length - 1} produk lainnya",
//                                         style: AppTypo.overline,
//                                         maxLines: kIsWeb ? null : 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       )
//                                     : SizedBox.shrink(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Pelanggan",
//                                   style: AppTypo.overline,
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text(
//                                   "${transaction.recipentName}",
//                                   style: AppTypo.subtitle1
//                                       .copyWith(fontWeight: FontWeight.w700),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Total Harga",
//                                   style: AppTypo.overline,
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text(
//                                   "Rp ${AppExt.toRupiah(transaction.totalPrice)}",
//                                   style: AppTypo.subtitle1
//                                       .copyWith(fontWeight: FontWeight.w700),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 MouseRegion(
//                   cursor: SystemMouseCursors.click,
//                   child: GestureDetector(
//                     onTap: onConfirm,
//                     child: Text("Lihat detail",
//                         style: AppTypo.body1.copyWith(
//                             fontSize: 14,
//                             color: AppColor.primary,
//                             fontWeight: FontWeight.w700)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Divider(
//             color: AppColor.line,
//             thickness: 1,
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 15),
//             child: IntrinsicHeight(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(5),
//                       onTap: onConfirm,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Boxicons.bx_check, color: AppColor.primary),
//                           SizedBox(width: 10),
//                           Text(
//                             "Terima",
//                             style: AppTypo.button
//                                 .copyWith(color: AppColor.primary),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   VerticalDivider(
//                     color: AppColor.line,
//                     thickness: 1,
//                   ),
//                   SizedBox(width: 5),
//                   Expanded(
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(5),
//                       onTap: () => _showRejectConfirmationDialog(
//                         context: context,
//                         transaction: transaction,
//                         onReject: () => transactionsCubit.rejectOrder(
//                           orderId: transaction.orderId,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Boxicons.bx_block, color: AppColor.red),
//                           SizedBox(width: 10),
//                           Text(
//                             "Tolak",
//                             style: AppTypo.button.copyWith(color: AppColor.red),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRejectConfirmationDialog(
//       {@required BuildContext context,
//       @required Transaction transaction,
//       @required void Function() onReject}) {
//     showDialog(
//         barrierColor: Colors.black87,
//         context: context,
//         builder: (BuildContext context) {
//           return DialogWeb(
//             width: 350,
//             height: 230,
//             onPressedClose: () => Navigator.pop(context),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                       style: AppTypo.body2,
//                       children: [
//                         TextSpan(
//                           text: 'Apakah kamu yakin menolak pesanan ',
//                         ),
//                         TextSpan(
//                           text: '${transaction.recipentName}?',
//                           style: AppTypo.body2
//                               .copyWith(fontWeight: FontWeight.w700),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: RoundedButton.contained(
//                           isUpperCase: false,
//                           isCompact: true,
//                           label: "Ya",
//                           onPressed: () {
//                             onReject();
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Expanded(
//                         child: RoundedButton.outlined(
//                           isUpperCase: false,
//                           isCompact: true,
//                           label: "Tidak",
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }

// class TransactionListDialog extends StatefulWidget {
//   final int orderId;
//   final int paymentId;
//   // final int paymentMethodId;
//   final String transactionCode;
//   final String shopName;
//   final void Function() onReload;
//   final bool isPaymentModal;
//   final bool isPaymentDetailModal;
//   final bool isDetailBuy;
//   final bool isOrderReseller;

//   // const TransactionListDialog({Key key, this.orderId, this.paymentId, this.onReload}) : super(key: key);

//   const TransactionListDialog.payment({
//     this.orderId,
//     this.paymentId,
//     this.onReload,
//     this.isPaymentModal = true,
//     this.isPaymentDetailModal = false,
//     this.isDetailBuy = false,
//     this.transactionCode,
//     this.shopName,
//     this.isOrderReseller = false,
//   });

//   const TransactionListDialog.paymentDetail({
//     this.orderId,
//     this.paymentId,
//     this.onReload,
//     this.isPaymentModal = false,
//     this.isPaymentDetailModal = true,
//     this.isDetailBuy = false,
//     this.transactionCode,
//     this.shopName,
//     this.isOrderReseller = false,
//   });

//   const TransactionListDialog.detailBuy({
//     this.orderId,
//     this.paymentId,
//     this.onReload,
//     this.isPaymentModal = false,
//     this.isPaymentDetailModal = false,
//     this.isDetailBuy = true,
//     this.transactionCode,
//     this.shopName,
//     this.isOrderReseller = false,
//   });

//   const TransactionListDialog.detailOrderReseller({
//     this.orderId,
//     this.paymentId,
//     this.onReload,
//     this.isPaymentModal = false,
//     this.isPaymentDetailModal = false,
//     this.isDetailBuy = true,
//     this.transactionCode,
//     this.shopName,
//     this.isOrderReseller = true,
//   });

//   @override
//   _TransactionListDialogState createState() => _TransactionListDialogState();
// }

// class _TransactionListDialogState extends State<TransactionListDialog> {
//   int _paymentId;
//   bool _isPaymentModal;
//   bool _isPaymentDetailModal;
//   bool _isDetailBuy;
//   bool _isUserDoPayment;

//   @override
//   void initState() {
//     _isPaymentModal = widget.isPaymentModal ? true : false;
//     _isPaymentDetailModal = widget.isPaymentDetailModal ? true : false;
//     _isDetailBuy = widget.isDetailBuy ? true : false;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DialogWeb(
//         // width: _isDetailBuy == true ? 750 : 400,
//         width: 700,
//         hasTitle: true,
//         onPressedClose: () {
//           if (_isUserDoPayment == true) {
//             widget.onReload();
//             AppExt.popScreen(context);
//           } else {
//             AppExt.popScreen(context);
//           }
//         },
//         title: _isPaymentModal == true
//             ? "Metode Pembayaran"
//             : _isPaymentDetailModal == true
//                 ? "Pembayaran"
//                 : "Detail Pembelian",
//         // closeToHome: true,
//         child: _isPaymentModal == true
//             ? PaymentModalContent(
//                 isFromTransactionList: true,
//                 orderId: widget.orderId,
//                 onPayment: (value) {
//                   setState(() {
//                     _isPaymentModal = false;
//                     _isPaymentDetailModal = true;
//                     _isUserDoPayment = true;
//                     _paymentId = value;
//                   });
//                 },
//                 onCancelPayment: () {
//                   widget.onReload();
//                   AppExt.popScreen(context);
//                 },
//               )
//             : _isPaymentDetailModal == true
//                 ? PaymentDetailModalContent(
//                     isFromTransactionList: true,
//                     paymentId: _paymentId ?? widget.paymentId,
//                     onPaymentConfirm: () {
//                       widget.onReload();
//                       AppExt.popScreen(context);
//                     },
//                     onChangePayment: () {
//                       _isUserDoPayment = true;
//                     },
//                     onCancelPayment: () {
//                       widget.onReload();
//                       AppExt.popScreen(context);
//                     })
//                 : _isDetailBuy == true
//                     ? OrderDetailUserModalContent(
//                         orderId: widget.orderId,
//                         transactionCode: widget.transactionCode,
//                         shopName: widget.shopName,
//                         isOrderReseller: widget.isOrderReseller,
//                         onReload: widget.isOrderReseller
//                             ? () {
//                                 widget.onReload();
//                               }
//                             : null,
//                         onPayment: widget.isOrderReseller
//                             ? () {
//                                 setState(() {
//                                   _isPaymentModal = true;
//                                   _isPaymentDetailModal = false;
//                                   _isUserDoPayment = false;
//                                   _isDetailBuy = false;
//                                 });
//                               }
//                             : null,
//                       )
//                     : SizedBox());
//   }
// }
