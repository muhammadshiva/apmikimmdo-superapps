import 'package:flutter/material.dart';

import 'colors.dart' as AppColor;

const String _fontMontserrat = 'Montserrat';
const String _fontInter = 'Inter';
const String _fontLato = 'Lato';

// textSizeSmall = 12.0;
// textSizeSMedium = 14.0;
// textSizeMedium = 16.0;
// textSizeLargeMedium = 18.0;
// textSizeNormal = 20.0;
// textSizeLarge = 24.0;
// textSizeXLarge = 30.0;
// textSizeTitle = 34.0;

//Font Lato
const TextStyle LatoBold = TextStyle(
  fontFamily: _fontLato,
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
  color: AppColor.textPrimary,
);

const TextStyle body1Lato = TextStyle(
  fontFamily: _fontLato,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  color: AppColor.textPrimary,
);

const TextStyle body2Lato = TextStyle(
  fontFamily: _fontLato,
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  color: AppColor.textPrimary,
);

//===============

const TextStyle h1 = TextStyle(
  fontFamily: _fontMontserrat,
  fontSize: 34.0,
  fontWeight: FontWeight.w700,
  color: AppColor.textPrimary,
);

TextStyle h1Inv = h1.copyWith(color: AppColor.textPrimaryInverted);
TextStyle h1Accent = h1.copyWith(color: AppColor.textSecondary);

const TextStyle h2 = TextStyle(
  fontFamily: _fontMontserrat,
  fontSize: 26.0,
  fontWeight: FontWeight.w700,
  color: AppColor.textPrimary,
);

TextStyle h2Inv = h2.copyWith(color: AppColor.textPrimaryInverted);
TextStyle h2Accent = h2.copyWith(color: AppColor.textSecondary);

const TextStyle h3 = TextStyle(
  fontFamily: _fontMontserrat,
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  color: AppColor.textPrimary,
);

TextStyle h3Inv = h3.copyWith(color: AppColor.textPrimaryInverted);
TextStyle h3Accent = h3.copyWith(color: AppColor.textSecondary);

const TextStyle subtitle1 = TextStyle(
  fontFamily: _fontLato,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  color: AppColor.textPrimary,
);

TextStyle subtitle1Inv =
    subtitle1.copyWith(color: AppColor.textPrimaryInverted);
TextStyle subtitle1Accent = subtitle1.copyWith(color: AppColor.textSecondary);

const TextStyle subtitle2 = TextStyle(
  fontFamily: _fontMontserrat,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  color: AppColor.textPrimary,
);

TextStyle subtitle2Inv =
    subtitle2.copyWith(color: AppColor.textPrimaryInverted);
TextStyle subtitle2Accent = subtitle2.copyWith(color: AppColor.textSecondary);

const TextStyle caption = TextStyle(
  fontFamily: _fontLato,
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  color: AppColor.textPrimary,
);

const TextStyle boldCaption = TextStyle(
  fontFamily: _fontLato,
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
  color: AppColor.textPrimary,
);

const TextStyle captionGold = TextStyle(
  fontFamily: _fontLato,
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  color: AppColor.yellow,
);

const TextStyle disableText = TextStyle(
  fontFamily: _fontLato,
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  color: AppColor.inactiveSwitch,
);

TextStyle body1Inv = body1.copyWith(color: AppColor.textPrimaryInverted);
TextStyle body1Accent = body1.copyWith(color: AppColor.textSecondary);

const TextStyle body2 = TextStyle(
  fontFamily: _fontLato,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  color: AppColor.textPrimary,
);

TextStyle body2Inv = body2.copyWith(color: AppColor.textPrimaryInverted);
TextStyle body2Accent = body2.copyWith(color: AppColor.textSecondary);

const TextStyle button = TextStyle(
  fontFamily: _fontMontserrat,
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.25,
);

TextStyle buttonInv = button.copyWith(color: AppColor.textPrimaryInverted);
TextStyle buttonAccent = button.copyWith(color: AppColor.textSecondary);

TextStyle captionInv = caption.copyWith(color: AppColor.textPrimaryInverted);
TextStyle captionAccent = caption.copyWith(color: AppColor.textSecondary);

const TextStyle body1 = TextStyle(
  fontFamily: _fontLato,
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
  color: AppColor.textPrimary,
);

const TextStyle overline = TextStyle(
  fontFamily: _fontLato,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  color: AppColor.textPrimary,
);

TextStyle overlineInv = overline.copyWith(color: AppColor.textPrimaryInverted);
TextStyle overlineAccent =
    overline.copyWith(color: AppColor.inactiveTrackSwitch);

const TextStyle tab = TextStyle(
  fontFamily: _fontMontserrat,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  color: AppColor.textPrimary,
);

TextStyle tabInv = tab.copyWith(color: AppColor.textPrimaryInverted);
TextStyle tabAccent = tab.copyWith(color: AppColor.textSecondary);

// v2
const TextStyle subtitle1v2 = TextStyle(
  fontFamily: _fontLato,
  fontSize: 20.0,
  fontWeight: FontWeight.normal,
  color: AppColor.textPrimary,
);

TextStyle subtitle1v2Inv =
    subtitle1v2.copyWith(color: AppColor.textPrimaryInverted);
TextStyle subtitle1v2Accent =
    subtitle1v2.copyWith(color: AppColor.textSecondary);

const TextStyle subtitle2v2 = TextStyle(
  fontFamily: _fontMontserrat,
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  color: AppColor.textPrimary,
);

TextStyle subtitle2v2Inv =
    subtitle2v2.copyWith(color: AppColor.textPrimaryInverted);
TextStyle subtitle2v2Accent =
    subtitle2v2.copyWith(color: AppColor.textSecondary);

const TextStyle body1v2 = TextStyle(
  fontFamily: _fontLato,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  color: AppColor.textPrimary,
);

TextStyle body1v2Inv = body1v2.copyWith(color: AppColor.textPrimaryInverted);
TextStyle body1v2Accent = body1v2.copyWith(color: AppColor.textSecondary);
