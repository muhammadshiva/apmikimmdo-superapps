import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/ui/widgets/widgets.dart';

import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class EmptyData extends StatelessWidget {
  final String title;
  final String subtitle;
  final String labelBtn;
  final String image;
  final void Function() onClick;

  const EmptyData(
      {Key key,
      this.title = "Coming soon",
      @required this.subtitle,
      this.onClick,
      this.labelBtn,
      this.image = AppImg.img_not_found})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.fromLTRB(
        _screenWidth * (5 / 100),
        0,
        _screenWidth * (5 / 100),
        _screenWidth * (5 / 100),
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: _screenWidth * (60 / 100),
                height: _screenHeight * (30 / 100),
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: _screenWidth * (75 / 100),
                child: Text(
                  title,
                  style: AppTypo.h3.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: _screenWidth * (75 / 100),
                child: Text(
                  subtitle,
                  style: AppTypo.body1v2,
                  textAlign: TextAlign.center,
                ),
              ),
              onClick != null
                  ? SizedBox(
                      height: 30,
                    )
                  : SizedBox.shrink(),
              onClick != null
                  ? SizedBox(
                      width: _screenWidth * (80 / 100),
                      child: RoundedButton.contained(
                        isSmall: true,
                        isUpperCase: false,
                        label: labelBtn ?? "",
                        onPressed: onClick,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}

class NoConnection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String labelButton;
  final Function() onButtonPressed;

  const NoConnection(
      {Key key,
      this.title = "Tidak ada koneksi internet",
      this.subtitle = "Cek paket data/koneksi wifi kamu lalu coba lagi..",
      this.labelButton = "Coba Lagi",
      @required this.onButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImg.img_no_connection,
            //   width: _screenWidth * (50 / 100),
            //   height: _screenWidth * (40 / 100),
            //   fit: BoxFit.contain,
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            SizedBox(
              width: _screenWidth * (75 / 100),
              child: Text(
                title,
                style: AppTypo.h3.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: _screenWidth * (75 / 100),
              child: Text(
                subtitle,
                style: AppTypo.body1v2,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: _screenWidth * (60 / 100),
              child: RoundedButton.contained(
                isSmall: true,
                label: labelButton,
                onPressed: onButtonPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ErrorFetchForUser extends StatelessWidget {
  final String title;
  final String subtitle;
  final String labelButton;
  final Function() onButtonPressed;

  const ErrorFetchForUser(
      {Key key,
      this.title = "Sistem Mengalami Masalah",
      this.subtitle = "Terdapat masalah pada aplikasi",
      this.labelButton = "Coba Lagi",
      @required this.onButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: _screenWidth * (75 / 100),
              child: Text(
                title,
                style: AppTypo.h3.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: _screenWidth * (75 / 100),
              child: Text(
                subtitle,
                style: AppTypo.body1v2,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: _screenWidth * (60 / 100),
              child: RoundedButton.contained(
                isSmall: true,
                label: labelButton,
                onPressed: onButtonPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ErrorFetch extends StatelessWidget {
  final String message;
  final String labelButton;
  final Function() onButtonPressed;

  const ErrorFetch(
      {Key key,
      this.message,
      this.labelButton = "Coba Lagi",
      @required this.onButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              EvaIcons.alertCircleOutline,
              size: 45,
              color: AppColor.primaryDark,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
              child: Text(
                message ?? "Data gagal dimuat",
                style: AppTypo.overlineAccent,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            OutlineButton(
              child: Text(labelButton),
              onPressed: onButtonPressed,
              textColor: AppColor.primaryDark,
              color: AppColor.danger,
            ),
          ],
        ),
      ],
    );
  }
}

class ErrorDialog {
  ErrorDialog.show(
      {@required this.context,
      @required this.message,
      @required this.type,
      @required this.onTry,
      @required this.onBack,
      this.barrierColor}) {
    this._show();
  }

  final BuildContext context;
  final Color barrierColor;
  final String message;
  final ErrorType type;
  final Function() onTry;
  final Function() onBack;

  void _show() {
    AppExt.hideKeyboard(context);

    showDialog(
      barrierDismissible: false,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Oops',
                        style: AppTypo.body2
                            .copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 20,
                    ),
                    Text('$message',
                        textAlign: TextAlign.center, style: AppTypo.body2),
                    SizedBox(
                      height: 20,
                    ),
                    type == ErrorType.network
                        ? Row(
                            children: [
                              Expanded(
                                child: RoundedButton.outlined(
                                  isUpperCase: false,
                                  isSmall: true,
                                  isCompact: true,
                                  label: "Kembali",
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onBack();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: RoundedButton.contained(
                                  isUpperCase: false,
                                  isSmall: true,
                                  isCompact: true,
                                  label: "Coba Lagi",
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onTry();
                                  },
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: 120,
                            child: RoundedButton.contained(
                              isUpperCase: false,
                              isSmall: true,
                              isCompact: true,
                              label: "Oke",
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
