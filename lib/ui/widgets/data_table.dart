import 'package:flutter/material.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class dataTable {
  static Widget detail(@required String title, @required String subtitle) {
    return Table(
      children: [
        TableRow(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: AppTypo.caption,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        subtitle,
                        softWrap: true,
                        textAlign: TextAlign.right,
                        style: AppTypo.caption
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget boldDetail(@required String title, @required String subtitle) {
    return Table(
      children: [
        TableRow(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: AppTypo.caption,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        subtitle,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        style: AppTypo.caption
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget detail2(
      @required String title, @required String subtitle, @required onPress) {
    return Table(
      children: [
        TableRow(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: AppTypo.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.appPrimary),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: onPress,
                        child: Text(
                          subtitle,
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: AppTypo.caption.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.appPrimary,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget description(
      @required String title, @required String subtitle, textStyle, onPressed) {
    return Table(
      children: [
        TableRow(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: AppTypo.caption.copyWith(color: Colors.grey),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      " : ",
                      style: AppTypo.caption.copyWith(color: Colors.grey),
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: GestureDetector(
                        onTap: onPressed,
                        child: Text(
                          subtitle,
                          softWrap: true,
                          style: textStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget totalSummary(
      @required String title, @required String subtitle) {
    return Table(
      children: [
        TableRow(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: AppTypo.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColor.appPrimary),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        subtitle,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        style: AppTypo.caption.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
