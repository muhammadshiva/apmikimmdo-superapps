import 'package:flutter/material.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class RoleItem extends StatelessWidget {
  const RoleItem(
      {Key key,
      @required this.onTap,
      @required this.icon,
      @required this.title,
      @required this.subtitle})
      : super(key: key);
  final Function onTap;
  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
                style: BorderStyle.solid, color: Colors.grey[400], width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      icon ?? SizedBox(),
                      SizedBox(height: 7),
                      Text(
                        title ?? '',
                        style: AppTypo.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                VerticalDivider(
                  thickness: 1,
                  color: Colors.grey[400],
                  indent: 7,
                  endIndent: 7,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    subtitle ?? '',
                    style: AppTypo.overline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
