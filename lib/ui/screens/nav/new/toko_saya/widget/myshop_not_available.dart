import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/join_user/join_user_screen.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class MyShopNotAvailable extends StatelessWidget {
  const MyShopNotAvailable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _screenWidth * (10 / 100)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImg.img_open_shop,
                width: _screenWidth * (70 / 100),
              ),
              SizedBox(
                height: 40,
              ),
              Text("Toko Anda Belum Tersedia",
                  style: AppTypo.LatoBold.copyWith(
                      fontSize: 18, color: AppColor.primary)),
              SizedBox(
                height: 18,
              ),
              Text(
                "Bergabunglah menjadi reseller kami untuk membuka toko dan raih penghasilan tambahan hingga jutaan rupiah",
                textAlign: TextAlign.center,
                style: AppTypo.body2Lato.copyWith(color: AppColor.grey),
              ),
              SizedBox(
                height: 32,
              ),
              RoundedButton.contained(
                  label: "Gabung Reseller",
                  isUpperCase: false,
                  textColor: AppColor.textPrimaryInverted,
                  onPressed: () {
                    if (BlocProvider.of<UserDataCubit>(context).state.user != null) {
                      BlocProvider.of<BottomNavCubit>(context).navItemTapped(3);
                      AppExt.pushScreen(context, JoinUserScreen(
                                userType: UserType.reseller,
                              ));
                    }else{
                      AppExt.pushScreen(context, SignInScreen());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
