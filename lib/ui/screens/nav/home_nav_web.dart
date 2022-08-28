import 'package:flutter/material.dart';

class HomeNavWeb extends StatefulWidget {
  const HomeNavWeb({ Key key }) : super(key: key);

  @override
  State<HomeNavWeb> createState() => _HomeNavWebState();
}

class _HomeNavWebState extends State<HomeNavWeb> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

// import 'dart:async';
// import 'dart:convert';

// import 'package:animations/animations.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_boxicons/flutter_boxicons.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:marketplace/data/blocs/new_cubit/products/fetch_products_by_category/fetch_products_by_category_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/sellers/fetch_sellers/fetch_sellers_cubit.dart';
// import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
// import 'package:marketplace/ui/screens/web/sections/web_sections.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:websafe_svg/websafe_svg.dart';

// import 'package:marketplace/api/api.dart';
// import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
// import 'package:marketplace/data/blocs/fetch_categories/fetch_categories_cubit.dart';
// import 'package:marketplace/data/blocs/fetch_home_slider/fetch_home_slider_cubit.dart';
// import 'package:marketplace/data/blocs/shipping/fetch_shipping_addresses/fetch_shipping_addresses_cubit.dart';
// import 'package:marketplace/data/blocs/shipping/shipping_address/shipping_address_cubit.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/products/fetch_products/fetch_products_cubit.dart';
// import 'package:marketplace/data/models/new_models/category.dart' as categoryModel;
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/data/repositories/authentication_repository.dart';
// import 'package:marketplace/data/repositories/recipent_repository.dart';
// import 'package:marketplace/ui/screens/products_by_category_screen.dart';
// import 'package:marketplace/ui/screens/screens.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:marketplace/ui/widgets/fetch_conditions.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:path/path.dart' as p;

// class HomeNavWeb extends StatefulWidget {

//   const HomeNavWeb({
//     Key key,
//   }) : super(key: key);

//   @override
//   _HomeNavWebState createState() => _HomeNavWebState();
// }

// class _HomeNavWebState extends State<HomeNavWeb> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   final AuthenticationRepository _authRepo = AuthenticationRepository();
//   final RecipentRepositoryOld _recipentRepo = RecipentRepositoryOld();

//   FetchProductsCubit _fetchPromoCubit;
//   FetchProductsCubit _fetchBestSellCubit;
//   FetchProductsCubit _fetchCateringCubit;
//   FetchHomeSliderCubit _fetchHomeSliderCubit;
//   FetchCategoriesCubit _fetchCategoriesCubit;
//   FetchCategoriesCubit _fetchCategoryProductRecomCubit;
//   FetchSellersCubit _fetchSellersCubit;

//   Completer<void> _refreshCompleter;

//   @override
//   void initState() {
//     super.initState();
//     _refreshCompleter = Completer<void>();

//     _fetchHomeSliderCubit = FetchHomeSliderCubit()..fetchHomeSlider();
//     _fetchPromoCubit = FetchProductsCubit(type: FetchProductsType.promo);
//     _fetchBestSellCubit = FetchProductsCubit(type: FetchProductsType.bestSell);
//     _fetchCategoriesCubit = FetchCategoriesCubit()..load();
//     _fetchCategoryProductRecomCubit = FetchCategoriesCubit()
//       ..categoryProductRecom();
//     _fetchSellersCubit = FetchSellersCubit()
//       ..load(
//         categoryId: 5,
//         recipentId: BlocProvider.of<ShippingAddressCubit>(context)
//                     .state
//                     .selectedRecipent !=
//                 null
//             ? BlocProvider.of<ShippingAddressCubit>(context)
//                 .state
//                 .selectedRecipent
//                 .id
//             : null,
//       );

//     _checkUser();
//     if (BlocProvider.of<UserDataCubit>(context).state.user != null) {
//       BlocProvider.of<FetchShippingAddressesCubit>(context).load();
//     } else {
//       _fetchPromoCubit.fetchProductsLimited();
//       _fetchBestSellCubit.fetchProductsLimited();
//       _fetchCateringCubit.fetchProductsLimited();
//       _fetchCategoryProductRecomCubit.categoryProductRecom();
//     }
//   }

//   void _checkUser() async {
//     if (await _authRepo.hasToken()) {
//       await BlocProvider.of<UserDataCubit>(context).loadUser();
//     }
//   }

//   void _handleAddAddress() async {
//     var isChanged = await AppExt.pushScreen(
//       context,
//       AddressEntryScreen(),
//     );
//     if (isChanged ?? false) {
//       BlocProvider.of<FetchShippingAddressesCubit>(context).load();
//     }
//   }

//   void _launchUrl(String _url) async {
//     if (await canLaunch(_url)) {
//       await launch(_url);
//     } else {
//       BSFeedback.show(
//         context,
//         icon: Boxicons.bx_x_circle,
//         color: AppColor.red,
//         title: "Gagal mengakses halaman",
//         description: "Halaman atau koneksi internet bermasalah",
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final config = AAppConfig.of(context);
//     final double _screenWidth = MediaQuery.of(context).size.width;
//     // if (_screenWidth < 1366) {
//     //   _fetchPromoCubit.fetchProductsLimited();
//     //   _fetchBestSellCubit.fetchProductsLimited();
//     //   _fetchCateringCubit.fetchProductsLimited();
//     // }
//     return Title(
//       color: AppColor.primary,
//       title: config.appName,
//       child: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
//         child: MultiBlocProvider(
//           providers: [
//             BlocProvider(create: (_) => _fetchPromoCubit),
//             BlocProvider(create: (_) => _fetchBestSellCubit),
//             BlocProvider(create: (_) => _fetchCateringCubit),
//             BlocProvider(create: (_) => _fetchHomeSliderCubit),
//             BlocProvider(create: (_) => _fetchCategoriesCubit),
//             BlocProvider(create: (_) => _fetchCategoryProductRecomCubit),
//           ],
//           child: GestureDetector(
//             onTap: () => AppExt.hideKeyboard(context),
//             child: Scaffold(
//               key: _scaffoldKey,
//               backgroundColor:
//                   context.isPhone ? AppColor.navScaffoldBg : Colors.white,
//               appBar:null,
//               body: MultiBlocListener(
//                 listeners: [
//                   BlocListener(
//                     cubit: BlocProvider.of<UserDataCubit>(context),
//                     listener: (context, state) {
//                       if (state is UserDataState) {
//                         if (state.user != null) {
//                           BlocProvider.of<FetchShippingAddressesCubit>(context)
//                               .load();
//                         } else {
//                           _checkUser();
//                           _fetchPromoCubit.fetchProductsLimited();
//                           _fetchBestSellCubit.fetchProductsLimited();
//                           _fetchCateringCubit.fetchProductsLimited();
//                           _fetchSellersCubit.load(categoryId: 5);
//                           _fetchCategoryProductRecomCubit
//                               .categoryProductRecom();
//                         }
//                       }
//                       return;
//                     },
//                   ),
//                   BlocListener(
//                     cubit: _fetchPromoCubit,
//                     listener: (context, state) {
//                       if (state is FetchProductsSuccess) {
//                         _refreshCompleter?.complete();
//                         _refreshCompleter = Completer();
//                       }
//                       if (state is FetchProductsFailure) {
//                         _refreshCompleter?.complete();
//                         _refreshCompleter = Completer();
//                       }
//                       return;
//                     },
//                   ),
//                   BlocListener(
//                     cubit: _fetchBestSellCubit,
//                     listener: (context, state) {
//                       if (state is FetchProductsSuccess) {
//                         _refreshCompleter?.complete();
//                         _refreshCompleter = Completer();
//                       }
//                       if (state is FetchProductsFailure) {
//                         _refreshCompleter?.complete();
//                         _refreshCompleter = Completer();
//                       }
//                       return;
//                     },
//                   ),
//                   BlocListener(
//                     cubit: _fetchCateringCubit,
//                     listener: (context, state) {
//                       if (state is FetchProductsSuccess) {
//                         _refreshCompleter?.complete();
//                         _refreshCompleter = Completer();
//                       }
//                       if (state is FetchProductsFailure) {
//                         _refreshCompleter?.complete();
//                         _refreshCompleter = Completer();
//                       }
//                       return;
//                     },
//                   ),
//                   BlocListener(
//                     cubit: _fetchHomeSliderCubit,
//                     listener: (context, state) {
//                       if (state is FetchHomeSliderSuccess) {
//                         _refreshCompleter?.complete();
//                         _refreshCompleter = Completer();
//                       }
//                       if (state is FetchHomeSliderFailure) {
//                         _refreshCompleter?.complete();
//                         _refreshCompleter = Completer();
//                       }
//                       return;
//                     },
//                   ),
//                   BlocListener(
//                     cubit:
//                         BlocProvider.of<FetchShippingAddressesCubit>(context),
//                     listener: (context, state) async {
//                       if (state is FetchShippingAddressesSuccess) {
//                         BlocProvider.of<ShippingAddressCubit>(context).set(
//                           selectedRecipent: await _recipentRepo
//                               .getRecipent(state.shippingAddresses),
//                           selectedRecipentIdx: await _recipentRepo
//                               .getRecipentIndex(state.shippingAddresses),
//                         );
//                         _fetchPromoCubit.fetchProductsLimited();
//                         _fetchBestSellCubit.fetchProductsLimited();
//                         _fetchCateringCubit.fetchProductsLimited();
//                         _fetchCategoryProductRecomCubit.categoryProductRecom();
//                         _fetchSellersCubit.load(
//                           categoryId: 5,
//                           recipentId: BlocProvider.of<ShippingAddressCubit>(
//                                           context)
//                                       .state
//                                       .selectedRecipent !=
//                                   null
//                               ? BlocProvider.of<ShippingAddressCubit>(context)
//                                   .state
//                                   .selectedRecipent
//                                   .id
//                               : null,
//                         );
//                         return;
//                       }

//                       if (state is FetchShippingAddressesFailure) {
//                         _scaffoldKey.currentState
//                           ..hideCurrentSnackBar()
//                           ..showSnackBar(
//                             SnackBar(
//                               margin: EdgeInsets.zero,
//                               duration: Duration(seconds: 5),
//                               action: SnackBarAction(
//                                   textColor: AppColor.primaryLight2,
//                                   label: "Retry",
//                                   onPressed: () {
//                                     BlocProvider.of<
//                                                 FetchShippingAddressesCubit>(
//                                             context)
//                                         .load();
//                                     _scaffoldKey.currentState
//                                         .hideCurrentSnackBar();
//                                   }),
//                               content: Text('${state.message}'),
//                               backgroundColor: Colors.grey[900],
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         return;
//                       }
//                     },
//                   ),
//                 ],
//                 child: BlocBuilder(
//                   cubit: _fetchPromoCubit,
//                   builder: (context, fetchPromoState) => BlocBuilder(
//                     cubit: _fetchBestSellCubit,
//                     builder: (context, fetchBestSellState) => BlocBuilder(
//                             cubit: _fetchHomeSliderCubit,
//                             builder: (context, fetchSlidersState) =>
//                                 BlocBuilder(
//                               cubit: _fetchCategoriesCubit,
//                               builder: (context, fetchCategoriesState) =>
//                                   BlocBuilder(
//                                 cubit: _fetchCategoryProductRecomCubit,
//                                 builder: (context, fetchCategorytRecomState) =>
//                                     BlocBuilder(
//                                   cubit: _fetchSellersCubit,
//                                   builder: (context, fetchSellersState) {
//                                     return RefreshIndicatorWrapper(
//                                       visible: context.isPhone,
//                                       onRefresh: () {
//                                         _checkUser();
//                                         _fetchPromoCubit.fetchProductsLimited();
//                                         _fetchBestSellCubit
//                                             .fetchProductsLimited();
//                                         _fetchCateringCubit
//                                             .fetchProductsLimited();
//                                         _fetchHomeSliderCubit.fetchHomeSlider();
//                                         _fetchCategoryProductRecomCubit
//                                             .categoryProductRecom();
//                                         return _refreshCompleter.future;
//                                       },
//                                       child: ScrollbarWrapper(
//                                         visible: !context.isPhone,
//                                         child: ListView(
//                                           children: [
//                                             Center(
//                                               child: ConstrainedBox(
//                                                 constraints: BoxConstraints(
//                                                   maxWidth: 1366,
//                                                 ),
//                                                 child: ListView(
//                                                   physics:
//                                                       NeverScrollableScrollPhysics(),
//                                                   shrinkWrap: true,
//                                                   children: [
//                                                     ListView(
//                                                       physics:
//                                                           NeverScrollableScrollPhysics(),
//                                                       shrinkWrap: true,
//                                                       children: [
//                                                         SizedBox(
//                                                                 height: 20,
//                                                               ),
//                                                         //===================================== HERO =====================================
//                                                         Container(
//                                                           color: Colors.white,
//                                                           padding: EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal:
//                                                                       82,
//                                                                 ),
//                                                           child: fetchSlidersState
//                                                                   is FetchHomeSliderLoading
//                                                               ? HeroSection(
//                                                                   isLoading:
//                                                                       true)
//                                                               : fetchSlidersState
//                                                                       is FetchHomeSliderSuccess
//                                                                   ? HeroSection(
//                                                                       sliders:
//                                                                           fetchSlidersState
//                                                                               .homeSliders,
//                                                                     )
//                                                                   : HeroSection(),
//                                                         ),
//                                                         //===================================== KATEGORI =====================================
//                                                         Container(
//                                                           color: Colors.white,
//                                                           padding: EdgeInsets.only(
//                                                                   top: 45, left: 82,right: 82
//                                                                 ),
//                                                           child: CategoryWeb(),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 20),
//                                                     AppTrans
//                                                         .SharedAxisTransitionSwitcher(
//                                                             transitionType:
//                                                                 SharedAxisTransitionType
//                                                                     .vertical,
//                                                             fillColor: Colors
//                                                                 .transparent,
//                                                             child: fetchPromoState is FetchProductsFailure &&
//                                                                     fetchBestSellState
//                                                                         is FetchProductsFailure 
//                                                                 ? Center(
//                                                                     child: fetchPromoState.type == ErrorType.network ??
//                                                                             fetchBestSellState.type ==
//                                                                                 ErrorType.network 
//                                                                         ? NoConnection(onButtonPressed: () {
//                                                                             _checkUser();
//                                                                             _fetchPromoCubit.fetchProductsLimited();
//                                                                             _fetchBestSellCubit.fetchProductsLimited();
//                                                                             _fetchCateringCubit.fetchProductsLimited();
//                                                                             _fetchHomeSliderCubit.fetchHomeSlider();
//                                                                           })
//                                                                         : ErrorFetch(
//                                                                             message: fetchPromoState.message ??
//                                                                                 fetchBestSellState.message ,
                                                                                
//                                                                             onButtonPressed:
//                                                                                 () {
//                                                                               _checkUser();
//                                                                               _fetchPromoCubit.fetchProductsLimited();
//                                                                               _fetchBestSellCubit.fetchProductsLimited();
//                                                                               _fetchCateringCubit.fetchProductsLimited();
//                                                                               _fetchHomeSliderCubit.fetchHomeSlider();
//                                                                             },
//                                                                           ),
//                                                                   )
//                                                                 : Column(
//                                                                     children: [
//                                                                       //============================================================PROMO (PANEN)===============================================================
//                                                                       Container(
//                                                                         padding: EdgeInsets.zero,
//                                                                         color: Colors
//                                                                             .white,
//                                                                         child:
//                                                                             Column(
//                                                                           children: [
//                                                                             fetchPromoState is FetchProductsLoading
//                                                                                 ? ShimmerProductList(isPromo: true)
//                                                                                 : fetchPromoState is FetchProductsSuccess
//                                                                                     ? fetchPromoState.products.length > 0
//                                                                                         ? !context.isPhone
//                                                                                             ? ProductListWeb(
//                                                                                                 titleSection: "Promo",
//                                                                                                 products: fetchPromoState.products,
//                                                                                                 isTitleSection: true,
//                                                                                                 isWithBottomDivider: true,
//                                                                                                 chunkSize: _screenWidth <= 975 && _screenWidth >= 875
//                                                                                                     ? 4
//                                                                                                     : _screenWidth <= 874
//                                                                                                         ? 3
//                                                                                                         : 5,
//                                                                                               )
//                                                                                             : ProductList(
//                                                                                                 section: "Promo",
//                                                                                                 products: fetchPromoState.products,
//                                                                                                 viewAll: fetchPromoState.products.length >= 7
//                                                                                                     ? () => AppExt.pushScreen(
//                                                                                                           context,
//                                                                                                           ViewAllProductScreen(
//                                                                                                             productsType: FetchProductsType.promo,
//                                                                                                           ),
//                                                                                                         )
//                                                                                                     : null,
//                                                                                               )
//                                                                                         : SizedBox.shrink()
//                                                                                     : SizedBox.shrink(),
//                                                                             Padding(
//                                                                                 padding: EdgeInsets.symmetric(horizontal: 82),
//                                                                                 child: SizedBox.shrink()),
//                                                                             fetchBestSellState is FetchProductsLoading
//                                                                                 ? ShimmerProductList(isPromo: false)
//                                                                                 : fetchBestSellState is FetchProductsSuccess
//                                                                                     ? fetchBestSellState.products.length > 0
//                                                                                         ? ProductListWeb(
//                                                                                                   titleSection: "Produk Terlaris",
//                                                                                                   products: fetchBestSellState.products,
//                                                                                                   isTitleSection: true,
//                                                                                                   isWithBottomDivider: true,
//                                                                                                 )
//                                                                                         : SizedBox.shrink()
//                                                                                     : SizedBox.shrink(),
//                                                                             fetchCategorytRecomState is FetchCategoriesLoading
//                                                                                 ? ShimmerProductList()
//                                                                                 : fetchCategorytRecomState is FetchCategoriesSuccess
//                                                                                     ? fetchCategorytRecomState.categories.length > 0
//                                                                                         ? ListView.separated(
//                                                                                             physics: NeverScrollableScrollPhysics(),
//                                                                                             shrinkWrap: true,
//                                                                                             separatorBuilder: (ctx, idx) {
//                                                                                               return SizedBox(height: !context.isPhone ? 7 : 0);
//                                                                                             },
//                                                                                             itemCount: fetchCategorytRecomState.categories.length,
//                                                                                             itemBuilder: (ctx, idx) {
//                                                                                               categoryModel.Category _categoryItem = fetchCategorytRecomState.categories[idx];
//                                                                                               return CategoryRecomProductListWeb(
//                                                                                                     category: _categoryItem,
//                                                                                                     isWithBottomDivider: idx == fetchCategorytRecomState.categories.length - 1 ? false : true ,
//                                                                                                   );
//                                                                                             },
//                                                                                           )
//                                                                                         : SizedBox.shrink()
//                                                                                     : SizedBox.shrink(),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       // config.appType ==
//                                                                       //         AppType.panenpanen
//                                                                       //     ? fetchSellersState is FetchSellersLoading
//                                                                       //         ? ShimmerResellerList()
//                                                                       //         : fetchSellersState is FetchSellersSuccess
//                                                                       //             ? fetchSellersState.sellers.length > 0
//                                                                       //                 ? Container(
//                                                                       //                     padding: EdgeInsets.only(
//                                                                       //                             top: 20,
//                                                                       //                           ),
//                                                                       //                     margin: !context.isPhone
//                                                                       //                         ? EdgeInsets.zero
//                                                                       //                         : EdgeInsets.only(
//                                                                       //                             top: 20,
//                                                                       //                           ),
//                                                                       //                     color: Colors.white,
//                                                                       //                     child: ResellerListWeb(
//                                                                       //                             section: "Reseller",
//                                                                       //                             seller: fetchSellersState.sellers,
//                                                                       //                           )
//                                                                       //                   )
//                                                                       //                 : SizedBox.shrink()
//                                                                       //             : SizedBox.shrink()
//                                                                       //     : SizedBox.shrink(),
//                                                                       config.appType == AppType.ichc ||
//                                                                               config.appType == AppType.sumedang
//                                                                           ? SizedBox.shrink()
//                                                                           : !context.isPhone
//                                                                               ?
//                                                                               // Container(
//                                                                               //         width: double.infinity,
//                                                                               //         padding: EdgeInsets.only(left: 82, right: 82, bottom: 25, top: 20),
//                                                                               //         child: Column(
//                                                                               //           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                               //           children: [
//                                                                               //             Text("Bergabung Bersama PanenMitra", style: AppTypo.h2.copyWith(fontWeight: FontWeight.w600, fontSize: 24)),
//                                                                               //             SizedBox(
//                                                                               //               height: 25,
//                                                                               //             ),
//                                                                               //             Container(
//                                                                               //               width: double.infinity,
//                                                                               //               child: Wrap(
//                                                                               //                 runSpacing: 28,
//                                                                               //                 spacing: 28,
//                                                                               //                 direction: Axis.horizontal,
//                                                                               //                 children: [
//                                                                               //                   GeneralOutlineButton(
//                                                                               //                     title: "Form Penawaran Produk Supplier",
//                                                                               //                     width: 300,
//                                                                               //                     icon: WebsafeSvg.asset(AppImg.ic_supplier, width: 35, height: 35),
//                                                                               //                     onPressed: () {
//                                                                               //                       _launchUrl('${AppConst.TOOLBOX_URL}/supplier/offering');
//                                                                               //                     },
//                                                                               //                   ),
//                                                                               //                   GeneralOutlineButton(
//                                                                               //                     title: "Warung Panen",
//                                                                               //                     width: 175,
//                                                                               //                     icon: WebsafeSvg.asset(AppImg.ic_shop),
//                                                                               //                     onPressed: () {
//                                                                               //                       _launchUrl('https://forms.gle/nNCF7w1Jcafg5wjh9');
//                                                                               //                     },
//                                                                               //                   ),
//                                                                               //                   GeneralOutlineButton(
//                                                                               //                     title: "Catering",
//                                                                               //                     width: 175,
//                                                                               //                     icon: WebsafeSvg.asset(AppImg.ic_food),
//                                                                               //                     onPressed: () {
//                                                                               //                       _launchUrl('${AppConst.TOOLBOX_URL}/register/catering');
//                                                                               //                     },
//                                                                               //                   ),
//                                                                               //                   GeneralOutlineButton(
//                                                                               //                     title: "Pembudidaya",
//                                                                               //                     width: 175,
//                                                                               //                     icon: WebsafeSvg.asset(AppImg.ic_fish),
//                                                                               //                     onPressed: () {
//                                                                               //                       _launchUrl('${AppConst.TOOLBOX_URL}/register/pembudidaya');
//                                                                               //                     },
//                                                                               //                   ),
//                                                                               //                   GeneralOutlineButton(
//                                                                               //                     title: "Petani Sayur",
//                                                                               //                     width: 175,
//                                                                               //                     icon: WebsafeSvg.asset(AppImg.ic_vegetables),
//                                                                               //                     onPressed: () {
//                                                                               //                       _launchUrl('${AppConst.TOOLBOX_URL}/register/petani');
//                                                                               //                     },
//                                                                               //                   ),
//                                                                               //                   GeneralOutlineButton(
//                                                                               //                     title: "Petani Buah",
//                                                                               //                     width: 175,
//                                                                               //                     icon: WebsafeSvg.asset(AppImg.ic_fruit),
//                                                                               //                     onPressed: () {
//                                                                               //                       _launchUrl('${AppConst.TOOLBOX_URL}/register/petanibuah');
//                                                                               //                     },
//                                                                               //                   ),
//                                                                               //                   GeneralOutlineButton(
//                                                                               //                     title: "Peternak",
//                                                                               //                     width: 175,
//                                                                               //                     icon: WebsafeSvg.asset(AppImg.ic_chicken),
//                                                                               //                     onPressed: () {
//                                                                               //                       _launchUrl('${AppConst.TOOLBOX_URL}/register/peternak');
//                                                                               //                     },
//                                                                               //                   )
//                                                                               //                 ],
//                                                                               //               ),
//                                                                               //             ),
//                                                                               //             SizedBox(height: 60),
//                                                                               //           ],
//                                                                               //         ),)
//                                                                               SizedBox.shrink()
//                                                                               :
//                                                                               // Column(
//                                                                               //     children: [
//                                                                               //       _SimulationProcess(),
//                                                                               Container(
//                                                                                   padding: EdgeInsets.zero,
//                                                                                   margin: EdgeInsets.zero,
//                                                                                   color: Colors.white,
//                                                                                   child: Column(
//                                                                                     mainAxisSize: MainAxisSize.max,
//                                                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                     children: [
//                                                                                       Padding(
//                                                                                         padding: EdgeInsets.symmetric(
//                                                                                           horizontal: !context.isPhone ? 18 : 20,
//                                                                                         ),
//                                                                                         child: Text(
//                                                                                           "Gabung Mitra Bisniso",
//                                                                                           style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700),
//                                                                                         ),
//                                                                                       ),
//                                                                                       SizedBox(height: 5),
//                                                                                       Material(
//                                                                                         color: Colors.white,
//                                                                                         child: InkWell(
//                                                                                           child: Padding(
//                                                                                             padding: EdgeInsets.symmetric(
//                                                                                               horizontal: 20,
//                                                                                               vertical: 5,
//                                                                                             ),
//                                                                                             child: Row(
//                                                                                               children: [
//                                                                                                 Expanded(
//                                                                                                   child: Text(
//                                                                                                     'Reseller',
//                                                                                                     style: AppTypo.body1v2Accent,
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               ],
//                                                                                             ),
//                                                                                           ),
//                                                                                           onTap: () {
//                                                                                             if (kIsWeb) {
//                                                                                               BlocProvider.of<UserDataCubit>(context).state.user != null ? context.beamToNamed('/join/warung') : context.beamToNamed('/signin');
//                                                                                             } else {
//                                                                                               AppExt.pushScreen(
//                                                                                                 context,
//                                                                                                 BlocProvider.of<UserDataCubit>(context).state.user != null
//                                                                                                     ? ShopEntryScreenOld(
//                                                                                                         shopType: ShopType.reseller,
//                                                                                                       )
//                                                                                                     : SignInScreen(),
//                                                                                               );
//                                                                                             }
//                                                                                           },
//                                                                                         ),
//                                                                                       ),
//                                                                                       Material(
//                                                                                         color: Colors.white,
//                                                                                         child: InkWell(
//                                                                                           child: Padding(
//                                                                                             padding: EdgeInsets.symmetric(
//                                                                                               horizontal: 20,
//                                                                                               vertical: 5,
//                                                                                             ),
//                                                                                             child: Row(
//                                                                                               children: [
//                                                                                                 Expanded(
//                                                                                                   child: Text(
//                                                                                                     'Supplier',
//                                                                                                     style: AppTypo.body1v2Accent,
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               ],
//                                                                                             ),
//                                                                                           ),
//                                                                                           onTap: () {
//                                                                                             if (kIsWeb) {
//                                                                                               BlocProvider.of<UserDataCubit>(context).state.user != null ? context.beamToNamed('/join/supplier') : context.beamToNamed('/signin');
//                                                                                             } else {
//                                                                                               AppExt.pushScreen(
//                                                                                                 context,
//                                                                                                 BlocProvider.of<UserDataCubit>(context).state.user != null ? ShopEntryScreenOld(shopType: ShopType.supplier) : SignInScreen(),
//                                                                                               );
//                                                                                             }
//                                                                                           },
//                                                                                         ),
//                                                                                       ),
//                                                                                       //             Material(
//                                                                                       //               color: Colors.white,
//                                                                                       //               child: InkWell(
//                                                                                       //                 child: Padding(
//                                                                                       //                   padding: EdgeInsets.symmetric(
//                                                                                       //                     horizontal: 20,
//                                                                                       //                     vertical: 5,
//                                                                                       //                   ),
//                                                                                       //                   child: Row(
//                                                                                       //                     children: [
//                                                                                       //                       Expanded(
//                                                                                       //                         child: Text(
//                                                                                       //                           'Catering',
//                                                                                       //                           style: AppTypo.body1v2Accent,
//                                                                                       //                         ),
//                                                                                       //                       ),
//                                                                                       //                     ],
//                                                                                       //                   ),
//                                                                                       //                 ),
//                                                                                       //                 onTap: () {
//                                                                                       //                   if (kIsWeb) {
//                                                                                       //                     BlocProvider.of<UserDataCubit>(context).state.user != null ? context.beamToNamed('/join/catering') : context.beamToNamed('/signin');
//                                                                                       //                   } else {
//                                                                                       //                     AppExt.pushScreen(
//                                                                                       //                       context,
//                                                                                       //                       BlocProvider.of<UserDataCubit>(context).state.user != null ? ShopEntryScreen(shopType: ShopType.catering) : SignInScreen(),
//                                                                                       //                     );
//                                                                                       //                   }
//                                                                                       //                 },
//                                                                                       //               ),
//                                                                                       //             ),
//                                                                                       //             Material(
//                                                                                       //               color: Colors.white,
//                                                                                       //               child: InkWell(
//                                                                                       //                 child: Padding(
//                                                                                       //                   padding: EdgeInsets.symmetric(
//                                                                                       //                     horizontal: 20,
//                                                                                       //                     vertical: 5,
//                                                                                       //                   ),
//                                                                                       //                   child: Row(
//                                                                                       //                     children: [
//                                                                                       //                       Expanded(
//                                                                                       //                         child: Text(
//                                                                                       //                           'HORECA',
//                                                                                       //                           style: AppTypo.body1v2Accent,
//                                                                                       //                         ),
//                                                                                       //                       ),
//                                                                                       //                     ],
//                                                                                       //                   ),
//                                                                                       //                 ),
//                                                                                       //                 onTap: () {
//                                                                                       //                   if (kIsWeb) {
//                                                                                       //                     BlocProvider.of<UserDataCubit>(context).state.user != null ? context.beamToNamed('/join/horeca') : context.beamToNamed('/signin');
//                                                                                       //                   } else {
//                                                                                       //                     AppExt.pushScreen(
//                                                                                       //                       context,
//                                                                                       //                       BlocProvider.of<UserDataCubit>(context).state.user != null ? ShopEntryScreen(shopType: ShopType.horeca) : SignInScreen(),
//                                                                                       //                     );
//                                                                                       //                   }
//                                                                                       //                 },
//                                                                                       //               ),
//                                                                                       //             ),
//                                                                                     ],
//                                                                                   ),
//                                                                                 ),
                                                                     

//                                                                       !context.isPhone
//                                                                           ? SizedBox(
//                                                                               height: 35,
//                                                                             )
//                                                                           : SizedBox()
//                                                                     ],
//                                                                   )

//                                                             ),
//                                                     FooterWeb()
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
 
//   }

//   @override
//   void dispose() {
//     _fetchPromoCubit.close();
//     _fetchBestSellCubit.close();
//     _fetchCateringCubit.close();

//     _fetchHomeSliderCubit.close();
//     _fetchCategoriesCubit.close();
//     _fetchSellersCubit.close();
//     super.dispose();
//   }
// }
