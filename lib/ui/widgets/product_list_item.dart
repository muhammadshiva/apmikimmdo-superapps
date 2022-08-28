import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/product_detail_screen.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/bs_bagikan_produk.dart';
import 'package:marketplace/ui/widgets/bs_feedback.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:shimmer/shimmer.dart';
import 'package:websafe_svg/websafe_svg.dart';

// ignore: must_be_immutable
class ProductListItem extends StatelessWidget {
  final Products product;
  bool isDiscount,
      useLineProgress,
      isShop,
      isBumdes,
      isKomisi,
      isFlashSale,
      isPublicResellerShop;
  bool isUpgradeUser;
  final void Function(int productId) onDelete;

  ProductListItem({
    Key key,
    @required this.product,
    this.isDiscount = false,
    this.useLineProgress = false,
    this.isUpgradeUser,
    this.isShop = false,
    this.isBumdes = false,
    this.isKomisi = false,
    this.isFlashSale = false,
    this.isPublicResellerShop,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final isUser = BlocProvider.of<UserDataCubit>(context).state.user != null
        ? BlocProvider.of<UserDataCubit>(context).state.user
        : null;
    isUpgradeUser = isUser != null ? isUser.reseller != null : false;

    return kIsWeb
        ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                context.beamToNamed(
                    '/productdetail/${product.id}/${isPublicResellerShop ? 'publicshop' : 'general'}');
              },
              child: cardProduct(context, isUser, _screenHeight),
            ),
          )
        : InkWell(
            onTap: () {
              AppExt.pushScreen(
                  context,
                  ProductDetailScreen(
                    productId: product.id,
                  ));
            },
            child: cardProduct(context, isUser, _screenHeight));
  }

  Align cardProduct(BuildContext context, User userData, double screenHeight) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: Container(
          //355 -> upgradeuser & bumdes , 330 -> general (upgradeuser)
          height: isUpgradeUser && isBumdes
              ? 342
              : isUpgradeUser && isFlashSale
                  ? 350
                  : isUpgradeUser
                      ? 360
                      : isBumdes
                          ? 300
                          : 295,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColor.black.withOpacity(0.08),
                blurRadius: 5,
                // spreadRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: kIsWeb
                          ? Image(
                              image: NetworkImage(
                                product.productPhoto[0].image,
                              ),
                              width: double.infinity,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return Image.asset(
                                  AppImg.img_error,
                                  width: double.infinity,
                                  height: 80,
                                  fit: BoxFit.contain,
                                );
                              },
                              frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                } else {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: frame != null
                                        ? child
                                        : Container(
                                            width: double.infinity,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                  );
                                }
                              },
                            )
                          : CachedNetworkImage(
                              imageUrl: product.productPhoto.length > 0
                                  ? product.productPhoto[0].image
                                  : 'https://v1end.apmikimmdo.com/images/blank.png',
                              memCacheHeight: Get.height > 350
                                  ? (Get.height * 0.25).toInt()
                                  : Get.height,
                              width: double.infinity,
                              height: 140,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[200],
                                period: Duration(milliseconds: 1000),
                                child: Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)),
                                      color: Colors.white),
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                AppImg.img_error,
                                width: double.infinity,
                                height: 115,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    isShop
                        ? Positioned(
                            bottom: 7,
                            right: 7,
                            child: GestureDetector(
                              onTap: () {
                                onDelete(product.id);
                              },
                              child: Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Icon(
                                  FlutterIcons.trash_ent,
                                  color: AppColor.redFlashSale,
                                  size: 15,
                                )),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              isBumdes
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      width: double.infinity,
                      child: Text("Bumdes",
                          style:
                              AppTypo.body1Lato.copyWith(color: Colors.white)),
                      decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30))),
                    )
                  : SizedBox(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isUpgradeUser && isKomisi == true
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: AppColor.red.withOpacity(0.25),
                              ),
                              child: Text(
                                "Komisi ${product.komisi ?? 0}%",
                                style: AppTypo.overline.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: AppColor.red),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${product.name}",
                        maxLines: kIsWeb ? 2 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypo.caption.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Rp ${AppExt.toRupiah(isDiscount ? product.discPrice : product.sellingPrice)}",
                        maxLines: kIsWeb ? null : 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypo.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColor.primary),
                      ),
                      isDiscount ? SizedBox(height: 6) : SizedBox.shrink(),
                      isDiscount
                          ? Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: AppColor.red.withOpacity(0.25),
                                  ),
                                  child: Text(
                                    "${product.disc ?? 0}%",
                                    style: AppTypo.overline.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppColor.red),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                      "Rp ${AppExt.toRupiah(isDiscount ? product.sellingPrice : 0)}",
                                      maxLines: kIsWeb ? null : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypo.captionAccent.copyWith(
                                          fontSize: 13,
                                          decoration:
                                              TextDecoration.lineThrough)),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: !isShop ? 6 : 0),
                      !isShop
                          ? Row(
                              children: [
                                kIsWeb
                                    ? WebsafeSvg.asset(AppImg.ic_marker_map,
                                        width: 10)
                                    : SvgPicture.asset(AppImg.ic_marker_map,
                                        width: 10),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Text(
                                    product.supplier.city,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        AppTypo.caption.copyWith(fontSize: 12),
                                  ),
                                )
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 5),
                      !useLineProgress
                          ? Text("Terjual ${AppExt.toRupiah(product.sold)}",
                              style:
                                  AppTypo.captionAccent.copyWith(fontSize: 12))
                          : SizedBox(),
                      SizedBox(
                        height: isUpgradeUser ? 9 : 0,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 10, right: 10, bottom: isUpgradeUser ? 10 : 5),
                  child: Column(
                    children: [
                      useLineProgress
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    value: product.stock == 0
                                        ? 1
                                        : product.sold / product.stock,
                                    backgroundColor: AppColor.silverFlashSale,
                                    minHeight: 15,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColor.redFlashSale),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 3, bottom: 3),
                                  alignment: Alignment.center,
                                  child: Text(
                                      "Terjual ${AppExt.toRupiah(product.sold)}",
                                      style: AppTypo.body1.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: Colors.white)),
                                )
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: useLineProgress ? 10 : 0,
                      ),
                      isUpgradeUser
                          ? GestureDetector(
                              onTap: () {
                                product.stock != 0
                                    ? BsBagikanProduk().showBsReview(
                                        context, product, null, isShop)
                                    : BSFeedback.outOfStock(
                                        context,
                                        imgUrl: "images/img_outofstock.png",
                                        title: "Maaf, stok barang sedang habis",
                                        description:
                                            " Anda dapat membagikan produk saat stok kembali tersedia",
                                      );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      EvaIcons.shareOutline,
                                      color: AppColor.textPrimaryInverted,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "Bagikan",
                                      style: AppTypo.body2Lato.copyWith(
                                          color: AppColor.textPrimaryInverted),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: product.stock != 0
                                        ? AppColor.primary
                                        : Colors.grey[350],
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            )
                          : SizedBox(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
