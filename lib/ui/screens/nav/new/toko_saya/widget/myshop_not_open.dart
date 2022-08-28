import 'package:flutter/material.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class MyShopNotOpen extends StatelessWidget {
  const MyShopNotOpen({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: _screenWidth * (10 / 100)),
          child: Container(
            alignment: Alignment.center,
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
                  Text("Toko Anda Belum Buka",style: AppTypo.LatoBold.copyWith(fontSize: 18,color: AppColor.primary)),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                      "Lengkapi profil toko anda dan dapatkan peluang penghasilan hingga jutaan rupiah dengan menjadi reseller kami",textAlign: TextAlign.center,style: AppTypo.body2Lato.copyWith(color: AppColor.grey),),
                  SizedBox(
                    height: 32,
                  ),
                  RoundedButton.contained(
                      label: "Lengkapi Profil Toko",
                      isUpperCase: false,
                      textColor: AppColor.textPrimaryInverted,
                      onPressed: (){
                        AppExt.pushScreen(context, JoinUserProfileEntryScreen());
                        // await BlocProvider.of<BottomNavCubit>(context).navItemTapped(0);
                      }),
                ],
              ),
            ),
          ),
        );
  }
}