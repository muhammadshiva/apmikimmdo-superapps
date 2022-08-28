import 'dart:io';

import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/home_category.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class CategoryRepository {
  final ApiProvider _provider = ApiProvider();
  final String _adsKey = AppConst.API_ADS_KEY;

  Future<HomeCategoryResponse> fetchHomeCategory() async {
    final response = await _provider.get(
      "/home/categories",
      headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
        'ADS-Key': _adsKey
      },
    );
    return HomeCategoryResponse.fromJson(response);
  }

  Future<CategoryResponse> fetchCategory() async {
    final response = await _provider.get(
      "/category/all",
      headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
        'ADS-Key': _adsKey
      },
    );
    return CategoryResponse.fromJson(response);
  }

  Future<CategoryResponse> fetchCategoryMitra() async {
    final response = await _provider.get(
      "/category/mitra",
      headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
        'ADS-Key': _adsKey
      },
    );
    return CategoryResponse.fromJson(response);
  }

  Future<SubcategoryResponse> fetchSubcategory(int categoryId) async {
    var requestUrl = '/category/subcategory/$categoryId';
    final response = await _provider.get(
      requestUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
        'ADS-Key': _adsKey
      },
    );
    return SubcategoryResponse.fromJson(response);
  }

  Future<CategoryResponse> fetchProductCategoryRecom() async {
    final response = await _provider.get(
      "/app/config/home",
      headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
        'ADS-Key': _adsKey
      },
    );
    return CategoryResponse.fromJson(response);
  }
}
