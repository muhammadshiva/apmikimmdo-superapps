import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/order/cancel_order/cancel_order_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/order/change_payment_method/change_payment_method_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/order/fetch_payment_method/fetch_payment_method_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/invoice/invoice_payment_screen.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:shimmer/shimmer.dart';

class PaymentDetailScreen extends StatefulWidget {
  final GeneralOrderResponseData orderData;
  final CheckoutTemp checkoutTemp;

  PaymentDetailScreen({Key key, @required this.orderData, this.checkoutTemp})
      : super(key: key);

  @override
  _PaymentDetailScreenState createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FetchPaymentMethodCubit _fetchPaymentMethodCubit;
  ChangePaymentMethodCubit _changePaymentMethodCubit;
  CancelOrderCubit _cancelOrderCubit;

  int _selectedPaymentIndex;

  @override
  void initState() {
    _selectedPaymentIndex = null;
    _cancelOrderCubit = CancelOrderCubit();
    _fetchPaymentMethodCubit = FetchPaymentMethodCubit()..load();
    _changePaymentMethodCubit = ChangePaymentMethodCubit();
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

  // void _handleConfirmPayment({@required int paymentId}) async {
  //   LoadingDialog.show(context);
  //   await Future.delayed(Duration(seconds: 1));
  //   await _changePaymentStatusCubit.confirmPayment(paymentId: paymentId);
  // }

  void _handleCancelOrder({@required int paymentId}) async {
    LoadingDialog.show(context);
    await Future.delayed(Duration(seconds: 1));
    await _cancelOrderCubit.cancelOrder(paymentId: paymentId);
     AppExt.popScreen(context);
  }

  @override
  void dispose() {
    _cancelOrderCubit.close();
    _fetchPaymentMethodCubit.close();
    _changePaymentMethodCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final config = AAppConfig.of(context);

    return new WillPopScope(
      onWillPop: () async {
        AppExt.popUntilRoot(context);
        return;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _fetchPaymentMethodCubit),
          BlocProvider(create: (_) => _changePaymentMethodCubit),
          BlocProvider(create: (_) => _cancelOrderCubit),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                            iconTheme: IconThemeData(color: Colors.black54),
                            backgroundColor: Colors.white,
                            centerTitle: true,
                            forceElevated: false,
                            pinned: true,
                            shadowColor: Colors.black54,
                            floating: true,
                            leading: IconButton(
                                splashRadius: 20,
                                icon: Icon(FlutterIcons.arrow_back_mdi),
                                onPressed: () => AppExt.popScreen(context)),
                            title: Text("Pembayaran"),
                            brightness: Brightness.dark,
                          ),
                        ];
                      },
                      body: MultiBlocListener(
                        listeners: [
                          BlocListener(
                            cubit: _cancelOrderCubit,
                            listener: (_, state) async {
                              if (state is CancelOrderSuccess) {
                               
                                AppExt.popUntilRoot(context);
                                BlocProvider.of<BottomNavCubit>(context)
                                    .navItemTapped(0);

                                BSFeedback.show(
                                  context,
                                  title: "Pemesanan dibatalkan",
                                  description:
                                      "Silahkan melakukan belanja kembali",
                                );

                                // ScaffoldMessenger.of(context)
                                //   ..hideCurrentSnackBar()
                                //   ..showSnackBar(
                                //     SnackBar(
                                //       behavior: SnackBarBehavior.floating,
                                //       backgroundColor: Colors.grey[900],
                                //       duration: Duration(seconds: 1),
                                //       content: Text("Pemesanan dibatalkan"),
                                //     ),
                                //   );
                              }
                              if (state is CancelOrderFailure) {
                                AppExt.popScreen(context);
                                _scaffoldKey.currentState
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    new SnackBar(
                                      backgroundColor: Colors.grey[900],
                                      content: new Text(
                                        state.message,
                                      ),
                                    ),
                                  );
                                return;
                              }
                            },
                          ),
                          BlocListener(
                            cubit: _fetchPaymentMethodCubit,
                            listener: (_, state) async {
                              if (state is FetchPaymentMethodSuccess) {
                                final int index = state.paymentMethods
                                    .indexWhere((element) =>
                                        element.id ==
                                        widget.orderData.payment.paymentMethod
                                            .id);
                                setState(() {
                                  _selectedPaymentIndex =
                                      index >= 0 ? index : null;
                                });
                              }
                              if (state is FetchPaymentMethodFailure) {
                                _scaffoldKey.currentState
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    new SnackBar(
                                      backgroundColor: Colors.grey[900],
                                      content: new Text(
                                        "Terjadi kesalahan",
                                      ),
                                    ),
                                  );
                                return;
                              }
                            },
                          ),
                          BlocListener(
                            cubit: _changePaymentMethodCubit,
                            listener: (_, state) async {
                              if (state is ChangePaymentMethodSuccess) {
                                AppExt.popScreen(context);
                                AppExt.popUntilRoot(context);
                                AppExt.pushScreen(
                                    context,
                                    PaymentDetailScreen(
                                      orderData: state.data,
                                      checkoutTemp: widget.checkoutTemp,
                                    ));
                              }
                              if (state is ChangePaymentMethodFailure) {
                                AppExt.popScreen(context);
                                _scaffoldKey.currentState
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    new SnackBar(
                                      backgroundColor: Colors.red,
                                      content: new Text(
                                        "${state.message}",
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                return;
                              }
                            },
                          ),
                        ],
                        child: AppTrans.SharedAxisTransitionSwitcher(
                            transitionType: SharedAxisTransitionType.vertical,
                            fillColor: Colors.transparent,
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                  vertical: _screenWidth * (3 / 100)),
                              children: [
                                Image.asset(
                                  AppImg.img_payment_success,
                                  height: _screenWidth * (50 / 100),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Center(
                                    child: Text(
                                        "Selamat, pemesanan anda berhasil!",
                                        style: AppTypo.LatoBold.copyWith(
                                            fontSize: 18,
                                            color: AppColor.primary))),
                                SizedBox(
                                  height: 18,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _screenWidth * (10 / 100)),
                                  child: Text(
                                    "Silahkan transfer ke nomor rekening berikut agar pesanan dapat segera kami proses",
                                    textAlign: TextAlign.center,
                                    style: AppTypo.body2Lato
                                        .copyWith(color: AppColor.grey),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: Divider(color: AppColor.line),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _screenWidth * (8 / 100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Transfer ke nomor rekening",
                                              style: AppTypo.body1Lato),
                                          BlocBuilder(
                                            cubit: _fetchPaymentMethodCubit,
                                            builder: (context,
                                                    statePaymentMethod) =>
                                                statePaymentMethod
                                                        is FetchPaymentMethodFailure
                                                    ? Center(
                                                        child: Text(
                                                            "Terjadi Kesalahan"),
                                                      )
                                                    : AppTrans
                                                        .SharedAxisTransitionSwitcher(
                                                        transitionType:
                                                            SharedAxisTransitionType
                                                                .vertical,
                                                        fillColor:
                                                            Colors.transparent,
                                                        child: statePaymentMethod
                                                                    is FetchPaymentMethodSuccess &&
                                                                statePaymentMethod
                                                                        .paymentMethods
                                                                        .length >
                                                                    0
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      debugPrint("ID PEMBAYARANE " +
                                                                          widget
                                                                              .orderData
                                                                              .payment
                                                                              .id
                                                                              .toString());
                                                                      _showPaymentMethod(
                                                                        context:
                                                                            context,
                                                                        paymentMethod:
                                                                            statePaymentMethod.paymentMethods,
                                                                        selectedPayment:
                                                                            _selectedPaymentIndex,
                                                                        onChange:
                                                                            (paymentMethodId) {
                                                                          AppExt.popScreen(
                                                                              context);
                                                                          LoadingDialog.show(
                                                                              context);
                                                                          _changePaymentMethodCubit.changePaymentMethod(
                                                                              paymentId: widget.orderData.payment.id,
                                                                              paymentMethodId: paymentMethodId);
                                                                        },
                                                                      );
                                                                    },
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    highlightColor: AppColor
                                                                        .danger
                                                                        .withOpacity(
                                                                            0.2),
                                                                    splashColor: AppColor
                                                                        .danger
                                                                        .withOpacity(
                                                                            0.2),
                                                                    splashFactory:
                                                                        InkRipple
                                                                            .splashFactory,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10.0,
                                                                          vertical:
                                                                              3),
                                                                      child:
                                                                          Text(
                                                                        "Ubah Rekening",
                                                                        style: AppTypo.overline.copyWith(
                                                                            color:
                                                                                AppColor.danger,
                                                                            decoration: TextDecoration.underline),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox.shrink(),
                                                      ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${widget.orderData.payment.paymentMethod.image}",
                                              memCacheHeight: Get.height > 350
                                                  ? (Get.height * 0.25).toInt()
                                                  : Get.height,
                                              width:
                                                  _screenWidth * (17.5 / 100),
                                              height: _screenWidth * (13 / 100),
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                baseColor: Colors.grey[300],
                                                highlightColor:
                                                    Colors.grey[200],
                                                period: Duration(
                                                    milliseconds: 1000),
                                                child: Container(
                                                  width: _screenWidth *
                                                      (17.5 / 100),
                                                  height:
                                                      _screenWidth * (13 / 100),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                AppImg.img_error,
                                                width:
                                                    _screenWidth * (17.5 / 100),
                                                height:
                                                    _screenWidth * (13 / 100),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: _screenWidth * (4.5 / 100),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${widget.orderData.payment.paymentMethod.accountNumber}",
                                                  style: AppTypo.LatoBold,
                                                ),
                                                Text(
                                                  "a/n ${widget.orderData.payment.paymentMethod.accountName}",
                                                  style: AppTypo.body2Lato,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
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
                                          highlightedBorderColor:
                                              AppColor.primary,
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          onPressed: () => _handleCopy(
                                              widget.orderData.payment
                                                  .paymentMethod.accountNumber,
                                              "Nomor rekening telah disalin"),
                                          child: Text(
                                            "Salin Nomor Rekening",
                                            style: AppTypo.caption.copyWith(
                                                color: AppColor.primary),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Divider(color: AppColor.grey),
                                      ),
                                      Text(
                                        "Jumlah yang harus ditransfer",
                                        style: AppTypo.body1Lato,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Rp" +
                                            AppExt.toRupiah(widget
                                                .checkoutTemp.totalPayment),
                                        style: AppTypo.h3.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.primary),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
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
                                          highlightedBorderColor:
                                              AppColor.primary,
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          onPressed: () => _handleCopy(
                                              (widget.checkoutTemp.totalPayment)
                                                  .toString(),
                                              "Jumlah transfer telah disalin"),
                                          child: Text(
                                            "Salin Jumlah",
                                            style: AppTypo.caption.copyWith(
                                                color: AppColor.primary),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        "Kode Transaksi",
                                        style: AppTypo.body1Lato,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${widget.orderData.payment.paymentMethod.accountNumber}",
                                        style: AppTypo.h3.copyWith(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
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
                                          highlightedBorderColor:
                                              AppColor.primary,
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          onPressed: () => _handleCopy(
                                              widget.orderData.payment
                                                  .paymentMethod.accountNumber,
                                              "Kode transaksi telah disalin"),
                                          child: Text(
                                            "Salin Kode Transaksi",
                                            style: AppTypo.caption.copyWith(
                                                color: AppColor.primary),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 13, 13, 13),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: AppColor.primary,
                                              width: 1),
                                          color:
                                              AppColor.primary.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.info,
                                                color: AppColor.primary
                                                    .withOpacity(0.5)),
                                            SizedBox(width: 3),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: Icon(
                                                            Icons.circle,
                                                            color: AppColor
                                                                .textPrimary,
                                                            size: 7),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        child: Text(
                                                            "Silakan selesaikan pembayaran anda dengan bank yang sudah anda pilih",
                                                            style: AppTypo
                                                                .caption),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: Icon(
                                                            Icons.circle,
                                                            color: AppColor
                                                                .textPrimary,
                                                            size: 7),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        child: Text(
                                                            "Setelah anda sudah membayar silahkan menunggu konfirmasi dari penjual dan pesanan anda akan segera di proses",
                                                            style: AppTypo
                                                                .caption),
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
                                        label: "Download Invoice",
                                        textColor: Colors.white,
                                        onPressed: () {
                                          final checkout = widget.checkoutTemp;
                                          final order = widget.orderData;
                                          AppExt.pushScreen(
                                              context,
                                              InvoicePaymentScreen(
                                                checkout: checkout,
                                                order: order,
                                              ));
                                          // debugPrint(order.payment.);
                                          // debugPrint(checkout.);
                                        },
                                        isUpperCase: false,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Center(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () =>
                                                _showConfirmationDialog(
                                              context: context,
                                              onYes: () => _handleCancelOrder(
                                                  paymentId: widget
                                                      .orderData.payment.id),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            highlightColor: AppColor.danger
                                                .withOpacity(0.2),
                                            splashColor: AppColor.danger
                                                .withOpacity(0.2),
                                            splashFactory:
                                                InkRipple.splashFactory,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Text(
                                                "Batalkan Pesanan",
                                                style: AppTypo.button.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.danger,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentMethod({
    @required BuildContext context,
    @required List<PaymentMethod> paymentMethod,
    @required int selectedPayment,
    @required void Function(int) onChange,
  }) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final int initialPayment = selectedPayment;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setSheetState) {
          return Container(
            constraints: BoxConstraints(maxHeight: _screenHeight * (90 / 100)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: _screenWidth * (15 / 100),
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(7.5 / 2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text(
                          "Ganti Metode Pembayaran",
                          textAlign: TextAlign.start,
                          style: AppTypo.subtitle2v2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        paymentMethod.length > 0
                            ? ListView.separated(
                                key: Key("loaded_otp"),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, id) {
                                  return PaymentOption(
                                      label: "${paymentMethod[id].name}",
                                      imageUrl: "${paymentMethod[id].image}",
                                      selected: selectedPayment == id,
                                      onTap: () {
                                        setSheetState(() {
                                          selectedPayment = id;
                                        });
                                      });
                                },
                                separatorBuilder: (context, id) => SizedBox(
                                      height: 15,
                                    ),
                                itemCount: paymentMethod.length)
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedButton.contained(
                    label: "Ubah Pembayaran",
                    disabled: selectedPayment == initialPayment,
                    onPressed: () =>
                        onChange(paymentMethod[selectedPayment].id),
                    isUpperCase: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showConfirmationDialog(
      {@required BuildContext context, @required void Function() onYes}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: !context.isPhone
                      ? 500
                      : MediaQuery.of(context).size.width),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apakah anda yakin untuk membatalkan pesanan?',
                      style: AppTypo.body2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButton.outlined(
                            isUpperCase: false,
                            isCompact: true,
                            label: "Ya",
                            onPressed: () {
                              Navigator.pop(context);
                              onYes();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RoundedButton.contained(
                            isUpperCase: false,
                            isCompact: true,
                            label: "Tidak",
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class PaymentOption extends StatelessWidget {
  final String label;
  final String imageUrl;
  final bool selected;
  final VoidCallback onTap;

  const PaymentOption({
    Key key,
    @required this.label,
    @required this.imageUrl,
    @required this.selected,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(7.5),
      hoverColor: !context.isPhone
          ? Colors.transparent
          : AppColor.primaryLight1.withOpacity(0.3),
      splashColor: AppColor.primaryLight1.withOpacity(0.3),
      highlightColor: AppColor.primaryLight2.withOpacity(0.3),
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.all(!context.isPhone ? 20 : _screenWidth * (4.5 / 100)),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.line, width: 1),
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                memCacheHeight:
                    Get.height > 350 ? (Get.height * 0.25).toInt() : Get.height,
                width: _screenWidth * (17.5 / 100),
                height: _screenWidth * (13 / 100),
                fit: BoxFit.contain,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  period: Duration(milliseconds: 1000),
                  child: Container(
                    width: _screenWidth * (17.5 / 100),
                    height: _screenWidth * (13 / 100),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  AppImg.img_error,
                  width: _screenWidth * (17.5 / 100),
                  height: _screenWidth * (13 / 100),
                ),
              ),
            ),
            SizedBox(
              width: _screenWidth * (4.5 / 100),
            ),
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: AppTypo.h3,
              ),
            ),
            Icon(
              selected
                  ? FlutterIcons.check_circle_mco
                  : FlutterIcons.checkbox_blank_circle_outline_mco,
              color: AppColor.primary,
              size: 35,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
