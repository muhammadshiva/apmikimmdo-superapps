import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/widgets/web/dialog_web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/images.dart' as AppImg;

class CheckoutSuccessDialogWebScreen extends StatefulWidget {
  final List<CartProduct> cart;
  final int sellerId;

  const CheckoutSuccessDialogWebScreen({Key key, this.cart, this.sellerId})
      : super(key: key);

  @override
  _CheckoutSuccessDialogWebScreenState createState() =>
      _CheckoutSuccessDialogWebScreenState();
}

class _CheckoutSuccessDialogWebScreenState
    extends State<CheckoutSuccessDialogWebScreen> {
  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final String imagePath = AppImg.img_logo_dark;

    Future.delayed(
        Duration.zero,
        () => showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: false,
            builder: (_) {
              return CheckoutSuccessDialogContent(
                cart: widget.cart,
                sellerId: widget.sellerId,
              );
            }));

    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  imagePath,
                  width: _screenWidth * (50 / 100),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutSuccessDialogContent extends StatelessWidget {
  const CheckoutSuccessDialogContent({Key key, this.cart, this.sellerId})
      : super(key: key);

  final List<CartProduct> cart;
  final int sellerId;

  @override
  Widget build(BuildContext context) {
    return DialogWeb(
      height: 400,
      onPressedClose: () {
        context.beamToNamed('/');
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          // mainAxisSize: MainAxisSize.,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppColor.primary,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Checkout Sukses",
              textAlign: TextAlign.center,
              style: AppTypo.h3,
            ),
            Text("Silahkan menuju ke halaman checkout",
                textAlign: TextAlign.center, style: AppTypo.subtitle2Accent),
            SizedBox(
              height: 20,
            ),
            RoundedButton.contained(
                label: "Menuju halaman checkout",
                isUpperCase: false,
                isSmall: true,
                onPressed: () {
                  context.beamToNamed(
                    '/checkout/cart/$sellerId?c=${AppExt.encryptMyData(json.encode(cart))}',
                  );
                })
          ],
        ),
      ),
    );
  }
}
