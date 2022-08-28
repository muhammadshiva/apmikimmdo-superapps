import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/data/models/new_models/search_news_activity.dart';
import 'package:marketplace/data/models/new_models/tag_news_activity.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class TagNewsActivityRepository {
  final ApiProvider _provider = ApiProvider();
  final String _adsKey = AppConst.API_ADS_KEY;

  Future<TagNewsActivityResponse> fetchTagNewsActivity() async {
    final response = await _provider.get("/tags", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return TagNewsActivityResponse.fromJson(response);
  }
}
