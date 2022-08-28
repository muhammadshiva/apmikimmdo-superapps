import 'dart:io';

import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class HomeSliderRepository {
  final ApiProvider _provider = ApiProvider();
  final String _adsKey = AppConst.API_ADS_KEY;

  Future<HomeSliderResponse> fetchHomeSlider() async {
    final response = await _provider.get("/home/slider", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key':_adsKey
    });
    return HomeSliderResponse.fromJson(response);
  }
}
