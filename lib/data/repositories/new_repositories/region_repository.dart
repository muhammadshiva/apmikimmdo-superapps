import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/region.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class RegionRepository {
  final ApiProvider _provider = ApiProvider();
  final String _adsKey = AppConst.API_ADS_KEY;

  Future<GeneralRegionResponse> fetchProvinces() async {
    final response = await _provider.get("/master/provinces", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
       'ADS-Key':_adsKey
    });

    return GeneralRegionResponse.fromJson(response);
  }

  Future<GeneralRegionResponse> fetchCities({@required int provinceId}) async {
    final response = await _provider.get("/master/cities?province_id=$provinceId", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
       'ADS-Key':_adsKey
    });

    return GeneralRegionResponse.fromJson(response);
  }


}
