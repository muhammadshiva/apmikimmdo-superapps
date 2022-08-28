import 'package:flutter/material.dart';
import 'colors.dart' as AppColor;

BoxDecoration customElevation = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: AppColor.black.withOpacity(0.05),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ],
);

BoxDecoration customElevationInverse = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: AppColor.black.withOpacity(0.05),
      blurRadius: 10,
      offset: Offset(0, -4),
    ),
  ],
);
