import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppCheckoutPaymentType extends StatefulWidget {
  const WppCheckoutPaymentType({Key key}) : super(key: key);

  @override
  _WppCheckoutPaymentTypeState createState() => _WppCheckoutPaymentTypeState();
}

class _WppCheckoutPaymentTypeState extends State<WppCheckoutPaymentType> {
  PaymentType _paymentType;

  @override
  void initState() {
    _paymentType = PaymentType.manual;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Metode Verifikasi Pembayaran',
        //   style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700),
        // ),
        // SizedBox(
        //   height: 5,
        // ),
        // GestureDetector(
        //   onTap: () => setState(() {
        //     _paymentType = PaymentType.manual;
        //   }),
        //   child: Container(
        //     height: 35,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           'Manual',
        //           style: AppTypo.body1v2,
        //         ),
        //         Radio(
        //           value: PaymentType.manual,
        //           groupValue: _paymentType,
        //           onChanged: (value) {
        //             setState(() {
        //               _paymentType = value;
        //             });
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // InkWell(
        //   onTap: () =>
        //       setState(() {
        //     _paymentType =
        //         PaymentType
        //             .otomatis;
        //   }),
        //   child: Container(
        //     height: 35,
        //     child: Row(
        //       mainAxisAlignment:
        //           MainAxisAlignment
        //               .spaceBetween,
        //       children: [
        //         Text(
        //           'Otomatis',
        //           style: AppTypo
        //               .body1v2,
        //         ),
        //         Radio(
        //           value: PaymentType
        //               .otomatis,
        //           groupValue:
        //               _paymentType,
        //           onChanged:
        //               (value) {
        //             setState(
        //                 () {
        //               _paymentType =
        //                   value;
        //             });
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 25,
        // ),
      ],
    );
  }
}
