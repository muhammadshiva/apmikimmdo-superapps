import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';

import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/colors.dart' as AppColor;

class BsChangeStock {
  void showChangeStockSheet(
      context, {
        @required void Function(int) onSubmit,
        @required int stock,
        // @required ProductV2 product,
        // @required int totalItem,
        // @required int totalPrice,
      }) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      elevation: 10,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      builder: (BuildContext bc) {
        return _BsChangeStock(
          stock: stock,
          onSubmit: onSubmit,
        );
      },
    );
  }
}

class _BsChangeStock extends StatefulWidget {
  const _BsChangeStock({Key key, @required this.stock, this.onSubmit})
      : super(key: key);

  final int stock;
  final void Function(int) onSubmit;

  @override
  _BsChangeStockState createState() => _BsChangeStockState();
}

class _BsChangeStockState extends State<_BsChangeStock> {
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stockController.text = widget.stock.toString();
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 10),
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: _screenWidth * (15 / 100),
              height: 7,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(7.5 / 2),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Ubah Stok",
              textAlign: TextAlign.center,
              style: AppTypo.h3,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  disabledColor: AppColor.primary.withOpacity(0.3),
                  icon: Icon(FlutterIcons.minus_circle_mco),
                  onPressed: _stockController.text.isNotEmpty
                      ? int.parse(_stockController.text) <= 0
                      ? null
                      : () {
                    AppExt.hideKeyboard(context);
                    setState(() {
                      _stockController.text =
                      '${int.parse(_stockController.text) - 1}';
                    });
                    /*setSheetState(() {
                      _stockController.text =
                      '${int.parse(_stockController.text) - 1}';
                    });*/
                  }
                      : null,
                  color: AppColor.primary,
                  iconSize: 40,
                  splashRadius: 30,
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: _screenWidth * (40 / 100),
                  child: EditText(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    hintText: "",
                    controller: _stockController,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  disabledColor: AppColor.primary.withOpacity(0.3),
                  icon: Icon(FlutterIcons.plus_circle_mco),
                  onPressed: () {
                    AppExt.hideKeyboard(context);
                    setState(() {
                      _stockController.text =
                      '${int.parse(_stockController.text) + 1}';
                    });
                    /*setSheetState(() {
                      _stockController.text =
                      '${int.parse(_stockController.text) + 1}';
                    });*/
                  },
                  color: AppColor.primary,
                  iconSize: 40,
                  splashRadius: 30,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: _screenWidth * (5 / 100)),
              child: RoundedButton.contained(
                  label: 'Ubah',
                  onPressed: _stockController.text.isEmpty ||
                      _stockController.text == ""
                      ? null
                      : () {
                    widget.onSubmit(int.parse(_stockController.text));
                  }),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}