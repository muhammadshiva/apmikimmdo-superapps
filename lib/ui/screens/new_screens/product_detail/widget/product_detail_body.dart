import 'dart:developer';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/add_to_cart/add_to_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/toko_saya/add_product_toko_saya/add_product_toko_saya_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/wpp_cart/add_to_cart_offline/add_to_cart_offline_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/recipent_repository.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_account_screen.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_address_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_alamat_pelanggan_screen.dart';
import 'package:marketplace/ui/screens/sign_in_screen.dart';
import 'package:marketplace/ui/widgets/bs_feedback.dart';
import 'package:marketplace/ui/widgets/loading_dialog.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:url_launcher/url_launcher.dart';

import 'detail_screen_list.dart';
import 'footer_product_detail.dart';

class ProductDetailBody extends StatefulWidget {
  const ProductDetailBody({
    Key key,
    @required this.product,
    @required this.productId,
    this.categoryId,
  }) : super(key: key);

  final Products product;
  final int productId;
  final int categoryId;

  @override
  _ProductDetailBodyState createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody> {
  final RecipentRepository _repoRecipent = RecipentRepository();
  AddProductTokoSayaCubit _addProductTokoSayaCubit;
  FetchSelectedRecipentCubit _fetchSelectedRecipentCubit;

  // List<String> imageProduct = [];

  int variantIdSelected = 0;

  Recipent recipentMainAddress;

  @override
  void initState() {
    _addProductTokoSayaCubit = AddProductTokoSayaCubit();
    _fetchSelectedRecipentCubit = FetchSelectedRecipentCubit()
      ..fetchSelectedRecipent();
    variantIdSelected = widget.product.productVariant.length > 0 ? widget.product.productVariant[0].id : 0;
    // addProductPhoto();
    super.initState();
  }

  _handleAddToCart({@required int sellerId, int variantId = 0}) {
    LoadingDialog.show(context);
    context.read<AddToCartCubit>().addToCart(
        productId: widget.productId,
        sellerId: sellerId,
        isVariant: variantId == 0 ? 0 : 1,
        variantId: variantId == 0 ? null : variantId);
    // _addToCartCubit.addToCart(productId: widget.productId, sellerId: sellerId);
  }

  @override
  void dispose() {
    _addProductTokoSayaCubit.close();
    _fetchSelectedRecipentCubit.close();
    super.dispose();
  }

  void _launchUrl(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      BSFeedback.show(
        context,
        icon: Boxicons.bx_x_circle,
        color: AppColor.red,
        title: "Gagal mengakses halaman",
        description: "Halaman atau koneksi internet bermasalah",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _screenHeight = MediaQuery.of(context).size.height;
    final userData = BlocProvider.of<UserDataCubit>(context).state.user != null
        ? BlocProvider.of<UserDataCubit>(context).state.user
        : null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => _addProductTokoSayaCubit,
        ),
        BlocProvider(
          create: (_) => _fetchSelectedRecipentCubit,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener(
            cubit: _addProductTokoSayaCubit,
            listener: (context, state) {
              if (state is AddProductTokoSayaLoading) {
                LoadingDialog.show(context);
              }
              if (state is AddProductTokoSayaFailure) {
                if (state.result.contains("Product already exists")) {
                  AppExt.popScreen(context);
                  BSFeedback.showFeedBackShop(
                    context,
                    isAddToTokoSaya: true,
                    color: Colors.red,
                    title: "Produk gagal ditambahkan!",
                    description: "Produk ini sudah tersedia pada toko anda",
                  );
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        margin: EdgeInsets.zero,
                        duration: Duration(seconds: 2),
                        content: Text(state.result.toString()),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                }
              }
              if (state is AddProductTokoSayaSuccess) {
                AppExt.popScreen(context);
                BSFeedback.showFeedBackShop(context,
                    isAddToTokoSaya: true,
                    color: AppColor.primary,
                    title: "Produk berhasil ditambahkan!",
                    description:
                        "Anda dapat menambahkan lebih banyak produk lagi untuk menambah peluang keuntungan anda");
              }
            },
          ),
          BlocListener(
            cubit: _fetchSelectedRecipentCubit,
            listener: (context, state) {
              if (state is FetchSelectedRecipentSuccess) {
                setState(() {
                  recipentMainAddress = state.recipent;
                });
              }
              if (state is FetchSelectedRecipentFailure) {
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
            },
          ),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            CarouselProduct(
                              images: widget.product.productPhoto.length > 0
                                  ? widget.product.productPhoto
                                  : [
                                      ProductPhoto(
                                          image:
                                              "https://v1end.apmikimmdo.com/images/blank.png")
                                    ],
                              isLoading: false,
                            ),
                            DetailScreenList(
                              product: widget.product,
                              recipentMainAddress: recipentMainAddress,
                              onVariantSelected: (int id) {
                                print("ID VARIANT //");
                                setState(() {
                                  variantIdSelected = id;
                                });
                              },
                            ),
                          ],
                        ),
                        BlocProvider.of<UserDataCubit>(context).state.user !=
                                null
                            ? BlocProvider.of<UserDataCubit>(context)
                                        .state
                                        .user
                                        .reseller !=
                                    null
                                ? Positioned(
                                    top: _screenHeight * (43.5 / 100),
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (widget.product.stock > 0) {
                                          _addProductTokoSayaCubit.addProduct(
                                              productId: widget.productId);
                                        } else {
                                          BSFeedback.show(context,
                                              color: AppColor.danger,
                                              title:
                                                  "Gagal menambah ke toko saya",
                                              description: "Stok barang habis",
                                              icon: Icons.cancel_outlined);
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: Image.asset(
                                            AppImg.img_add_shop_product,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 0,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    6), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: widget.product.stock > 0
                                                ? Colors.white
                                                : Colors.grey[200]),
                                      ),
                                    ),
                                  )
                                : SizedBox()
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: FooterProductDetail(
                    stock: widget.product.stock,
                    phone: () {
                      _launchUrl(
                          "https://api.whatsapp.com/send?phone=//${widget.product.supplier.phone}");
                    },
                    onPressed: () {
                      if (widget.product.stock == 0) {
                        BSFeedback.show(context,
                            color: AppColor.danger,
                            title: "Gagal menambah ke keranjang",
                            description: "Stok barang habis",
                            icon: Icons.cancel_outlined);
                      } else {
                        if (BlocProvider.of<UserDataCubit>(context)
                                .state
                                .user ==
                            null) {
                          AppExt.pushScreen(context, SignInScreen());
                          /*_handleAddToCartOffline(
                                        product: widget.product,
                                        productId: widget.productId,
                                        categoryId: widget.categoryId);*/
                        } else if (recipentMainAddress == null) {
                          BSFeedback.show(context,
                              color: AppColor.danger,
                              title:
                                  "Alamat pengiriman kosong atau belum ditentukan",
                              description:
                                  "Tentukan alamat pengiriman terlebih dahulu",
                              icon: Icons.cancel_outlined,
                              anotherWidget: RoundedButton.contained(
                                  label: "Tentukan Alamat",
                                  isUpperCase: false,
                                  onPressed: () {
                                    AppExt.popUntilRoot(context);
                                    AppExt.pushScreen(
                                        context, UpdateAddressScreen());
                                  }));
                        } else {
                          if (widget.product.productVariant.length > 0) {
                            if (variantIdSelected == 0) {
                              BSFeedback.unselectVariant(
                                context,
                                imgUrl: "images/img_product_error.png",
                                description: "Pilih varian terlebih dahulu!",
                              );
                            } else {
                              _handleAddToCart(
                                sellerId: widget.product.supplierId,
                                variantId: variantIdSelected,
                              );
                            }
                          } else {
                            _handleAddToCart(
                              sellerId: widget.product.supplierId,
                              variantId: 0,
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
