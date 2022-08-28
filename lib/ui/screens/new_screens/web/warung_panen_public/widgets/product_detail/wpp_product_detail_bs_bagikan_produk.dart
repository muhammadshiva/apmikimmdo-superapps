import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:marketplace/data/blocs/new_cubit/bagikan_produk/bagikan_produk_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class WppProductDetailBsBagikanProduk {
  Future<void> showBsReview(BuildContext context, Products product,
      TokoSayaProducts productShop, bool isShop) async {
    final bagikan = ["Gambar", "Judul dan Deskripsi"];

    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
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
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: NetworkImage(product.productPhoto[0].image),
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                          errorBuilder: (context, object, stack) => Image.asset(
                            AppImg.img_error,
                            width: 48,
                            height: 48,
                          ),
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            } else {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: frame != null
                                    ? child
                                    : Container(
                                        width: 48,
                                        height: 48,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[200]),
                                      ),
                              );
                            }
                          },
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isShop ? productShop.name : product.name,
                            style: AppTypo.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Rp ${AppExt.toRupiah(isShop ? productShop.oriPrice : product.sellingPrice)}",
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
                            label: bagikan[0],
                            isChoosen: state.contains(bagikan[0]));
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    BlocBuilder<BagikanProdukCubit, List<String>>(
                      builder: (context, state) {
                        return BagikanELement(
                            label: bagikan[1],
                            isChoosen: state.contains(bagikan[1]));
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
                      onPressed: !state.contains(bagikan[0]) &&
                              !state.contains(bagikan[1])
                          ? null
                          : () {
                              state.contains(bagikan[0]) &&
                                      state.contains(bagikan[1])
                                  ? AppExt.shareProductImageText(
                                      product: product,
                                      productShop: productShop)
                                  : state.contains(bagikan[0])
                                      ? AppExt.shareProductImage(
                                          product: product,
                                          productShop: productShop)
                                      : AppExt.shareProductText(
                                          product: product,
                                          productShop: productShop);
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
          );
        });
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
            color: isChoosen ? Color(0xFFFCE8BF) : Colors.white),
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
