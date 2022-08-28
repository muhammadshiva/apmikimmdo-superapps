import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:beamer/beamer.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/shipping/fetch_shipping_options/fetch_shipping_options_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/new_screens/checkout/widgets/checkout_courier_item.dart';
import 'package:marketplace/ui/screens/new_screens/checkout/widgets/checkout_item.dart';
import 'package:marketplace/ui/screens/new_screens/checkout/widgets/checkout_payment_type.dart';
import 'package:marketplace/ui/screens/new_screens/checkout/widgets/deliver_address_item.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/ui/widgets/data_table.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key key, this.cart}) : super(key: key);

  final List<NewCart> cart;

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FetchRecipentCubit _fetchRecipentCubit;

  List<WidgetIndexTemp> widgetIndexTemp = [];
  List<ShippingCodeTemp> shippingCodes = [];
  List<NoteTemp> notes = [];
  List<int> itemIds = [];
  List<OngkirTemp> ongkirs = [];

  int totalOngkirPrice = 0;
  int totalRecipents = 0;
  PaymentType _paymentType = PaymentType.manual;

  @override
  void initState() {
    _fetchRecipentCubit = FetchRecipentCubit()..fetchRecipents();
    fillListId();
    super.initState();
  }

  void fillListId() {
    for (int i = 0; i < widget.cart.length; i++) {
      for (int k = 0; k < widget.cart[i].product.length; k++) {
        itemIds.add(widget.cart[i].product[k].cartId);
      }
    }
  }

  @override
  void dispose() {
    _fetchRecipentCubit.close();
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

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => _fetchRecipentCubit)],
      child: BlocListener(
        cubit: _fetchRecipentCubit,
        listener: (context, state) {
          if (state is FetchRecipentSuccess) {
            setState(() {
              totalRecipents = state.recipent.length;
            });
          }
        },
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: !context.isPhone ? 450 : double.infinity),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark),
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
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverAppBar(
                                    iconTheme:
                                        IconThemeData(color: AppColor.black),
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
                                      horizontal: _screenWidth * (5 / 100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      DeliverAddressItem(
                                        cart: widget.cart,
                                        triggerRefreshRecipent: () {
                                          _fetchRecipentCubit.fetchRecipents();
                                        },
                                        recipentIdNow: (value) {
                                          AppExt.popScreen(context);
                                          AppExt.pushScreen(
                                              context,
                                              CheckoutScreen(
                                                cart: widget.cart,
                                              ));
                                          debugPrint(
                                              "RECIPENT ID NOW : $value");
                                        },
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        'Detail Pesanan',
                                        style: AppTypo.subtitle1.copyWith(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CheckoutItem(
                                        enableCourier: totalRecipents != 0,
                                        cart: widget.cart,
                                        courierSelected: (id, price,
                                            indexWidget, nameCourier, note) {
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
                                              courier: nameCourier,
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
                                              if (widgetIndexTemp[i]
                                                      .indexWidget ==
                                                  indexWidget) {
                                                debugPrint("MASUK KE 1");
                                                widgetIndexTemp.removeWhere(
                                                    (element) =>
                                                        element.indexWidget ==
                                                        indexWidget);
                                                shippingCodes.removeWhere(
                                                    (element) =>
                                                        element.indexWidget ==
                                                        indexWidget);
                                                notes.removeWhere((element) =>
                                                    element.indexWidget ==
                                                    indexWidget);
                                                ongkirs.removeWhere((element) =>
                                                    element.indexWidget ==
                                                    indexWidget);
                                                widgetIndexTemp
                                                    .add(WidgetIndexTemp(
                                                  indexWidget: indexWidget,
                                                ));
                                                shippingCodes
                                                    .add(ShippingCodeTemp(
                                                  id: id,
                                                  shippingCode: nameCourier,
                                                  indexWidget: indexWidget,
                                                ));
                                                ongkirs.add(OngkirTemp(
                                                  id: id,
                                                  ongkir: price,
                                                  courier: nameCourier,
                                                  indexWidget: indexWidget,
                                                ));
                                                notes.add(NoteTemp(
                                                  id: id,
                                                  note: note,
                                                  indexWidget: indexWidget,
                                                ));
                                              } else {
                                                debugPrint("MASUK KE 2");
                                                widgetIndexTemp
                                                    .add(WidgetIndexTemp(
                                                  indexWidget: indexWidget,
                                                ));
                                                shippingCodes
                                                    .add(ShippingCodeTemp(
                                                  id: id,
                                                  shippingCode: nameCourier,
                                                  indexWidget: indexWidget,
                                                ));
                                                ongkirs.add(OngkirTemp(
                                                  id: id,
                                                  ongkir: price,
                                                  courier: nameCourier,
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
                                                    previousValue +
                                                    element.ongkir);
                                          });

                                          debugPrint(
                                              "INDEX WIDGET SAAT INI : $indexWidget");
                                          debugPrint(
                                              "LENGTH ONGKIR SAAT INI : ${widgetIndexTemp.length}");
                                        },
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      CheckoutPaymentType(),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        'Ringkasan Pembayaran',
                                        style: AppTypo.subtitle1.copyWith(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      dataTable.detail(
                                        "Subtotal ( ${totalItem} item )",
                                        "Rp. ${AppExt.toRupiah(subtotalPrice)},-",
                                      ),
                                      dataTable.detail(
                                        "Ongkos Kirim",
                                        "Rp. ${AppExt.toRupiah(totalOngkirPrice ?? 0)},-",
                                      ),
                                      Divider(
                                        color: AppColor.line,
                                      ),
                                      dataTable.detail(
                                        "Total Pembayaran",
                                        totalOngkirPrice != null
                                            ? "Rp. ${AppExt.toRupiah(subtotalPrice + totalOngkirPrice)},-"
                                            : "Rp. ${AppExt.toRupiah(subtotalPrice)},-",
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
                                          color: Color(0xFF21232C)
                                              .withOpacity(0.05),
                                          spreadRadius: 0,
                                          blurRadius: 10,
                                          offset: Offset(0, -4),
                                        ),
                                      ]),
                                  child: Column(
                                    children: [
                                      //Voucher
                                      InkWell(
                                        onTap: () => BsConfirmation().warning(
                                            context: context,
                                            title:
                                                "Nantikan fitur terbaru dari kami.")

                                        /*{
                                          */ /*AppExt.pushScreen(
                                              context, VoucherScreen());*/ /*

                                        }*/
                                        ,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  _screenWidth * 5 / 100,
                                              vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppImg
                                                          .ic_voucher_horizontal,
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("Gunakan Voucher")
                                                  ],
                                                ),
                                              ),
                                              Icon(Icons.chevron_right),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                      ),
                                      //Coin
                                      InkWell(
                                        onTap: () => BsConfirmation().warning(
                                            context: context,
                                            title:
                                                "Nantikan fitur terbaru dari kami."),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  _screenWidth * 5 / 100,
                                              vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppImg.ic_coin,
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("Tukarkan")
                                                  ],
                                                ),
                                              ),
                                              Icon(Icons.chevron_right),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _screenWidth * (5 / 100),
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
                                                  ? "Rp. ${AppExt.toRupiah(subtotalPrice + totalOngkirPrice)}"
                                                  : "Rp. ${AppExt.toRupiah(subtotalPrice)}",
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
                                                  widget.cart.length ||
                                              totalRecipents == 0,
                                          label: "Pembayaran",
                                          isCompact: true,
                                          color: AppColor.bgBadgePink,
                                          textColor: AppColor.appPrimary,
                                          isUpperCase: false,
                                          elevation: 6,
                                          onPressed: () {
                                            if (_paymentType ==
                                                PaymentType.manual) {
                                              AppExt.pushScreen(
                                                  context,
                                                  PaymentScreen(
                                                    checkoutTemp: CheckoutTemp(
                                                        cart: widget.cart,
                                                        itemId: itemIds,
                                                        shippingCode:
                                                            shippingCodes,
                                                        note: notes,
                                                        ongkir: ongkirs,
                                                        subtotal: subtotalPrice,
                                                        totalOngkir:
                                                            totalOngkirPrice,
                                                        totalPayment:
                                                            subtotalPrice +
                                                                totalOngkirPrice),
                                                  ));
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
