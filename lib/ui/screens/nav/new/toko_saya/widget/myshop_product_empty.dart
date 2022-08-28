import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class MyShopProductEmpty extends StatelessWidget {
  const MyShopProductEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
          right: _screenWidth * (5 / 100),
          left: _screenWidth * (5 / 100),
          top: _screenHeight * (20 / 100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              AppImg.img_shop_product_empty,
              width: _screenWidth * (60 / 100),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _screenWidth * (15 / 100)),
            child: Text("Anda belum menambahkan produk",
                textAlign: TextAlign.center,
                style: AppTypo.LatoBold.copyWith(
                    fontSize: 18, color: AppColor.primary)),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _screenWidth * (12 / 100)),
            child: Text(
              "Anda dapat menambahkan produk anda sendiri maupun produk dari toko lain yang sedang banyak diminati.",
              textAlign: TextAlign.center,
              style: AppTypo.body2Lato.copyWith(color: AppColor.textSecondary2),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          RoundedButton.contained(
              label: "Cari Produk",
              textColor: AppColor.textPrimaryInverted,
              isUpperCase: false,
              onPressed: () async {
                BlocProvider.of<BottomNavCubit>(context).navItemTapped(0);
              })
        ],
      ),
    );
  }
}
