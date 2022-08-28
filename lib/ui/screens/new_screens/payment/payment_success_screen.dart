import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Padding(
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
                    AppImg.img_payment_success,
                    width: _screenWidth * (70 / 100),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Selamat, pemesanan anda berhasil!",style: AppTypo.LatoBold.copyWith(fontSize: 18,color: AppColor.primary)),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                      "Pesanan anda akan segera kami proses. Anda dapat melihat status transaksi pada detail transaksi.",textAlign: TextAlign.center,style: AppTypo.body2Lato.copyWith(color: AppColor.grey),),
                  SizedBox(
                    height: 32,
                  ),
                  RoundedButton.contained(
                      label: "Belanja Lagi",
                      isUpperCase: false,
                      textColor: AppColor.textPrimaryInverted,
                      onPressed: () async{
                        AppExt.popUntilRoot(context);
                        await BlocProvider.of<BottomNavCubit>(context).navItemTapped(0);
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  RoundedButton.outlined(
                      label: "Lihat Detail Transaksi",
                      isUpperCase: false,
                      onPressed: () async{
                        AppExt.popUntilRoot(context);
                         await BlocProvider.of<BottomNavCubit>(context).navItemTapped(1);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
