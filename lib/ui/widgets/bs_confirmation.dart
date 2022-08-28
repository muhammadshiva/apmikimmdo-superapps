import 'package:flutter/material.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class BsConfirmation {
  void show(
      {@required BuildContext context,
      @required void Function() onYes,
      @required String title}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: !context.isPhone
                      ? 500
                      : MediaQuery.of(context).size.width),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypo.body2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButton.outlined(
                            isUpperCase: false,
                            isCompact: true,
                            label: "Ya",
                            onPressed: () {
                              Navigator.pop(context);
                              onYes();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RoundedButton.contained(
                            isUpperCase: false,
                            isCompact: true,
                            label: "Tidak",
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void dialog(
      {@required BuildContext context,
      @required void Function() onYes,
      @required String title,
      @required String subtitle}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: !context.isPhone
                      ? 500
                      : MediaQuery.of(context).size.width),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypo.body2,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      subtitle,
                      style: AppTypo.body2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButton.outlined(
                            isUpperCase: false,
                            isCompact: true,
                            label: "Ya",
                            onPressed: () {
                              Navigator.pop(context);
                              onYes();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RoundedButton.contained(
                            isUpperCase: false,
                            isCompact: true,
                            label: "Tidak",
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void warning({@required BuildContext context, @required String title}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          contentPadding: const EdgeInsets.all(20),
          content: Text(
            title,
            style: AppTypo.body2,
            textAlign: TextAlign.left,
          ),
          actions: [
            RoundedButton.contained(
              isUpperCase: false,
              isCompact: true,
              label: 'Ok',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
