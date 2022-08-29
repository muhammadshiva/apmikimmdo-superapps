import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/fetch_user/fetch_user_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/toko_saya/fetch_product_toko_saya/fetch_product_toko_saya_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/toko_saya/remove_product_toko_saya/remove_product_toko_saya_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/update_quantity/update_quantity_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_products/fetch_products_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/nav/new/new_nav.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/myshop_not_available.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/myshop_not_open.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/myshop_product_empty.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/myshop_select_option.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/ui/widgets/grid_two_product_list_item.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:share_plus/share_plus.dart';

class TokoSayaScreen extends StatefulWidget {
  const TokoSayaScreen({Key key}) : super(key: key);

  @override
  _TokoSayaScreenState createState() => _TokoSayaScreenState();
}

class _TokoSayaScreenState extends State<TokoSayaScreen> {
  bool isCustomer = false;
  bool hasShop = false;
  bool initialLoading = true;

  FetchUserCubit _fetchUserCubit;
  FetchProductTokoSayaCubit _fetchProductTokoSayaCubit;
  RemoveProductTokoSayaCubit _removeProductTokoSayaCubit;

  @override
  void initState() {
    _fetchUserCubit = FetchUserCubit()..load();
    _fetchProductTokoSayaCubit = FetchProductTokoSayaCubit()..load();
    _removeProductTokoSayaCubit = RemoveProductTokoSayaCubit();
    // updateState();
    super.initState();
  }

  // updateState(Reseller reseller,Supplier supplier){
  //   isCustomer = reseller == null && supplier == null;
  //   hasShop =  reseller != null;
  // }

  void shareShop(String nameShop, String slug) {
    // Share.share(
    //     "Yuk belanja di *${nameShop ?? 'user'}* Banyak produk baru dan promo lho! Klik disini \n https://warung.panenpanen.id/wpp/dashboard/$slug");
    Share.share(
        "Yuk belanja di *${nameShop ?? 'user'}* Banyak produk baru dan promo lho! Klik disini \n https://reseller.apmikimmdo.com/wpp/dashboard/$slug");
  }

  Future refreshData() async {
    _fetchUserCubit.load();
    _fetchProductTokoSayaCubit.load();
  }

  @override
  void dispose() {
    _fetchUserCubit.close();
    _fetchProductTokoSayaCubit.close();
    _removeProductTokoSayaCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = !context.isPhone;

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _fetchProductTokoSayaCubit),
          BlocProvider(create: (_) => _removeProductTokoSayaCubit),
          BlocProvider(create: (_) => _fetchUserCubit),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener(
                cubit: _removeProductTokoSayaCubit,
                listener: (context, state) {
                  if (state is RemoveProductTokoSayaLoading) {
                    LoadingDialog.show(context);
                  }
                  if (state is RemoveProductTokoSayaFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          margin: EdgeInsets.zero,
                          duration: Duration(seconds: 2),
                          content: Text('${state.message}'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  }
                  if (state is RemoveProductTokoSayaSuccess) {
                    AppExt.popScreen(context);
                    _fetchProductTokoSayaCubit.load();
                  }
                }),
            BlocListener(
                cubit: _fetchUserCubit,
                listener: (context, state) {
                  if (state is FetchUserSuccess) {
                    debugPrint("MASUKK SINI");
                    setState(() {
                      isCustomer = state.user.data.reseller == null &&
                          state.user.data.supplier == null;
                      hasShop = state.user.data.reseller != null;
                      initialLoading = false;
                    });
                  }
                })
          ],
          child: BlocBuilder(
              cubit: _fetchProductTokoSayaCubit,
              builder: (context, fetchProductTokoSayaState) => BlocBuilder(
                  cubit: _fetchUserCubit,
                  builder: (context, fetchUserState) =>
                      //======================= ERROR HANDLING ================
                      // fetchUserState is FetchUserFailure ||
                      //         fetchProductTokoSayaState
                      //             is FetchProductTokoSayaFailure
                      //     ? Center(
                      //         child: fetchUserState.type == ErrorType.network ||
                      //                 fetchUserState.type == ErrorType.network
                      //             ? NoConnection(onButtonPressed: refreshData)
                      //             : ErrorFetchForUser(
                      //                 onButtonPressed: refreshData))
                      //     :

                      //=======================================================
                      initialLoading == true
                          ? Center(child: CircularProgressIndicator())
                          : hasShop == false
                              ? MyShopNotAvailable()
                              : AnnotatedRegion<SystemUiOverlayStyle>(
                                  value: SystemUiOverlayStyle.dark,
                                  child: Scaffold(
                                      appBar: AppBarConfig(
                                        bgColor: Colors.white,
                                        iconColor: AppColor.textPrimary,
                                        logoColor: AppColor.primary,
                                      ),
                                      body: isCustomer
                                          ? MyShopNotAvailable()
                                          : hasShop == true
                                              ? Stack(children: [
                                                  //Body
                                                  fetchProductTokoSayaState
                                                          is FetchProductTokoSayaLoading
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )
                                                      : fetchProductTokoSayaState
                                                              is FetchProductTokoSayaFailure
                                                          ? Center(
                                                              child: Text(
                                                                  fetchProductTokoSayaState
                                                                      .message),
                                                            )
                                                          : fetchProductTokoSayaState
                                                                  is FetchProductTokoSayaSuccess
                                                              ? fetchProductTokoSayaState
                                                                          .tokoSayaProduct
                                                                          .length >
                                                                      0
                                                                  ? Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 180),
                                                                      child: StaggeredGridView
                                                                          .countBuilder(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          top:
                                                                              20,
                                                                          left: _screenWidth *
                                                                              (5 / 100),
                                                                          right:
                                                                              _screenWidth * (5 / 100),
                                                                        ),
                                                                        crossAxisCount:
                                                                            2,
                                                                        itemCount: fetchProductTokoSayaState
                                                                            .tokoSayaProduct
                                                                            .length,
                                                                        itemBuilder:
                                                                            (BuildContext context,
                                                                                int index) {
                                                                          TokoSayaProducts
                                                                              _item =
                                                                              fetchProductTokoSayaState.tokoSayaProduct[index];
                                                                          return GridTwoProductListItem(
                                                                            productShop:
                                                                                _item,
                                                                            isDiscount:
                                                                                _item.disc != null && _item.disc > 0,
                                                                            isKomisi:
                                                                                false,
                                                                            isUpgradeUser:
                                                                                true,
                                                                            isShop:
                                                                                true,
                                                                            onDelete:
                                                                                (id) {
                                                                              BsConfirmation().show(
                                                                                  context: context,
                                                                                  onYes: () {
                                                                                    _removeProductTokoSayaCubit.deleteProduct(productId: id);
                                                                                  },
                                                                                  title: "Apakah anda yakin ingin menghapus produk dari katalog?");
                                                                            },
                                                                          );
                                                                        },
                                                                        staggeredTileBuilder:
                                                                            (int index) =>
                                                                                new StaggeredTile.fit(1),
                                                                        mainAxisSpacing:
                                                                            13,
                                                                        crossAxisSpacing:
                                                                            13,
                                                                      ),
                                                                    )
                                                                  : MyShopProductEmpty()
                                                              : SizedBox
                                                                  .shrink(),

                                                  //Header
                                                  fetchUserState
                                                          is FetchUserLoading
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )
                                                      : fetchUserState
                                                              is FetchUserFailure
                                                          ? Center(
                                                              child: Text(
                                                                  "Terjadi kesalahan"),
                                                            )
                                                          : fetchUserState
                                                                  is FetchUserSuccess
                                                              ? Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: _screenWidth * (5 / 100)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CircleAvatar(
                                                                              backgroundColor: AppColor.navScaffoldBg,
                                                                              radius: _screenWidth * (6 / 100),
                                                                              backgroundImage: fetchUserState.user.data.avatar != null
                                                                                  ? NetworkImage("${AppConst.STORAGE_URL}/user/avatar/${fetchUserState.user.data.avatar}")
                                                                                  : AssetImage(
                                                                                      AppImg.img_default_account,
                                                                                    ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      fetchUserState.user.data.reseller.name,
                                                                                      style: AppTypo.body2Lato.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                      maxLines: 2,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 3,
                                                                                    ),
                                                                                    Text(
                                                                                      "Kota ${fetchUserState.user.data.reseller.city}",
                                                                                      style: AppTypo.body2Lato.copyWith(
                                                                                        fontSize: 12,
                                                                                        color: AppColor.textSecondary2,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 3,
                                                                                    ),
                                                                                    Text("Bergabung: ${fetchUserState.user.data.reseller.joinDate}", style: AppTypo.body2Lato.copyWith(fontSize: 12, color: AppColor.textSecondary2))
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                shareShop(fetchUserState.user.data.reseller.name ?? 'user', fetchUserState.user.data.reseller.slug);
                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.share_outlined,
                                                                                      color: AppColor.textPrimaryInverted,
                                                                                      size: 15,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 4,
                                                                                    ),
                                                                                    Text(
                                                                                      "Bagikan Toko",
                                                                                      style: AppTypo.body2Lato.copyWith(color: AppColor.textPrimaryInverted),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(5)),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            24,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: _screenWidth * (5 / 100)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(EvaIcons.star, color: AppColor.bottomNavIconActive, size: 18),
                                                                                    SizedBox(width: 5),
                                                                                    Text(
                                                                                      fetchUserState.user.data.reseller.rating.toString(),
                                                                                      style: AppTypo.body1Lato,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 6,
                                                                                ),
                                                                                Text(
                                                                                  "Rating & ulasan",
                                                                                  style: AppTypo.body2Lato.copyWith(color: AppColor.textSecondary2, fontSize: 12),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                Text(fetchUserState.user.data.reseller.sold.toString(), style: AppTypo.body1Lato),
                                                                                SizedBox(
                                                                                  height: 6,
                                                                                ),
                                                                                Text("Produk Terjual", style: AppTypo.body2Lato.copyWith(color: AppColor.textSecondary2, fontSize: 12))
                                                                              ],
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                AppExt.pushScreen(context, MyShopCustomerScreen());
                                                                              },
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(fetchUserState.user.data.reseller.customer.toString(), style: AppTypo.body1Lato),
                                                                                  SizedBox(
                                                                                    height: 6,
                                                                                  ),
                                                                                  Text("Total Pelanggan", style: AppTypo.body2Lato.copyWith(color: AppColor.textSecondary2, fontSize: 12))
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      IntrinsicHeight(
                                                                          child:
                                                                              Divider(
                                                                        height:
                                                                            1,
                                                                        color: AppColor
                                                                            .silverFlashSale,
                                                                      )),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                _screenWidth * (5 / 100),
                                                                            vertical: 14),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            MyShopSelectOption(
                                                                              title: "Filter",
                                                                              onTap: () {
                                                                                BSFilterProduct.show(context);
                                                                              },
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
                                                                )
                                                              : SizedBox
                                                                  .shrink()
                                                ])
                                              : SizedBox.shrink())))),
        ));
  }
}
