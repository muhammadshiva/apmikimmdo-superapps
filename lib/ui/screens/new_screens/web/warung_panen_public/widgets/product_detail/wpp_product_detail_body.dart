import 'dart:developer';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/add_to_cart/add_to_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/toko_saya/add_product_toko_saya/add_product_toko_saya_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/wpp_cart/add_to_cart_offline/add_to_cart_offline_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_alamat_pelanggan_screen.dart';
import 'package:marketplace/ui/screens/sign_in_screen.dart';
import 'package:marketplace/ui/widgets/bs_feedback.dart';
import 'package:marketplace/ui/widgets/bs_select_variant.dart';
import 'package:marketplace/ui/widgets/loading_dialog.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:url_launcher/url_launcher.dart';

import 'wpp_product_detail_detail_screen_list.dart';
import 'wpp_product_detail_footer.dart';

class WppProductDetailBody extends StatefulWidget {
  const WppProductDetailBody({
    Key key,
    @required this.product,
    @required this.productId,
    this.categoryId,
    this.isPublicResellerShop = false,
  }) : super(key: key);

  final Products product;
  final int productId;
  final int categoryId;
  final bool isPublicResellerShop;

  @override
  _WppProductDetailBodyState createState() => _WppProductDetailBodyState();
}

class _WppProductDetailBodyState extends State<WppProductDetailBody> {

  ProductVariant _productVariantSelected;

  @override
  void initState() {
   _productVariantSelected = widget.product.productVariant.length > 0 ? widget.product.productVariant[0] : null;
    super.initState();
  }

  _handleAddToCartOffline({
    @required Products product,
    @required int productId,
    @required ProductVariant variantSelected,
    // int categoryId,
  }) {
    context
        .read<AddToCartOfflineCubit>()
        .addToCartOffline(
          product: product, 
          productId: productId,
          variantSelected: variantSelected
        );
    final data = context.read<AddToCartOfflineCubit>().state;
    BSFeedback.showFeedBackShop(context,
        color: AppColor.success,
        title: "Produk berhasil ditambahkan ke keranjang",
        description:
            "Silahkan checkout untuk melakukan pembelian");
    debugPrint("mycart $data");
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        CarouselProduct(
                          images: widget.product.productPhoto,
                          isLoading: false,
                        ),
                        WppProductDetailDetailScreenList(
                          product: widget.product,
                          onVariantSelected: (ProductVariant productVariantSelected){
                            setState(() {
                               _productVariantSelected = productVariantSelected;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: WppProductDetailFooter(
                stock: widget.product.stock,
                phone: () {
                  _launchUrl(
                      "https://api.whatsapp.com/send?phone=${widget.product.supplier.phone}");
                },
                isButtonBeliEnable: true,
                onPressed: () {
                  if (widget.product.stock == 0) {
                    BSFeedback.show(context,
                        color: AppColor.danger,
                        title: "Gagal menambah ke keranjang",
                        description: "Stok barang habis",
                        icon: Icons.cancel_outlined);
                  } else {
                    if (widget.product.productVariant.length > 0) {
                            BsSelectVariant().showBsReview(context,
                            listVariant:widget.product.productVariant, 
                            variantSelected: _productVariantSelected,
                            onVariantSelected: (int val,ProductVariant val2){
                              AppExt.popScreen(context);
                              _handleAddToCartOffline(product: widget.product, productId: widget.productId, variantSelected: val2);
                            });
                          } else {
                            _handleAddToCartOffline(product: widget.product, productId: widget.productId, variantSelected: _productVariantSelected);
                          }
                    // debugPrint("FOOTERNYA WEB");
                    // _handleAddToCartOffline(
                    //         product: widget.product,
                    //         productId: widget.productId,
                    //         variantSelected: _productVariantSelected != null ? _productVariantSelected : null
                    //         // categoryId: widget.categoryId
                    //       );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
