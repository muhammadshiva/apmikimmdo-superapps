
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:marketplace/api/api_provider.dart';
import 'package:marketplace/data/models/new_models/search_kecamatan.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class KecamatanRepository {
  final ApiProvider _provider = ApiProvider();
  final String _baseUrl = AppConst.API_URL;
  final String _adsKey = AppConst.API_ADS_KEY;

  Future<SearchKecamatan> fetchKecamatan({String keyword}) async {
    Dio dio = new Dio();

    final formSearch = new FormData.fromMap({
      "keyword": keyword,
    });
    /*Map<String, String> queryParams = {
      'keyword': '$keyword',
    };*/
    // String queryString = Uri(queryParameters: queryParams).query;
    // var requestUrl = '/ocations/search/subdistrict';
    var response = await dio.post(
      "$_baseUrl/locations/search/subdistrict",
      data: formSearch,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'ADS-Key':_adsKey
        },
      ),
    );
    /*final response = await _provider.get(
      requestUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
      },
    );*/
    return SearchKecamatan.fromJson(response.data);
  }
}