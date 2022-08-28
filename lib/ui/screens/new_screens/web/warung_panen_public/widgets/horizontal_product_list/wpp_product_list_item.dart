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
import 'package:marketplace/data/repositories/new_repositories/recipent_repository.dart';
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
class WppProductListItem extends StatelessWidget {
  final Products product;
  final RelatedProduct relatedProduct;
  bool isDiscount,
      useLineProgress,
      isShop,
      isBumdes,
      isKomisi,
      isFlashSale,
      isPublicResellerShop;
  final void Function(int productId) onDelete;
  //VARIABEL KHUSUS WARUNG
  final String warungSlug;
  //=======================

  WppProductListItem({
    Key key,
    @required this.product,
    this.relatedProduct,
    this.isDiscount = false,
    this.useLineProgress = false,
    this.isShop = false,
    this.isBumdes = false,
    this.isKomisi = false,
    this.isFlashSale = false,
    this.isPublicResellerShop,
    this.onDelete,
    this.warungSlug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final RecipentRepository _recipentRepo = RecipentRepository();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () {
            product != null
                ? context.beamToNamed(
                    '/wpp/productdetail/$warungSlug/${product.slug}/${product.id}')
                : relatedProduct != null
                    ? () {
                        _recipentRepo.setRecipentUserNoAuthDetailProduct(
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
                        context.beamToNamed(
                            '/wpp/productdetail/$warungSlug/${relatedProduct.slug}/${relatedProduct.id}');
                      }()
                    : null;
          },
          child: product != null
              ? cardProduct(context, _screenHeight)
              : relatedProduct != null
                  ? cardProductRelated(context, _screenHeight)
                  : SizedBox()),
    );
  }

  Align cardProduct(BuildContext context, double screenHeight) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: Container(
          //355 -> upgradeuser & bumdes , 330 -> general (upgradeuser)
          height: 350,
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
                        child: Image(
                          image: NetworkImage(
                            product.productPhoto[0].image,
                            // "https://picsum.photos/200",
                          ),
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                            return Image.asset(
                              AppImg.img_error,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.contain,
                            );
                          },
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            } else {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: frame != null
                                    ? child
                                    : Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10)),
                                          color: Colors.grey[200],
                                        ),
                                      ),
                              );
                            }
                          },
                        )),
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
                      child: Text("Bumdes Singosari",
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
                      isKomisi == true
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
                            fontSize: 14, fontWeight: FontWeight.w500),
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
                      // SizedBox(
                      //   height: isUpgradeUser ? 9 : 0,
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                                  child: Text("Terjual ${product.sold}",
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
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Align cardProductRelated(BuildContext context, double screenHeight) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: Container(
          //355 -> upgradeuser & bumdes , 330 -> general (upgradeuser)
          height: 300,
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
                        child: Image(
                          image: NetworkImage(
                            relatedProduct.cover,
                            // "https://picsum.photos/200",
                          ),
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                            return Image.asset(
                              AppImg.img_error,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.contain,
                            );
                          },
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            } else {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: frame != null
                                    ? child
                                    : Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10)),
                                          color: Colors.grey[200],
                                        ),
                                      ),
                              );
                            }
                          },
                        )),
                  ],
                ),
              ),
              isBumdes
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      width: double.infinity,
                      child: Text("Bumdes Singosari",
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
                      // isKomisi == true
                      //     ? Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 4, vertical: 2),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(2),
                      //           color: AppColor.red.withOpacity(0.25),
                      //         ),
                      //         child: Text(
                      //           "Komisi ${product.komisi ?? 0}%",
                      //           style: AppTypo.overline.copyWith(
                      //               fontWeight: FontWeight.w500,
                      //               color: AppColor.red),
                      //         ),
                      //       )
                      //     : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${relatedProduct.name}",
                        maxLines: kIsWeb ? 2 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypo.caption.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Rp ${AppExt.toRupiah(isDiscount ? relatedProduct.discPrice : relatedProduct.sellingPrice)}",
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
                                    "${relatedProduct.disc ?? 0}%",
                                    style: AppTypo.overline.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.red),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                      "Rp ${AppExt.toRupiah(isDiscount ? relatedProduct.sellingPrice : 0)}",
                                      maxLines: kIsWeb ? null : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypo.captionAccent.copyWith(
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
                                    relatedProduct.address,
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
                          ? Text("Terjual ${relatedProduct.sold}",
                              style:
                                  AppTypo.captionAccent.copyWith(fontSize: 12))
                          : SizedBox(),
                      // SizedBox(
                      //   height: isUpgradeUser ? 9 : 0,
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
