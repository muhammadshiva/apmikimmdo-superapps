import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:beamer/beamer.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/alamat_pelanggan.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:marketplace/ui/screens/new_screens/checkout/widgets/checkout_item.dart';
import 'package:marketplace/ui/screens/new_screens/checkout/widgets/checkout_payment_type.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/checkout/wpp_checkout_item.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'widgets/checkout/wpp_checkout_payment_type.dart';

class WppCheckoutWebScreen extends StatefulWidget {
  const WppCheckoutWebScreen({Key key, this.cart, this.alamatPelangganWithCart})
      : super(key: key);

  final List<NewCart> cart;
  final AlamatPelangganWithCart alamatPelangganWithCart;

  @override
  _WppCheckoutWebScreenState createState() =>
      _WppCheckoutWebScreenState();
}

class _WppCheckoutWebScreenState
    extends State<WppCheckoutWebScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TransactionRepository _transRepo = TransactionRepository();

  List<WidgetIndexTemp> widgetIndexTemp = [];
  List<ShippingCodeTemp> shippingCodes = [];
  List<NoteTemp> notes = [];
  List<int> itemIds = [];
  List<OngkirTemp> ongkirs = [];

  int totalOngkirPrice = 0;
  PaymentType _paymentType = PaymentType.manual;

  @override
  void initState() {
    fillListId();
    super.initState();
  }

  void fillListId() {
    for (int i = 0; i < widget.cart.length; i++) {
      for (int k = 0; k < widget.cart[i].product.length; k++) {
        itemIds.add(widget.cart[i].product[k].id);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    // final bool _isKeyboardVisible =
    //     MediaQuery.of(context).viewInsets.bottom != 0;
    final int totalItem = widget.cart.fold(
      0,
      (previousValue, element) =>
          previousValue +
          element.product.fold(
              0, (previousValue, element) => previousValue + element.quantity),
    );
    final int subtotalPrice = widget.cart.fold(
      0,
      (previousValue, element) =>
          previousValue +
          (element.product.fold(
              0,
              (previousValue, element) =>
                  previousValue + (element.enduserPrice * element.quantity))),
    );

    return Center(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: !context.isPhone ? 450 : double.infinity),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
          child: GestureDetector(
              onTap: () => AppExt.hideKeyboard(context),
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  key: _scaffoldKey,
                  backgroundColor: Colors.white,
                  body: SafeArea(
                      child: Stack(
                    children: [
                      NestedScrollView(
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverAppBar(
                                iconTheme: IconThemeData(color: AppColor.black),
                                textTheme:
                                    TextTheme(headline6: AppTypo.subtitle2),
                                backgroundColor: Colors.white,
                                centerTitle: true,
                                forceElevated: false,
                                pinned: true,
                                shadowColor: Colors.black54,
                                floating: true,
                                title: Text("Checkout"),
                                brightness: Brightness.dark,
                              ),
                            ];
                          },
                          body: SingleChildScrollView(
                            physics: new BouncingScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Alamat pengiriman
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('Alamat Pengiriman',
                                            style: AppTypo.subtitle1.copyWith(
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                  Text(widget.alamatPelangganWithCart.nama,
                                      style: AppTypo.overline.copyWith(
                                          fontWeight: FontWeight.w700)),
                                  Text(widget.alamatPelangganWithCart.telepon,
                                      style: AppTypo.overline.copyWith(
                                          fontWeight: FontWeight.w700)),
                                  Text(widget.alamatPelangganWithCart.email,
                                      style: AppTypo.overline.copyWith(
                                          fontWeight: FontWeight.w700)),
                                  Text(widget.alamatPelangganWithCart.alamat,
                                      style: AppTypo.overline.copyWith(
                                          fontWeight: FontWeight.w700)),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Detail Pesanan',
                                    style: AppTypo.subtitle1
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  WppCheckoutItem(
                                    cart: widget.cart,
                                    enableCourier: true,
                                    courierSelected: (id, price, indexWidget,
                                        nameCourier, note) {
                                      if (widgetIndexTemp.length == 0) {
                                        debugPrint("ARRAY KOSONG");
                                        widgetIndexTemp.add(WidgetIndexTemp(
                                          indexWidget: indexWidget,
                                        ));
                                        shippingCodes.add(ShippingCodeTemp(
                                          id: id,
                                          shippingCode: nameCourier,
                                          indexWidget: indexWidget,
                                        ));
                                        ongkirs.add(OngkirTemp(
                                          id: id,
                                          ongkir: price,
                                          indexWidget: indexWidget,
                                        ));
                                        notes.add(NoteTemp(
                                          id: id,
                                          note: note,
                                          indexWidget: indexWidget,
                                        ));
                                      } else {
                                        for (int i = 0;
                                            i < widgetIndexTemp.length;
                                            i++) {
                                          if (widgetIndexTemp[i].indexWidget ==
                                              indexWidget) {
                                            debugPrint("MASUK KE 1");
                                            widgetIndexTemp.removeWhere((element) =>
                                                element.indexWidget == indexWidget);
                                            shippingCodes.removeWhere((element) =>
                                                element.indexWidget == indexWidget);
                                            notes.removeWhere((element) =>
                                                element.indexWidget == indexWidget);
                                            ongkirs.removeWhere((element) =>
                                                element.indexWidget == indexWidget);
                                            widgetIndexTemp.add(WidgetIndexTemp(
                                              indexWidget: indexWidget,
                                            ));
                                            shippingCodes.add(ShippingCodeTemp(
                                              id: id,
                                              shippingCode: nameCourier,
                                              indexWidget: indexWidget,
                                            ));
                                            ongkirs.add(OngkirTemp(
                                              id: id,
                                              ongkir: price,
                                              indexWidget: indexWidget,
                                            ));
                                            notes.add(NoteTemp(
                                              id: id,
                                              note: note,
                                              indexWidget: indexWidget,
                                            ));
                                          } else {
                                            debugPrint("MASUK KE 2");
                                            widgetIndexTemp.add(WidgetIndexTemp(
                                              indexWidget: indexWidget,
                                            ));
                                            shippingCodes.add(ShippingCodeTemp(
                                              id: id,
                                              shippingCode: nameCourier,
                                              indexWidget: indexWidget,
                                            ));
                                            ongkirs.add(OngkirTemp(
                                              id: id,
                                              ongkir: price,
                                              indexWidget: indexWidget,
                                            ));
                                            notes.add(NoteTemp(
                                              id: id,
                                              note: note,
                                              indexWidget: indexWidget,
                                            ));
                                          }
                                        }
                                      }
                                      setState(() {
                                        totalOngkirPrice = ongkirs.fold(
                                            0,
                                            (previousValue, element) =>
                                                previousValue + element.ongkir);
                                      });

                                      debugPrint("INDEX WIDGET SAAT INI : $indexWidget");
                                      debugPrint(
                                          "LENGTH ONGKIR SAAT INI : ${widgetIndexTemp.length}");
                                    },
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Ringkasan Pembayaran',
                                    style: AppTypo.subtitle1
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Text("Subtotal ( $totalItem item )",
                                          style: AppTypo.overline),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Rp ${AppExt.toRupiah(subtotalPrice)}",
                                          textAlign: TextAlign.right,
                                          style: AppTypo.overline,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: kIsWeb ? null : 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    children: [
                                      Text("Ongkos Kirim", style: AppTypo.overline),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Rp " +
                                              AppExt.toRupiah(
                                                  totalOngkirPrice ?? 0),
                                          textAlign: TextAlign.right,
                                          style: AppTypo.overline,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: kIsWeb ? null : 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: AppColor.line,
                                  ),
                                  Row(
                                    children: [
                                      Text("Total Pembayaran",
                                          style: AppTypo.body2),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: Text(
                                        totalOngkirPrice != null
                                            ? "Rp ${AppExt.toRupiah(subtotalPrice + totalOngkirPrice)}"
                                            : "Rp ${AppExt.toRupiah(subtotalPrice)}",
                                        textAlign: TextAlign.right,
                                        style: AppTypo.body2.copyWith(
                                            color: AppColor.primaryDark,
                                            fontWeight: FontWeight.w700),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: kIsWeb ? null : 1,
                                      )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 220,
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Color(0xFF21232C).withOpacity(0.05),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: Offset(0, -4),
                                    ),
                                  ]),
                              child: Column(
                                children: [
                                  //Voucher
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     AppExt.pushScreen(context, VoucherScreen());
                                  //   },
                                  //   child: Padding(
                                  //     padding: EdgeInsets.symmetric(
                                  //         horizontal: _screenWidth * 5 / 100,
                                  //         vertical: 15),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Container(
                                  //           child: Row(
                                  //             children: [
                                  //               SvgPicture.asset(
                                  //                 AppImg.ic_voucher_horizontal,
                                  //                 width: 20,
                                  //                 height: 20,
                                  //               ),
                                  //               SizedBox(
                                  //                 width: 20,
                                  //               ),
                                  //               Text("Gunakan Voucher")
                                  //             ],
                                  //           ),
                                  //         ),
                                  //         Icon(Icons.chevron_right),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Divider(
                                    height: 1,
                                  ),
                                  //Coin
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(
                                  //       horizontal: _screenWidth * 5 / 100,
                                  //       vertical: 15),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Container(
                                  //         child: Row(
                                  //           children: [
                                  //             SvgPicture.asset(
                                  //               AppImg.ic_coin,
                                  //               width: 20,
                                  //               height: 20,
                                  //             ),
                                  //             SizedBox(
                                  //               width: 20,
                                  //             ),
                                  //             Text("Tukarkan")
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Icon(Icons.chevron_right),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 17),
                              color: AppColor.primary,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Pembayaran",
                                          style: AppTypo.overlineInv,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          totalOngkirPrice != null
                                              ? "Rp ${AppExt.toRupiah(subtotalPrice + totalOngkirPrice)}"
                                              : "Rp ${AppExt.toRupiah(subtotalPrice)}",
                                          key: Key("price"),
                                          style: AppTypo.h3Inv.copyWith(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Theme(
                                    data: ThemeData(
                                        shadowColor: Colors.black38,
                                        splashColor: AppColor.primary),
                                    child: RoundedButton.contained(
                                      disabled: widgetIndexTemp.length <
                                          widget.cart.length,
                                      label: "Pembayaran",
                                      isCompact: true,
                                      color: AppColor.bgBadgeLightGreen,
                                      textColor: AppColor.appPrimary,
                                      isUpperCase: false,
                                      elevation: 6,
                                      onPressed: () {
                                        final WppCheckoutTempWeb dataCheckout = WppCheckoutTempWeb(
                                                    cart: widget.cart,
                                                    alamatPelangganWithCart: widget.alamatPelangganWithCart,
                                                    itemId: itemIds,
                                                    shippingCode: shippingCodes,
                                                    note: notes,
                                                    ongkir: ongkirs,
                                                    subtotal: subtotalPrice,
                                                    totalOngkir: totalOngkirPrice,
                                                    totalPayment: subtotalPrice +
                                                        totalOngkirPrice);
                                              
                                              
                                        if (_paymentType ==
                                            PaymentType.manual) {
                                              debugPrint("PEMBAYARAN MANUAL");
                                              _transRepo.setPaymentCheck(value: true);
                                              context.beamToNamed('/wpp/payment?dt=${AppExt.encryptMyData(jsonEncode(dataCheckout))}');
                                          // AppExt.pushScreen(
                                          //     context,
                                          //     PaymentScreen(
                                          //       checkoutTemp: 
                                          // CheckoutTempWeb(
                                          //           cart: widget.cart,
                                          //           itemId: itemIds,
                                          //           shippingCode: shippingCodes,
                                          //           note: notes,
                                          //           ongkir: ongkirs,
                                          //           subtotal: subtotalPrice,
                                          //           totalOngkir: totalOngkirPrice,
                                          //           totalPayment: subtotalPrice +
                                          //               totalOngkirPrice),
                                          //     ));
                                        }
                                        // debugPrint("CHECK CART :" +
                                        //     widget.cart.toString());
                                        // debugPrint("CHECK itemId :" +
                                        //     itemIds.toString());
                                        // debugPrint("CHECK shippingCode :" +
                                        //     shippingCodes.toString());
                                        // debugPrint("CHECK note :" +
                                        //     notes.toString());
                                        // debugPrint("CHECK ongkir :" +
                                        //     ongkirs.toString());
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )))),
        ),
      ),
    );
  }
}

class WidgetIndexTemp {
  //YANG DIGUNAKAN HANYA indexWidget Saja
  int indexWidget;

  WidgetIndexTemp({this.indexWidget});
}

