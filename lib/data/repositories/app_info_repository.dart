import 'dart:io';

import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class AppInfoRepository {
  final ApiProvider _provider = ApiProvider();
  final String _adsKey = AppConst.API_ADS_KEY;

  Future<AppInfoRes> fetchAppInfo() async {
    final response = await _provider.get(
      "/app/version",
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'ADS-Key':_adsKey
      },
    );
    return AppInfoRes.fromJson(response);
  }

  Future<PackageInfo> getAppInfo() async {
    return await PackageInfo.fromPlatform();
  }
}
