import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/products/fetch_product_recom/fetch_product_recom_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/recipent_repository.dart';
import 'package:marketplace/ui/screens/new_screens/comment/comment_screen.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/product_description.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/horizontal_product_list/wpp_horizontal_product_list.dart';
import 'package:marketplace/ui/widgets/data_table.dart';
import 'package:marketplace/ui/widgets/horizontal_product_list.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:beamer/beamer.dart';
import 'package:readmore/readmore.dart';

import 'rounded_container.dart';

class WppProductDetailDetailScreenList extends StatefulWidget {
  const WppProductDetailDetailScreenList({
    Key key,
    @required this.product,
    this.onVariantSelected,
  }) : super(key: key);

  final Products product;
  final Function(ProductVariant variantSelected) onVariantSelected;

  @override
  _WppProductDetailDetailScreenListState createState() =>
      _WppProductDetailDetailScreenListState();
}

class _WppProductDetailDetailScreenListState
    extends State<WppProductDetailDetailScreenList> {
  final RecipentRepository recipentRepo = RecipentRepository();

  int variantSelectedId = 0;
  ProductVariant _productVariant;

  @override
  void initState() {
    _productVariant = widget.product.productVariant.length > 0
        ? widget.product.productVariant[0]
        : null;
    variantSelectedId = widget.product.productVariant.length > 0
        ? widget.product.productVariant[0].id
        : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: AppTypo.subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    widget.product.productVariant.length > 0
                        ? Text(
                      " ${_productVariant.variantName}",
                      style: AppTypo.subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    )
                        : SizedBox(),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.product.productVariant.length > 0
                            ? 'Rp ${AppExt.toRupiah((_productVariant.variantFinalPrice))}'
                            : 'Rp ${AppExt.toRupiah(widget.product.discPrice != 0 ? widget.product.discPrice : widget.product.sellingPrice)}',
                        style: AppTypo.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RoundedContainer(
                            fillColor: Color(0x3300AE8F),
                            child: Image.asset(
                              "images/icons/ic_truck.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dikirim Dari",
                                style: AppTypo.caption,
                              ),
                              Text(
                                "${widget.product.supplier.city}",
                                style: AppTypo.caption
                                    .copyWith(color: Color(0xFF00AE8F)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                widget.product.productVariant.length > 0 &&
                    _productVariant.variantDisc != 0
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
                        "${_productVariant.variantDisc ?? 0}%",
                        style: AppTypo.overline.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColor.red),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: Text(
                          "Rp ${AppExt.toRupiah(_productVariant.variantSellPrice ?? 0)}",
                          maxLines: kIsWeb ? null : 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypo.captionAccent.copyWith(
                              decoration: TextDecoration.lineThrough)),
                    ),
                  ],
                )
                    : widget.product.disc != 0
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
                        "${widget.product.disc ?? 0}%",
                        style: AppTypo.overline.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColor.red),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: Text(
                          "Rp ${AppExt.toRupiah(widget.product.sellingPrice ?? 0)}",
                          maxLines: kIsWeb ? null : 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypo.captionAccent.copyWith(
                              decoration:
                              TextDecoration.lineThrough)),
                    ),
                  ],
                )
                    : SizedBox(),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.star_fill,
                      color: Colors.orangeAccent,
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "4.9",
                      style:
                      AppTypo.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "(134 ulasan)",
                      style: AppTypo.caption.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Divider(
          //   thickness: 7,
          //   color: Color(0xFFEBECED),
          // ),
          // Container(
          //   margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
          //   child: Row(
          //     children: [
          //       Icon(Icons.location_on_outlined),
          //       Text(
          //         "Dikirim ke",
          //         style: AppTypo.caption,
          //       ),
          //       Text(
          //         " ${recipentRepo.getSelectedRecipentNoAuth()['subdistrict']}, ${recipentRepo.getSelectedRecipentNoAuth()['city']}",
          //         style: AppTypo.caption
          //             .copyWith(color: Theme.of(context).primaryColor),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          widget.product.productVariant.length > 0
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                thickness: 7,
                color: Color(0xFFEBECED),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Varian : ",
                      style: AppTypo.subtitle1
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemCount: widget.product.productVariant.length,
                        itemBuilder: (context, index) {
                          ProductVariant productVariant =
                          widget.product.productVariant[index];
                          return VariantRoundedContainer(
                            title: productVariant.variantName,
                            isSelected:
                            variantSelectedId == productVariant.id,
                            onTap: () {
                              setState(() {
                                variantSelectedId = productVariant.id;
                                _productVariant = productVariant;
                              });
                              widget.onVariantSelected(_productVariant);
                            },
                          );
                        }),
                  ],
                ),
              ),
            ],
          )
              : SizedBox(),
          Divider(
            thickness: 7,
            color: Color(0xFFEBECED),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "images/img_cs.png",
                        height: 60,
                        width: 60,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // "",
                            "${widget.product.reseller.name ?? "-"}",
                            style: AppTypo.caption
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.star_fill,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "${widget.product.reseller.rating ?? "-"}",
                                style: AppTypo.caption
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: AppColor.primary)),
                    onPressed: () {
                      recipentRepo.setRecipentUserNoAuthDetailProduct(
                        subdistrictId: recipentRepo
                            .getSelectedRecipentNoAuth()['subdistrict_id'],
                        subdistrict: recipentRepo
                            .getSelectedRecipentNoAuth()['subdistrict'],
                        city: recipentRepo.getSelectedRecipentNoAuth()['city'],
                        province: recipentRepo
                            .getSelectedRecipentNoAuth()['province'],
                        name: recipentRepo.getSelectedRecipentNoAuth()['name'],
                        address:
                        recipentRepo.getSelectedRecipentNoAuth()['address'],
                        phone:
                        recipentRepo.getSelectedRecipentNoAuth()['phone'],
                      );
                      context.beamToNamed(
                          '/wpp/dashboard/${widget.product.reseller.slug}',
                          data: {'isFromListWarung': true});
                    },
                    child: Text(
                      "Kunjungi Toko",
                      style: AppTypo.caption.copyWith(color: AppColor.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 7,
            color: Color(0xFFEBECED),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 13,
                ),
                Text(
                  "Informasi Produk",
                  style:
                  AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 8,
                ),
                dataTable.description(
                  "Berat",
                  "${widget.product.weight} ${widget.product.unit}",
                  AppTypo.caption,
                  null,
                ),
                dataTable.description(
                  "Kategori",
                  "${widget.product.categoryName}",
                  AppTypo.caption.copyWith(
                      color: AppColor.primary, fontWeight: FontWeight.w600),
                      () {},
                ),
                Text(
                  "Deskripsi",
                  style: AppTypo.subtitle1
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ReadMoreText(
                  "${widget.product.description}",
                  trimLines: 3,
                  style: AppTypo.caption,
                  trimLength: 50,
                  trimCollapsedText: "\nLihat Selengkapnya",
                  trimExpandedText: "\nLihat Sedikit",
                  delimiter: ' ',
                )
              ],
            ),
          ),
          Divider(
            thickness: 7,
            color: Color(0xFFEBECED),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 13,
              ),
              // Text(
              //   "Produk Lainnya",
              //   style:
              //       AppTypo.subtitle1.copyWith(fontWeight: FontWeight.w700),
              // ),
              WppHorizontalProductList(
                section: "Produk Lainnya",
                products: null,
                warungSlug: widget.product.reseller.slug,
                relatedProduct: widget.product.relatedProduct,
                viewAll: null,
              )
            ],
          ),
          /*Divider(
            thickness: 7,
            color: Color(0xFFEBECED),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ulasan Pembeli",
                        style: AppTypo.subtitle1
                            .copyWith(fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () {
                        AppExt.pushScreen(context, CommentScreen());
                      },
                      child: Text(
                        "Lihat Semua",
                        style: AppTypo.caption.copyWith(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.star_fill,
                      color: Colors.orangeAccent,
                      size: 30,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "4.9",
                      style: AppTypo.subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Text(
                      "dari 134 ulasan",
                      style: AppTypo.caption.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    for (var i = 0; i <= 4; i++)
                      Icon(
                        CupertinoIcons.star_fill,
                        color: Colors.orangeAccent,
                        size: 20,
                      )
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Text(
                      "Rusmini",
                      style: AppTypo.caption,
                    ),
                    Text(
                      " • ",
                      style: AppTypo.caption.copyWith(color: Colors.grey),
                    ),
                    Text(
                      "30 Apr",
                      style: AppTypo.caption.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Pengiriman cepat dan bahannya bagus banget",
                  style: AppTypo.caption,
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}