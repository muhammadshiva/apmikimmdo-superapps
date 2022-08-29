import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:beamer/beamer.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/reseller_shop/fetch_data_reseller_shop/fetch_data_reseller_shop_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/reseller_shop/fetch_products_reseller_shop/fetch_products_reseller_shop_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/toko_saya/remove_product_toko_saya/remove_product_toko_saya_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/update_quantity/update_quantity_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_products/fetch_products_cubit.dart';
import 'package:marketplace/data/models/models.dart';

import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/nav/new/new_nav.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/myshop_not_available.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/myshop_not_open.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/myshop_product_empty.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/myshop_select_option.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/wpp_bs_search_kecamatan.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/grid_two_product_list_item.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';

class WppDashboardWarungWebScreen extends StatefulWidget {
  const WppDashboardWarungWebScreen(
      {Key key, this.slugReseller, this.isFromListWarung = false})
      : super(key: key);

  final String slugReseller;
  final bool isFromListWarung;

  @override
  _WppDashboardWarungWebScreenState createState() =>
      _WppDashboardWarungWebScreenState();
}

class _WppDashboardWarungWebScreenState
    extends State<WppDashboardWarungWebScreen> {
  final JoinUserRepository _reshopRepo = JoinUserRepository();
  final RecipentRepository _recipentRepo = RecipentRepository();
  UserDataCubit userDataCubit;

  FetchProductsResellerShopCubit _fetchProductsResellerShopCubit;
  FetchDataResellerShopCubit _fetchDataResellerShopCubit;
  FetchSelectedRecipentCubit _fetchSelectedRecipent;

  String subdistrict = "";

  int subdistrictId = 0;

  @override
  void initState() {
    userDataCubit = BlocProvider.of<UserDataCubit>(context);
    _reshopRepo.setSlugReseller(slug: widget.slugReseller);
    
    _fetchProductsResellerShopCubit = FetchProductsResellerShopCubit();
    _fetchProductsResellerShopCubit
      ..fetchProductsList(
          nameSlugReseller: widget.slugReseller, subdistrictId: 0);
    _fetchDataResellerShopCubit = FetchDataResellerShopCubit()
      ..fetchData(nameSlugReseller: widget.slugReseller);
    _fetchSelectedRecipent = FetchSelectedRecipentCubit()
      ..fetchSelectedrecipentUserNoAuthDashboard();
      
    subdistrictId = _recipentRepo.getSelectedRecipentNoAuthDashboard()['subdistrict_id'] ?? 0;

  
    
    if (_recipentRepo.getFromWppDetailProductCheck() != true) {
      
      if (_recipentRepo.getSelectedRecipentNoAuthDashboard() == null || _recipentRepo.getSelectedRecipentNoAuthDashboard()['subdistrict_id'] == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          bsAddress();
        });
      }else{
        // debugPrint("KECAMATAN ID DASHBOARD : ${_recipentRepo.getSelectedRecipentNoAuthDashboard()['subdistrict_id']} ");
        _fetchProductsResellerShopCubit.fetchProductsList(
            nameSlugReseller: widget.slugReseller,
            subdistrictId: subdistrictId);
      }
      _recipentRepo.gs.remove('recipentUserNoAuthDashboard');
    }else{
      _recipentRepo.isFromWppDetailProductDetail(value: false);
       _fetchProductsResellerShopCubit.fetchProductsList(
            nameSlugReseller: widget.slugReseller,
            subdistrictId: subdistrictId);
      _recipentRepo.gs.remove('recipentUserNoAuthDashboard');
    }
    

    super.initState();
  }

  void bsAddress() {
    WppBsSearchKecamatan.show(
      context,
      useCloseButton: false,
      image: AppImg.img_delivery_road,
      title: "Mau kirim belanjaan kemana?",
      description:
          "Sebelum menuju warung, tentukan alamat pengiriman mu agar kami bisa memberikan rekomendasi produk yang sesuai.",
      onTap: (subdistrictId, subdistrictVal) {
        debugPrint(subdistrictVal);
        setState(() {
          subdistrict = subdistrictVal;
        });
        _fetchProductsResellerShopCubit.fetchProductsList(
            nameSlugReseller: widget.slugReseller,
            subdistrictId: subdistrictId);
        _fetchSelectedRecipent = FetchSelectedRecipentCubit()
          ..fetchSelectedRecipentUserNoAuth();
      },
    );
  }

  void _launchUrl(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (ctx) {
            return AlertFailureWeb(
                title: "Gagal mengakses halaman",
                description: "Halaman atau koneksi internet bermasalah",
                onPressClose: () {
                  AppExt.popScreen(context);
                });
          });
    }
  }

  @override
  void dispose() {
    _fetchProductsResellerShopCubit.close();
    _fetchDataResellerShopCubit.close();
    _fetchSelectedRecipent.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _fetchProductsResellerShopCubit),
        BlocProvider(create: (_) => _fetchDataResellerShopCubit),
        BlocProvider(create: (_) => _fetchSelectedRecipent),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener(
              cubit: _fetchProductsResellerShopCubit,
              listener: (ctx, state) {
                if (state is FetchProductsResellerShopSuccess) {
                  if (state.resellerProducts.length == 0) {
                    WppBsSearchKecamatan.show(
                      context,
                      useCloseButton: false,
                      image: AppImg.img_product_error,
                      title:
                          "Mohon maaf produk toko ini belum tersedia di daerah anda",
                      description:
                          "Tapi jangan khawatir, yuk cari warung disekitarmu",
                      isRouteToListWarung: true,
                      onTap: (subdistrictId, subdistrictVal) {
                        
                        setState(() {
                          subdistrict = subdistrictVal;
                        });
                        _fetchProductsResellerShopCubit.fetchProductsList(
                            nameSlugReseller: widget.slugReseller,
                            subdistrictId: subdistrictId);
                        _fetchSelectedRecipent = FetchSelectedRecipentCubit()
                        ..fetchSelectedrecipentUserNoAuthDashboard();
                      },
                    );
                  }
                }
                if (state is FetchProductsResellerShopFailure) {
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
              })
        ],
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
            child: Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: AppColor.primary),
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  centerTitle: false,
                  leading: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 11, top: 4, left: 10, right: 10),
                      child: WebsafeSvg.asset(AppImg.ic_logo_small,
                          width: 30, height: 30)),
                  titleSpacing: 0,
                  title: Container(
                    height: 50,
                    child: EditText(
                      hintText: "Cari produk",
                      inputType: InputType.search,
                      readOnly: true,
                      onTap: () => AppExt.pushScreen(context, SearchScreen()),
                    ),
                  ),
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                            padding: EdgeInsets.only(top: 10, right: 10),
                            constraints: BoxConstraints(),
                            icon: Icon(EvaIcons.shoppingCart),
                            iconSize: 26,
                            onPressed: () {
                              context.beamToNamed('/wpp/cart');
                            }),
                      ],
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    //===================================== HEADER ================================
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BlocBuilder(
                              cubit: _fetchDataResellerShopCubit,
                              builder: (context, state) => state
                                      is FetchDataResellerShopLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : state is FetchDataResellerShopFailure
                                      ? Center(child: Text(state.message))
                                      : state is FetchDataResellerShopSuccess
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            AppColor
                                                                .navScaffoldBg,
                                                        radius: 25,
                                                        backgroundImage: state
                                                                    .reseller
                                                                    .logo !=
                                                                null
                                                            ? NetworkImage(state
                                                                .reseller.logo)
                                                            : AssetImage(
                                                                AppImg
                                                                    .img_default_account,
                                                              ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                state.reseller
                                                                    .name,
                                                                style: AppTypo
                                                                    .body2Lato
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              // SizedBox(
                                                              //   height: 3,
                                                              // ),
                                                              // Text(
                                                              //   "${state.reseller.city}",
                                                              //   style: AppTypo
                                                              //       .body2Lato
                                                              //       .copyWith(
                                                              //     fontSize:
                                                              //         10,
                                                              //     color: AppColor
                                                              //         .textSecondary2,
                                                              //   ),
                                                              // ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                  "Bergabung: ${state.reseller.joinDate}",
                                                                  style: AppTypo
                                                                      .body2Lato
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              AppColor.textSecondary2))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          _launchUrl(
                                                              "https://api.whatsapp.com/send?phone=${state.reseller.phone}");
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      24,
                                                                  vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Chat",
                                                                style: AppTypo
                                                                    .body2Lato
                                                                    .copyWith(
                                                                        color: AppColor
                                                                            .textPrimaryInverted),
                                                              ),
                                                            ],
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: AppColor
                                                                  .primary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 24,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(Icons.star,
                                                                    color: AppColor
                                                                        .primary,
                                                                    size: 20),
                                                                Text(
                                                                  state.reseller
                                                                      .rating
                                                                      .toString(),
                                                                  style: AppTypo
                                                                      .LatoBold,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 6,
                                                            ),
                                                            Text(
                                                              "Rating & ulasan",
                                                              style: AppTypo
                                                                  .body2Lato
                                                                  .copyWith(
                                                                      color: AppColor
                                                                          .textSecondary2,
                                                                      fontSize:
                                                                          14),
                                                            )
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                                state.reseller
                                                                    .sold
                                                                    .toString(),
                                                                style: AppTypo
                                                                    .LatoBold),
                                                            SizedBox(
                                                              height: 6,
                                                            ),
                                                            Text(
                                                                "Produk Terjual",
                                                                style: AppTypo
                                                                    .body2Lato
                                                                    .copyWith(
                                                                        color: AppColor
                                                                            .textSecondary2,
                                                                        fontSize:
                                                                            14))
                                                          ],
                                                        ),
                                                        MouseRegion(
                                                          cursor:
                                                              SystemMouseCursors
                                                                  .click,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              AppExt.pushScreen(
                                                                  context,
                                                                  MyShopCustomerScreen());
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                    state
                                                                        .reseller
                                                                        .customer
                                                                        .toString(),
                                                                    style: AppTypo
                                                                        .LatoBold),
                                                                SizedBox(
                                                                  height: 6,
                                                                ),
                                                                Text(
                                                                    "Total Pelanggan",
                                                                    style: AppTypo
                                                                        .body2Lato
                                                                        .copyWith(
                                                                            color:
                                                                                AppColor.textSecondary2,
                                                                            fontSize: 14))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink()),
                          SizedBox(
                            height: 12,
                          ),
                          IntrinsicHeight(
                              child: Divider(
                            height: 1,
                            color: AppColor.silverFlashSale,
                          )),
                          SizedBox(
                            height: 12,
                          ),
                          BlocBuilder(
                              cubit: _fetchSelectedRecipent,
                              builder: (context, state) => state
                                      is FetchSelectedRecipentLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : state is FetchSelectedRecipentFailure
                                      ? Center(
                                          child: Text(state.message),
                                        )
                                      : state is FetchSelectedRecipentSuccess
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () => bsAddress(),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on_outlined,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      RichText(
                                                          text: TextSpan(
                                                              text: "Dikirim ke ",
                                                              style: AppTypo
                                                                      .LatoBold
                                                                  .copyWith(
                                                                      fontSize: 12),
                                                              children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  "${state.recipent.subdistrict}. ${state.recipent.city}",
                                                              style: AppTypo
                                                                      .LatoBold
                                                                  .copyWith(
                                                                      fontSize: 12,
                                                                      color: AppColor
                                                                          .primary),
                                                            )
                                                          ]))
                                                      // Text(
                                                      //     "Dikirim ke - Kec. ${state.recipent.subdistrict}. ${state.recipent.city}")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox()),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 14),
                            child: Row(
                              children: [
                                MyShopSelectOption(
                                  title: "Filter",
                                ),
                                SizedBox(
                                  width: 13,
                                ),
                                MyShopSelectOption(
                                  title: "Kategori",
                                  onTap: () {
                                    BsKategori().showBsStatus(context);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    //================================== BODY ====================================
                    Expanded(
                      child: BlocBuilder(
                          cubit: _fetchProductsResellerShopCubit,
                          builder: (context, state) {
                            return state is FetchProductsResellerShopLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : state is FetchProductsResellerShopFailure
                                    ? Center(
                                        child: Text("Terjadi kesalahan"),
                                      )
                                    : state is FetchProductsResellerShopSuccess
                                        ? state.resellerProducts.length > 0
                                            ? StaggeredGridView.countBuilder(
                                                padding: EdgeInsets.only(
                                                  top: 20,
                                                  left: 15,
                                                  right: 25,
                                                ),
                                                crossAxisCount: 2,
                                                itemCount: state
                                                    .resellerProducts.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  Products _item = state
                                                      .resellerProducts[index];
                                                  return GridTwoProductListItem(
                                                    product: _item,
                                                    warungSlug:
                                                        widget.slugReseller,
                                                    isDiscount: _item.disc != 0,
                                                    isUpgradeUser: false,
                                                    isPublicWarung:
                                                        widget.slugReseller !=
                                                            null,
                                                  );
                                                },
                                                staggeredTileBuilder: (int
                                                        index) =>
                                                    new StaggeredTile.fit(1),
                                                mainAxisSpacing: 13,
                                                crossAxisSpacing: 13,
                                              )
                                            : MyShopProductEmpty()
                                        : SizedBox.shrink();
                          }),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
