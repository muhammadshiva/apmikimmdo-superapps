import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/order/add_order/add_order_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/order/fetch_payment_method/fetch_payment_method_cubit.dart';
import 'package:marketplace/data/models/checkout.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/data/repositories/new_repositories/recipent_repository.dart';
import 'package:marketplace/ui/screens/new_screens/checkout/widgets/deliver_address_item.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/new_screens/payment/widget/payment_method_item.dart';
import 'package:marketplace/ui/widgets/data_table.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key key, this.checkoutTemp}) : super(key: key);

  final CheckoutTemp checkoutTemp;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final RecipentRepository _recRepo = RecipentRepository();

  AddOrderCubit _addOrderCubit;
  FetchPaymentMethodCubit _fetchPaymentMethodCubit;

  //Variable for get passing data
  int _recipentIdUser;
  PaymentMethod _selectedPayment;

  @override
  void initState() {
    _selectedPayment = null;
    _addOrderCubit = AddOrderCubit();
    _recipentIdUser = _recRepo.getSelectedRecipent()['id'];
    _fetchPaymentMethodCubit = FetchPaymentMethodCubit()..load();
    super.initState();
  }

  void handleBayar({@required int paymentMethodId}) {
    LoadingDialog.show(context);
    _addOrderCubit.addOrder(
        itemId: widget.checkoutTemp.itemId,
        recipientId: _recipentIdUser,
        shippingCode: widget.checkoutTemp.shippingCode
            .map((e) => e.shippingCode)
            .toList(),
        ongkir: widget.checkoutTemp.ongkir.map((e) => e.ongkir).toList(),
        note: widget.checkoutTemp.note.map((e) => e.note).toList(),
        verificationMethod: "manual",
        paymentMethodId: paymentMethodId);
  }

  @override
  void dispose() {
    _addOrderCubit.close();
    _fetchPaymentMethodCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        AppExt.popScreen(context);
        AppExt.popScreen(context);
        AppExt.pushScreen(
            context,
            CheckoutScreen(
              cart: widget.checkoutTemp.cart,
            ));
        return;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _addOrderCubit,
          ),
          BlocProvider(
            create: (_) => _fetchPaymentMethodCubit,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener(
                cubit: _addOrderCubit,
                listener: (context, state) {
                  if (state is AddOrderSuccess) {
                    AppExt.popScreen(context);
                    AppExt.popUntilRoot(context);
                    BlocProvider.of<BottomNavCubit>(context).navItemTapped(2);
                    AppExt.pushScreen(
                        context,
                        PaymentDetailScreen(
                          orderData: state.data,
                          checkoutTemp: widget.checkoutTemp,
                        ));
                  }
                  if (state is AddOrderFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.grey[900],
                          duration: Duration(seconds: 1),
                          content: Text(state.message),
                        ),
                      );
                    debugPrint(state.message);
                  }
                })
          ],
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
              body: SafeArea(
                  child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            iconTheme: IconThemeData(color: AppColor.black),
                            textTheme: TextTheme(headline6: AppTypo.subtitle2),
                            backgroundColor: Colors.white,
                            centerTitle: true,
                            forceElevated: false,
                            pinned: true,
                            shadowColor: Colors.black54,
                            floating: true,
                            title: Text("Metode Pembayaran"),
                            brightness: Brightness.dark,
                          ),
                        ];
                      },
                      body: SingleChildScrollView(
                        physics: new BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _screenWidth * (5 / 120)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DeliverAddressItem(
                                cart: widget.checkoutTemp.cart,
                                isAlreadyCheckout: true,
                                recipentIdNow: (int recId) {
                                  setState(() {
                                    _recipentIdUser = recId;
                                  });
                                  debugPrint("RECIPENT ID SEKARANG :" +
                                      recId.toString());
                                },
                              ),
                              Divider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ringkasan Belanja",
                                    style: AppTypo.LatoBold,
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: 6,
                                    ),
                                    itemCount: widget.checkoutTemp.cart.length,
                                    itemBuilder: (context, index1) {
                                      NewCart item =
                                          widget.checkoutTemp.cart[index1];
                                      final note =
                                          widget.checkoutTemp.note[index1];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.nameSeller ?? "-",
                                              style: AppTypo.LatoBold.copyWith(
                                                  fontSize: 14)),
                                          Text(item.city ?? "-",
                                              style: AppTypo.body1.copyWith(
                                                  fontSize: 14,
                                                  color: AppColor.grey)),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            separatorBuilder:
                                                (context, index) => SizedBox(
                                              height: 12,
                                            ),
                                            itemCount: widget.checkoutTemp
                                                .cart[index1].product.length,
                                            itemBuilder: (context, index2) {
                                              CartProduct cartProduct =
                                                  item.product[index2];

                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${cartProduct.quantity} x",
                                                    textAlign: TextAlign.left,
                                                    style: AppTypo.LatoBold
                                                        .copyWith(
                                                            fontSize: 14,
                                                            color: AppColor
                                                                .appPrimary),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            "${cartProduct.name}",
                                                            maxLines: 2,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: AppTypo.body2Lato
                                                                .copyWith(
                                                                    fontSize: 14)),
                                                        cartProduct.productVariantName != null ?
                                                        Text(cartProduct.productVariantName) : SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Rp. ${AppExt.toRupiah(cartProduct.enduserPrice * cartProduct.quantity)},-",
                                                    style: AppTypo.caption
                                                        .copyWith(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            "Catatan: ${note.note}",
                                            style: AppTypo.caption.copyWith(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          const Divider(
                                            thickness: 1.5,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Ringkasan Pembayaran",
                                    style: AppTypo.LatoBold,
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  dataTable.detail(
                                    "Subtotal Produk",
                                    "Rp. ${AppExt.toRupiah(widget.checkoutTemp.subtotal)},-",
                                  ),
                                  dataTable.detail(
                                    "Subtotal Pengiriman",
                                    "Rp. ${AppExt.toRupiah(widget.checkoutTemp.totalOngkir)},-",
                                  ),
                                  dataTable.detail(
                                    "Biaya Penanganan",
                                    "Rp. -",
                                  ),
                                  Divider(),
                                  dataTable.totalSummary(
                                    "TOTAL",
                                    "Rp. ${AppExt.toRupiah(widget.checkoutTemp.totalPayment)},-",
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Text("Pilih Metode Pembayaran",
                                      style: AppTypo.LatoBold),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  BlocBuilder<FetchPaymentMethodCubit,
                                          FetchPaymentMethodState>(
                                      builder: (context, state) => state
                                              is FetchPaymentMethodLoading
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : state is FetchPaymentMethodFailure
                                              ? Center(
                                                  child: Text(state.message))
                                              : state is FetchPaymentMethodSuccess
                                                  ? PaymentMethodItem(
                                                      paymentMethod:
                                                          state.paymentMethods,
                                                      onSelected: (data) {
                                                        setState(() {
                                                          _selectedPayment =
                                                              data;
                                                        });
                                                      },
                                                    )
                                                  : SizedBox.shrink()),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RoundedButton.contained(
                                    disabled: _selectedPayment == null,
                                    textColor: Colors.white,
                                    label: "Bayar",
                                    onPressed: () => handleBayar(
                                      paymentMethodId: _selectedPayment.id,
                                    ),
                                    isUpperCase: false,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ))),
            ),
          ),
        ),
      ),
    );
  }
}
