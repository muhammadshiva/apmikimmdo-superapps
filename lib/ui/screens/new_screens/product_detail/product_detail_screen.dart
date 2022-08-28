import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/add_to_cart/add_to_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_product_detail/fetch_product_detail_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_product_recom/fetch_product_recom_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/product_detail_appbar.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/product_detail_body.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/decorations.dart' as AppDecor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    Key key,
    @required this.productId,
    this.categoryId,
  }) : super(key: key);

  final int categoryId, productId;
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FetchProductDetailCubit _fetchProductDetailCubit;
  FetchProductRecomCubit _fetchProductRecomCubit;
  AddToCartCubit _addToCartCubit;

  AnimationController _colorAnimationController;
  Animation<Color> _colorTween,
      _iconColorTween,
      _iconBackgroundColorTween,
      _shadowColorTween;

  @override
  void initState() {
    _fetchProductDetailCubit = FetchProductDetailCubit()
      ..load(
        productId: widget.productId,
      );
    _addToCartCubit =
        AddToCartCubit(userDataCubit: BlocProvider.of<UserDataCubit>(context));
    _fetchProductRecomCubit = FetchProductRecomCubit()..fetchProductRecom();

    super.initState();

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_colorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.white, end: Color(0xFFF4406F))
        .animate(_colorAnimationController);
    _iconBackgroundColorTween =
        ColorTween(begin: Color(0xFF000000).withOpacity(0.2), end: Colors.white)
            .animate(_colorAnimationController);
    _shadowColorTween = ColorTween(begin: Colors.transparent, end: Colors.grey)
        .animate(_colorAnimationController);
  }

  @override
  void dispose() {
    _fetchProductDetailCubit.close();
    _fetchProductRecomCubit.close();
    _addToCartCubit.close();
    // _fetchShippingAddressesCubit.close();
    super.dispose();
  }

  // _handleAddToCart({@required int sellerId}) {
  //   LoadingDialog.show(context);
  //   _addToCartCubit.addToCart(productId: widget.productId, sellerId: sellerId);
  // }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 150);

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _fetchProductDetailCubit,
          ),
          BlocProvider(
            create: (_) => _addToCartCubit,
          ),
          BlocProvider(
            create: (_) => _fetchProductRecomCubit,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener(
              cubit: _addToCartCubit,
              listener: (_, state) {
                if (state is AddToCartFailure) {
                  AppExt.popScreen(context);
                  BSFeedback.show(
                    context,
                    icon: Boxicons.bx_x_circle,
                    color: AppColor.red,
                    title: "Produk gagal ditambahkan ke keranjang",
                    description: "${state.message}",
                  );
                  return;
                }
                if (state is AddToCartSuccess) {
                  AppExt.popScreen(context);
                  BottomSheetFeedbackAddCart.show(
                    context,
                    title: "Produk ditambahkan ke keranjang",
                    description: "Silakan checkout untuk melakukan pembelian",
                  );
                  _fetchProductDetailCubit.reload(productId: widget.productId);
                  return;
                }
              },
            ),
          ],
          child: GestureDetector(
            onTap: () => AppExt.hideKeyboard(context),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
                child: Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: AppColor.textPrimaryInverted,
                  body: SafeArea(
                    child: BlocBuilder(
                      cubit: _fetchProductDetailCubit,
                      builder: (context, state) {
                        return AppTrans.SharedAxisTransitionSwitcher(
                          fillColor: Colors.transparent,
                          transitionType: SharedAxisTransitionType.vertical,
                          child: state is FetchProductDetailLoading
                              ? ShimmerProductDetail()
                              : state is FetchProductDetailFailure
                                  ? Center(
                                      child: state.type == ErrorType.network
                                          ? NoConnection(onButtonPressed: () {
                                              _fetchProductDetailCubit.load(
                                                  productId: widget.productId);
                                            })
                                          : ErrorFetch(
                                              message: state.message,
                                              onButtonPressed: () {
                                                _fetchProductDetailCubit.load(
                                                    productId:
                                                        widget.productId);
                                              },
                                            ),
                                    )
                                  : state is FetchProductDetailSuccess
                                      ? NotificationListener<
                                          ScrollNotification>(
                                          onNotification: _scrollListener,
                                          child: Stack(
                                            children: [
                                              ProductDetailBody(
                                                productId: widget.productId,
                                                categoryId: widget.categoryId,
                                                product: state.product,
                                              ),
                                              AnimatedBuilder(
                                                animation:
                                                    _colorAnimationController,
                                                builder: (BuildContext context,
                                                        Widget child) =>
                                                    ProductDetailAppbar(
                                                  product: state.product,
                                                  backgroundColor:
                                                      _colorTween.value,
                                                  iconColor:
                                                      _iconColorTween.value,
                                                  iconBackundColor:
                                                      _iconBackgroundColorTween
                                                          .value,
                                                  shadowColor:
                                                      _shadowColorTween.value,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                        );
                      },
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
}
