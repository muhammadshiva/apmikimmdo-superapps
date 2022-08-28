import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;

class WppBsProductDetailNotCoverage {
  static Future show(BuildContext context,
      {void Function() onTap,
      bool useCloseButton = true}) async {
    double _screenWidth = MediaQuery.of(context).size.width;
    AppExt.hideKeyboard(context);

    await showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return WppBsProductDetailNotCoverageItem(
          onTap: onTap,
          useCloseButton: useCloseButton,
        );
      },
    );
  }
}

class WppBsProductDetailNotCoverageItem extends StatefulWidget {
  const WppBsProductDetailNotCoverageItem({
    Key key,
    this.onTap,
    this.useCloseButton,
  }) : super(key: key);

  final void Function() onTap;
  final bool useCloseButton;

  @override
  State<WppBsProductDetailNotCoverageItem> createState() =>
      _WppBsProductDetailNotCoverageItemState();
}

class _WppBsProductDetailNotCoverageItemState
    extends State<WppBsProductDetailNotCoverageItem> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 35),
          child: Column(
            children: [
              Image.asset(
                AppImg.img_homepage_warung,
                width: 200,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Mohon maaf produk ini tidak tersedia di daerah anda",
                textAlign: TextAlign.center,
                style: AppTypo.LatoBold.copyWith(
                    fontSize: 18, color: AppColor.primary),
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                    "Tapi jangan khawatir, Yuk lihat produk-produk lain di toko ini",
                    textAlign: TextAlign.center,
                    style: AppTypo.body1Lato.copyWith(color: AppColor.grey)),
              ),
              SizedBox(
                height: 20,
              ),
              RoundedButton.contained(label: "Lihat Produk Lainnya",isUpperCase: false, onPressed: widget.onTap)
            ],
          ),
        ),
      ),
    );
  }
}
