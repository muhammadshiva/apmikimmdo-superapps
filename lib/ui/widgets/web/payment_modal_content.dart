// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:intl/intl.dart';
// import 'package:beamer/beamer.dart';
// import 'package:marketplace/data/blocs/payment/add_payment/add_payment_cubit.dart';
// import 'package:marketplace/data/blocs/payment/cancel_payment/cancel_payment_cubit.dart';
// import 'package:marketplace/data/blocs/payment/fetch_payment_detail/fetch_payment_detail_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/data/models/payment.dart';
// import 'package:marketplace/ui/widgets/loading_dialog.dart';
// import 'package:marketplace/ui/widgets/rounded_button.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/images.dart' as AppImg;

// class PaymentModalContent extends StatefulWidget {
//   const PaymentModalContent({Key key, this.onPayment, this.orderId, this.isFromTransactionList, this.onCancelPayment})
//       : super(key: key);

//   final int orderId;
//   final bool isFromTransactionList;
//   final void Function(int) onPayment;
//   final Function onCancelPayment;

//   @override
//   _PaymentModalContentState createState() => _PaymentModalContentState();
// }

// class _PaymentModalContentState extends State<PaymentModalContent> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   FetchPaymentDetailCubit _fetchPaymentDetailCubit;
//   AddPaymentCubit _addPaymentCubit;
//   CancelPaymentCubit _cancelPaymentCubit;
//   int _selectedOpt = 0;
//   Payment _selectedPayment;
//   bool _isPaymentSuccess = false;

//   @override
//   void initState() {
//     _fetchPaymentDetailCubit = FetchPaymentDetailCubit()
//       ..getPaymentOrder(orderId: widget.orderId);
//     _addPaymentCubit = AddPaymentCubit();
//     _cancelPaymentCubit = CancelPaymentCubit();
//     super.initState();
//   }

//   void _handleSubmit(
//       {@required int paymentMethodId, @required int orderId}) async {
//     LoadingDialog.show(context);
//     _addPaymentCubit.addPayment(
//         paymentMethodId: paymentMethodId, orderId: orderId);
//   }

//   void _handleCancelPayment({@required int orderId}) async {
//     LoadingDialog.show(context);
//     _cancelPaymentCubit.cancelPayment(orderId: orderId);
//   }

//   String toRupiah(int number) {
//     final currencyFormatter = NumberFormat('#,##0', 'ID');
//     return currencyFormatter.format(number);
//   }

//   @override
//   void dispose() {
//     _fetchPaymentDetailCubit.close();
//     _addPaymentCubit.close();
//     _cancelPaymentCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => _fetchPaymentDetailCubit),
//           BlocProvider(create: (_) => _addPaymentCubit),
//           BlocProvider(create: (_) => _cancelPaymentCubit),
//         ],
//         child: MultiBlocListener(
//           listeners: [
//             BlocListener(
//               cubit: _fetchPaymentDetailCubit,
//               listener: (_, state) {
//                 if (state is FetchPaymentDetailSuccess) {
//                   setState(() {
//                     _selectedPayment = state.paymentMethod.length != 0
//                         ? state.paymentMethod[_selectedOpt]
//                         : null;
//                   });
//                   return;
//                 }
//                 if (state is FetchPaymentDetailFailure) {
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Terjadi kesalahan"))
//                 );
//                   return;
//                 }
//               },
//             ),
//             BlocListener(
//               cubit: _addPaymentCubit,
//               listener: (_, state) async {
//                 if (state is AddPaymentSuccess) {
//                   AppExt.popScreen(context);
//                   widget.onPayment(state.data.id);
//                   // debugPrint("payment success");
//                   return;
//                 }
//                 if (state is AddPaymentFailure) {
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar( backgroundColor: Colors.grey[900] ,content: Text("Terjadi kesalahan")));
//                   return;
//                 }
//               },
//             ),
//             BlocListener(
//               cubit: _cancelPaymentCubit,
//               listener: (_, state) async {
//                 if (state is CancelPaymentSuccess) {
//                   if (widget.isFromTransactionList == true) {
//                     AppExt.popScreen(context);
//                     widget.onCancelPayment();
//                   }else{
//                     AppExt.popScreen(context);
//                     AppExt.popScreen(context);
//                     context.beamToNamed('/transactionlist');
                    
//                   }
//                   // if (kIsWeb) {
//                   //   context.beamToNamed('/');
//                   //   // AppExt.popUntilRoot(context);
//                   // } else {
//                   //   BlocProvider.of<BottomNavCubit>(context)
//                   //       .navItemTapped(3);
//                   //   AppExt.popUntilRoot(context);
//                   // }

//                   return;
//                 }
//                 if (state is CancelPaymentFailure) {
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar( backgroundColor: Colors.grey[900] ,content: Text("Terjadi kesalahan")));
//                   return;
//                 }
//               },
//             ),
//           ],
//           child: Scrollbar(
//             isAlwaysShown: true,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 child: BlocBuilder(
//                   cubit: _fetchPaymentDetailCubit,
//                   builder: (context, state) =>
//                       AppTrans.SharedAxisTransitionSwitcher(
//                     fillColor: Colors.transparent,
//                     transitionType: SharedAxisTransitionType.vertical,
//                     child: state is FetchPaymentDetailLoading
//                         ? Center(
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation(AppColor.primary),
//                         ),
//                       ),
//                     )
//                         : state is FetchPaymentDetailFailure
//                             ? _buildError()
//                             : state is FetchPaymentDetailSuccess
//                                 ? _buildPaymentDetail(
//                                     summary: state.summary,
//                                     order: state.order,
//                                     paymentMethod: state.paymentMethod)
//                                 : SizedBox.shrink(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }

//   Widget _buildOption(double _screenWidth, String label, String imageUrl,
//       bool selected, VoidCallback onTap, BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(7.5),
//       splashColor: AppColor.primaryLight1.withOpacity(0.3),
//       highlightColor: AppColor.primaryLight2.withOpacity(0.3),
//       hoverColor: Colors.transparent,
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
//                   height: 56,
//                   fit: BoxFit.contain,
//                   errorBuilder: (context, object, stack) => Image.asset(
//                     AppImg.img_error,
//                     width: 60,
//                     height: 56,
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
//                                 height: 56,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(7.5),
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
//                 style: AppTypo.h3.copyWith(fontSize: 20),
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

//   Widget _buildError() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             FlutterIcons.error_outline_mdi,
//             size: 45,
//             color: AppColor.primaryDark,
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           SizedBox(
//             width: 250,
//             child: Text(
//               "Terjadi Kesalahan",
//               style: AppTypo.overlineAccent,
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(
//             height: 7,
//           ),
//           OutlineButton(
//             child: Text("Coba lagi"),
//             onPressed: () =>
//                 _fetchPaymentDetailCubit.getPaymentOrder(orderId: widget.orderId),
//             textColor: AppColor.primaryDark,
//             color: AppColor.danger,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentDetail({
//     @required List<OrderSummary> summary,
//     @required CheckoutOrder order,
//     @required List<Payment> paymentMethod,
//   }) {
//     final double _screenWidth = MediaQuery.of(context).size.width;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
        
//         Text(
//           'Ringkasan Pembayaran',
//           style: AppTypo.body1.copyWith(fontSize: 14,fontWeight: FontWeight.w700),
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Subtotal (" + summary.length.toString() + " item)",
//                 style: AppTypo.body1.copyWith(fontSize: 14)
//               ),
//             SizedBox(
//               width: 20,
//             ),
//             Expanded(
//               child: Text(
//                 "Rp ${AppExt.toRupiah(order.subtotal)}",
//                 textAlign: TextAlign.right,
//                 style: AppTypo.body1.copyWith(fontSize: 14)
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Ongkos Kirim", style: AppTypo.body1.copyWith(fontSize: 14)),
//             SizedBox(
//               width: 20,
//             ),
//             Expanded(
//               child: Text(
//                 "Rp ${AppExt.toRupiah(order.ongkir)}",
//                 textAlign: TextAlign.right,
//                 style: AppTypo.body1.copyWith(fontSize: 14)
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Divider(
//           thickness: 1,
//                                                     color:
//                                                         AppColor.textSecondary2,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("TOTAL",
//                 style: AppTypo.body1.copyWith(fontSize: 14,fontWeight: FontWeight.w900,color: AppColor.primary)),
//             SizedBox(
//               width: 20,
//             ),
//             Expanded(
//               child: Text(
//                 "Rp ${AppExt.toRupiah(order.totalPayment)}",
//                 textAlign: TextAlign.right,
//                 style: AppTypo.body1.copyWith(fontSize: 14,fontWeight: FontWeight.w900,color: AppColor.primary)
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 25,
//         ),
//         // Text(
//         //   'Ringkasan Belanja',
//         //   style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700),
//         // ),
//         // SizedBox(
//         //   height: 15,
//         // ),
//         ExpandableCardWeb(
//           title: "Ringkasan Belanja",
//           child: Padding(
//             padding: EdgeInsets.all(15),
//             child: ListView.separated(
//             physics: new NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: summary.length,
//             separatorBuilder: (_, __) {
//               return SizedBox(
//                 height: 15,
//               );
//             },
//             itemBuilder: (context, index) {
//               OrderSummary item = summary[index];
//               return Row(
//                 children: [
//                   Text(item.quantity.toString() + "x",
//                       style: AppTypo.body1.copyWith(fontSize: 14)),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Text(
//                       item.productName,
//                       textAlign: TextAlign.left,
//                       style:
//                           AppTypo.body1.copyWith(fontSize: 14),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Text(
//                       "Rp ${AppExt.toRupiah(item.subtotal)}",
//                       textAlign: TextAlign.right,
//                       style:
//                           AppTypo.body1.copyWith(fontSize: 14),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: kIsWeb? null : 1,
//                     ),
//                   ),
//                 ],
//               );
//             },
//         ),
//           ),
//         ),
        
//         SizedBox(height: 10),
//         Divider(
//           color: AppColor.line,
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Text(
//           'Pilih Metode Pembayaran',
//           style: AppTypo.body1.copyWith(fontSize: 14,fontWeight: FontWeight.w700)
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         paymentMethod != null
//             ? ListView.separated(
//                 key: Key("loaded_otp"),
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, id) {
//                   // return Text("hahahah");
//                   return _buildOption(
//                       _screenWidth,
//                       "a}",
//                       "${AppConst.STORAGE_URL}/bank/a",
//                       // NetworkImage(
//                       //     "${AppConst.STORAGE_URL}/bank/${paymentMethod[id].image}"),
//                       _selectedOpt == id, () {
//                     setState(() {
//                       _selectedOpt = id;
//                       _selectedPayment = paymentMethod[id];
//                     });
//                   }, context);
//                 },
//                 separatorBuilder: (context, id) => SizedBox(
//                       height: 15,
//                     ),
//                 itemCount: paymentMethod.length)
//             : SizedBox.shrink(
//                 key: Key("else_otp"),
//               ),
//         SizedBox(
//           height: 25,
//         ),
//         RoundedButton.contained(
//           disabled: _isPaymentSuccess || paymentMethod.length == 0,
//           key: const Key('signInScreen_signIn_roundedButton'),
//           label: "Bayar",
//           onPressed: () => _handleSubmit(
//               paymentMethodId: _selectedPayment.id, orderId: order.id),
//           isUpperCase: false,
//         ),
//         SizedBox(
//           height: 30,
//         ),
//         Center(
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () => _handleCancelPayment(orderId: order.id),
//               borderRadius: BorderRadius.circular(10),
//               highlightColor: AppColor.danger.withOpacity(0.2),
//               splashColor: AppColor.danger.withOpacity(0.2),
//               splashFactory: InkRipple.splashFactory,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Text(
//                   "Batalkan Pembayaran",
//                   style: AppTypo.button.copyWith(
//                       fontWeight: FontWeight.w500,
//                       color: AppColor.danger,
//                       fontSize: 14),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 30,
//         ),
//       ],
//     );
//   }

//   Widget _buildPaymentDetailShimmer() {
//     final double _screenWidth = MediaQuery.of(context).size.width;

//     Widget _unShim = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: _screenWidth * 0.4,
//           height: 20,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: _screenWidth * 0.2,
//               height: 15,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey[200]),
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Expanded(child: SizedBox()),
//             Container(
//               width: _screenWidth * 0.3,
//               height: 15,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey[200]),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: _screenWidth * 0.2,
//               height: 15,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey[200]),
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Expanded(child: SizedBox()),
//             Container(
//               width: _screenWidth * 0.3,
//               height: 15,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey[200]),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Divider(
//           color: AppColor.line,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: _screenWidth * 0.2,
//               height: 15,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey[200]),
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Expanded(child: SizedBox()),
//             Container(
//               width: _screenWidth * 0.3,
//               height: 15,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.grey[200]),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 25,
//         ),
//         Container(
//           width: _screenWidth * 0.4,
//           height: 20,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         ListView.separated(
//           physics: new NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: 1,
//           separatorBuilder: (_, __) {
//             return SizedBox(
//               height: 15,
//             );
//           },
//           itemBuilder: (context, index) {
//             return Row(
//               children: [
//                 Container(
//                   width: _screenWidth * 0.2,
//                   height: 15,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: Colors.grey[200]),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Container(
//                   width: _screenWidth * 0.3,
//                   height: 15,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: Colors.grey[200]),
//                 ),
//                 Spacer(
//                   flex: 1,
//                 ),
//                 Container(
//                   width: _screenWidth * 0.3,
//                   height: 15,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: Colors.grey[200]),
//                 ),
//               ],
//             );
//           },
//         ),
//         SizedBox(height: 10),
//         Divider(
//           color: AppColor.line,
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Container(
//           width: _screenWidth * 0.4,
//           height: 20,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5), color: Colors.white),
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         ListView.separated(
//             key: Key("loading_otp"),
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, id) => _buildSimmer(),
//             separatorBuilder: (context, id) => SizedBox(
//                   height: 15,
//                 ),
//             itemCount: 5),
//       ],
//     );

//     return _unShim;
//   }

//   Widget _buildSimmer() {
//     Random rnd;
//     rnd = new Random();
//     double rTitle = (70 + rnd.nextInt(100 - 70)).toDouble();
//     double rSubtitle = (120 + rnd.nextInt(170 - 120)).toDouble();

//     final double _screenWidth = MediaQuery.of(context).size.width;

//     Widget _unShim2 = Row(
//       children: [
//         Container(
//           width: _screenWidth * (17.5 / 100),
//           height: _screenWidth * (13 / 100),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
//         ),
//         SizedBox(
//           width: _screenWidth * (4.5 / 100),
//         ),
//         Container(
//           height: 20,
//           width: rTitle,
//           color: Colors.grey[200],
//         ),
//         Spacer(),
//         Icon(
//           FlutterIcons.checkbox_blank_circle_outline_mco,
//           color: AppColor.primary,
//           size: 35,
//         ),
//         SizedBox(
//           height: 15,
//         ),
//       ],
//     );

//     return Container(
//       padding: EdgeInsets.all(_screenWidth * (4.5 / 100)),
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColor.line, width: 1),
//         borderRadius: BorderRadius.circular(7.5),
//       ),
//       child: _unShim2,
//     );
//   }
// }


// // class _PaymentDetailWidget extends StatelessWidget {
// //   const _PaymentDetailWidget({
// //     Key key,
// //     @required this.summary,
// //     @required this.order,
// //     @required this.paymentMethod,
// //   }) : super(key: key);

// //   final List<OrderSummary> summary;
// //   final CheckoutOrder order;
// //   final List<Payment> paymentMethod;

// //   @override
// //   Widget build(BuildContext context) {
// //     final double _screenWidth = MediaQuery.of(context).size.width;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         Text(
// //           'Ringkasan Pembayaran',
// //           style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700),
// //         ),
// //         SizedBox(
// //           height: 15,
// //         ),
// //         Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text("Subtotal (" + summary.length.toString() + " item)",
// //                 style: AppTypo.overline),
// //             SizedBox(
// //               width: 20,
// //             ),
// //             Expanded(
// //               child: Text(
// //                 "Rp ${AppExt.toRupiah(order.subtotal)}",
// //                 textAlign: TextAlign.right,
// //                 style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
// //               ),
// //             ),
// //           ],
// //         ),
// //         SizedBox(
// //           height: 10,
// //         ),
// //         Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text("Ongkos Kirim", style: AppTypo.overline),
// //             SizedBox(
// //               width: 20,
// //             ),
// //             Expanded(
// //               child: Text(
// //                 "Rp ${AppExt.toRupiah(order.ongkir)}",
// //                 textAlign: TextAlign.right,
// //                 style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
// //               ),
// //             ),
// //           ],
// //         ),
// //         SizedBox(
// //           height: 10,
// //         ),
// //         Divider(
// //           color: AppColor.line,
// //         ),
// //         SizedBox(
// //           height: 10,
// //         ),
// //         Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text("TOTAL",
// //                 style: AppTypo.overline.copyWith(color: AppColor.primary)),
// //             SizedBox(
// //               width: 20,
// //             ),
// //             Expanded(
// //               child: Text(
// //                 "Rp ${AppExt.toRupiah(order.totalPayment)}",
// //                 textAlign: TextAlign.right,
// //                 style: AppTypo.overline.copyWith(
// //                     fontWeight: FontWeight.w700, color: AppColor.primary),
// //               ),
// //             ),
// //           ],
// //         ),
// //         SizedBox(
// //           height: 25,
// //         ),
// //         Text(
// //           'Ringkasan Belanja',
// //           style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700),
// //         ),
// //         SizedBox(
// //           height: 15,
// //         ),
// //         ListView.separated(
// //           physics: new NeverScrollableScrollPhysics(),
// //           shrinkWrap: true,
// //           itemCount: summary.length,
// //           separatorBuilder: (_, __) {
// //             return SizedBox(
// //               height: 15,
// //             );
// //           },
// //           itemBuilder: (context, index) {
// //             OrderSummary item = summary[index];
// //             return Row(
// //               children: [
// //                 Text(item.quantity.toString() + "x",
// //                     style: AppTypo.overline.copyWith(color: AppColor.primary)),
// //                 SizedBox(
// //                   width: 20,
// //                 ),
// //                 Expanded(
// //                   flex: 1,
// //                   child: Text(
// //                     item.productName,
// //                     textAlign: TextAlign.left,
// //                     style:
// //                         AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   flex: 1,
// //                   child: Text(
// //                     "Rp ${AppExt.toRupiah(item.subtotal)}",
// //                     textAlign: TextAlign.right,
// //                     style:
// //                         AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
// //                     overflow: TextOverflow.ellipsis,
// //                     maxLines: kIsWeb? null : 1,
// //                   ),
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //         SizedBox(height: 10),
// //         Divider(
// //           color: AppColor.line,
// //         ),
// //         SizedBox(
// //           height: 20,
// //         ),
// //         Text(
// //           'Pilih Metode Pembayaran',
// //           style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700),
// //         ),
// //         SizedBox(
// //           height: 15,
// //         ),
// //         paymentMethod != null
// //             ? ListView.separated(
// //                 key: Key("loaded_otp"),
// //                 shrinkWrap: true,
// //                 physics: NeverScrollableScrollPhysics(),
// //                 itemBuilder: (context, id) {
// //                   return Text("huhuh");
// //                   // return _buildOption(
// //                   //     _screenWidth,
// //                   //     "${paymentMethod[id].name}",
// //                   //     "${AppConst.STORAGE_URL}/bank/${paymentMethod[id].image}",
// //                   //     // NetworkImage(
// //                   //     //     "${AppConst.STORAGE_URL}/bank/${paymentMethod[id].image}"),
// //                   //     _selectedOpt == id, () {
// //                   //   setState(() {
// //                   //     _selectedOpt = id;
// //                   //     _selectedPayment = paymentMethod[id];
// //                   //   });
// //                   // });
// //                 },
// //                 separatorBuilder: (context, id) => SizedBox(
// //                       height: 15,
// //                     ),
// //                 itemCount: paymentMethod.length)
// //             : SizedBox.shrink(
// //                 key: Key("else_otp"),
// //               ),
// //         SizedBox(
// //           height: 25,
// //         ),
// //         // RoundedButton.contained(
// //         //   disabled: _isPaymentSuccess || paymentMethod.length == 0,
// //         //   key: const Key('signInScreen_signIn_roundedButton'),
// //         //   label: "Bayar",
// //         //   onPressed: () => _handleSubmit(
// //         //       paymentMethodId: _selectedPayment.id, orderId: order.id),
// //         //   isUpperCase: false,
// //         // ),
// //         SizedBox(
// //           height: 30,
// //         ),
// //         Center(
// //           child: Material(
// //             color: Colors.transparent,
// //             child: InkWell(
// //               onTap: () {},
// //               // onTap: () => _handleCancelPayment(orderId: order.id),
// //               borderRadius: BorderRadius.circular(10),
// //               highlightColor: AppColor.danger.withOpacity(0.2),
// //               splashColor: AppColor.danger.withOpacity(0.2),
// //               splashFactory: InkRipple.splashFactory,
// //               child: Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
// //                 child: Text(
// //                   "Batalkan Pembayaran",
// //                   style: AppTypo.button.copyWith(
// //                       fontWeight: FontWeight.w500,
// //                       color: AppColor.danger,
// //                       fontSize: 14),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(
// //           height: 30,
// //         ),
// //       ],
// //     );
// //   }
// // }



