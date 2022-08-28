import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:url_launcher/url_launcher.dart';

class UpdateAppOverlay extends StatelessWidget {
  const UpdateAppOverlay({
    Key key,
    this.isShowed = false,
  }) : super(key: key);

  final bool isShowed;

  void _launchUrl(BuildContext context, String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      BSFeedback.show(
        context,
        icon: Boxicons.bx_x_circle,
        color: AppColor.red,
        title: "Gagal mengakses halaman",
        description: "Halaman atau koneksi internet bermasalah",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isShowed) return SizedBox();

    return Material(
      color: Colors.white.withOpacity(0.90),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: Get.size.width / 1.3),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black26)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Oops!",
                style: AppTypo.h2Inv,
              ),
              Text(
                "Update dulu aplikasinya",
                style: AppTypo.body1Inv,
              ),
              SizedBox(
                height: 20,
              ),
              RoundedButton.contained(
                color: Colors.white,
                label: "Update",
                onPressed: () => _launchUrl(
                  context,
                  AppConst.PLAYSTORE,
                ),
                textColor: AppColor.primaryLight2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
