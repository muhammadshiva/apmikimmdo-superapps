// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:beamer/beamer.dart';
// import 'package:marketplace/ui/widgets/web/dialog_web.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/images.dart' as AppImg;

// class PaymentDialogWebScreen extends StatefulWidget {
//   const PaymentDialogWebScreen({Key key, this.orderId}) : super(key: key);

//   final int orderId;

//   @override
//   _PaymentDialogWebScreenState createState() => _PaymentDialogWebScreenState();
// }

// class _PaymentDialogWebScreenState extends State<PaymentDialogWebScreen> {
//   @override
//   void initState() {
//     BlocProvider.of<HandleTransactionRouteWebCubit>(context)
//         .changeCheckCheckout(false);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final config = AAppConfig.of(context);
//     final String imagePath = config.appType == AppType.panenpanen
//         ? AppImg.img_logo_dark
//         : AppImg.img_logo_placeholder;
//     final double _screenWidth = MediaQuery.of(context).size.width;
//     Future.delayed(
//         Duration.zero,
//         () => showDialog(
//             context: context,
//             barrierDismissible: false,
//             useRootNavigator: false,
//             builder: (_) {
//               return PaymentDialog(orderId: widget.orderId);
//             }));

//     return Scaffold(
//       backgroundColor: AppColor.primary,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Column(
//               children: [
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Image.asset(
//                   imagePath,
//                   width: _screenWidth * (50 / 100),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PaymentDialog extends StatefulWidget {
//   const PaymentDialog({Key key, this.orderId}) : super(key: key);
//   final int orderId;

//   @override
//   _PaymentDialogState createState() => _PaymentDialogState();
// }

// class _PaymentDialogState extends State<PaymentDialog> {
//   int _paymentId;
//   bool _isPaymentModal = true;
//   bool _isPaymentDetailModal = false;

//   @override
//   Widget build(BuildContext context) {
//     return DialogWeb(
//         width: 600,
//         hasTitle: true,
//         onPressedClose: () {
//           BlocProvider.of<HandleTransactionRouteWebCubit>(context)
//               .changeCheckPaymentWeb(false);
//           AppExt.popScreen(context);
//           context.beamToNamed('/transactionlist');
//         },
//         title: _isPaymentModal == true ? "Metode Pembayaran" : "Pembayaran",
//         child: _isPaymentModal == true
//             ? PaymentModalContent(
//                 orderId: widget.orderId,
//                 onPayment: (value) {
//                   setState(() {
//                     _isPaymentModal = false;
//                     _isPaymentDetailModal = true;
//                     _paymentId = value;
//                   });
//                 },
//               )
//             : _isPaymentDetailModal == true
//                 ? PaymentDetailModalContent(
//                     paymentId: _paymentId,
//                   )
//                 : SizedBox());
//   }
// }
