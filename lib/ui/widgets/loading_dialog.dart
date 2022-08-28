import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class LoadingDialog {
  static void show(BuildContext context, {Color barrierColor}) {
    AppExt.hideKeyboard(context);
    showDialog(
      useRootNavigator: !kIsWeb,
      barrierDismissible: false,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Wrap(
                children: [
                  Material(
                    elevation: 10,
                    shadowColor: Colors.black38,
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: AppColor.primary,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Loading",
                            style: AppTypo.subtitle2Inv,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
