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
import 'package:marketplace/data/blocs/new_cubit/products/product_coverage_validation/product_coverage_validation_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/product_detail_appbar.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/product_detail_body.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/product_detail/wpp_product_detail_appbar.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/product_detail/wpp_product_detail_body.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/wpp_bs_product_detail_not_coverage.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/wpp_bs_search_kecamatan.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/decorations.dart' as AppDecor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:beamer/beamer.dart';

class WppProductDetailWebScreen extends StatefulWidget {
  const WppProductDetailWebScreen({
    Key key,
    this.categoryId,
    @required this.slugWarung,
    @required this.slugProduct,
    this.productId,
  }) : super(key: key);

  final int categoryId, productId;
  final String slugWarung, slugProduct;

  @override
  _WppProductDetailWebScreenState createState() =>
      _WppProductDetailWebScreenState();
}

class _WppProductDetailWebScreenState extends State<WppProductDetailWebScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final RecipentRepository _recipentRepo = RecipentRepository();

  FetchProductDetailCubit _fetchProductDetailCubit;
  FetchProductRecomCubit _fetchProductRecomCubit;
  FetchSelectedRecipentCubit _fetchSelectedRecipent;
  ProductCoverageValidationCubit _productCoverageValidationCubit;

  AnimationController _colorAnimationController;
  Animation<Color> _colorTween,
      _iconColorTween,
      _iconBackgroundColorTween,
      _shadowColorTween;

  int subdistrictId = 0;

  @override
  void initState() {
    _fetchProductDetailCubit = FetchProductDetailCubit()
      ..fetchProductDetailWarung(
          slugWarung: widget.slugWarung, slugProduct: widget.slugProduct);
    _fetchProductRecomCubit = FetchProductRecomCubit()..fetchProductRecom();
    _productCoverageValidationCubit = ProductCoverageValidationCubit();
    _fetchSelectedRecipent = FetchSelectedRecipentCubit()
      ..fetchSelectedrecipentUserNoAuthDetailProduct();
    // subdistrictId =
    //     _recipentRepo.getSelectedRecipentNoAuthDetailProduct()['subdistrict_id'] ?? 0;

    // if (_recipentRepo.getSelectedRecipentNoAuthDetailProduct()['subdistrict_id'] == null) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     bsAddress();
    //   });
    // } else {
    //   // debugPrint(
    //   //     "KECAMATAN ID PRODUCT DETAIL : ${_recipentRepo.getSelectedRecipentResellerShop()['subdistrict_id']} ");
    //   // _productCoverageValidationCubit.productCoverageValidate(
    //   //     productId: widget.productId, subdistrictId: subdistrictId);
    //   _recipentRepo.setRecipentUserNoAuthDashboard(
    //     subdistrictId:
    //         _recipentRepo.getSelectedRecipentNoAuth()['subdistrict_id'],
    //     subdistrict: _recipentRepo.getSelectedRecipentNoAuth()['subdistrict'],
    //     city: _recipentRepo.getSelectedRecipentNoAuth()['city'],
    //     province: _recipentRepo.getSelectedRecipentNoAuth()['province'],
    //     name: _recipentRepo.getSelectedRecipentNoAuth()['name'],
    //     address: _recipentRepo.getSelectedRecipentNoAuth()['address'],
    //     phone: _recipentRepo.getSelectedRecipentNoAuth()['phone'],
    //   );
    //   _recipentRepo.gs.remove('recipentUserNoAuthDetailProduct');

    // }

    if (_recipentRepo.getFromWppDashboardCheck() == false) {
      if (_recipentRepo.getSelectedRecipentNoAuthDetailProduct() == null ||
          _recipentRepo
                  .getSelectedRecipentNoAuthDetailProduct()['subdistrict_id'] ==
              null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          bsAddress();
        });
      } else {
        _recipentRepo.gs.remove('recipentUserNoAuthDetailProduct');
      }
    } else {
      // debugPrint(
      //     "KECAMATAN ID PRODUCT DETAIL : ${_recipentRepo.getSelectedRecipentResellerShop()['subdistrict_id']} ");
      // _productCoverageValidationCubit.productCoverageValidate(
      //     productId: widget.productId, subdistrictId: subdistrictId);
      _recipentRepo.isFromWppDashboard(value: false);
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
      _recipentRepo.gs.remove('recipentUserNoAuthDetailProduct');
    }

    super.initState();

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_colorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.white, end: AppColor.primary)
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
    _productCoverageValidationCubit.close();
    _fetchSelectedRecipent.close();
    // _fetchShippingAddressesCubit.close();
    super.dispose();
  }

  void bsAddress() {
    WppBsSearchKecamatan.show(
      context,
      useCloseButton: false,
      image: AppImg.img_delivery_road,
      title: "Mau kirim belanjaan kemana?",
      description:
          "Sebelum menuju detail produk, tentukan alamat pengiriman mu agar kami bisa memberikan rekomendasi produk yang sesuai.",
      onTap: (subdistrictId, subdistrictVal) {
        debugPrint(subdistrictVal);
        _productCoverageValidationCubit.productCoverageValidate(
            productId: widget.productId, subdistrictId: subdistrictId);
      },
    );
  }

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
            create: (_) => _fetchProductRecomCubit,
          ),
          BlocProvider(
            create: (_) => _productCoverageValidationCubit,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener(
                cubit: _productCoverageValidationCubit,
                listener: (ctx, state) {
                  if (state is ProductCoverageValidationSuccess) {
                    if (state.status != true) {
                      WppBsProductDetailNotCoverage.show(context, onTap: () {
                        _recipentRepo.setRecipentUserNoAuthDashboard(
                          subdistrictId: _recipentRepo
                              .getSelectedRecipentNoAuth()['subdistrict_id'],
                          subdistrict: _recipentRepo
                              .getSelectedRecipentNoAuth()['subdistrict'],
                          city:
                              _recipentRepo.getSelectedRecipentNoAuth()['city'],
                          province: _recipentRepo
                              .getSelectedRecipentNoAuth()['province'],
                          name:
                              _recipentRepo.getSelectedRecipentNoAuth()['name'],
                          address: _recipentRepo
                              .getSelectedRecipentNoAuth()['address'],
                          phone: _recipentRepo
                              .getSelectedRecipentNoAuth()['phone'],
                        );
                        context
                            .beamToNamed('/wpp/dashboard/${widget.slugWarung}');
                      });
                    }
                  }
                  if (state is ProductCoverageValidationFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          margin: EdgeInsets.zero,
                          duration: Duration(seconds: 2),
                          content: Text('Terjadi Kesalahan'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  }
                }),
            BlocListener(
                cubit: _fetchProductDetailCubit,
                listener: (ctx, state) {
                  if (state is FetchProductDetailFailure) {
                    WppBsSearchKecamatan.show(
                      context,
                      useCloseButton: false,
                      isRouteToListWarung: true,
                      image: AppImg.img_product_error,
                      title: state.message,
                      description:
                          "Silahkan memilih kecamatan, agar kami bisa merekomendasikan warung untuk anda",
                      onTap: (subdistrictId, subdistrictVal) {
                        debugPrint(subdistrictVal);
                        // _productCoverageValidationCubit.productCoverageValidate(
                        //     productId: widget.productId, subdistrictId: subdistrictId);
                      },
                    );
                  }
                })
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
                                              _fetchProductDetailCubit
                                                  .fetchProductDetailWarung(
                                                      slugWarung:
                                                          widget.slugWarung,
                                                      slugProduct:
                                                          widget.slugProduct);
                                            })
                                          : ErrorFetch(
                                              message: state.message,
                                              onButtonPressed: () {
                                                _fetchProductDetailCubit
                                                    .fetchProductDetailWarung(
                                                        slugWarung:
                                                            widget.slugWarung,
                                                        slugProduct:
                                                            widget.slugProduct);
                                              },
                                            ),
                                    )
                                  : state is FetchProductDetailSuccess
                                      ? NotificationListener<
                                          ScrollNotification>(
                                          onNotification: _scrollListener,
                                          child: Stack(
                                            children: [
                                              WppProductDetailBody(
                                                productId: widget.productId,
                                                categoryId: widget.categoryId,
                                                product: state.product,
                                                isPublicResellerShop: true,
                                              ),
                                              AnimatedBuilder(
                                                animation:
                                                    _colorAnimationController,
                                                builder: (BuildContext context,
                                                        Widget child) =>
                                                    WppProductDetailAppbar(
                                                  product: state.product,
                                                  isPublicResellerShop: true,
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
