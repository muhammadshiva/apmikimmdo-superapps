import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as enDec;
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/routes.dart' as AppRoute;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

extension StringExtension on String {
  String capitalize() {
    String _result = "";
    List<String> _splitted = this.split(' ');
    for (var i = 0; i < _splitted.length; i++) {
      _result = _result +
          "${_splitted[i][0].toUpperCase()}${_splitted[i].substring(1)}";
      if (i != _splitted.length - 1) {
        _result = _result + " ";
      }
    }
    return _result;
  }

  String replaceMapPattern(Map<String, dynamic> pattern) {
    String source = this;
    pattern.forEach((keys, value) {
      source = source.replaceAll(keys, value.toString());
    });
    return source;
  }

  String setFallback([String fallbackChar = ""]) {
    if (this == null || this.isEmpty) return fallbackChar;
    return this;
  }
}

extension UnitExtension on double {
  /// Unit calculation according to https://stackoverflow.com/a/49637372/6193799
  double get mmToDp => this * 6.299;
}

void backToRoot(context) {
  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
}

void popUntilRoot(context) {
  Navigator.popUntil(context, ModalRoute.withName('/'));
}

void backToMain(context) {
  Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
}

void hideKeyboard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void popScreen(BuildContext context, [dynamic data]) {
  Navigator.pop(context, data);
}

enum RouteTransition { slide, dualSlide, fade, material, cupertino, slideUp }

Future pushScreen(BuildContext context, Widget buildScreen,
    [RouteTransition routeTransition = RouteTransition.slide,
    Widget fromScreen]) async {
  dynamic data;
  switch (routeTransition) {
    case RouteTransition.slide:
      data =
          await Navigator.push(context, AppRoute.SlideRoute(page: buildScreen));
      break;
    case RouteTransition.fade:
      data =
          await Navigator.push(context, AppRoute.FadeRoute(page: buildScreen));
      break;
    case RouteTransition.material:
      data = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => buildScreen));
      break;
    case RouteTransition.dualSlide:
      data = await Navigator.push(
          context,
          AppRoute.DualSlideRoute(
              enterPage: buildScreen, exitPage: fromScreen ?? context.widget));
      break;
    case RouteTransition.cupertino:
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              fullscreenDialog: true, builder: (context) => buildScreen));
      break;
    case RouteTransition.slideUp:
      data = await Navigator.push(
          context, AppRoute.SlideUpRoute(page: buildScreen));
      break;
  }
  return data;
}

void pushAndRemoveScreen(BuildContext context, {@required Widget pageRef}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => pageRef),
      (Route<dynamic> route) => false);
}

Color hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return Color(val);
}
/*
String parseHtmlString(String htmlString) {
  return parse(parse(htmlString).body.text).documentElement.text;
}*/

Color computeTextColor(Color color) {
  return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

String toRupiah(int number) {
  if (number == null) return "-";
  final currencyFormatter = NumberFormat('#,##0', 'ID');
  return currencyFormatter.format(number);
}

String shortCurr(int number) {
  return number < 1000000 ? toRupiah(number) : convCurr(number);
}

String convCurr(int number) {
  final currencyFormatter = NumberFormat.compact(locale: 'ID');
  return currencyFormatter.format(number);
}

String convertWeightUnit(double weight) {
  final kg = weight / 1000;
  final kwintal = kg / 100;
  if (weight == 0) {
    return "0";
  } else if (kg < 1) {
    return "$weight gr";
  } else if (kg > 0 && kwintal < 1) {
    return "$kg kg";
  } else {
    return "$kwintal kwintal";
  }
}

String convertDateToStringFormatId(DateTime time) =>
    DateFormat("d MMMM yyyy", 'in_ID').format(time ?? DateTime.now());

String getDateFrom(DateTime now) {
  final _now = now ?? DateTime.now();
  final date = DateTime(_now.year, _now.month, _now.day);
  return DateFormat("yyyy-MM-d").format(date);
}

String getDateTo(DateTime now) {
  final date = DateTime(now.year, now.month, now.day, 23, 59, 59);
  return DateFormat("yyyy-MM-d").format(date);
}

String randomDoubleInRange(num start, num end) =>
    (Random().nextDouble() * (end - start) + start).toStringAsFixed(1);

BadgeColor badgeColor(String badge) {
  return badge == "Petani Sayur"
      ? BadgeColor(
          background: AppColor.bgBadgeDarkGreen, text: AppColor.bgTextDarkGreen)
      : badge == "Petani Buah"
          ? BadgeColor(
              background: AppColor.bgBadgeRed.withOpacity(0.75),
              text: AppColor.bgTextRed)
          : badge == "Pembudidaya"
              ? BadgeColor(
                  background: AppColor.bgBadgeBlue.withOpacity(0.75),
                  text: AppColor.bgTextBlue)
              : badge == "Peternak"
                  ? BadgeColor(
                      background: AppColor.bgBadgeBrown.withOpacity(0.75),
                      text: AppColor.bgTextBrown)
                  : BadgeColor(
                      background: AppColor.bgBadgeGreen.withOpacity(0.75),
                      text: AppColor.bgTextGreen);
}

String replaceUriToId(String uri) {
  final linkUrl = uri;
  final find = 'http://marketplace.panen-panen.com';
  final replaceWith = 'https://marketplace.panenpanen.id';
  final newURI = linkUrl.replaceAll(find, replaceWith);
  // debugPrint(newURI);
  return newURI;
}

String convertCategoryWeb(int categoryId) {
  String categoryName = "";
  if (categoryId == 1) {
    categoryName = "sayuran";
  } else if (categoryId == 2) {
    categoryName = "buah";
  } else if (categoryId == 3) {
    categoryName = "ikan";
  } else if (categoryId == 4) {
    categoryName = "ternak";
  } else if (categoryId == 5) {
    categoryName = "warung";
  } else if (categoryId == 6) {
    categoryName = "catering";
  } else {
    categoryName = null;
  }
  return categoryName;
}

/// generate invoice format string like `INV/20210927/000123`
/// [minIdDigit] define the leading zeroes being added to the [id]
String generateInvoiceNumber({
  @required DateTime date,
  @required int id,
  int minIdDigit = 7,
}) {
  String formattedDate =
      date == null ? '-' : DateFormat("yyyyMMd", "id_ID").format(date);
  String formattedId = id.toString().padLeft(minIdDigit, '0');
  return "INV/$formattedDate/$formattedId";
}

String convertSubCategoryWeb(int categoryId) {
  return categoryId == 1 ? "Segar" : "Olahan";
}

String convertLowerCaseNoSpace(String word) {
  return word.toLowerCase().replaceAll(' ', '');
}

final key = enDec.Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
final iv = enDec.IV.fromUtf8('put16characters!'); //16 chars

//encrypt
String encryptMyData(String text) {
  final e = enDec.Encrypter(enDec.AES(key, mode: enDec.AESMode.cbc));
  final encryptData = e.encrypt(text, iv: iv);
  // debugPrint("ENCRYPT DATA : " + encryptData.base64);
  return encryptData.base64;
}

//dycrypt
String decryptMyData(String text) {
  final e = enDec.Encrypter(enDec.AES(key, mode: enDec.AESMode.cbc));
  var base64Data = text;
  // debugPrint("DARI URL: "+base64Data.replaceAll(' ', '+') ?? null);
  var urlEnc = Uri.encodeComponent(base64Data.replaceAll(' ', '+'));
  // debugPrint("ENDCODE COMPONENT : " + urlEnc); // EBES%2F%2B7dzA%3D%3D
  var urlDec = base64.normalize(urlEnc).replaceAll(' ', '');
  // debugPrint("DECODE COMPONENT : " + urlDec); // EBES/+7dzA==
  final decode = urlDec.replaceAll(' ', '');
  final decryptData = e.decrypt(enDec.Encrypted.fromBase64(decode), iv: iv);
  // debugPrint("DECRYPT : " + decryptData);
  return decryptData;
}

class BadgeColor {
  final Color background;
  final Color text;

  BadgeColor({@required this.background, @required this.text});
}

String formatPhoneNumber(String phone) {
  String changeToZero = phone.substring(0, 2).replaceAll("62", "0");
  // return "$changeToZero${phone.substring(2, phone.length - 1)}";
  return "$changeToZero${phone.substring(2, phone.length)}";
}

String removeCodePhone(String phone) {
  String changeToZero = phone.substring(0, 2).replaceAll("62", "");
  return "$changeToZero${phone.substring(2, phone.length)}";
}

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

Future<String> downloadImage({String image}) async {
  if (await _requestPermission(Permission.storage)) {
    var url = image ?? 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
    var response = await get(url);
    final fileName = url.split("/").last;
    var res = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.bodyBytes),
      quality: 100,
      name: "$fileName",
    );
    if (res['isSuccess'] ?? false) {
      return "${res['filePath']}";
    }
    throw Exception(res);
  } else {
    return null;
  }
}

void shareProductImageText(
    {Products product, TokoSayaProducts productShop, User userData}) async {
  var url = productShop != null
      ? productShop.productPhoto
      : product != null
          ? product.productPhoto[0].image
          : null;
  var idProduct = productShop != null
      ? productShop.id
      : product != null
          ? product.id
          : null;
  var nameProduk = productShop != null
      ? productShop.name
      : product != null
          ? product.name
          : null;
  var productSlug = productShop != null
      ? productShop.slug
      : product != null
          ? product.slug
          : null;

  var response = await get(url);
  final documentDirectory = (await getExternalStorageDirectory()).path;
  File imgFile = new File('$documentDirectory/product.png');
  imgFile.writeAsBytesSync(response.bodyBytes);
  Share.shareFiles(['$documentDirectory/product.png'],
      text:
          "Produk $nameProduk - https://warung.panenpanen.id/wpp/productdetail/${userData.reseller.slug}/$productSlug/$idProduct");
}

void shareProductImage(
    {Products product, TokoSayaProducts productShop, User userData}) async {
  var url = productShop != null
      ? productShop.productPhoto
      : product != null
          ? product.productPhoto[0].image
          : null;
  var response = await get(url);
  final documentDirectory = (await getExternalStorageDirectory()).path;
  File imgFile = new File('$documentDirectory/product.png');
  imgFile.writeAsBytesSync(response.bodyBytes);
  Share.shareFiles(['$documentDirectory/product.png']);
}

void shareProductText(
    {Products product, TokoSayaProducts productShop, User userData}) {
  var nameProduk = productShop != null
      ? productShop.name
      : product != null
          ? product.name
          : null;
  var idProduct = productShop != null
      ? productShop.id
      : product != null
          ? product.id
          : null;
  var productSlug = productShop != null
      ? productShop.slug
      : product != null
          ? product.slug
          : null;

  Share.share(
      "Produk $nameProduk - https://warung.panenpanen.id/wpp/productdetail/${userData.reseller.slug}/$productSlug/$idProduct");
}

String kabupatenToKab(String value) {
  return value.replaceAll('Kabupaten', 'Kab.');
}

String deleteAllComma(String value) {
  return value.replaceAll(',', '');
}
