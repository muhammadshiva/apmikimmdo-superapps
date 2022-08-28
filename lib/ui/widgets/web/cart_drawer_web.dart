import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/cart_stock_validation/cart_stock_validation_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/delete_cart_item/delete_cart_item_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/update_quantity/update_quantity_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/web/dialog_web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/decorations.dart' as AppDecor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class CartDrawerWeb extends StatefulWidget {
  const CartDrawerWeb({Key key}) : super(key: key);

  @override
  _CartDrawerWebState createState() => _CartDrawerWebState();
}

class _CartDrawerWebState extends State<CartDrawerWeb> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FetchCartCubit _fetchCartCubit;
  UpdateQuantityCubit _updateQuantityCubit;
  CartStockValidationCubit _cartStockValidationCubit;
  List<Cart> _listCart;
  bool _goBack;
  int _selectedCartIndex;
  //kategoriCart ID = 1->pembelian,2->booking
  int categoryCartId = 0;

  @override
  void initState() {
    super.initState();
    _goBack = false;
    _listCart = [];
    _fetchCartCubit = FetchCartCubit()..load();
    _updateQuantityCubit = UpdateQuantityCubit();
    _cartStockValidationCubit = CartStockValidationCubit();
  }

  _updateQuantity(List<int> cartId, List<int> quantity) {
    _updateQuantityCubit.updateQuantity(cartId: cartId, quantity: quantity);
  }

  _backUpdate() async {
    if (_listCart.length > 0) {
      List<int> _cartId = [];
      List<int> _quantity = [];
      setState(() {
        _goBack = true;
      });
      LoadingDialog.show(context);
      for (Cart i in _listCart) {
        for (CartProduct j in i.product) {
          _cartId.add(j.cartId);
          _quantity.add(j.quantity);
        }
      }
      await _updateQuantity(_cartId, _quantity);
    } else {
      AppExt.popScreen(context);
    }
    await BlocProvider.of<UserDataCubit>(context).updateCountCart();
  }

  @override
  void dispose() {
    _fetchCartCubit.close();
    _updateQuantityCubit.close();
    _cartStockValidationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final config = AAppConfig.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _fetchCartCubit),
        BlocProvider(create: (_) => _updateQuantityCubit),
        BlocProvider(create: (_) => _cartStockValidationCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener(
            cubit: _fetchCartCubit,
            listener: (context, state) {
              if (state is FetchCartSuccess) {
                setState(() {
                  // _listCart = state.cart;
                });
                return;
              }
            },
          ),
          BlocListener(
            cubit: _updateQuantityCubit,
            listener: (context, state) async {
              if (state is UpdateQuantitySuccess) {
                await _fetchCartCubit.reload();
                if (_goBack) {
                  AppExt.popScreen(context);
                  AppExt.popScreen(context);
                } else {
                  await Future.delayed(Duration(milliseconds: 200));
                  List<int> _productId = [];
                  List<int> _quantity = [];
                  if (_selectedCartIndex != null) {
                    for (CartProduct j
                        in _listCart[_selectedCartIndex].product) {
                      _productId.add(j.id);
                      _quantity.add(j.quantity);
                    }
                    _cartStockValidationCubit.cartStockValidation(
                        sellerId: _listCart[_selectedCartIndex].sellerId,
                        productId: _productId,
                        quantity: _quantity);
                  }
                }
                return;
              }
              if (state is UpdateQuantityFailure) {
                setState(() {
                  _goBack = false;
                  _selectedCartIndex = null;
                });
                AppExt.popScreen(context);
                ErrorDialog.show(
                    context: context,
                    type: ErrorType.general,
                    message: state.message == null
                        ? "Terjadi Kesalahan"
                        : "${state.message}",
                    onTry: () {},
                    onBack: () {
                      AppExt.popScreen(context);
                    });
                return;
              }
            },
          ),
          BlocListener(
            cubit: _cartStockValidationCubit,
            listener: (context, state) async {
              if (state is CartStockValidationSuccess) {
                if (_goBack) {
                  AppExt.popScreen(context);
                  AppExt.popScreen(context);
                } else {
                  final List<CartProduct> filteredCart =
                      _listCart[_selectedCartIndex]
                          .product
                          .where((element) =>
                              element.quantity > 0 && element.stock > 0)
                          .toList();
                  AppExt.popScreen(context);
                  AppExt.popScreen(context);
                  // context.beamToNamed(
                  //   '/checkout/cart/${_listCart[_selectedCartIndex].sellerId}?c=${AppExt.encryptMyData(json.encode(filteredCart))}',
                  // );
                  BlocProvider.of<HandleTransactionRouteWebCubit>(context)
                      .changeBeamGuardPaymentDetail(true);
                  context.beamToNamed(
                      '/successcheckout/${_listCart[_selectedCartIndex].sellerId}?c=${AppExt.encryptMyData(json.encode(filteredCart))}');
                  // BlocProvider.of<HandleTransactionRouteWebCubit>(context)
                  //     .changeCheckCheckout(true);
                }
                return;
              }
              if (state is CartStockValidationFailure) {
                setState(() {
                  _goBack = false;
                  _selectedCartIndex = null;
                });
                AppExt.popScreen(context);
                ErrorDialog.show(
                    context: context,
                    type: ErrorType.general,
                    message: state.message == null
                        ? "Terjadi Kesalahan"
                        : "${state.message}",
                    onTry: () {},
                    onBack: () {
                      AppExt.popScreen(context);
                    });
                return;
              }
            },
          ),
        ],
        child: Container(
          width: 500,
          child: Drawer(
            child: Container(
                // width: 1500,
                color: AppColor.navScaffoldBg,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.textPrimaryInverted,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColor.grey.withOpacity(0.45),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 30, bottom: 12, right: 30, left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Keranjang",
                                style: AppTypo.h2.copyWith(fontSize: 24)),
                            IconButton(
                              iconSize: 30,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              splashRadius: 30,
                              hoverColor: Colors.transparent,
                              icon: Icon(
                                Boxicons.bx_x,
                              ),
                              onPressed: () async {
                                // AppExt.popScreen(context);
                                // AppExt.popScreen(context);
                                _backUpdate();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    //TAB INDICATOR
                    config.appType == AppType.panenpanen
                        ? Container(
                            decoration: BoxDecoration(
                                color: AppColor.navScaffoldBg,
                                border: Border(
                                    bottom: BorderSide(color: AppColor.grey))),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        categoryCartId = 0;
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColor.navScaffoldBg,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: categoryCartId == 0
                                                        ? AppColor.primary
                                                        : Colors.transparent))),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 5),
                                        // color: Colors.blue,
                                        child: Center(
                                          child: Text("Pembelian",
                                              style: AppTypo.subtitle1.copyWith(
                                                  color: categoryCartId == 0
                                                      ? AppColor.primary
                                                      : AppColor.grey,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                  ),
                                ),
                                // Expanded(
                                //   child: InkWell(
                                //     onTap: () {
                                //       setState(() {
                                //         categoryCartId = 1;
                                //       });
                                //     },
                                //     child: Container(
                                //         decoration: BoxDecoration(
                                //             // color: AppColor.textPrimaryInverted,
                                //             border: Border(
                                //                 bottom: BorderSide(
                                //                     color: categoryCartId == 1
                                //                         ? AppColor.primary
                                //                         : Colors.transparent))),
                                //         padding: EdgeInsets.symmetric(
                                //             horizontal: 30, vertical: 5),
                                //         // color: Colors.yellow,
                                //         child: Center(
                                //           child: Text("Booking",
                                //               style: AppTypo.subtitle1.copyWith(
                                //                   color: categoryCartId == 1
                                //                       ? AppColor.primary
                                //                       : AppColor.grey,
                                //                   fontWeight: FontWeight.bold)),
                                //         )),
                                //   ),
                                // ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    categoryCartId == 0 // >>>>>>>>>>>> CART <<<<<<<<<<<<<<<
                        ? Expanded(
                            child: BlocBuilder(
                              cubit: _fetchCartCubit,
                              builder: (context, state) =>
                                  AppTrans.SharedAxisTransitionSwitcher(
                                transitionType:
                                    SharedAxisTransitionType.vertical,
                                fillColor: Colors.transparent,
                                child: state is FetchCartLoading
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 30),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          height: 15,
                                        ),
                                        itemCount: 3,
                                        itemBuilder: (context, index) {
                                          return ShimmerCartItemWidget();
                                        },
                                      )
                                    : state is FetchCartFailure
                                        ? Center(
                                            child: state.type ==
                                                    ErrorType.network
                                                ? NoConnection(
                                                    onButtonPressed: () {
                                                    _fetchCartCubit.load();
                                                  })
                                                : ErrorFetch(
                                                    message: state.message,
                                                    onButtonPressed: () {
                                                      _fetchCartCubit.load();
                                                    },
                                                  ),
                                          )
                                        : state is FetchCartSuccess
                                            ? state.cart.length > 0
                                                ? ListView.separated(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20,
                                                            horizontal: 30),
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            SizedBox(
                                                      height: 15,
                                                    ),
                                                    itemCount:
                                                        state.cart.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      /*Cart _item =
                                                          state.cart[index];*/
                                                          Cart _item;
                                                      return CartItemWidgetWeb(
                                                          itemIndex: index,
                                                          cart: _item,
                                                          scaffoldKey:
                                                              _scaffoldKey,
                                                          fetchCartCubit:
                                                              _fetchCartCubit,
                                                          updateQuantityCubit:
                                                              _updateQuantityCubit,
                                                          onCheckout: () async {
                                                            List<int> _cartId =
                                                                [];
                                                            List<int>
                                                                _quantity = [];
                                                            setState(() {
                                                              _goBack = false;
                                                              _selectedCartIndex =
                                                                  index;
                                                            });
                                                            LoadingDialog.show(
                                                                context);
                                                            for (Cart i
                                                                in _listCart) {
                                                              for (CartProduct j
                                                                  in i.product) {
                                                                _cartId.add(
                                                                    j.cartId);
                                                                _quantity.add(
                                                                    j.quantity);
                                                              }
                                                            }
                                                            await _updateQuantity(
                                                                _cartId,
                                                                _quantity);
                                                          },
                                                          onDelete: (index) {
                                                            setState(() {
                                                              state.cart
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          });
                                                    },
                                                  )
                                                : Center(
                                                    child: EmptyData(
                                                      title:
                                                          "Keranjang belanja anda kosong",
                                                      subtitle:
                                                          "Silahkan pilih produk yang anda inginkan untuk mengisinya",
                                                      labelBtn: "Mulai Belanja",
                                                      onClick: () {
                                                        AppExt.popScreen(context);
                                                        context.beamToNamed('/');
                                                      },
                                                    ),
                                                  )
                                            : SizedBox.shrink(),
                              ),
                            ),
                          )
                         : SizedBox()
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

//=================================== CART ITEM CONFIG ===================================

class CartItemWidgetWeb extends StatefulWidget {
  final int itemIndex;
  final Cart cart;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FetchCartCubit fetchCartCubit;
  final Function(int) onDelete;
  final Function onCheckout;
  final UpdateQuantityCubit updateQuantityCubit;

  const CartItemWidgetWeb({
    Key key,
    @required this.itemIndex,
    @required this.cart,
    @required this.scaffoldKey,
    @required this.fetchCartCubit,
    @required this.onDelete,
    @required this.onCheckout,
    @required this.updateQuantityCubit,
  }) : super(key: key);

  @override
  _CartItemWidgetWebState createState() => _CartItemWidgetWebState();
}

class _CartItemWidgetWebState extends State<CartItemWidgetWeb> {
  List<CartProduct> _cartProduct;
  int _total;
  bool _isQuantityNotValid;

  @override
  void initState() {
    _cartProduct = widget.cart.product;
    _total = 0;
    _isQuantityNotValid = false;
    super.initState();
  }

  _validateQuantity() {
    bool _result = false;
    // int _countNotZero = 0;
    _cartProduct.forEach((e) {
      if (_cartProduct.length == 1 && e.quantity < 1) {
        _result = true;
      }
      if (e.quantity > e.stock) {
        _result = true;
      }
      if (e.stock == 0) {
        _result = true;
      }
      // if (e.stock == 0) {
      //   _result = true;
      // }
      // if (e.quantity > 0) {
      //   _countNotZero++;
      // }
    });
    setState(() {
      _isQuantityNotValid = _result;
    });
  }

  _deleteCart(int cartId) {
    final index =
        _cartProduct.indexWhere((element) => element.cartId == cartId);
    if (index == 0 && _cartProduct.length == 1) {
      widget.onDelete(widget.itemIndex);
    } else {
      setState(() {
        _cartProduct.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _cartProduct = widget.cart.product;
      _total = _cartProduct?.fold(
          0,
          (previous, current) =>
              previous + (current.quantity * current.enduserPrice));
    });
    _validateQuantity();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: AppDecor.customElevation.copyWith(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "${widget.cart.nameSeller}",
            style: AppTypo.body1v2.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          // ListView.separated(
          //     physics: NeverScrollableScrollPhysics(),
          //     shrinkWrap: true,
          //     itemBuilder: (context, index) {
          //       CartProduct item = _cartProduct[index];
          //       return CartProductItemWeb(
          //         product: item,
          //         scaffoldKey: widget.scaffoldKey,
          //         fetchCartCubit: widget.fetchCartCubit,
          //         onUpdate: (qty, price) {
          //           setState(() {
          //             _cartProduct[index].quantity = qty;
          //             _cartProduct[index].enduserPrice = price;
          //           });
          //           _validateQuantity();
          //         },
          //         onDelete: (cartId) => _deleteCart(cartId),
          //       );
          //     },
          //     separatorBuilder: (context, index) => SizedBox(height: 7),
          //     itemCount: widget.cart.product.length),
          Divider(
            thickness: 1,
            color: AppColor.grey,
            indent: 3,
            endIndent: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Pembelian", style: AppTypo.overline),
                    Text(
                      "Rp " + AppExt.toRupiah(_total),
                      style: AppTypo.subtitle1v2.copyWith(
                          fontWeight: FontWeight.w700, color: AppColor.primary),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15),
              RoundedButton.contained(
                  elevation: 0,
                  isCompact: true,
                  label: "Checkout",
                  isSmall: true,
                  isUpperCase: false,
                  onPressed: _isQuantityNotValid ? null : widget.onCheckout
                  // () async {
                  //     final List<CartProduct> filteredCart = widget
                  //         .cart.product
                  //         .where((element) => element.quantity > 0)
                  //         .toList();
                  //     AppExt.pushScreen(
                  //       context,
                  //       CheckoutScreen(
                  //         sellerId: widget.cart.sellerId,
                  //         cart: filteredCart,
                  //       ),
                  //     );
                  //   },
                  ),
            ],
          )
        ],
      ),
    );
  }
}

// class CartProductItemWeb extends StatefulWidget {
//   final CartProduct product;
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   final FetchCartCubit fetchCartCubit;
//   final void Function(int, int) onUpdate;
//   final void Function(int) onDelete;

//   const CartProductItemWeb({
//     Key key,
//     @required this.product,
//     @required this.scaffoldKey,
//     @required this.fetchCartCubit,
//     @required this.onUpdate,
//     @required this.onDelete,
//   }) : super(key: key);

//   // @override
//   // _CartProductItemWebState createState() => _CartProductItemWebState();
// }

// class _CartProductItemWebState extends State<CartProductItemWeb> {
//   DeleteCartItemCubit _deleteCartItemCubit;
//   TextEditingController _quantityController;

//   @override
//   void initState() {
//     super.initState();
//     _deleteCartItemCubit = DeleteCartItemCubit(
//         userDataCubit: BlocProvider.of<UserDataCubit>(context));
//     _quantityController =
//         TextEditingController(text: "${widget.product.quantity}");
//     _initPrice();
//   }

//   _initPrice() async {
//     int _price = await _wholesalePrice(widget.product.quantity);
//     widget.onUpdate(widget.product.quantity, _price);
//   }

//   // _wholesalePrice(int _quantity) {
//   //   if (widget.product.wholesale.length > 0) {
//   //     int resultPrice;
//   //     for (var i = widget.product.wholesale.length - 1; i >= 0; i--) {
//   //       if (_quantity >= widget.product.wholesale[i].from &&
//   //           _quantity <= widget.product.wholesale[i].to) {
//   //         return resultPrice = widget.product.wholesale[i].wholesalePrice;
//   //       }
//   //       resultPrice = widget.product.initialPrice;
//   //     }
//   //     return resultPrice;
//   //   } else {
//   //     return widget.product.initialPrice;
//   //   }
//   // }

//   void _updateQuantity(String value) async {
//     try {
//       if (int.parse(value) <= 0 && widget.product.stock > 0) {
//         widget.scaffoldKey.currentState.showSnackBar(
//           new SnackBar(
//             content: new Text(
//               "Jumlah minimal 1",
//             ),
//             duration: Duration(seconds: 1),
//           ),
//         );
//         int _price = await _wholesalePrice(1);
//         widget.onUpdate(1, _price);
//         return;
//       } else if (int.parse(value) > widget.product.stock) {
//         widget.scaffoldKey.currentState.hideCurrentSnackBar();
//         ErrorDialog.show(
//             context: context,
//             type: ErrorType.general,
//             message:
//                 "Stok ${widget.product.name} tersisa ${widget.product.stock}",
//             onTry: () {},
//             onBack: () {
//               AppExt.popScreen(context);
//             });
//         int _price = await _wholesalePrice(widget.product.stock);
//         widget.onUpdate(widget.product.stock, _price);
//         return;
//       }
//       int _price = await _wholesalePrice(int.parse(value));
//       widget.onUpdate(int.parse(value), _price);
//     } catch (e) {
//       widget.scaffoldKey.currentState.showSnackBar(
//         new SnackBar(
//           content: new Text(
//             "Jumlah tidak valid",
//           ),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }
//   }

//   void _onPlus() async {
//     try {
//       setState(() {
//         _quantityController.text = "${widget.product.quantity + 1}";
//         _quantityController.selection = TextSelection.fromPosition(
//             TextPosition(offset: _quantityController.text.length));
//       });
//       int _price = await _wholesalePrice(widget.product.quantity + 1);
//       widget.onUpdate(widget.product.quantity + 1, _price);
//     } catch (e) {
//       widget.scaffoldKey.currentState.showSnackBar(
//         new SnackBar(
//           content: new Text(
//             "Jumlah tidak valid",
//           ),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }
//   }

//   void _onMin() async {
//     try {
//       setState(() {
//         _quantityController.text = "${widget.product.quantity - 1}";
//         _quantityController.selection = TextSelection.fromPosition(
//             TextPosition(offset: _quantityController.text.length));
//       });
//       int _price = await _wholesalePrice(widget.product.quantity - 1);
//       widget.onUpdate(widget.product.quantity - 1, _price);
//     } catch (e) {
//       widget.scaffoldKey.currentState.showSnackBar(
//         new SnackBar(
//           content: new Text(
//             "Jumlah tidak valid",
//           ),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _quantityController.text = "${widget.product.quantity}" ?? '';
//       _quantityController.selection = TextSelection.fromPosition(
//           TextPosition(offset: _quantityController.text.length));
//     });

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => _deleteCartItemCubit),
//       ],
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener(
//             cubit: _deleteCartItemCubit,
//             listener: (context, state) {
//               if (state is DeleteCartItemSuccess) {
//                 AppExt.popScreen(context);
//                 widget.onDelete(widget.product.cartId);
//               }
//               if (state is DeleteCartItemFailure) {
//                 AppExt.popScreen(context);
//                 ErrorDialog.show(
//                     context: context,
//                     type: state.type,
//                     message: "${state.message}",
//                     onTry: () {},
//                     onBack: () {
//                       AppExt.popScreen(context);
//                     });
//               }
//             },
//           ),
//         ],
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(5),
//                     ),
//                     child: Image(
//                       image: NetworkImage(
//                         "${AppConst.STORAGE_URL}/products/${widget.product.productPhoto}",
//                       ),
//                       width: 65,
//                       height: 47,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, object, stack) => Image.asset(
//                         AppImg.img_error,
//                         width: 65,
//                         height: 47,
//                       ),
//                       frameBuilder:
//                           (context, child, frame, wasSynchronouslyLoaded) {
//                         if (wasSynchronouslyLoaded) {
//                           return child;
//                         } else {
//                           return AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 500),
//                             child: frame != null
//                                 ? child
//                                 : Container(
//                                     width: 65,
//                                     height: 47,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(5)),
//                                       color: Colors.grey[200],
//                                     ),
//                                   ),
//                           );
//                         }
//                       },
//                     )),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${widget.product.name}",
//                         maxLines: kIsWeb? null : 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTypo.body1v2.copyWith(
//                             color: widget.product.stock == 0
//                                 ? AppColor.textSecondary
//                                 : AppColor.textPrimary),
//                       ),
//                       SizedBox(height: 2),
//                       widget.product.wholesale.length > 0
//                           ? Container(
//                               margin:
//                                   EdgeInsets.only(right: 5, top: 3, bottom: 3),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 4, vertical: 2),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(2),
//                                   color: AppColor.gold.withOpacity(0.75)),
//                               child: Text(
//                                 "Grosir",
//                                 style: AppTypo.overline.copyWith(
//                                     fontWeight: FontWeight.w700,
//                                     color: AppColor.red,
//                                     fontSize: 12),
//                               ),
//                             )
//                           : SizedBox.shrink(),
//                       Row(
//                         children: [
//                           RichText(
//                             text: TextSpan(
//                               text: "Rp " +
//                                   AppExt.toRupiah(widget.product.enduserPrice),
//                               style: AppTypo.body1v2.copyWith(
//                                   fontWeight: FontWeight.w700,
//                                   color: widget.product.stock == 0
//                                       ? AppColor.textSecondary
//                                       : AppColor.textPrimary),
//                               // children: <TextSpan>[
//                               //   TextSpan(
//                               //       text: "/box", style: AppTypo.body1v2Accent),
//                               // ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       widget.product.stock == 0
//                           ? Container(
//                               margin:
//                                   EdgeInsets.only(right: 5, top: 3, bottom: 3),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 4, vertical: 2),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(2),
//                                   color: AppColor.red.withOpacity(0.2)),
//                               child: Text(
//                                 "Stok Kosong",
//                                 style: AppTypo.overline.copyWith(
//                                     fontWeight: FontWeight.w700,
//                                     color: AppColor.red,
//                                     fontSize: 12),
//                               ),
//                             )
//                           : SizedBox.shrink(),
//                     ],
//                   ),
//                 ),
//                 widget.product.stock > 0
//                     ? Row(children: [
//                         Material(
//                           color: Colors.transparent,
//                           child: IconButton(
//                             visualDensity: VisualDensity.compact,
//                             disabledColor: AppColor.primary.withOpacity(0.3),
//                             icon: Icon(FlutterIcons.minus_circle_outline_mco),
//                             onPressed: widget.product.stock != 0 &&
//                                     widget.product.quantity > 1
//                                 ? () => _onMin()
//                                 : null,
//                             color: AppColor.primary,
//                             iconSize: 30,
//                             splashRadius: 18,
//                           ),
//                         ),
//                         Container(
//                           constraints: BoxConstraints(maxWidth: 60),
//                           child: IntrinsicWidth(
//                             child: TextFormField(
//                               onChanged: (value) => _updateQuantity(value),
//                               controller: _quantityController,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly,
//                               ],
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 counter: SizedBox.shrink(),
//                                 isDense: true,
//                                 contentPadding: EdgeInsets.only(
//                                   bottom: 2,
//                                 ),
//                               ),
//                               style: AppTypo.subtitle2.copyWith(
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Material(
//                           color: Colors.transparent,
//                           child: IconButton(
//                             visualDensity: VisualDensity.compact,
//                             disabledColor: AppColor.primary.withOpacity(0.3),
//                             icon: Icon(FlutterIcons.plus_circle_outline_mco),
//                             onPressed:
//                                 widget.product.stock > widget.product.quantity
//                                     ? () => _onPlus()
//                                     : null,
//                             color: AppColor.primary,
//                             iconSize: 30,
//                             splashRadius: 18,
//                           ),
//                         ),
//                       ])
//                     : SizedBox.shrink(),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Material(
//                     color: Colors.transparent,
//                     elevation: 0,
//                     child: InkWell(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(5),
//                       ),
//                       onTap: () async {
//                         LoadingDialog.show(context);
//                         await Future.delayed(Duration(milliseconds: 200));
//                         _deleteCartItemCubit.deleteCartItem(
//                             listCartId: [widget.product.cartId]);
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Boxicons.bxs_trash, color: AppColor.grey),
//                           SizedBox(width: 3),
//                           Text(
//                             "Hapus",
//                             style: AppTypo.captionAccent
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
