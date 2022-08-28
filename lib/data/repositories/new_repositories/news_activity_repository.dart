import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/data/models/new_models/search_news_activity.dart';
import 'package:marketplace/data/models/new_models/tag_news_activity.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class NewsActivityRepository {
  final ApiProvider _provider = ApiProvider();
  final String _adsKey = AppConst.API_ADS_KEY;

  Future<NewsActivityResponse> fetchNewsActivity() async {
    final response = await _provider.get("/posts", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return NewsActivityResponse.fromJson(response);
  }

  Future<SearchNewsActivityResponse> search({@required String keyword}) async {
    var requestUrl = '/posts?keyword=' + keyword;
    final response = await _provider.get(requestUrl, headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return SearchNewsActivityResponse.fromJson(response);
  }

  Future<NewsActivityResponse> fetchNewsActivityByTag(
      {@required int tagId}) async {
    final response = await _provider.get("/posts?tag=$tagId", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });

    return NewsActivityResponse.fromJson(response);
  }
}
