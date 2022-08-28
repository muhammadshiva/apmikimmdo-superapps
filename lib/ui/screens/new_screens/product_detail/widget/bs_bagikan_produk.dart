import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:marketplace/data/blocs/new_cubit/bagikan_produk/bagikan_produk_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/toko_saya/add_product_toko_saya/add_product_toko_saya_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/widgets/bs_feedback.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/ui/widgets/loading_dialog.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class BsBagikanProduk {
  Future<void> showBsReview(BuildContext context, Products product,
      TokoSayaProducts productShop, bool isShop) async {
    final bagikan = ["Gambar", "Judul dan Deskripsi"];

    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return BodyBagikanProduk(bagikan: bagikan,product: product,productShop: productShop,isShop: isShop,);
        });
  }
}

class BodyBagikanProduk extends StatefulWidget {
  const BodyBagikanProduk({
    Key key,
    @required this.bagikan, this.productShop, this.product, this.isShop,
  }) : super(key: key);

  final List<String> bagikan;
  final TokoSayaProducts productShop;
  final Products product;
  final bool isShop;

  @override
  _BodyBagikanProdukState createState() => _BodyBagikanProdukState();
}

class _BodyBagikanProdukState extends State<BodyBagikanProduk> {

  AddProductTokoSayaCubit _addProductTokoSayaCubit;
  UserDataCubit _userDataCubit;

  @override
  void initState() {
    _addProductTokoSayaCubit = AddProductTokoSayaCubit();
    _userDataCubit = BlocProvider.of<UserDataCubit>(context);
    // addProductPhoto();
    super.initState();
  }

  @override
  void dispose() {
    _addProductTokoSayaCubit.close();
    _userDataCubit.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _addProductTokoSayaCubit,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          // shrinkWrap: true,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bagikan Produk",
                    style: AppTypo.subtitle1
                        .copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    AppExt.popScreen(context);
                  },
                  icon: Icon(Icons.close),
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: widget.isShop
                        ? widget.productShop.productPhoto
                        : widget.product.productPhoto[0].image,
                    memCacheHeight: Get.height > 350
                        ? (Get.height * 0.25).toInt()
                        : Get.height,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[200],
                      period: Duration(milliseconds: 1000),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            color: Colors.white),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AppImg.img_error,
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isShop ? widget.productShop.name : widget.product.name,
                        style: AppTypo.caption,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Rp ${AppExt.toRupiah(widget.isShop ? widget.productShop.oriPrice : widget.product.discPrice != 0 ? widget.product.discPrice : widget.product.sellingPrice)}",
                        style: AppTypo.caption
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Pilih Konten",
              style: AppTypo.caption.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              children: [
                BlocBuilder<BagikanProdukCubit, List<String>>(
                  builder: (context, state) {
                    return BagikanELement(
                        label: widget.bagikan[0],
                        isChoosen: state.contains(widget.bagikan[0]));
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                BlocBuilder<BagikanProdukCubit, List<String>>(
                  builder: (context, state) {
                    return BagikanELement(
                        label: widget.bagikan[1],
                        isChoosen: state.contains(widget.bagikan[1]));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            BlocBuilder<BagikanProdukCubit, List<String>>(
              builder: (context, state) => SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: !state.contains(widget.bagikan[0]) &&
                          !state.contains(widget.bagikan[1])
                      ? null
                      : () {
                          state.contains(widget.bagikan[0]) &&
                                  state.contains(widget.bagikan[1])
                              ? AppExt.shareProductImageText(
                                  product: widget.product,
                                  productShop: widget.productShop,
                                  userData: _userDataCubit.state.user)
                              : state.contains(widget.bagikan[0])
                                  ? AppExt.shareProductImage(
                                      product: widget.product,
                                      productShop: widget.productShop,
                                      userData: _userDataCubit.state.user)
                                  : AppExt.shareProductText(
                                      product: widget.product,
                                      productShop: widget.productShop,
                                      userData: _userDataCubit.state.user);
                              _addProductTokoSayaCubit.addProduct(productId: widget.product.id);
                        },
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Bagikan",
                    style: AppTypo.caption.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BagikanELement extends StatelessWidget {
  const BagikanELement(
      {Key key, @required this.label, @required this.isChoosen})
      : super(key: key);

  final String label;
  final bool isChoosen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isChoosen) {
          debugPrint("REMOVE $label");
          context.read<BagikanProdukCubit>().remove(label);
        } else {
          debugPrint("ADD $label");
          context.read<BagikanProdukCubit>().add(label);
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color:
                    isChoosen ? Theme.of(context).primaryColor : Colors.grey),
            color: isChoosen ? AppColor.bgBadgePink : Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypo.caption
                  .copyWith(color: isChoosen ? Colors.black : Colors.grey),
            ),
            isChoosen
                ? Icon(
                    Icons.check_circle_rounded,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.check_circle_rounded,
                    color: Colors.grey,
                  )
          ],
        ),
      ),
    );
  }
}
