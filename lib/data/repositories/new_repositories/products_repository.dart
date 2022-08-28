import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:dio/dio.dart';

class ProductsRepository {
  final ApiProvider _provider = ApiProvider();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final RecipentRepository _recipentRepo = RecipentRepository();
  final String _adsKey = AppConst.API_ADS_KEY;
  Dio dio = new Dio();

  Future<SearchResponse> search({@required String keyword}) async {
    var requestUrl = '/home/search?keyword=' + keyword;
    final response = await _provider.get(requestUrl, headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return SearchResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> fetchProductsBestSell() async {
    int getSubdistrictId = await _recipentRepo.getMainAddressSubdistrictId();
    int getSubdistrictIdStorage =
        _recipentRepo.getSelectedSubdistrictIdStorage();
    final int subdistrictId =
        getSubdistrictId == 0 ? getSubdistrictIdStorage ?? 0 : getSubdistrictId;

    final response = await _provider
        .get('/product/subdistrict/sold/$subdistrictId', headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> fetchProductsFlashSale() async {
    int getSubdistrictId = await _recipentRepo.getMainAddressSubdistrictId();
    int getSubdistrictIdStorage =
        _recipentRepo.getSelectedSubdistrictIdStorage();
    final int subdistrictId =
        getSubdistrictId == 0 ? getSubdistrictIdStorage ?? 0 : getSubdistrictId;

    final response = await _provider.get(
        '/product/subdistrict/flash/flash_subdistrict?subdistrict_id=$subdistrictId',
        headers: {
          HttpHeaders.contentTypeHeader: 'text/plain',
          'ADS-Key': _adsKey
        });
    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> fetchProductsPromo() async {
    int getSubdistrictId = await _recipentRepo.getMainAddressSubdistrictId();
    int getSubdistrictIdStorage =
        _recipentRepo.getSelectedSubdistrictIdStorage();
    final int subdistrictId =
        getSubdistrictId == 0 ? getSubdistrictIdStorage ?? 0 : getSubdistrictId;

    final response = await _provider
        .get('/product/subdistrict/disc/$subdistrictId', headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> fetchProductsBumdes() async {
    int getSubdistrictId = await _recipentRepo.getMainAddressSubdistrictId();
    int getSubdistrictIdStorage =
        _recipentRepo.getSelectedSubdistrictIdStorage();

    final int subdistrictId =
        getSubdistrictId == 0 ? getSubdistrictIdStorage ?? 0 : getSubdistrictId;

    final response = await _provider
        .get('/product/subdistrict/category/$subdistrictId/72', headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> fetchReadyToEat() async {
    int getSubdistrictId = await _recipentRepo.getMainAddressSubdistrictId();
    int getSubdistrictIdStorage =
        _recipentRepo.getSelectedSubdistrictIdStorage();
    final int subdistrictId =
        getSubdistrictId == 0 ? getSubdistrictIdStorage ?? 0 : getSubdistrictId;

    final response = await _provider
        .get('/product/subdistrict/category/$subdistrictId/3', headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductDetailResponse> fetchProductDetail(
      {@required int productId}) async {
    final response = await _provider.get("/product/show/$productId", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return ProductDetailResponse.fromJson(response);
  }

  Future<ProductDetailResponse> fetchProductDetailVariant(
      {@required String slugProduct, @required String slugVariant}) async {
    final response = await _provider
        .get("/product/variant/$slugProduct/$slugVariant", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return ProductDetailResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> fetchProductsByCategory(
      {@required int categoryId}) async {
    int getSubdistrictId = await _recipentRepo.getMainAddressSubdistrictId();
    int getSubdistrictIdStorage =
        _recipentRepo.getSelectedSubdistrictIdStorage();
    final int subdistrictId =
        getSubdistrictId == 0 ? getSubdistrictIdStorage ?? 0 : getSubdistrictId;

    final response = await _provider.get(
        "/product/subdistrict/category/$subdistrictId/$categoryId",
        headers: {
          HttpHeaders.contentTypeHeader: 'text/plain',
          'ADS-Key': _adsKey
        });
    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> fetchProductsByAllCategory() async {
    int getSubdistrictId = await _recipentRepo.getMainAddressSubdistrictId();
    int getSubdistrictIdStorage =
        _recipentRepo.getSelectedSubdistrictIdStorage();
    final int subdistrictId =
        getSubdistrictId == 0 ? getSubdistrictIdStorage ?? 0 : getSubdistrictId;

    final response = await _provider
        .get("/product/all?subdistrict_id=$subdistrictId", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key': _adsKey
    });
    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> fetchProductRecom() async {
    Map<String, dynamic> getSubdistrictId = _recipentRepo.getSelectedRecipent();

    final int subdistrictId =
        getSubdistrictId == null ? 502 : getSubdistrictId['subdistrict_id'];

    final response = await _provider.get('/product/subdistrict/suggestions',
        headers: {
          HttpHeaders.contentTypeHeader: 'text/plain',
          'ADS-Key': _adsKey
        });
    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductsGeneralResponse> filterProduct(
      {String sortByLowestPrice,
      String sortByHighestPrice,
      String sortByReview,
      String sortByLatest,
      String lowestPrice,
      String highestPrice,
      String cityId}) async {
    final response = await _provider.get(
        '/home/search?sortby_lowest_price=$sortByLowestPrice&sortby_highest_price=$sortByHighestPrice&sortby_review=$sortByReview&latest=$sortByLatest&lowest_price=$lowestPrice&highest_price=$highestPrice&city=$cityId',
        headers: {
          HttpHeaders.contentTypeHeader: 'text/plain',
          'ADS-Key': _adsKey
        });

    return ProductsGeneralResponse.fromJson(response);
  }

  Future<ProductsCoverageValidationResponse> productCoverageValidation({
    @required int productId,
    @required int subdistrictId,
  }) async {
    var formData = new FormData.fromMap({
      "product_id": productId,
      "subdistrict_id": subdistrictId,
    });

    debugPrint("formdata ${formData.fields}");

    var response = await dio.post(
      "${AppConst.API_URL}/product-coverage-validation",
      data: formData,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'ADS-Key': _adsKey
      }, validateStatus: (status) => true),
    );

    // debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      debugPrint("success update stock");
      return ProductsCoverageValidationResponse.fromJson(response.data);
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }

  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================
  // ====================================================================================================================================

  Future<ProductsGeneralResponse> fetchProductsSpecialOffer(
      {FetchProductsType type}) async {
    final Map<String, String> queryParams = {
      'recipent_id': ""
      // _recipentId != null ? "$_recipentId" : null,
    };

    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl =
        '/product/${type == FetchProductsType.promo ? "promo" : type == FetchProductsType.bestSell ? "bestsell" : ""}/all?' +
            queryString;

    final response = await _provider.get(requestUrl, headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
    });
    return ProductsGeneralResponse.fromJson(response);
  }
}
