import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/nav/nav.dart';
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

class ProductList extends StatelessWidget {
  final String section;
  final List<Products> products;
  final Function() viewAll;
  final bool isBumdes;
  final int warungPhoneNumber;

  const ProductList(
      {Key key,
      @required this.section,
      @required this.products,
      @required this.viewAll,
      this.isBumdes = false,
      this.warungPhoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final bool isUpgradeUser =
        BlocProvider.of<UserDataCubit>(context).state.user != null &&
                BlocProvider.of<UserDataCubit>(context).state.user.reseller !=
                    null ||
            BlocProvider.of<UserDataCubit>(context).state.user != null &&
                BlocProvider.of<UserDataCubit>(context).state.user.supplier !=
                    null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _screenWidth * (5 / 100),
            vertical: 16
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section,
                style: AppTypo.LatoBold.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
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
                              color: AppColor.primary,
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
        SizedBox(height: 5),
        Container(
          height: isUpgradeUser && isBumdes
              ? 400
              : isUpgradeUser
                  ? 370
                  : isBumdes
                      ? 340
                      : 310,
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
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              Products _item = products[index];
              return Container(
                width: 135,
                child: ProductListItem(
                  product: _item,
                  isKomisi: _item.komisi != null && _item.komisi > 0,
                  isDiscount: _item.disc > 0,
                  isBumdes: isBumdes,
                ),
              );
            },
          ),
        ),
      
      ],
    );
  }
}
