import 'dart:convert';

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
import 'package:marketplace/data/repositories/cart_repository.dart';
import 'package:marketplace/data/repositories/repositories.dart';

import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_body.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_footer.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_header.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_alamat_pelanggan_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/cart/wpp_cart_body.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/cart/wpp_cart_footer.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/cart/wpp_cart_header.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppCartWebScreen extends StatefulWidget {
  const WppCartWebScreen({Key key}) : super(key: key);

  @override
  _WppCartWebScreenState createState() => _WppCartWebScreenState();
}

class _WppCartWebScreenState extends State<WppCartWebScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final CartRepository _repo = CartRepository();
  final RecipentRepository _recipentRepo = RecipentRepository();

  // FetchCartCubit _fetchCartCubit;
  UpdateQuantityCubit _updateQuantityCubit;
  CartStockValidationCubit _cartStockValidationCubit;
  IncDecCartCubit _incDecCartCubit;
  FetchRecipentCubit _fetchRecipentCubit;

  // List<Cart> _listCart;
  List<CartResponseElement> _listCart;
  bool _goBack;
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
    // _fetchCartCubit = FetchCartCubit()..load();
    // _fetchCartCubit = FetchCartCubit();
    _updateQuantityCubit = UpdateQuantityCubit();
    _cartStockValidationCubit = CartStockValidationCubit();
    _incDecCartCubit = IncDecCartCubit();
    _fetchRecipentCubit = FetchRecipentCubit();
    // context.read<IncDecCartCubit>();
    context.read<FetchCartCubit>().reset();

    _recipentRepo.setRecipentUserNoAuthDetailProduct(
        subdistrictId:
            _recipentRepo.getSelectedRecipentNoAuth()['subdistrict_id'],
        subdistrict: _recipentRepo.getSelectedRecipentNoAuth()['subdistrict'],
        city: _recipentRepo.getSelectedRecipentNoAuth()['city'],
        province: _recipentRepo.getSelectedRecipentNoAuth()['province'],
        name: _recipentRepo.getSelectedRecipentNoAuth()['name'],
        address: _recipentRepo.getSelectedRecipentNoAuth()['address'],
        phone: _recipentRepo.getSelectedRecipentNoAuth()['phone'],
      );

    _loadCart();
  }

  void _loadCart() {}

  @override
  void didChangeDependencies() {
    final offlineCart = BlocProvider.of<AddToCartOfflineCubit>(context).state;
    context
            .read<FetchCartCubit>()
            .fetchCartOffline(List<CartResponseElement>.from(offlineCart.cart));
        // _fetchCartCubit.fetchCartOffline(List<CartResponseElement>.from(offlineCart.cart));
        _incDecCartCubit.initialization(offlineCart.cart,false);
        setState(() {
          _listCart = offlineCart.cart;
        });
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
      for (var i = 0;
      i < stateStore[c].item.length;
      i++) {
        if (stateStore[c].item[i].checked) {
          var newProduct = _listCart[c]
              .products
              .firstWhere((element) =>
          element.productId ==
              stateStore[c]
                  .item[i]
                  .productId &&
              element.id ==
                  stateStore[c].item[i].cartId);
          var newCart = CartProduct(
            cartId: newProduct.id,
            id: newProduct.productId,
            stock: newProduct.product.stock,
            name: newProduct.product.name,
            variantSelected: newProduct.variantSelected != null
                ? newProduct.variantSelected
                : null,
            enduserPrice:
            newProduct.product.disc > 0 ?
            newProduct.product.discPrice : newProduct.product.sellingPrice,
            initialPrice:
             newProduct.product.disc > 0 ?
            newProduct.product.discPrice : newProduct.product.sellingPrice,
            productPhoto: newProduct.product.productPhoto[0].image,
            quantity: stateStore[c].item[i].qty,
            weight: newProduct.product.weight,
            unit: newProduct.product.unit,
            wholesale: [],
          );
          products.add(newCart);
        }
      }
      var totalChecked = 0;
      for (var i = 0;
      i < stateStore[c].item.length;
      i++) {
        if (!stateStore[c].item[i].checked)
          continue;
        if (stateStore[c].item[i].checked) {
          if (totalChecked >= 1) break;
          listCart.add(NewCart(
              sellerId: stateStore[c].sellerId,
              resellerId: stateStore[c].resellerId,
              nameSeller: stateStore[c].nameSeller,
              city: _listCart[c].reseller.city,
              product: products));
          totalChecked = 1;
        }
      }
    }

    debugPrint("listCart ${listCart}");
     context.beamToNamed(
      '/wpp/customeraddress/?dt=${AppExt.encryptMyData(jsonEncode(listCart))}'
      );

    // if (!kIsWeb) {
    //   // AppExt.popScreen(context);
    //   //
    //   /// jon ini datane [listCart]
    //   AppExt.pushScreen(
    //     context,
    //     CheckoutScreen(
    //       // sellerId:
    //       //     _listCart[_selectedCartIndex].sellerId,
    //       cart: listCart,
    //     ),
    //   );
    // } else {
    //   // context.beamToNamed(
    //   // '/checkout/cart/${_listCart[_selectedCartIndex].sellerId}?c=${AppExt.encryptMyData(json.encode(filteredCart))}',
    //   // '/checkout/cart/${_listCart[_selectedCartIndex].products[0].productId}?c=${AppExt.encryptMyData(json.encode(null))}',
    //   // data: {
    //   //   'cart': filteredCart,
    //   // }
    //   // );
    //   if (BlocProvider.of<UserDataCubit>(context)
    //       .state
    //       .user ==
    //       null) {
    //     AppExt.pushScreen(
    //       context,
    //       WppAlamatPelangganScreen(
    //         // sellerId:
    //         //     _listCart[_selectedCartIndex].sellerId,
    //         cart: listCart,
    //       ),
    //     );
    //   } else {
    //     AppExt.pushScreen(
    //       context,
    //       CheckoutScreen(
    //         // sellerId:
    //         //     _listCart[_selectedCartIndex].sellerId,
    //         cart: listCart,
    //       ),
    //     );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final config = AAppConfig.of(context);

    // final offlineCart = BlocProvider.of<AddToCartOfflineCubit>(context).state;
    JoinUserRepository _repo = JoinUserRepository();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: kIsWeb ? 450 : double.infinity),
        child: WillPopScope(
            onWillPop: () async {
              if (kIsWeb) {
                context.beamBack();
              } else {
                AppExt.popScreen(context);
              }
              /*if (_listCart.length > 0) {
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
              }
              await BlocProvider.of<UserDataCubit>(context).updateCountCart();*/
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
                              debugPrint("TEST 1");
                              debugPrint("fetch cart state success ${state.cart}");
                              // _incDecCartCubit.initialization(state.cart);
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
                            if (state is FetchRecipentSuccess){
                              debugPrint("myrecipient ${state.recipent}");
                              final recipient = state.recipent.singleWhere((element) => element.isMainAddress == 1, orElse: () => null);
                              if (recipient != null){
                                final cityId = recipient.cityId;
                                context.read<FetchCartCubit>().fetchCartWithCityId(cityId: cityId);
                              } else {
                                context.read<FetchCartCubit>().load();
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

                               _passingDataCartToCheckout();
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
                      child:
                       BlocBuilder<FetchCartCubit, FetchCartState>(
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
                            debugPrint("TEST 2 = " + state.cart.length.toString());
                            // debugPrint("TEST 3 = " + state.uncovered.length.toString());
                            return 
                            ((state.cart != null && state.cart.length > 0) || (state.uncovered != null && state.uncovered.length > 0  ))
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
                                        child: WppCartHeader(),
                                      ),
                                    ),
                                    body: SafeArea(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Container(
                                              color: Colors.grey[100],
                                              child: WppCartBody(
                                                cart: state.cart ?? null,
                                                uncovered: state.uncovered ?? null,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: WppCartFooter(
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
                                        context.beamToNamed('/wpp/dashboard/${_repo.getSlugReseller()}');
                                      },
                                    ),
                                  );
                          }

                          return Center(child: CircularProgressIndicator(),);
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
