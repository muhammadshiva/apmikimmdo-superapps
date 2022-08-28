import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AAppConfig.of(context);
    final String imagePath = AppImg.img_logo_light;
    final double _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFF4406F),
            Color(0xFFFF658B),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColor.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: !context.isPhone ? 20 : 50,
                  ),
                  Image.asset(
                    imagePath,
                    width: !context.isPhone ? 400 : _screenWidth * (60 / 100),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(AppColor.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
