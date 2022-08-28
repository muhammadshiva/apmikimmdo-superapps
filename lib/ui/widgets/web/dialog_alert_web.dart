import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:marketplace/main.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/cart_screen.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:beamer/beamer.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/constants.dart' as AppConst;

class AlertSuccessWeb extends StatelessWidget {
  const AlertSuccessWeb(
      {Key key, this.title, this.description, @required this.onPressClose})
      : super(key: key);

  final String title, description;
  final Function onPressClose;

  @override
  Widget build(BuildContext context) {
    return DialogWeb(
      height: 300,
      onPressedClose: onPressClose,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          // mainAxisSize: MainAxisSize.,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppColor.primary,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: AppTypo.h3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(description ?? "",
                  textAlign: TextAlign.center, style: AppTypo.subtitle2Accent),
            )
          ],
        ),
      ),
    );
  }
}

class AlertAddCartWeb extends StatelessWidget {
  const AlertAddCartWeb(
      {Key key,
      this.title,
      this.description,
      @required this.onPressClose,
      this.phonenumber,
      this.showCart,
      this.isWarung = false})
      : super(key: key);

  final String title, description;
  final Function onPressClose;
  final int phonenumber;
  final bool isWarung;
  final Function showCart;

  @override
  Widget build(BuildContext context) {
    return DialogWeb(
      onPressedClose: onPressClose,
      height: 410,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppColor.primary,
              size: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title ?? "",
                    textAlign: TextAlign.center,
                    style: AppTypo.h3,
                  ),
                  Text(description ?? "",
                      textAlign: TextAlign.center,
                      style: AppTypo.subtitle2Accent),
                  SizedBox(
                    height: 20,
                  ),
                  RoundedButton.contained(
                      label: "Lihat keranjang",
                      isUpperCase: false,
                      isSmall: true,
                      onPressed: () {
                        AppExt.popScreen(context);
                        kIsWeb && isWarung
                            ? context.beamToNamed(
                                '/${AppConst.WP_URL_PATH_ID}/$phonenumber/cart')
                            : kIsWeb && !isWarung
                                ? showGlobalDrawer(
                                    context: scaffoldMainKey.currentContext,
                                    useRootNavigator: true,
                                    barrierDismissible: false,
                                    barrierColor: Colors.transparent,
                                    direction: AxisDirection.right,
                                    duration: Duration(milliseconds: 300),
                                    builder: (BuildContext context) {
                                      return CartDrawerWeb();
                                    })
                                : AppExt.pushScreen(
                                    context,
                                     CartScreen());
                                    // isWarung
                                    //     ? WpCartScreen(phone: phonenumber)
                                    //     : CartScreenOld());
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedButton.outlined(
                      label: "Lanjut belanja",
                      isUpperCase: false,
                      isSmall: true,
                      onPressed: () {
                        AppExt.popScreen(context);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertFailureWeb extends StatelessWidget {
  const AlertFailureWeb(
      {Key key, this.title, this.description, @required this.onPressClose})
      : super(key: key);

  final String title, description;
  final Function onPressClose;

  @override
  Widget build(BuildContext context) {
    return DialogWeb(
      height: 300,
      onPressedClose: onPressClose,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          // mainAxisSize: MainAxisSize.,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Boxicons.bx_x_circle,
              color: AppColor.danger,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: AppTypo.h3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(description ?? "",
                  textAlign: TextAlign.center, style: AppTypo.subtitle2Accent),
            )
          ],
        ),
      ),
    );
  }
}

class AlertMaintenanceWeb extends StatelessWidget {
  const AlertMaintenanceWeb(
      {Key key, this.title, this.description, this.onPressClose})
      : super(key: key);

  final String title, description;
  final Function onPressClose;

  @override
  Widget build(BuildContext context) {
    return DialogWeb(
      height: 300,
      onPressedClose: onPressClose,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          // mainAxisSize: MainAxisSize.,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.build_circle,
              color: AppColor.warning,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: AppTypo.h3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(description ?? "",
                  textAlign: TextAlign.center, style: AppTypo.subtitle2Accent),
            )
          ],
        ),
      ),
    );
  }
}
