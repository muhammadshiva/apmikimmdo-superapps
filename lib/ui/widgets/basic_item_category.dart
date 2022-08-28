import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class BasicItemCategory extends StatelessWidget {
  final double width,height,borderWidth;
  final String icon;
  final Color color,iconColor,borderColor;
  final Text label;
  final bool noContent;
  final VoidCallback onTap;

  const BasicItemCategory({Key key, this.icon="", this.label, this.onTap, this.color, this.iconColor, this.width, this.height, this.noContent=false, this.borderColor, this.borderWidth})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          width: borderWidth ?? 1,
          color: borderColor ?? Colors.grey[400],
        )
      ),
      child: noContent == true ?
      SizedBox():
      InkWell(
        onTap: onTap,
         borderRadius: BorderRadius.circular(7),
          child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              icon != null ?
              kIsWeb
                  ? Image.network(icon ?? null,width: 50, height: 50)
                  : SvgPicture.asset(icon, height: 40) : SizedBox(),
              SizedBox(
                width: icon != null ? 12.0 : 0,
              ),
              Flexible(child: label)
            ],  
          ),
        ),
      ),
    );
  }
}
