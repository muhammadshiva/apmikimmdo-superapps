import 'dart:convert';
import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/decorations.dart' as AppDecor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class ProductListWeb extends StatefulWidget {
  final String titleSection;
  final List<Products> products;
  final Function() viewAll;
  final bool isTitleSection;
  final bool isHeaderWithBorder;
  final bool isOnlyTitle;
  final bool isGrocir;
  final bool isWithBottomDivider;
  final bool isHasShadow;
  final double heightOfCarousel;
  final int chunkSize;
  final int titleLength;

  // final Recipent selectedAddress;

  const ProductListWeb(
      {Key key,
      this.titleSection,
      this.products,
      this.viewAll,
      this.isTitleSection = false,
      this.heightOfCarousel = 320,
      this.isWithBottomDivider = false,
      this.isHeaderWithBorder = false,
      this.isOnlyTitle = false,
      this.chunkSize = 5,
      this.isGrocir = false,
      this.isHasShadow = true, 
      this.titleLength = 50
      // this.selectedAddress
      })
      : super(key: key);
  @override
  _ProductListWebState createState() => _ProductListWebState();
}

class _ProductListWebState extends State<ProductListWeb> {
  final CarouselController _controller = CarouselController();

  List<List<Products>> chunks;
  int chunkSize = 5;
  int counter = 0;
  bool isHovered = false;
  bool rightButtonShow = false;
  bool leftButtonShow = false;

  @override
  void initState() {
    chunks = _generateChunks(widget.products, chunkSize, Products());
    chunkSize = widget.chunkSize;
    chunks = _generateChunks(widget.products, chunkSize, Products());
    if (chunkSize == 6) {
      if (widget.products.length > 6) {
        rightButtonShow = true;
      }
    } else {
      if (widget.products.length > 5) {
        rightButtonShow = true;
      }
    }

    super.initState();
  }

  List<List<T>> _generateChunks<T>(List<T> inList, int chunkSize, T emptyItem) {
    List<List<T>> outList = [];
    List<T> tmpList = [];
    int counter = 0;

    for (int current = 0; current < inList.length; current++) {
      if (counter != chunkSize) {
        tmpList.add(inList[current]);
        counter++;
      }
      if (counter == chunkSize || current == inList.length - 1) {
        outList.add(tmpList.toList());
        tmpList.clear();
        counter = 0;
      }
    }

    while (outList[outList.length - 1].length < chunkSize) {
      outList[outList.length - 1].add(emptyItem);
    }

    return outList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isTitleSection == true
            ? Padding(
                padding: EdgeInsets.only(left: 82, right: 82, top: 25),
                child: Text(
                  widget.titleSection,
                  style: AppTypo.h2
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 24),
                ),
              )
            : SizedBox(),
        MouseRegion(
          onEnter: (value) {
            setState(() {
              isHovered = true;
            });
          },
          onExit: (value) {
            setState(() {
              isHovered = false;
            });
          },
          child: Stack(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  // aspectRatio: 1.0,
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  enableInfiniteScroll: false,
                  height: widget.heightOfCarousel,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                ),
                carouselController: _controller,
                itemCount: chunks.length,
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 5;
                  final int second = first + 1;
                  final int three = second + 1;
                  final int four = three + 1;
                  final int five = four + 1;
                  final int six = five + 1;

                  // debugPrint("INDEX:${chunks[index]}");

                  return Padding(
                    padding: EdgeInsets.only(
                        left: 82, top: 20, right: 82, bottom: 10),
                    child: Row(
                      children: chunks[index].asMap().entries.map((e) {
                        if (e.value.id == null) {
                          return Expanded(
                            child: SizedBox(),
                          );
                        }
                        return Expanded(
                          child: Container(
                              margin: chunkSize == 6
                                  ? e.key == five
                                      ? EdgeInsets.only(right: 5)
                                      : e.key == six
                                          ? EdgeInsets.only(left: 5)
                                          : EdgeInsets.only(right: 10)
                                  : e.key == four
                                      ? EdgeInsets.only(right: 5)
                                      : e.key == five
                                          ? EdgeInsets.only(left: 5)
                                          : EdgeInsets.only(right: 10),
                              child: ProductListItemWebOld(
                                product: e.value, isPromo: e.value.disc != 0,
                                isOnlyTitle: widget.isOnlyTitle,
                                isHeaderWithBorder: widget.isHeaderWithBorder,
                                isHasShadow: widget.isHasShadow,

                                // selectedAddress: widget.selectedAddress
                              )
                              // child: Center(child: Text(imgList[idx])),
                              ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 70),
                child: Visibility(
                  visible: isHovered,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Visibility(
                        visible: leftButtonShow,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              counter--;
                            });
                            if (counter == 0) {
                              setState(() {
                                leftButtonShow = false;
                                rightButtonShow = true;
                              });
                            } else {
                              setState(() {
                                leftButtonShow = true;
                                rightButtonShow = true;
                              });
                            }
                            _controller.previousPage();
                          },
                          elevation: 4.0,
                          fillColor: Colors.white,
                          child: Icon(Icons.arrow_back_ios, size: 20),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                      ),
                      Visibility(
                        visible: rightButtonShow,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              counter++;
                              leftButtonShow = true;
                            });
                            if (counter == chunks.length - 1) {
                              setState(() {
                                rightButtonShow = false;
                              });
                            } else {
                              setState(() {
                                leftButtonShow = true;
                                rightButtonShow = true;
                              });
                            }
                            _controller.nextPage();
                          },
                          elevation: 4.0,
                          fillColor: Colors.white,
                          child: Icon(Icons.arrow_forward_ios, size: 20),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        widget.isWithBottomDivider == true
            ? Padding(
                padding:
                    EdgeInsets.only(left: 82, right: 82, top: 10, bottom: 0),
                child: Divider(
                  thickness: 1,
                  color: AppColor.grey,
                  indent: 3,
                  endIndent: 4,
                ),
              )
            : SizedBox()
      ],
    );
  }
}

class ProductListItemWebOld extends StatelessWidget {
  final Products product;
  final bool isPromo;
  final bool isFromShop;
  final bool isPotency;
  final bool isWithHeaderForBisniso;
  final bool isHeaderWithBorder;
  final bool isOnlyTitle;
  final bool isHasShadow;
  final List<ProductGroceries> wholesale;
  final int titleLength;
  // final Recipent selectedAddress;

  const ProductListItemWebOld(
      {Key key,
      @required this.product,
      this.isPromo = false,
      this.isFromShop = false,
      this.wholesale,
      this.isPotency = false,
      this.isWithHeaderForBisniso = true,
      this.isHeaderWithBorder = false,
      this.isOnlyTitle = false,
      this.isHasShadow = true, 
      this.titleLength = 50
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPrint(AppExt.encryptMyData(jsonEncode(ProductV2(id: product.id,prediction: product.prediction,monthId: product.monthId))));
    final config = AAppConfig.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColor.grey.withOpacity(0.45),
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        elevation: 0,
        child: InkWell(
          onTap: () {
            isPotency
                ? context.beamToNamed(
                    '/potency/${product.name.replaceAll(' ', '-')}?c=${AppExt.encryptMyData(jsonEncode([
                    product.id,
                  ]))}')
                : 
                context.beamToNamed(
                        '/product/detail/${isFromShop == true ? 'is' : 'ig'}/${ product.name.replaceAll(' ', '-')}/${product.id}/${product.categoryId ?? 0}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: Image(
                          image: NetworkImage(
                            "${AppConst.STORAGE_URL}/products/${product.productPhoto}",
                            // "https://picsum.photos/200",
                          ),
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                            return Image.asset(
                              AppImg.img_error,
                              width: double.infinity,
                              height: 180,
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
                                        height: 180,
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
                    Row(
                      children: [
                        // config.appType == AppType.panenpanen
                        //     ? 
                        //     product.badge != null
                        //         ? Container(
                        //             margin: const EdgeInsets.all(5),
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 4, vertical: 2),
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(2),
                        //               color: AppExt.badgeColor(product.badge)
                        //                   .background,
                        //             ),
                        //             child: Text(
                        //               "${product.badge}",
                        //               style: AppTypo.overline.copyWith(
                        //                   fontWeight: FontWeight.w700,
                        //                   color:
                        //                       AppExt.badgeColor(product.badge)
                        //                           .text,
                        //                   fontSize: 12),
                        //             ),
                        //           )
                        //         : SizedBox.shrink()
                        //     : SizedBox(),
                        // product.isWholesale == 1
                        //     ? Container(
                        //         margin: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 4, vertical: 2),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(2),
                        //           color: AppColor.gold.withOpacity(0.75),
                        //         ),
                        //         child: Text(
                        //           "Grosir",
                        //           style: AppTypo.overline.copyWith(
                        //               fontWeight: FontWeight.w700,
                        //               color: AppColor.red,
                        //               fontSize: 12),
                        //         ),
                        //       )
                        //     : SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    //   product.seller != null ?
                    //   BadgeCard(
                    //   text: product.seller.city.name ?? "",
                    //   textColor: AppColor.primary,
                    //   color: AppColor.primary.withOpacity(0.3),
                    //   borderRadius: 10,
                    //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    //   fontSize: 10,
                    //   margin: EdgeInsets.zero,
                    // ) : SizedBox() ,
                    SizedBox(height: 5,),
                      RichText(
                        maxLines: 2,
                        text: TextSpan(
                        text: product.name.length > titleLength ? product.name.substring(0,titleLength) : product.name,
                        style: isPotency
                            ? AppTypo.subtitle2
                                .copyWith(fontWeight: FontWeight.w700)
                            : AppTypo.caption,
                        children:[
                          TextSpan(
                            text: product.name.length > titleLength ? "..." : " "
                          )
                        ]
                      )),
                      // Text(
                      //   product.name.length > 25 ? product.name.substring(0,25) : product.name,
                      //   // maxLines: kIsWeb? null : 2,
                      //   // overflow: TextOverflow.ellipsis,
                      //   style: isPotency
                      //       ? AppTypo.subtitle2
                      //           .copyWith(fontWeight: FontWeight.w700)
                      //       : AppTypo.caption,
                      // ),
                      isPromo ? SizedBox(height: 2) : SizedBox.shrink(),
                      isPromo
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
                                    "${product.disc}%",
                                    style: AppTypo.overline.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.red),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                      "Rp ${AppExt.toRupiah(product.price)}",
                                      maxLines: kIsWeb? null : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypo.captionAccent.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough)),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: 3),
                      // !isPotency
                      //     ? Text("Rp ${AppExt.toRupiah(product.enduserPrice)}",
                      //           style: AppTypo.caption.copyWith(
                      //               fontWeight: FontWeight.w700,
                      //               color: AppColor.primary),
                      //       )
                      //     : Text(
                      //         "Prediksi : ${product.predictionAmount} kg",
                      //         style: AppTypo.body1.copyWith(
                      //             fontWeight: FontWeight.w700,
                      //             fontSize: 14,
                      //             color: AppColor.primary),
                      //       ),
                      !isFromShop ? SizedBox(height: 3) : SizedBox.shrink(),
                      !isFromShop && !isPotency
                          ? Text("Terjual ${AppExt.toRupiah(product.sold)}",
                              style: AppTypo.captionAccent)
                          : SizedBox.shrink(),
                      // SizedBox(height: 3),
                      // Row(
                      //   children: [
                      //     Icon(Icons.star, color: AppColor.warning, size: 18),
                      //     SizedBox(width: 2),
                      //     Text("${AppExt.randomDoubleInRange(4.5, 5.0)}",
                      //         style: AppTypo.caption),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ProductListItemBisnisoWeb extends StatelessWidget {
//   const ProductListItemBisnisoWeb({
//     Key key,
//     @required this.product,
//     @required this.isPromo,
//     this.isBlured = false,
//     this.isHeaderWithBorder = false,
//     this.isOnlyTitle = false,
//     this.isGrocir = false,
//     this.isHasShadow = true,
//   }) : super(key: key);

//   final ProductV2 product;
//   final bool isPromo;
//   final bool isBlured;
//   final bool isHeaderWithBorder;
//   final bool isOnlyTitle;
//   final bool isGrocir;
//   final bool isHasShadow;

//   @override
//   Widget build(BuildContext context) {
//     final config = AAppConfig.of(context);
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//         boxShadow: isHasShadow != true
//             ? null
//             : <BoxShadow>[
//                 BoxShadow(
//                   color: AppColor.grey.withOpacity(0.45),
//                   blurRadius: 5,
//                 ),
//               ],
//       ),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           isOnlyTitle ? Radius.circular(10) : Radius.circular(5),
//         ),
//         elevation: 0,
//         child: InkWell(
//           hoverColor: Colors.transparent,
//           onTap: () {
//             isOnlyTitle
//                 ? null
//                 :
//                 // BlocProvider.of<IsGrosirCubit>(context).state ?
//                 // context.beamToNamed(
//                 //   '/grosir/products/detail',
//                 //   data: {
//                 //     'product':product
//                 //   }
//                 // )
//                 // :
//                 context.beamToNamed('/products/detail',
//                     data: {'product': product});
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         borderRadius: isOnlyTitle
//                             ? BorderRadius.all(Radius.circular(10))
//                             : BorderRadius.only(
//                                 topLeft: Radius.circular(5),
//                                 topRight: Radius.circular(5)),
//                         border: isHeaderWithBorder == true
//                             ? Border.all(color: Color(0xFF979CA0))
//                             : null),
//                     child: ClipRRect(
//                         borderRadius: isOnlyTitle
//                             ? BorderRadius.all(Radius.circular(10))
//                             : BorderRadius.only(
//                                 topLeft: Radius.circular(5),
//                                 topRight: Radius.circular(5)),
//                         child: Image(
//                           image: AssetImage('${product.productPhoto}'),
//                           // NetworkImage(
//                           //   "${AppConst.STORAGE_URL}/products/${product.productPhoto}",
//                           //   // "https://picsum.photos/200",
//                           // ),
//                           width: double.infinity,
//                           height: 180,
//                           fit: BoxFit.cover,
//                           errorBuilder: (BuildContext context, Object exception,
//                               StackTrace stackTrace) {
//                             return Image.asset(
//                               AppImg.img_error,
//                               width: double.infinity,
//                               height: 180,
//                               fit: BoxFit.contain,
//                             );
//                           },
//                           frameBuilder:
//                               (context, child, frame, wasSynchronouslyLoaded) {
//                             if (wasSynchronouslyLoaded) {
//                               return child;
//                             } else {
//                               return AnimatedSwitcher(
//                                 duration: const Duration(milliseconds: 300),
//                                 child: frame != null
//                                     ? child
//                                     : Container(
//                                         width: double.infinity,
//                                         height: 80,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.vertical(
//                                               top: Radius.circular(10)),
//                                           color: Colors.grey[200],
//                                         ),
//                                       ),
//                               );
//                             }
//                           },
//                         )),
//                   ),
//                 ],
//               ),
//               isOnlyTitle == true
//                       ? Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Center(
//                             child: Text(
//                               product.name,
//                               maxLines: kIsWeb? null : 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: AppTypo.body1.copyWith(fontSize: 16),
//                             ),
//                           ),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 product.name,
//                                 maxLines: kIsWeb? null : 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: AppTypo.body1
//                                     .copyWith(fontWeight: FontWeight.w600),
//                               ),
//                               isPromo ? SizedBox(height: 2) : SizedBox.shrink(),
//                               isPromo
//                                   ? Row(
//                                       children: [
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 4, vertical: 2),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(2),
//                                             color:
//                                                 AppColor.red.withOpacity(0.25),
//                                           ),
//                                           child: Text(
//                                             "${product.disc}%",
//                                             style: AppTypo.overline.copyWith(
//                                                 fontWeight: FontWeight.w700,
//                                                 color: AppColor.red),
//                                           ),
//                                         ),
//                                         SizedBox(width: 3),
//                                         Expanded(
//                                           child: Text(
//                                               config.appType == AppType.panenpanen ?
//                                     "Rp ${AppExt.toRupiah(product.price)}/box" :
//                                     "Rp ${AppExt.toRupiah(product.price)}/pcs",
//                                               maxLines: kIsWeb? null : 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: AppTypo.captionAccent
//                                                   .copyWith(
//                                                       decoration: TextDecoration
//                                                           .lineThrough)),
//                                         ),
//                                       ],
//                                     )
//                                   : SizedBox.shrink(),
//                               SizedBox(height: 6),
//                               Text(
//                                   "Rp.${AppExt.toRupiah(isPromo ? product.promo : product.price)}",
//                                   style: AppTypo.body1.copyWith(fontSize: 14)),
//                               SizedBox(height: 6),
//                               Row(
//                                 children: [
//                                   RatingBar.builder(
//                                       initialRating: 5,
//                                       minRating: 1,
//                                       direction: Axis.horizontal,
//                                       allowHalfRating: true,
//                                       itemCount: 5,
//                                       itemSize: 12,
//                                       itemBuilder: (context, _) => Icon(
//                                             Icons.star,
//                                             color: Colors.amber,
//                                           ),
//                                       onRatingUpdate: (rating) {}),
//                                   Text(
//                                     "(${product.sold})",
//                                     style: AppTypo.body1.copyWith(fontSize: 12),
//                                   )
//                                 ],
//                               ),
//                               SizedBox(height: 6),
//                               Text(product.nameSeller,
//                                   style: AppTypo.caption.copyWith(
//                                       fontSize: 12, color: Color(0xFF979CA0)))
//                             ],
//                           ),
//                         ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class ProductListItemBisnisoWeb extends StatelessWidget {
//   const ProductListItemBisnisoWeb.withoutHeader({
//     Key key,
//     @required this.product,
//     @required this.isPromo,
//     this.onlyBgBody = true, this.isBlured = false,
//   }) : super(key: key);

//   const ProductListItemBisnisoWeb.withHeader({
//     Key key,
//     @required this.product,
//     @required this.isPromo,
//     this.onlyBgBody = false, this.isBlured,
//   }) : super(key: key);

//   final ProductV2 product;
//   final bool isPromo;
//   final bool isBlured;
//   final bool onlyBgBody;

//   @override
//   Widget build(BuildContext context) {
//   final config = AAppConfig.of(context);
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: AppColor.grey.withOpacity(0.45),
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           Radius.circular(5),
//         ),
//         elevation: 0,
//         child: InkWell(
//           onTap: () {
//             context.beamToNamed(
//               '/product/${AppExt.convertCategoryWeb(product.categoryId)}/${product.nameSeller.replaceAll(' ', '-') ?? product.name.replaceAll(' ', '-')}/${product.id}'
//             );
//           },
//           child:
//           onlyBgBody == true ?
//           ClipRRect(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(5),
//                           topRight: Radius.circular(5)),
//                       child:
//                       isBlured ?
//                       ImageFiltered(
//                         imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                         child: Image(
//                           image: NetworkImage(
//                             "${AppConst.STORAGE_URL}/products/${product.productPhoto}",
//                             // "https://picsum.photos/200",
//                           ),
//                           width: double.infinity,
//                           height: 180,
//                           fit: BoxFit.cover,
//                           errorBuilder: (BuildContext context, Object exception,
//                               StackTrace stackTrace) {
//                             return Image.asset(
//                               AppImg.img_error,
//                               width: double.infinity,
//                               height: 180,
//                               fit: BoxFit.contain,
//                             );
//                           },
//                           frameBuilder:
//                               (context, child, frame, wasSynchronouslyLoaded) {
//                             if (wasSynchronouslyLoaded) {
//                               return child;
//                             } else {
//                               return AnimatedSwitcher(
//                                 duration: const Duration(milliseconds: 300),
//                                 child: frame != null
//                                     ? child
//                                     : Container(
//                                         width: double.infinity,
//                                         height: 80,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.vertical(
//                                               top: Radius.circular(10)),
//                                           color: Colors.grey[200],
//                                         ),
//                                       ),
//                               );
//                             }
//                           },
//                         ),
//                       ) :
//                       Image(
//                         image: NetworkImage(
//                           "${AppConst.STORAGE_URL}/products/${product.productPhoto}",
//                           // "https://picsum.photos/200",
//                         ),
//                         width: double.infinity,
//                         height: 180,
//                         fit: BoxFit.cover,
//                         errorBuilder: (BuildContext context, Object exception,
//                             StackTrace stackTrace) {
//                           return Image.asset(
//                             AppImg.img_error,
//                             width: double.infinity,
//                             height: 180,
//                             fit: BoxFit.contain,
//                           );
//                         },
//                         frameBuilder:
//                             (context, child, frame, wasSynchronouslyLoaded) {
//                           if (wasSynchronouslyLoaded) {
//                             return child;
//                           } else {
//                             return AnimatedSwitcher(
//                               duration: const Duration(milliseconds: 300),
//                               child: frame != null
//                                   ? child
//                                   : Container(
//                                       width: double.infinity,
//                                       height: 80,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(10)),
//                                         color: Colors.grey[200],
//                                       ),
//                                     ),
//                             );
//                           }
//                         },
//                       )
//                       )
//           :
//            Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   ClipRRect(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(5),
//                           topRight: Radius.circular(5)),
//                       child: Image(
//                         image: NetworkImage(
//                           "${AppConst.STORAGE_URL}/products/${product.productPhoto}",
//                           // "https://picsum.photos/200",
//                         ),
//                         width: double.infinity,
//                         height: 180,
//                         fit: BoxFit.cover,
//                         errorBuilder: (BuildContext context, Object exception,
//                             StackTrace stackTrace) {
//                           return Image.asset(
//                             AppImg.img_error,
//                             width: double.infinity,
//                             height: 180,
//                             fit: BoxFit.contain,
//                           );
//                         },
//                         frameBuilder:
//                             (context, child, frame, wasSynchronouslyLoaded) {
//                           if (wasSynchronouslyLoaded) {
//                             return child;
//                           } else {
//                             return AnimatedSwitcher(
//                               duration: const Duration(milliseconds: 300),
//                               child: frame != null
//                                   ? child
//                                   : Container(
//                                       width: double.infinity,
//                                       height: 80,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(10)),
//                                         color: Colors.grey[200],
//                                       ),
//                                     ),
//                             );
//                           }
//                         },
//                       )),
//                 ],
//               ),
//               config.appType == AppType.bisnisogrosir && BlocProvider.of<UserDataCubit>(context).state.user == null  ?
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                         Text(
//                       product.name,
//                       maxLines: kIsWeb? null : 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: AppTypo.caption,
//                     ),
//                     Text("Rp.XXX0.000"),
//                   ],
//                 ),
//               )
//               :
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       product.name,
//                       maxLines: kIsWeb? null : 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: AppTypo.caption,
//                     ),
//                     isPromo ? SizedBox(height: 2) : SizedBox.shrink(),
//                     isPromo
//                         ? Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 4, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(2),
//                                   color: AppColor.red.withOpacity(0.25),
//                                 ),
//                                 child: Text(
//                                   "${product.disc}%",
//                                   style: AppTypo.overline.copyWith(
//                                       fontWeight: FontWeight.w700,
//                                       color: AppColor.red),
//                                 ),
//                               ),
//                               SizedBox(width: 3),
//                               Expanded(
//                                 child: Text(
//                                     "Rp ${AppExt.toRupiah(product.price)}/box",
//                                     maxLines: kIsWeb? null : 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: AppTypo.captionAccent.copyWith(
//                                         decoration:
//                                             TextDecoration.lineThrough)),
//                               ),
//                             ],
//                           )
//                         : SizedBox.shrink(),
//                     SizedBox(height: 3),
//                     Text("Rp.${AppExt.toRupiah(product.promo)}",
//                             style: AppTypo.captionAccent),
//                     SizedBox(height: 3),
//                     Row(
//                       children: [
//                         Icon(Icons.star, color: AppColor.warning, size: 18),
//                         SizedBox(width: 2),
//                         Text("${AppExt.randomDoubleInRange(4.5, 5.0)}",
//                             style: AppTypo.caption),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



