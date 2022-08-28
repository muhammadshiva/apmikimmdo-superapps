import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/order/cancel_order/cancel_order_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/order/change_payment_method/change_payment_method_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/order/fetch_payment_method/fetch_payment_method_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/wpp_cart/add_to_cart_offline/add_to_cart_offline_cubit.dart';
import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:marketplace/data/repositories/repositories.dart';

import 'package:marketplace/ui/screens/main_screen.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_invoice_payment_web_screen.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/web/dialog_web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:shimmer/shimmer.dart';

class WppPaymentDetailWebScreen extends StatefulWidget {
  final GeneralOrderResponseData orderData;
  final WppCheckoutTempWeb checkoutTempWeb;

  WppPaymentDetailWebScreen(
      {Key key, @required this.orderData, @required this.checkoutTempWeb})
      : super(key: key);

  @override
  _WppPaymentDetailWebScreenState createState() =>
      _WppPaymentDetailWebScreenState();
}

class _WppPaymentDetailWebScreenState extends State<WppPaymentDetailWebScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  JoinUserRepository _repo = JoinUserRepository();
  TransactionRepository _transRepo = TransactionRepository();
  final RecipentRepository _recipentRepo = RecipentRepository();

  @override
  void initState() {
    if (_transRepo.getPaymentDetailCheck() == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recipentRepo.setRecipentUserNoAuthDashboard(
          subdistrictId:
              _recipentRepo.getSelectedRecipentNoAuth()['subdistrict_id'],
          subdistrict: _recipentRepo.getSelectedRecipentNoAuth()['subdistrict'],
          city: _recipentRepo.getSelectedRecipentNoAuth()['city'],
          province: _recipentRepo.getSelectedRecipentNoAuth()['province'],
          name: _recipentRepo.getSelectedRecipentNoAuth()['name'],
          address: _recipentRepo.getSelectedRecipentNoAuth()['address'],
          phone: _recipentRepo.getSelectedRecipentNoAuth()['phone'],
        );
        context.beamToNamed('/wpp/dashboard/${_repo.getSlugReseller()}');
      });
     
    }
    super.initState();
  }

  void _handleCopy(String text, String message) {
    Clipboard.setData(new ClipboardData(text: text));
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        new SnackBar(
          backgroundColor: Colors.grey[900],
          content: new Text(
            message,
          ),
          duration: Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final config = AAppConfig.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: GestureDetector(
        onTap: () => AppExt.hideKeyboard(context),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: !context.isPhone ? 450 : 1000,
            ),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              body: SafeArea(
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        textTheme: TextTheme(headline6: AppTypo.subtitle2),
                        iconTheme: IconThemeData(color: AppColor.black),
                        backgroundColor: Colors.white,
                        centerTitle: true,
                        forceElevated: false,
                        pinned: true,
                        shadowColor: Colors.black54,
                        floating: true,
                        //     leading: IconButton(
                        // splashRadius: 20,
                        // icon: Icon(FlutterIcons.arrow_back_mdi),
                        // onPressed: ()=>AppExt.popScreen(context)),
                        title: Text("Pembayaran"),
                        brightness: Brightness.dark,
                      ),
                    ];
                  },
                  body: AppTrans.SharedAxisTransitionSwitcher(
                      transitionType: SharedAxisTransitionType.vertical,
                      fillColor: Colors.transparent,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: !context.isPhone
                                ? 20
                                : _screenWidth * (10 / 100),
                            vertical: !context.isPhone
                                ? 0
                                : _screenWidth * (3 / 100)),
                        children: [
                          Image.asset(
                            AppImg.img_payment_success,
                            height: !context.isPhone
                                ? 200
                                : _screenWidth * (50 / 100),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                              child: Text("Selamat, pemesanan anda berhasil!",
                                  style: AppTypo.LatoBold.copyWith(
                                      fontSize: 18, color: AppColor.primary))),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            "Silahkan transfer ke nomor rekening berikut agar pesanan dapat segera kami proses",
                            textAlign: TextAlign.center,
                            style: AppTypo.body2Lato
                                .copyWith(color: AppColor.grey),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Transfer ke nomor rekening",
                                style: AppTypo.caption,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    image: NetworkImage(
                                      widget.orderData.payment.paymentMethod
                                          .image,
                                    ),
                                    width: !context.isPhone
                                        ? 75
                                        : _screenWidth * (17.5 / 100),
                                    height: !context.isPhone
                                        ? 70
                                        : _screenWidth * (13 / 100),
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, object, stack) =>
                                        Image.asset(
                                      AppImg.img_error,
                                      width: !context.isPhone
                                          ? 60
                                          : _screenWidth * (17.5 / 100),
                                      height: !context.isPhone
                                          ? 56
                                          : _screenWidth * (13 / 100),
                                    ),
                                    frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) {
                                        return child;
                                      } else {
                                        return AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: frame != null
                                              ? child
                                              : Container(
                                                  width: !context.isPhone
                                                      ? 60
                                                      : _screenWidth *
                                                          (17.5 / 100),
                                                  height: !context.isPhone
                                                      ? 56
                                                      : _screenWidth *
                                                          (13 / 100),
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.grey[200]),
                                                ),
                                        );
                                      }
                                    },
                                  )),
                              SizedBox(
                                width: !context.isPhone
                                    ? 10
                                    : _screenWidth * (4.5 / 100),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.orderData.payment.paymentMethod.accountNumber}",
                                      style: AppTypo.subtitle1.copyWith(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "a/n ${widget.orderData.payment.paymentMethod.accountName}",
                                      style: AppTypo.overline,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 27,
                                child: OutlineButton(
                                  borderSide: BorderSide(
                                    color: AppColor.primary,
                                  ),
                                  highlightColor:
                                      AppColor.primary.withOpacity(0.3),
                                  splashColor:
                                      AppColor.primary.withOpacity(0.3),
                                  highlightedBorderColor: AppColor.primary,
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onPressed: () => _handleCopy(
                                      widget.orderData.payment.paymentMethod
                                          .accountNumber,
                                      "Nomor rekening telah disalin"),
                                  child: Text(
                                    "Salin Nomor Rekening",
                                    style: AppTypo.caption
                                        .copyWith(color: AppColor.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: AppColor.line),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Jumlah yang harus ditransfer",
                            style: AppTypo.caption,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Rp" +
                                AppExt.toRupiah(
                                    widget.orderData.payment.amount),
                            style: AppTypo.h3.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColor.primary),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 27,
                                child: OutlineButton(
                                  borderSide: BorderSide(
                                    color: AppColor.primary,
                                  ),
                                  highlightColor:
                                      AppColor.primary.withOpacity(0.3),
                                  splashColor:
                                      AppColor.primary.withOpacity(0.3),
                                  highlightedBorderColor: AppColor.primary,
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onPressed: () => _handleCopy(
                                      widget.orderData.payment.amount
                                          .toString(),
                                      "Jumlah transfer telah disalin"),
                                  child: Text(
                                    "Salin Jumlah",
                                    style: AppTypo.caption
                                        .copyWith(color: AppColor.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Kode Transaksi",
                            style: AppTypo.caption,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${widget.orderData.payment.transactionCode}",
                            style: AppTypo.h3
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 27,
                                child: OutlineButton(
                                  borderSide: BorderSide(
                                    color: AppColor.primary,
                                  ),
                                  highlightColor:
                                      AppColor.primary.withOpacity(0.3),
                                  splashColor:
                                      AppColor.primary.withOpacity(0.3),
                                  highlightedBorderColor: AppColor.primary,
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onPressed: () => _handleCopy(
                                      widget.orderData.payment.transactionCode,
                                      "Kode transaksi telah disalin"),
                                  child: Text(
                                    "Salin Kode Transaksi",
                                    style: AppTypo.caption
                                        .copyWith(color: AppColor.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 13, 13, 13),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: AppColor.primary, width: 1),
                                  color: AppColor.primary.withOpacity(0.2),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info,
                                        color:
                                            AppColor.primary.withOpacity(0.5)),
                                    SizedBox(width: 3),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Icon(Icons.circle,
                                                    color: AppColor.textPrimary,
                                                    size: 7),
                                              ),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                    "Silakan selesaikan pembayaran anda dengan bank yang sudah anda pilih",
                                                    style: AppTypo.caption),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Icon(Icons.circle,
                                                    color: AppColor.textPrimary,
                                                    size: 7),
                                              ),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                    "Setelah anda sudah membayar silahkan menunggu konfirmasi dari penjual dan pesanan anda akan segera di proses",
                                                    style: AppTypo.caption),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              RoundedButton.contained(
                                label: "Belanja Lagi",
                                onPressed: () {
                                  context.read<AddToCartOfflineCubit>().reset();
                                  _transRepo.setPaymentDetailCheck(
                                      value: false);
                                  _recipentRepo.setRecipentUserNoAuthDashboard(
                                    subdistrictId: _recipentRepo
                                            .getSelectedRecipentNoAuth()[
                                        'subdistrict_id'],
                                    subdistrict: _recipentRepo
                                            .getSelectedRecipentNoAuth()[
                                        'subdistrict'],
                                    city: _recipentRepo
                                        .getSelectedRecipentNoAuth()['city'],
                                    province: _recipentRepo
                                            .getSelectedRecipentNoAuth()[
                                        'province'],
                                    name: _recipentRepo
                                        .getSelectedRecipentNoAuth()['name'],
                                    address: _recipentRepo
                                        .getSelectedRecipentNoAuth()['address'],
                                    phone: _recipentRepo
                                        .getSelectedRecipentNoAuth()['phone'],
                                  );
                                  context.beamToNamed(
                                      '/wpp/dashboard/${_repo.getSlugReseller()}');
                                },
                                isUpperCase: false,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              RoundedButton.outlined(
                                label: "Download Invoice",
                                onPressed: () {
                                  WppInvoice wppInvoice = WppInvoice(
                                      order: widget.orderData,
                                      checkout: widget.checkoutTempWeb);
                                  context.beamToNamed(
                                      '/wpp/invoice?dt=${AppExt.encryptMyData(jsonEncode(wppInvoice))}');
                                },
                                isUpperCase: false,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
