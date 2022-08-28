import 'package:flutter/foundation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:websafe_svg/websafe_svg.dart';

class AppBarConfig extends StatelessWidget implements PreferredSizeWidget {
  AppBarConfig(
      {Key key,
      this.bgColor,
      this.iconColor,
      this.logoColor,
      this.haveNotificationMenu = true})
      : super(key: key);

  final Color bgColor, iconColor, logoColor;
  final bool haveNotificationMenu;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: iconColor ?? Colors.white),
      backgroundColor: bgColor ?? AppColor.primary,
      elevation: 0.0,
      centerTitle: false,
      leading: Padding(
          padding:
              const EdgeInsets.only(bottom: 11, top: 4, left: 10, right: 10),
          child: kIsWeb
              ? WebsafeSvg.asset(AppImg.ic_apmikimmdo,
                  width: 30, height: 30, color: logoColor ?? Colors.white)
              : Image.asset(
                  AppImg.ic_apmikimmdo_png,
                  fit: BoxFit.contain,
                  width: 33,
                  height: 33,
                  // color: logoColor ?? Colors.white,
                )),
      titleSpacing: 0,
      title: Container(
        height: 50,
        child: EditText(
          hintText: "Cari produk",
          inputType: InputType.search,
          readOnly: true,
          onTap: () => AppExt.pushScreen(context, SearchScreen()),
        ),
      ),
      actions: [
        haveNotificationMenu
            ? Stack(
                children: [
                  IconButton(
                      padding: EdgeInsets.only(left: 5, top: 10, right: 12),
                      constraints: BoxConstraints(),
                      icon: Icon(EvaIcons.bell),
                      splashRadius: 2,
                      iconSize: 26,
                      onPressed: () {
                        // AppExt.pushScreen(
                        //   context,
                        //   BlocProvider.of<UserDataCubit>(context).state.user != null
                        //       ? CartScreen()
                        //       : SignInScreen(),
                        // );
                      }),
                  /* BlocProvider.of<UserDataCubit>(context).state.countCart != null &&
                    BlocProvider.of<UserDataCubit>(context).state.countCart > 0
                ? new Positioned(
                    right: 10,
                    top: -10,
                    child: Chip(
                      shape: CircleBorder(side: BorderSide.none),
                      backgroundColor: AppColor.red,
                      padding: EdgeInsets.zero,
                      labelPadding: BlocProvider.of<UserDataCubit>(context)
                                  .state
                                  .countCart >
                              99
                          ? EdgeInsets.all(2)
                          : EdgeInsets.all(4),
                      label: Text(
                        "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
                        style: AppTypo.overlineInv.copyWith(fontSize: 8),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : SizedBox.shrink(), */
                ],
              )
            : SizedBox(),
        Stack(
          children: [
            IconButton(
                padding: EdgeInsets.only(top: 10, right: 10),
                constraints: BoxConstraints(),
                icon: Icon(EvaIcons.shoppingCart),
                iconSize: 26,
                onPressed: () {
                  AppExt.pushScreen(
                    context,
                    BlocProvider.of<UserDataCubit>(context).state.user != null
                        ? CartScreen()
                        : SignInScreen(),
                  );
                }),
            BlocProvider.of<UserDataCubit>(context).state.countCart != null &&
                    BlocProvider.of<UserDataCubit>(context).state.countCart > 0
                ? new Positioned(
                    right: 6,
                    top: -10,
                    child: Chip(
                      shape: CircleBorder(side: BorderSide.none),
                      backgroundColor: AppColor.red,
                      padding: EdgeInsets.zero,
                      labelPadding: BlocProvider.of<UserDataCubit>(context)
                                  .state
                                  .countCart >
                              99
                          ? EdgeInsets.all(2)
                          : EdgeInsets.all(4),
                      label: Text(
                        "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
                        style: AppTypo.overlineInv.copyWith(fontSize: 8),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
