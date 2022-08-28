import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/cart_stock_validation/cart_stock_validation_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/update_quantity/update_quantity_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/inc_dec_cart/inc_dec_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/wpp_cart/add_to_cart_offline/add_to_cart_offline_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/cart.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_account_screen.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_body.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_footer.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_header.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_alamat_pelanggan_screen.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/bs_feedback.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // FetchCartCubit _fetchCartCubit;
  UpdateQuantityCubit _updateQuantityCubit;
  CartStockValidationCubit _cartStockValidationCubit;
  IncDecCartCubit _incDecCartCubit;
  FetchRecipentCubit _fetchRecipentCubit;

  // List<Cart> _listCart;
  List<CartResponseElement> _listCart;
  bool _goBack;
  bool isRecipentAvailable;
  int _selectedCartIndex;

  @override
  void initState() {
    super.initState();
    /*SchedulerBinding.instance.addPostFrameCallback((_) {
      if (BlocProvider.of<UserDataCubit>(context).state.user == null)
        // AppRouter.router.navigateTo(
        //   context,
        //   AppRoutes.rootRoute.route,
        //   clearStack: true,
        //   replace: true,
        // );
        context.beamToNamed(
          '/',
          stacked: false,
          replaceCurrent: true,
        );
    });*/

    _goBack = false;
    _listCart = [];
    isRecipentAvailable = true;
    // _fetchCartCubit = FetchCartCubit()..load();
    // _fetchCartCubit = FetchCartCubit();
    _updateQuantityCubit = UpdateQuantityCubit();
    _cartStockValidationCubit = CartStockValidationCubit();
    _incDecCartCubit = IncDecCartCubit();
    _fetchRecipentCubit = FetchRecipentCubit();
    // context.read<IncDecCartCubit>();
    context.read<FetchCartCubit>().reset();

    _loadCart();
  }

  void _loadCart() {}

  @override
  void didChangeDependencies() {
    final offlineCart = BlocProvider.of<AddToCartOfflineCubit>(context).state;
    if (kIsWeb) {
      if (BlocProvider.of<UserDataCubit>(context).state.user == null) {
        context
            .read<FetchCartCubit>()
            .fetchCartOffline(List<CartResponseElement>.from(offlineCart.cart));

        _incDecCartCubit.initialization(offlineCart.cart, true);
        setState(() {
          _listCart = offlineCart.cart;
        });
      } else {
        _fetchRecipentCubit.fetchRecipents();
      }
    } else {
      _fetchRecipentCubit.fetchRecipents();
    }
  }

  @override
  void dispose() {
    _updateQuantityCubit.close();
    _cartStockValidationCubit.close();
    _incDecCartCubit.close();
    _fetchRecipentCubit.close();
    super.dispose();
  }

  _updateQuantity(List<int> cartId, List<int> quantity) {
    _updateQuantityCubit.updateQuantity(cartId: cartId, quantity: quantity);
  }

  void _passingDataCartToCheckout() {
    var stateStore = _incDecCartCubit.state.store;

    List<NewCart> listCart = [];
    for (var c = 0; c < stateStore.length; c++) {
      List<CartProduct> products = [];
      for (var i = 0; i < stateStore[c].item.length; i++) {
        if (stateStore[c].item[i].checked) {
          var newProduct = _listCart[c].products.firstWhere((element) =>
              element.productId == stateStore[c].item[i].productId &&
              element.id == stateStore[c].item[i].cartId);
          var newCart = CartProduct(
            cartId: newProduct.id,
            id: newProduct.productId,
            stock: newProduct.product.stock,
            name: newProduct.product.name,
            productVariantName: newProduct.product.productVariant.length > 0
                ? newProduct.product.productVariant[0].variantName
                : null,
            enduserPrice: newProduct.product.productVariant.length > 0
                ? newProduct.product.productVariant[0].variantDisc != 0
                    ? newProduct.product.productVariant[0].variantDiscPrice
                    : newProduct.product.productVariant[0].variantSellPrice
                : newProduct.product.discPrice != 0
                    ? newProduct.product.discPrice
                    : newProduct.product.sellingPrice,
            initialPrice: newProduct.product.sellingPrice,
            productPhoto: newProduct.product.coverPhoto,
            quantity: stateStore[c].item[i].qty,
            weight: newProduct.product.productVariant.length > 0
                ? newProduct.product.productVariant[0].variantWeight
                : newProduct.product.weight,
            unit: newProduct.product.productVariant.length > 0
                ? newProduct.product.productVariant[0].variantUnit
                : newProduct.product.unit,
            wholesale: [],
          );
          products.add(newCart);
        }
      }
      var totalChecked = 0;
      for (var i = 0; i < stateStore[c].item.length; i++) {
        if (!stateStore[c].item[i].checked) continue;
        if (stateStore[c].item[i].checked) {
          if (totalChecked >= 1) break;
          listCart.add(NewCart(
              sellerId: stateStore[c].sellerId,
              nameSeller: stateStore[c].nameSeller,
              city: _listCart[c].supplier.city,
              product: products));
          totalChecked = 1;
        }
      }
    }

    debugPrint("listCart ${listCart}");

    if (!kIsWeb) {
      // AppExt.popScreen(context);
      //
      /// jon ini datane [listCart]
      AppExt.pushScreen(
        context,
        CheckoutScreen(
          // sellerId:
          //     _listCart[_selectedCartIndex].sellerId,
          cart: listCart,
        ),
      );
    } else {
      // context.beamToNamed(
      // '/checkout/cart/${_listCart[_selectedCartIndex].sellerId}?c=${AppExt.encryptMyData(json.encode(filteredCart))}',
      // '/checkout/cart/${_listCart[_selectedCartIndex].products[0].productId}?c=${AppExt.encryptMyData(json.encode(null))}',
      // data: {
      //   'cart': filteredCart,
      // }
      // );
      if (BlocProvider.of<UserDataCubit>(context).state.user == null) {
        AppExt.pushScreen(
          context,
          WppAlamatPelangganScreen(
            // sellerId:
            //     _listCart[_selectedCartIndex].sellerId,
            cart: listCart,
          ),
        );
      } else {
        AppExt.pushScreen(
          context,
          CheckoutScreen(
            // sellerId:
            //     _listCart[_selectedCartIndex].sellerId,
            cart: listCart,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final userData = BlocProvider.of<UserDataCubit>(context).state.user != null
        ? BlocProvider.of<UserDataCubit>(context).state.user
        : null;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: kIsWeb ? 450 : double.infinity),
        child: WillPopScope(
            onWillPop: () async {
              AppExt.popScreen(context);
              return true;
            },
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => _updateQuantityCubit),
                BlocProvider(create: (_) => _cartStockValidationCubit),
                BlocProvider(
                  create: (_) => _incDecCartCubit,
                ),
                BlocProvider(
                  create: (_) => _fetchRecipentCubit,
                ),
              ],
              child: GestureDetector(
                onTap: () => AppExt.hideKeyboard(context),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: !context.isPhone ? 450 : 1000,
                  ),
                  child: Scaffold(
                    body: MultiBlocListener(
                      listeners: [
                        BlocListener<FetchCartCubit, FetchCartState>(
                          listener: (context, state) {
                            debugPrint("my fetch cart state $state");
                            if (state is FetchCartSuccess) {
                              debugPrint(
                                  "fetch cart state success ${state.cart}");
                              _incDecCartCubit.initialization(state.cart, true);
                              setState(() {
                                _listCart = state.cart;
                              });
                              return;
                            }
                            if (state is FetchCartFailure) {
                              debugPrint("fetch cart state failure");
                            }
                          },
                        ),
                        BlocListener<FetchRecipentCubit, FetchRecipentState>(
                          cubit: _fetchRecipentCubit,
                          listener: (context, state) {
                            if (state is FetchRecipentSuccess) {
                              debugPrint("myrecipient ${state.recipent}");
                              final recipient = state.recipent.singleWhere(
                                  (element) => element.isMainAddress == 1,
                                  orElse: () => null);

                              if (recipient != null) {
                                final cityId = recipient.cityId;
                                setState(() {
                                  isRecipentAvailable = true;
                                });

                                context
                                    .read<FetchCartCubit>()
                                    .fetchCartWithCityId(cityId: cityId);
                              } else {
                                setState(() {
                                  isRecipentAvailable = false;
                                });
                              }
                            }
                          },
                        ),
                        BlocListener(
                          cubit: _updateQuantityCubit,
                          listener: (context, state) async {
                            if (state is UpdateQuantitySuccess) {
                              if (_goBack) {
                                AppExt.popScreen(context);
                                AppExt.popScreen(context);
                              } else {
                                _passingDataCartToCheckout();
                              }
                            }
                            if (state is UpdateQuantityFailure) {
                              setState(() {
                                _goBack = false;
                                _selectedCartIndex = null;
                              });

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
                              if (kIsWeb &&
                                  BlocProvider.of<UserDataCubit>(context)
                                          .state
                                          .user ==
                                      null) {
                                _passingDataCartToCheckout();
                              } else {
                                final state =
                                    context.read<IncDecCartCubit>().state;

                                List<int> quantity = [];
                                List<int> cartId = [];
                                for (var c = 0; c < state.store.length; c++) {
                                  for (var i = 0;
                                      i < state.store[c].item.length;
                                      i++) {
                                    // quantity.add(state.store[c].item[i].qty);
                                    cartId.add(state.store[c].item[i].cartId);
                                    quantity.add(state.store[c].item[i].qty);
                                  }

                                  debugPrint(
                                      "seller id ${state.store[c].sellerId} productId $cartId, quantity $quantity");
                                }
                                _updateQuantityCubit.updateQuantity(
                                    cartId: cartId, quantity: quantity);
                              }
                              return;
                            }
                            if (state is CartStockValidationFailure) {
                              setState(() {
                                _goBack = false;
                                _selectedCartIndex = null;
                              });
                              // _fetchCartCubit = FetchCartCubit()..load();
                              if (BlocProvider.of<UserDataCubit>(context)
                                      .state
                                      .user !=
                                  null) {
                                context.read<FetchCartCubit>().load();
                              }
                              // AppExt.popScreen(context);
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
                      child: BlocBuilder<FetchCartCubit, FetchCartState>(
                        builder: (context, state) {
                          if (state is FetchCartFailure) {
                            return Center(
                              child: state.type == ErrorType.network
                                  ? NoConnection(onButtonPressed: () {
                                      context.read<FetchCartCubit>().load();
                                    })
                                  : ErrorFetch(
                                      message: state.message,
                                      onButtonPressed: () {
                                        context.read<FetchCartCubit>().load();
                                      },
                                    ),
                            );
                          }
                          if (state is FetchCartSuccess) {
                            return (state.cart.length > 0 ||
                                    state.uncovered.length > 0)
                                ? Scaffold(
                                    appBar: AppBar(
                                      automaticallyImplyLeading: false,
                                      backgroundColor: Colors.white,
                                      centerTitle: true,
                                      elevation: 0,
                                      title: Text("Keranjang",
                                          style: AppTypo.subtitle2
                                              .copyWith(color: Colors.black)),
                                      bottom: PreferredSize(
                                        preferredSize: Size.fromHeight(50),
                                        child: CartHeader(),
                                      ),
                                    ),
                                    body: SafeArea(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Container(
                                              color: Colors.grey[100],
                                              child: CartBody(
                                                cart: state.cart,
                                                uncovered: state.uncovered,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: CartFooter(
                                              onPressed: () {
                                                final state = context
                                                    .read<IncDecCartCubit>()
                                                    .state;
                                                List<int> quantity = [];
                                                List<int> productId = [];
                                                for (var c = 0;
                                                    c < state.store.length;
                                                    c++) {
                                                  for (var i = 0;
                                                      i <
                                                          state.store[c].item
                                                              .length;
                                                      i++) {
                                                    // quantity.add(state.store[c].item[i].qty);
                                                    productId.add(state.store[c]
                                                        .item[i].productId);
                                                    quantity.add(state
                                                        .store[c].item[i].qty);
                                                  }
                                                  debugPrint(
                                                      "seller id ${state.store[c].sellerId} productId $productId, quantity $quantity");
                                                }

                                                context
                                                    .read<
                                                        CartStockValidationCubit>()
                                                    .cartStockValidation(
                                                        sellerId: 0, // not used
                                                        productId: productId,
                                                        quantity: quantity);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: EmptyData(
                                      title: "Keranjang belanja anda kosong",
                                      subtitle:
                                          "Silahkan pilih produk yang anda inginkan untuk mengisinya",
                                      labelBtn: "Mulai Belanja",
                                      onClick: () {
                                        BlocProvider.of<BottomNavCubit>(context)
                                            .navItemTapped(0);
                                        AppExt.popUntilRoot(context);
                                      },
                                    ),
                                  );
                          }

                          return isRecipentAvailable == false
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    _screenWidth * (5 / 100),
                                    0,
                                    _screenWidth * (5 / 100),
                                    _screenWidth * (5 / 100),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: _screenWidth * (75 / 100),
                                          child: Text(
                                            "Alamat pengiriman kosong atau belum ditentukan",
                                            style: AppTypo.h3.copyWith(
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: _screenWidth * (75 / 100),
                                          child: Text(
                                            "Tentukan alamat pengiriman terlebih dahulu",
                                            style: AppTypo.body1v2,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        RoundedButton.contained(
                                            label: "Tentukan Alamat",
                                            isUpperCase: false,
                                            onPressed: () {
                                              AppExt.popUntilRoot(context);
                                              AppExt.pushScreen(
                                                  context,
                                                  UpdateAccountScreen(
                                                      user: userData));
                                            })
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(
                                      vertical: _screenWidth * (4 / 100),
                                      horizontal: !context.isPhone
                                          ? 20
                                          : _screenWidth * (5 / 100)),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 15,
                                  ),
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return ShimmerCartItemWidget();
                                  },
                                );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
