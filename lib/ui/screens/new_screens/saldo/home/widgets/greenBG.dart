import 'package:flutter/material.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class GreenBG extends StatelessWidget {
  const GreenBG({Key key, @required this.walletsBalance}) : super(key: key);
  final String walletsBalance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size deviceSize = MediaQuery.of(context).size;
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: deviceSize.height * 0.25,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage("images/decorations/bggreen.png")),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFF4406F),
                Color(0xFFFF658B),
              ],
            )),
        child: SizedBox(
          height: 53,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Saldo Anda",
                    style: AppTypo.caption
                        .copyWith(color: AppColor.white, fontSize: 16)),
                Text("${this.walletsBalance}",
                    style: AppTypo.subtitle1.copyWith(
                        color: AppColor.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height + 30, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
