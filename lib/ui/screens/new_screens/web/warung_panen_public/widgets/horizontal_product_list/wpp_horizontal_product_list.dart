import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/nav/nav.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/horizontal_product_list/wpp_product_list_item.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/decorations.dart' as AppDecor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class WppHorizontalProductList extends StatelessWidget {
  final String section,warungSlug;
  final List<Products> products;
  final List<RelatedProduct> relatedProduct;
  final Function() viewAll;
  final bool isBumdes;
  final int warungPhoneNumber;

  const WppHorizontalProductList(
      {Key key,
      @required this.section,
      @required this.products,
      @required this.viewAll,
      this.relatedProduct,
      this.isBumdes = false,
      this.warungPhoneNumber, this.warungSlug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    // final bool isUpgradeUser =
    //     BlocProvider.of<UserDataCubit>(context).state.user != null &&
    //             BlocProvider.of<UserDataCubit>(context).state.user.reseller !=
    //                 null ||
    //         BlocProvider.of<UserDataCubit>(context).state.user != null &&
    //             BlocProvider.of<UserDataCubit>(context).state.user.supplier !=
    //                 null;
    // final userData = BlocProvider.of<UserDataCubit>(context).state.user;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: !context.isPhone ? 18 : _screenWidth * (5 / 100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                section != null ?
                Text(
                  section,
                  style: AppTypo.LatoBold.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ) : SizedBox(),
                viewAll != null
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: viewAll,
                          borderRadius: BorderRadius.circular(5),
                          child: Text(
                            "Lihat Semua",
                            textAlign: TextAlign.right,
                            style: AppTypo.LatoBold.copyWith(
                                color: AppColor.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          Container(
            // color: Colors.blue,
            height: 350,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (ctx, idx) => SizedBox(
                width: 10,
              ),
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: 5,
                left: !context.isPhone ? 18 : _screenWidth * (5 / 100),
              ),
              itemCount: products != null ? products.length : relatedProduct != null ? relatedProduct.length : 0,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                
                return
                 Container(
                  width: 135,
                  child: WppProductListItem(
                    warungSlug: warungSlug,
                    product: products != null ? products[index] : null,
                    relatedProduct: relatedProduct != null ? relatedProduct[index] : null,
                    // isKomisi:true,
                    // isDiscount: true,
                    isKomisi: false,
                    isDiscount: products != null ? products[index].disc > 0 : relatedProduct != null ? relatedProduct[index].disc > 0 : false ,
                    isBumdes: isBumdes,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
