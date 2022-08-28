// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:marketplace/api/api.dart';
// import 'package:marketplace/data/blocs/new_cubit/order/change_payment_method/change_payment_method_cubit.dart';
// import 'package:marketplace/data/blocs/payment/change_payment_status/change_payment_status_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/order/fetch_payment_method/fetch_payment_method_cubit.dart';
// import 'package:marketplace/data/blocs/payment/fetch_payment_order/fetch_payment_order_cubit.dart';
// import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/images.dart' as AppImg;

// class PaymentDetailModalContent extends StatefulWidget {
//   const PaymentDetailModalContent(
//       {Key key,
//       this.paymentId,
//       this.onPaymentConfirm,
//       this.onChangePayment,
//       this.isFromTransactionList = false, this.onCancelPayment})
//       : super(key: key);

//   final int paymentId;
//   final bool isFromTransactionList;
//   final Function onPaymentConfirm;
//   final Function onChangePayment;
//   final Function onCancelPayment;

//   @override
//   _PaymentDetailModalContentState createState() =>
//       _PaymentDetailModalContentState();
// }

// class _PaymentDetailModalContentState extends State<PaymentDetailModalContent> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   FetchPaymentOrderCubit _fetchPaymentOrderCubit;
//   ChangePaymentStatusCubit _changePaymentStatusCubit;
//   CancelOrderCubit _cancelOrderCubit;
//   FetchPaymentMethodCubit _fetchPaymentMethodCubit;
//   ChangePaymentMethodCubit _changePaymentMethodCubit;
//   List<Payment> _paymentMethod;
//   int _selectedPaymentIndex;
//   PaymentDetail _paymentDetail;

//   @override
//   void initState() {
//     _fetchPaymentOrderCubit = FetchPaymentOrderCubit()
//       ..load(paymentId: widget.paymentId);
//     _paymentMethod = [];
//     _paymentDetail = null;
//     _selectedPaymentIndex = null;
//     _cancelOrderCubit = CancelOrderCubit();
//     _changePaymentStatusCubit = ChangePaymentStatusCubit();
//     _fetchPaymentMethodCubit = FetchPaymentMethodCubit();
//     _changePaymentMethodCubit = ChangePaymentMethodCubit();
//     super.initState();
//   }

//   void _handleCopy(String text, String message) {
//     Clipboard.setData(new ClipboardData(text: text));
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   void _handleConfirmPayment({@required int paymentId}) async {
//     LoadingDialog.show(context);
//     await Future.delayed(Duration(seconds: 1));
//     await _changePaymentStatusCubit.confirmPayment(paymentId: paymentId);
//   }

//   void _handleCancelOrder({@required int paymentId}) async {
//     LoadingDialog.show(context);
//     await Future.delayed(Duration(seconds: 1));
//     await _cancelOrderCubit.cancelOrder(paymentId: paymentId);
//   }

//   @override
//   void dispose() {
//     _fetchPaymentOrderCubit.close();
//     _changePaymentStatusCubit.close();
//     _cancelOrderCubit.close();
//     _fetchPaymentMethodCubit.close();
//     _changePaymentMethodCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => _changePaymentStatusCubit),
//           BlocProvider(create: (_) => _fetchPaymentMethodCubit),
//         ],
//         child: MultiBlocListener(
//           listeners: [
//             BlocListener(
//                 cubit: _fetchPaymentOrderCubit,
//                 listener: (_, state) async {
//                   if (state is FetchPaymentOrderSuccess) {
//                     setState(() {
//                       _paymentDetail = state.paymentDetail;
//                     });
//                     _fetchPaymentMethodCubit.load();
//                   }
//                   return;
//                 }),
//             BlocListener(
//               cubit: _changePaymentStatusCubit,
//               listener: (_, state) async {
//                 if (state is ChangePaymentStatusSuccess) {
//                   if (widget.isFromTransactionList == true) {
//                     widget.onPaymentConfirm();
//                     AppExt.popScreen(context);
//                   } else {
//                     AppExt.popScreen(context);
//                     AppExt.popScreen(context);
//                     context.beamToNamed('transactionlist');
//                   }
//                   // BlocProvider.of<HandleTransactionRouteWebCubit>(context)
//                   //     .changeCheckPayment(false);
//                 }
//                 if (state is ChangePaymentStatusFailure) {
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       backgroundColor: Colors.grey[900],
//                       content: Text("Terjadi kesalahan")));
//                   return;
//                 }
//               },
//             ),
//             BlocListener(
//               cubit: _cancelOrderCubit,
//               listener: (_, state) async {
//                 if (state is CancelOrderSuccess) {
//                   if (widget.isFromTransactionList == true) {
//                     widget.onPaymentConfirm();
//                     AppExt.popScreen(context);
//                   } else {
//                     AppExt.popScreen(context);
//                     AppExt.popScreen(context);
//                     context.beamToNamed('/');
//                   }
//                   // context.beamToNamed('/');
//                   // BlocProvider.of<HandleTransactionRouteWebCubit>(context)
//                   //     .changeCheckPayment(false);
//                 }
//                 if (state is CancelOrderFailure) {
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       backgroundColor: Colors.grey[900],
//                       content: Text("Terjadi kesalahan")));
//                   return;
//                 }
//               },
//             ),
//             BlocListener(
//               cubit: _fetchPaymentMethodCubit,
//               listener: (_, state) async {
//                 if (state is FetchPaymentMethodSuccess) {
//                   final int index = state.paymentMethods.indexWhere((element) =>
//                       element.id == _paymentDetail.paymentMethodId);
//                   // setState(() {
//                   //   _paymentMethod = state.paymentMethods;
//                   //   _selectedPaymentIndex = index >= 0 ? index : null;
//                   // });
//                 }
//                 if (state is FetchPaymentMethodFailure) {
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       backgroundColor: Colors.grey[900],
//                       content: Text("Terjadi kesalahan")));
//                   return;
//                 }
//               },
//             ),
//             BlocListener(
//               cubit: _changePaymentMethodCubit,
//               listener: (_, state) async {
//                 if (state is ChangePaymentMethodSuccess) {
//                   if (widget.isFromTransactionList == true) {
//                     widget.onChangePayment();
//                     AppExt.popScreen(context);
//                     _fetchPaymentOrderCubit.load(paymentId: widget.paymentId);
//                   } else {
//                     AppExt.popScreen(context);
//                     _fetchPaymentOrderCubit.load(paymentId: widget.paymentId);
//                   }
//                 }
//                 if (state is ChangePaymentMethodFailure) {
//                   AppExt.popScreen(context);
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       backgroundColor: Colors.grey[900],
//                       content: Text(state.message)));
//                   return;
//                 }
//               },
//             ),
//           ],
//           child: BlocBuilder(
//             cubit: _fetchPaymentOrderCubit,
//             builder: (context, state) => AppTrans.SharedAxisTransitionSwitcher(
//               transitionType: SharedAxisTransitionType.vertical,
//               fillColor: Colors.transparent,
//               child: state is FetchPaymentOrderLoading
//                   ? Center(
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation(AppColor.primary),
//                         ),
//                       ),
//                     )
//                   : state is FetchPaymentOrderFailure
//                       ? Center(
//                           child: state.type == ErrorType.network
//                               ? NoConnection(onButtonPressed: () {
//                                   _fetchPaymentOrderCubit.load(
//                                       paymentId: widget.paymentId);
//                                 })
//                               : ErrorFetch(
//                                   message: state.message,
//                                   onButtonPressed: () {
//                                     _fetchPaymentOrderCubit.load(
//                                         paymentId: widget.paymentId);
//                                   },
//                                 ),
//                         )
//                       : state is FetchPaymentOrderSuccess
//                           ? Scrollbar(
//                               isAlwaysShown: true,
//                               child: ListView(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 20),
//                                 children: [
//                                   // Text(
//                                   //   "Transfer ke nomor rekening",
//                                   //   style: AppTypo.caption,
//                                   // ),
//                                   // SizedBox(
//                                   //   height: 10,
//                                   // ),
//                                   Row(
//                                     children: [
//                                       ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           child: Image(
//                                             image: NetworkImage(
//                                               "${AppConst.STORAGE_URL}/bank/${state.paymentDetail.image}",
//                                             ),
//                                             width: 60,
//                                             height: 56,
//                                             fit: BoxFit.contain,
//                                             errorBuilder:
//                                                 (context, object, stack) =>
//                                                     Image.asset(
//                                               AppImg.img_error,
//                                               width: 60,
//                                               height: 56,
//                                             ),
//                                             frameBuilder: (context, child,
//                                                 frame, wasSynchronouslyLoaded) {
//                                               if (wasSynchronouslyLoaded) {
//                                                 return child;
//                                               } else {
//                                                 return AnimatedSwitcher(
//                                                   duration: const Duration(
//                                                       milliseconds: 500),
//                                                   child: frame != null
//                                                       ? child
//                                                       : Container(
//                                                           width: 60,
//                                                           height: 56,
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   20),
//                                                           decoration: BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                               color: Colors
//                                                                   .grey[200]),
//                                                         ),
//                                                 );
//                                               }
//                                             },
//                                           )),
//                                       SizedBox(
//                                         width: 30,
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "${state.paymentDetail.norek}",
//                                               style: AppTypo.subtitle1.copyWith(
//                                                   fontWeight: FontWeight.w700),
//                                             ),
//                                             Text(
//                                               "a/n ${state.paymentDetail.an}",
//                                               style: AppTypo.overline,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       // SizedBox(
//                                       //   width: 100,
//                                       // ),
//                                       Container(
//                                         width: 60,
//                                         height: 27,
//                                         child: OutlineButton(
//                                           borderSide: BorderSide(
//                                             color: AppColor.primary,
//                                           ),
//                                           highlightColor:
//                                               AppColor.primary.withOpacity(0.3),
//                                           splashColor:
//                                               AppColor.primary.withOpacity(0.3),
//                                           highlightedBorderColor:
//                                               AppColor.primary,
//                                           padding: EdgeInsets.only(
//                                               left: 15, right: 15),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(50)),
//                                           onPressed: () => _handleCopy(
//                                               state.paymentDetail.norek,
//                                               "Nomor rekening telah disalin"),
//                                           child: Text(
//                                             "Salin",
//                                             style: AppTypo.caption.copyWith(
//                                                 color: AppColor.primary),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 3,
//                                   ),
//                                   BlocBuilder(
//                                     cubit: _fetchPaymentMethodCubit,
//                                     builder: (context, statePaymentMethod) =>
//                                         AppTrans.SharedAxisTransitionSwitcher(
//                                       transitionType:
//                                           SharedAxisTransitionType.vertical,
//                                       fillColor: Colors.transparent,
//                                       child: statePaymentMethod
//                                                   is FetchPaymentMethodSuccess &&
//                                               statePaymentMethod
//                                                       .paymentMethods.length >
//                                                   0
//                                           ? Align(
//                                               alignment: Alignment.centerLeft,
//                                               child: Material(
//                                                 color: Colors.transparent,
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     _showPaymentMethod(
//                                                       context: context,
//                                                       paymentMethod:
//                                                           _paymentMethod,
//                                                       selectedPayment:
//                                                           _selectedPaymentIndex,
//                                                       onChange:
//                                                           (paymentMethodId) {
//                                                         AppExt.popScreen(
//                                                             context);
//                                                         LoadingDialog.show(
//                                                             context);
//                                                         _changePaymentMethodCubit
//                                                             .changePaymentMethod(
//                                                                 paymentId: state
//                                                                     .paymentDetail
//                                                                     .id,
//                                                                 paymentMethodId:
//                                                                     paymentMethodId);
//                                                       },
//                                                     );
//                                                   },
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   highlightColor: AppColor
//                                                       .danger
//                                                       .withOpacity(0.2),
//                                                   splashColor: AppColor.danger
//                                                       .withOpacity(0.2),
//                                                   splashFactory:
//                                                       InkRipple.splashFactory,
//                                                   child: Text(
//                                                     "Ubah Rekening",
//                                                     style: AppTypo.overline
//                                                         .copyWith(
//                                                             color:
//                                                                 AppColor.danger,
//                                                             decoration:
//                                                                 TextDecoration
//                                                                     .underline),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           : SizedBox.shrink(),
//                                     ),
//                                   ),
//                                   Divider(color: AppColor.line),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text("Jumlah yang harus ditransfer",
//                                       style:
//                                           AppTypo.body1.copyWith(fontSize: 14)),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Rp" +
//                                             AppExt.toRupiah(
//                                                 state.paymentDetail.total),
//                                         style: AppTypo.h3.copyWith(
//                                             fontWeight: FontWeight.w600,
//                                             color: AppColor.primary),
//                                       ),
//                                       Container(
//                                         width: 60,
//                                         height: 27,
//                                         child: OutlineButton(
//                                           borderSide: BorderSide(
//                                             color: AppColor.primary,
//                                           ),
//                                           highlightColor:
//                                               AppColor.primary.withOpacity(0.3),
//                                           splashColor:
//                                               AppColor.primary.withOpacity(0.3),
//                                           highlightedBorderColor:
//                                               AppColor.primary,
//                                           padding: EdgeInsets.only(
//                                               left: 15, right: 15),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(50)),
//                                           onPressed: () => _handleCopy(
//                                               state.paymentDetail.total
//                                                   .toString(),
//                                               "Jumlah transfer telah disalin"),
//                                           child: Text(
//                                             "Salin",
//                                             style: AppTypo.caption.copyWith(
//                                                 color: AppColor.primary),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(
//                                     height: 25,
//                                   ),
//                                   Text("Kode Transaksi",
//                                       style:
//                                           AppTypo.body1.copyWith(fontSize: 14)),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "${state.paymentDetail.transactionCode}",
//                                         style: AppTypo.h3.copyWith(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 14),
//                                       ),
//                                       Container(
//                                         width: 60,
//                                         height: 27,
//                                         child: OutlineButton(
//                                           borderSide: BorderSide(
//                                             color: AppColor.primary,
//                                           ),
//                                           highlightColor:
//                                               AppColor.primary.withOpacity(0.3),
//                                           splashColor:
//                                               AppColor.primary.withOpacity(0.3),
//                                           highlightedBorderColor:
//                                               AppColor.primary,
//                                           padding: EdgeInsets.only(
//                                               left: 15, right: 15),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(50)),
//                                           onPressed: () => _handleCopy(
//                                               state
//                                                   .paymentDetail.transactionCode
//                                                   .toString(),
//                                               "Kode transaksi telah disalin"),
//                                           child: Text(
//                                             "Salin",
//                                             style: AppTypo.caption.copyWith(
//                                                 color: AppColor.primary),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(
//                                     height: 25,
//                                   ),
//                                   Column(
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             5, 13, 13, 13),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           border: Border.all(
//                                               color: AppColor.primary,
//                                               width: 1),
//                                           color:
//                                               AppColor.primary.withOpacity(0.2),
//                                         ),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Icon(Icons.info,
//                                                 color: AppColor.primary
//                                                     .withOpacity(0.5)),
//                                             SizedBox(width: 3),
//                                             Expanded(
//                                               child: Column(
//                                                 children: [
//                                                   Row(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(top: 5.0),
//                                                         child: Icon(
//                                                             Icons.circle,
//                                                             color: AppColor
//                                                                 .textPrimary,
//                                                             size: 7),
//                                                       ),
//                                                       SizedBox(width: 5),
//                                                       Expanded(
//                                                         child: Text(
//                                                             "Silakan selesaikan pembayaran anda dengan bank yang sudah anda pilih",
//                                                             style: AppTypo
//                                                                 .caption),
//                                                       )
//                                                     ],
//                                                   ),
//                                                   SizedBox(height: 5),
//                                                   Row(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(top: 5.0),
//                                                         child: Icon(
//                                                             Icons.circle,
//                                                             color: AppColor
//                                                                 .textPrimary,
//                                                             size: 7),
//                                                       ),
//                                                       SizedBox(width: 5),
//                                                       Expanded(
//                                                         child: Text(
//                                                             "Masukkan kode transaksi dalam pesan berita transfer. Pastikan jumlah transfer dan nomor rekening sesuai.",
//                                                             style: AppTypo
//                                                                 .caption),
//                                                       )
//                                                     ],
//                                                   ),
//                                                   SizedBox(height: 5),
//                                                   Row(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(top: 5.0),
//                                                         child: Icon(
//                                                             Icons.circle,
//                                                             color: AppColor
//                                                                 .textPrimary,
//                                                             size: 7),
//                                                       ),
//                                                       SizedBox(width: 5),
//                                                       Expanded(
//                                                         child: Text(
//                                                             "Setelah anda sudah membayar silahkan menunggu konfirmasi dari penjual dan pesanan anda akan segera di proses",
//                                                             style: AppTypo
//                                                                 .caption),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 40,
//                                       ),
//                                       RoundedButton.contained(
//                                         label: "Konfirmasi Bayar",
//                                         onPressed: () => _handleConfirmPayment(
//                                             paymentId: state.paymentDetail.id),
//                                         isUpperCase: false,
//                                       ),
//                                       SizedBox(
//                                         height: 30,
//                                       ),
//                                       Center(
//                                         child: Material(
//                                           color: Colors.transparent,
//                                           child: InkWell(
//                                             onTap: () =>
//                                                 _showConfirmationDialog(
//                                               context: context,
//                                               onYes: () => _handleCancelOrder(
//                                                   paymentId:
//                                                       state.paymentDetail.id),
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             highlightColor: AppColor.danger
//                                                 .withOpacity(0.2),
//                                             splashColor: AppColor.danger
//                                                 .withOpacity(0.2),
//                                             splashFactory:
//                                                 InkRipple.splashFactory,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 10.0),
//                                               child: Text(
//                                                 "Batalkan Pesanan",
//                                                 style: AppTypo.button.copyWith(
//                                                     fontWeight: FontWeight.w500,
//                                                     color: AppColor.danger,
//                                                     fontSize: 14),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 30,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : SizedBox.shrink(),
//             ),
//           ),
//         ));
//   }

//   void _showPaymentMethod({
//     @required BuildContext context,
//     @required List<Payment> paymentMethod,
//     @required int selectedPayment,
//     @required void Function(int) onChange,
//   }) {
//     final double _screenWidth = MediaQuery.of(context).size.width;
//     final double _screenHeight = MediaQuery.of(context).size.height;
//     final int initialPayment = selectedPayment;
//     showDialog(
//         context: context,
//         useRootNavigator: false,
//         builder: (BuildContext context) {
//           return DialogWeb(
//               width: 400,
//               onPressedClose: () {
//                 AppExt.popScreen(context);
//               },
//               child: StatefulBuilder(
//                   builder: (BuildContext context, StateSetter setSheetState) {
//                 return Container(
//                   constraints:
//                       BoxConstraints(maxHeight: _screenHeight * (90 / 100)),
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Ubah Rekening',
//                             style: AppTypo.subtitle1
//                                 .copyWith(fontWeight: FontWeight.w700)),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Flexible(
//                           child: paymentMethod.length > 0
//                               ? Scrollbar(
//                                   isAlwaysShown: true,
//                                   child: ListView.separated(
//                                       key: Key("loaded_otp"),
//                                       shrinkWrap: true,
//                                       physics: ScrollPhysics(),
//                                       itemBuilder: (context, id) {
//                                         return PaymentOption(
//                                             label: "a",
//                                             imageUrl:
//                                                 "${AppConst.STORAGE_URL}/bank/a",
//                                             selected: selectedPayment == id,
//                                             onTap: () {
//                                               setSheetState(() {
//                                                 selectedPayment = id;
//                                               });
//                                             });
//                                       },
//                                       separatorBuilder: (context, id) =>
//                                           SizedBox(
//                                             height: 15,
//                                           ),
//                                       itemCount: paymentMethod.length),
//                                 )
//                               : SizedBox.shrink(),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         RoundedButton.contained(
//                           label: "Ubah Pembayaran",
//                           disabled: selectedPayment == initialPayment,
//                           onPressed: () =>
//                               onChange(_paymentMethod[selectedPayment].id),
//                           isUpperCase: false,
//                         ),
//                         SizedBox(
//                           height: 15,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }));
//         });
//   }

//   void _showConfirmationDialog(
//       {@required BuildContext context, @required void Function() onYes}) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25.0)),
//             child: Container(
//               constraints: BoxConstraints(maxWidth: 500),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Apakah anda yakin untuk membatalkan pesanan?',
//                       style: AppTypo.body2,
//                       textAlign: TextAlign.center,
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

// class PaymentOption extends StatelessWidget {
//   final String label;
//   final String imageUrl;
//   final bool selected;
//   final VoidCallback onTap;

//   const PaymentOption({
//     Key key,
//     @required this.label,
//     @required this.imageUrl,
//     @required this.selected,
//     @required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final double _screenWidth = MediaQuery.of(context).size.width;
//     return InkWell(
//       borderRadius: BorderRadius.circular(7.5),
//       hoverColor: Colors.transparent,
//       splashColor: AppColor.primaryLight1.withOpacity(0.3),
//       highlightColor: AppColor.primaryLight2.withOpacity(0.3),
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColor.line, width: 1),
//           borderRadius: BorderRadius.circular(7.5),
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image(
//                   image: NetworkImage(
//                     imageUrl,
//                   ),
//                   width: 60,
//                   height: 54,
//                   fit: BoxFit.contain,
//                   errorBuilder: (context, object, stack) => Image.asset(
//                     AppImg.img_error,
//                     width: 60,
//                     height: 54,
//                   ),
//                   frameBuilder:
//                       (context, child, frame, wasSynchronouslyLoaded) {
//                     if (wasSynchronouslyLoaded) {
//                       return child;
//                     } else {
//                       return AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 500),
//                         child: frame != null
//                             ? child
//                             : Container(
//                                 width: 60,
//                                 height: 154,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.grey[200],
//                                 ),
//                               ),
//                       );
//                     }
//                   },
//                 )),
//             SizedBox(
//               width: _screenWidth * (4.5 / 100),
//             ),
//             Expanded(
//               child: Text(
//                 label.toUpperCase(),
//                 style: AppTypo.h3,
//               ),
//             ),
//             Icon(
//               selected
//                   ? FlutterIcons.check_circle_mco
//                   : FlutterIcons.checkbox_blank_circle_outline_mco,
//               color: AppColor.primary,
//               size: 35,
//             ),
//             SizedBox(
//               height: 15,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
