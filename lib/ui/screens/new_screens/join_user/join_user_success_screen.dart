import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/new_screens/producer_dashboard/producer_dashboard_screen.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

import 'join_user_add_product_screen.dart';

class JoinUserSuccessScreen extends StatelessWidget {
  const JoinUserSuccessScreen({Key key, @required this.userType})
      : super(key: key);

  final UserType userType;

  @override
  Widget build(BuildContext context) {
    final AuthenticationRepository _authRepo = AuthenticationRepository();
    final double _screenWidth = MediaQuery.of(context).size.width;

    void _checkUser() async {
      if (await _authRepo.hasToken()) {
        await BlocProvider.of<UserDataCubit>(context).loadUser();
        // namaPenerima = _recipentRepo.getRecipentNameReceiver();
      }
    }

    return WillPopScope(
      onWillPop: () {
        AppExt.popScreen(context);
        _checkUser();
        return;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _screenWidth * (10 / 100)),
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
                    userType == UserType.reseller
                        ? Text(
                            "Selamat anda telah berhasil menjadi reseller Apmikimmdo",
                            textAlign: TextAlign.center,
                            style: AppTypo.LatoBold.copyWith(
                                fontSize: 18, color: AppColor.primary))
                        : Text(
                            "Selamat anda telah berhasil menjadi supplier Apmikimmdo",
                            textAlign: TextAlign.center,
                            style: AppTypo.LatoBold.copyWith(
                                fontSize: 18, color: AppColor.primary)),
                    SizedBox(
                      height: 14,
                    ),
                    userType == UserType.reseller
                        ? RoundedButton.contained(
                            label: "Buka Toko Anda",
                            isUpperCase: false,
                            textColor: AppColor.textPrimaryInverted,
                            onPressed: () {
                              AppExt.popUntilRoot(context);
                              BlocProvider.of<BottomNavCubit>(context)
                                  .navItemTapped(1);
                            })
                        : SizedBox(),
                    userType == UserType.supplier
                        ? RoundedButton.contained(
                            label: "Tambah Produk",
                            isUpperCase: false,
                            textColor: AppColor.textPrimaryInverted,
                            onPressed: () {
                              AppExt.popUntilRoot(context);
                              BlocProvider.of<BottomNavCubit>(context)
                                  .navItemTapped(3);
                              AppExt.pushScreen(
                                  context, JoinUserAddProductScreen());
                            })
                        : SizedBox(),
                    SizedBox(
                      height: userType == UserType.supplier ? 12 : 0,
                    ),
                    userType == UserType.supplier
                        ? RoundedButton.outlined(
                            label: "Tambah Produk Nanti",
                            isUpperCase: false,
                            textColor: AppColor.primary,
                            onPressed: () {
                              AppExt.popUntilRoot(context);
                              BlocProvider.of<BottomNavCubit>(context)
                                  .navItemTapped(3);
                              AppExt.pushScreen(
                                  context,
                                  ProducerDashboardScreen(
                                    isSupplier: true,
                                  ));
                            })
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
