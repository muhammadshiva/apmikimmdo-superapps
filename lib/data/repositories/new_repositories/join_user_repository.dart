import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/general.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:meta/meta.dart';

import '../authentication_repository.dart';

class JoinUserRepository {
  final ApiProvider _provider = ApiProvider();
  final AuthenticationRepository _authenticationRepository =
  AuthenticationRepository();
  final String _baseUrl = AppConst.API_URL;
  final String _adsKey = AppConst.API_ADS_KEY;
  final Dio dio = new Dio();
  final gs = GetStorage();

  Future<GeneralResponse> createShop({
    @required UserType userType,
    String shopName,
    bool isAlsoRegisterAsSeller,
    @required String addressSeller,
    @required int subDistrictId,
  }) async {
    final _token = await _authenticationRepository.getToken();

    Dio dio = new Dio();
    final roleId = userType == UserType.supplier ? 4 : 5;

    FormData formDataGeneral;

    if (roleId == 4) {
      //SUPPLIER
      if (isAlsoRegisterAsSeller) {
        debugPrint("register supplier with reseller");
        formDataGeneral = new FormData.fromMap({
          "shop_name": shopName,
          "address": addressSeller,
          "subdistrict_id": subDistrictId,
          "register_reseller": 1
        });
      } else {
        debugPrint("register only supplier");
        formDataGeneral = new FormData.fromMap({
          "address": addressSeller,
          "subdistrict_id": subDistrictId,
          "register_reseller": 0
        });
      }
    } else {
      debugPrint("register reseller");
      formDataGeneral = new FormData.fromMap({
        "shop_name": shopName,
        "address": addressSeller,
        "subdistrict_id": subDistrictId,
      });
    }

    debugPrint("url $_baseUrl/user/registration/${roleId.toString()}");
    var response = await dio.post(
      "$_baseUrl/user/registration/${roleId.toString()}",
      data: formDataGeneral,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          HttpHeaders.contentTypeHeader: 'application/json',
          'ADS-Key':_adsKey
        },
      ),
    );
    debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      final statusCode = response.data['status'];
      final message = response.data['message'] ?? 'Terjadi Kesalahan';
      // final String firstCode = statusCode[0];

      /*if (firstCode != "2") {
        switch (firstCode) {
          case "4":
            throw ClientException(message);
          case "5":
            throw ServerException(message);
          default:
            throw GeneralException(message);
        }
      }*/
      return GeneralResponse.fromJson(response.data);
    } else {
      throw GeneralException(response.data.toString());
    }
  }

  //=========================== Supplier ===========================

  Future<void> updateProfileSupplier(
      {@required String name,
        @required String phoneNumber,
        @required String logo,
        @required String subdistrictId,
        @required String address}) async {
    final token = await _authenticationRepository.getToken();
    var formData = new FormData.fromMap({
      "name": name,
      "phonenumber": phoneNumber,
      "logo": logo != null
          ? await MultipartFile.fromFile(logo, filename: "logo")
          : null,
      "subdistrict_id": subdistrictId,
      "address": address,
    });

    debugPrint("formdata ${formData.fields}");

    var response = await dio.post(
      "${AppConst.API_URL}/supplier/update-profile",
      data: formData,
      options: Options(headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'ADS-Key':_adsKey
      }, validateStatus: (status) => true),
    );

    // debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      debugPrint("success update supplier");
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }

  Future<GeneralResponse> addProductSupplier(
      {@required String name,
        @required int categoryId,
        @required int weight,
        @required String unit,
        @required int price,
        @required int stock,
        @required String description,
        @required int commision,
        @required String link,
        @required List<String> productPhoto,
        @required List<Uint8List> productPhotoByte,
        @required List<int> hargaGrosir,
        @required List<int> minimumOrder,
        @required List<String> varianType,
        @required List<String> varianName,
        @required List<int> varianPrice,
        @required List<int> varianStock}) async {
    final _token = await _authenticationRepository.getToken();

    Dio dio = new Dio();
    List uploadPhoto = [];
    List uploadPhotoByte = [];

    for (var file in productPhoto) {
      var multipartFile =
      await MultipartFile.fromFile(file, filename: "product");
      uploadPhoto.add(multipartFile);
    }

    for (var file in productPhotoByte) {
      final byte = file.cast<int>();
      var multipartFile = MultipartFile.fromBytes(byte, filename: "product");
      uploadPhotoByte.add(multipartFile);
    }
    debugPrint("tes");

    FormData formDataGeneral;
    formDataGeneral = new FormData.fromMap({
      "name": name,
      "category_id": categoryId,
      "weight": weight,
      "unit": unit,
      "price": price,
      "stock": stock,
      "description": description,
      "link": link,
      "commission": commision,
      "product_photo": kIsWeb ? uploadPhotoByte : uploadPhoto,
      "grocery_price": hargaGrosir,
      "minimum_order": minimumOrder,
      "variant_type": varianType,
      "variant_name": varianName,
      "variant_stock": varianStock,
      "variant_price": varianPrice,
    });

    debugPrint("formdata ${formDataGeneral.fields}");
    debugPrint("formdata ${formDataGeneral.files}");

    debugPrint("url $_baseUrl/supplier/product-submissions/store");
    var response = await dio.post(
      "$_baseUrl/supplier/product-submissions/store",
      data: formDataGeneral,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          HttpHeaders.contentTypeHeader: 'application/json',
          'ADS-Key':_adsKey
        },
      ),
    );
    debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      // final String firstCode = statusCode[0];

      return GeneralResponse.fromJson(response.data);
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }

  Future<GeneralResponse> updateProductSupplier(
      {@required int productId,
        @required String name,
        @required int categoryId,
        @required int weight,
        @required String unit,
        @required int price,
        @required int stock,
        @required String description,
        @required int commision,
        @required String link,
        @required List<String> productPhoto,
        @required List<Uint8List> productPhotoByte,
        @required List<int> hargaGrosir,
        @required List<int> minimumOrder,
        @required List<String> varianType,
        @required List<String> varianName,
        @required List<int> varianPrice,
        @required List<int> varianStock}) async {
    final _token = await _authenticationRepository.getToken();

    Dio dio = new Dio();
    List uploadPhoto = [];
    List uploadPhotoByte = [];

    // for (var i = 0; i < productPhoto.length; i++) {
    //   if (productPhoto[i].contains("http")) continue;
    //   var multipartFile =
    //       await MultipartFile.fromFile(productPhoto[i], filename: "product_photo");
    //   uploadPhoto.add(multipartFile);

    //   final byte = productPhotoByte[i].cast<int>();
    //   multipartFile = MultipartFile.fromBytes(byte, filename: "product_photo");
    //   uploadPhotoByte.add(multipartFile);
    // }


    for (var file in productPhoto) {
      var multipartFile = await MultipartFile.fromFile(
          file, filename: "product"
      );
      uploadPhoto.add(multipartFile);
    }

    /*for (var file in productPhotoByte) {
      final byte = file.cast<int>();
      var multipartFile = MultipartFile.fromBytes(
          byte, filename: "product"
      );
      uploadPhotoByte.add(multipartFile);
    }*/

    FormData formDataGeneral;
    formDataGeneral = new FormData.fromMap({
      "name": name,
      "category_id": categoryId,
      "weight": weight,
      "unit": unit,
      "price": price,
      "stock": stock,
      "description": description,
      "link": link,
      "commission": commision,
      // "product_photo":uploadPhoto,
      "grocery_price": hargaGrosir,
      "minimum_order": minimumOrder,
      "variant_type": varianType,
      "variant_name": varianName,
      "variant_stock": varianStock,
      "variant_price": varianPrice,
    });

    debugPrint("formdata ${formDataGeneral.fields}");
    debugPrint("formdata ${formDataGeneral.files}");

    debugPrint("url $_baseUrl/supplier/products/$productId/update");
    var response = await dio.post(
      "$_baseUrl/supplier/products/$productId/update",
      data: formDataGeneral,
      options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $_token',
            HttpHeaders.contentTypeHeader: 'application/json',
            'ADS-Key':_adsKey
          },
          validateStatus: (status) => true
      ),
    );
    debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      final statusCode = response.data['status'];
      final message = response.data['message'] ?? 'Terjadi Kesalahan';
      // final String firstCode = statusCode[0];

      return GeneralResponse.fromJson(response.data);
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }

  Future<SupplierDataResponse> getSupplierProductList({
    String keyword
  }) async {
    final _token = await _authenticationRepository.getToken();
    final response =
    await _provider.get("/supplier/product-submissions", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key':_adsKey
    });
    List<dynamic> dataList = response['data'];
    List<dynamic> filteredData = [];
    if (keyword != null) {
      filteredData = dataList
          .where((res) => res['product_name'].contains(keyword))
          .where((e) =>
      e['product_status'] == 'Menunggu Verifikasi' ||
          e['product_status'] == 'Ditolak')
          .toList();
    }else{
      filteredData = dataList
          .where((e) =>
      e['product_status'] == 'Menunggu Verifikasi' ||
          e['product_status'] == 'Ditolak')
          .toList();
    }
    Map<String, dynamic> dataResult = {"data": filteredData};

    return SupplierDataResponse.fromJson(dataResult);
  }

  Future<SupplierDataResponse> getSupplierProductApprovedList(
      {String keyword}) async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider.get("/supplier/products", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key':_adsKey
    });
    List<dynamic> dataList = response['data'];
    Map<String, dynamic> mappingResult = {};
    if (keyword != null) {
      final filteredData =
      dataList.where((data) => data["product_name"].contains(keyword)).toList();
      mappingResult = {"data": filteredData};
      return SupplierDataResponse.fromJson(mappingResult);
    } else {
      return SupplierDataResponse.fromJson(response);
    }
  }

  Future<void> deleteSupplierProductList(int id) async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider
        .delete("/supplier/product-submissions/destroy/$id", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key':_adsKey
    });
  }

  Future<void> deleteSupplierProductApprovedList(int id) async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider
        .delete("/supplier/products/$id/destroy/", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key':_adsKey
    });
  }

  Future<void> editStock({@required int id, @required int stock}) async {
    final token = await _authenticationRepository.getToken();
    var formData = new FormData.fromMap({
      "stock": stock,
    });

    debugPrint("formdata ${formData.fields}");

    var response = await dio.post(
      "${AppConst.API_URL}/supplier/products/$id/update-stock",
      data: formData,
      options: Options(headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'ADS-Key':_adsKey
      }, validateStatus: (status) => true),
    );

    // debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      debugPrint("success update stock");
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }

  //=========================== WARUNG PANEN / RESELLER ===========================

  Future<GeneralResponse> addProduct({@required int productId}) async {
    final _token = await _authenticationRepository.getToken();
    Map<String, dynamic> body = {
      'product_id': productId,
    };
    final response = await _provider
        .post("/reseller/products/store", body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key':_adsKey
    });

    return GeneralResponse.fromJson(response);
  }

  Future<TokoSayaDataResponse> getProductList() async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider.get("/reseller/products", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key':_adsKey
    });

    return TokoSayaDataResponse.fromJson(response);
  }

  Future<GeneralResponse> removeProduct({@required int productId}) async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider
        .delete("/reseller/products/$productId/destroy", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key':_adsKey
    });

    return GeneralResponse.fromJson(response);
  }

  Future<TokoSayaCustomersResponse> getCustomersList() async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider.get("/reseller/customer-list", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key':_adsKey
    });

    return TokoSayaCustomersResponse.fromJson(response);
  }

  Future<ResellerShopProductDataResponse> getProductListResellerShop(
      {@required String nameSlugReseller,@required int subdistrictId}) async {
    final response =
        await _provider.get("/product/reseller/$nameSlugReseller?subdistrict_id=$subdistrictId", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key':_adsKey
    });

    return ResellerShopProductDataResponse.fromJson(response);
  }

  Future<ProductDetailResponse> fetchProductWarungDetail(
      {@required String slugWarung,@required String slugProduct}) async {
    final response = await _provider.get("/$slugWarung/products/$slugProduct", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key':_adsKey
    });
    return ProductDetailResponse.fromJson(response);
  }

  Future<ResellerShopProductDataResponse> getProductListBySubdistrict(
      {@required int subdistrictId}) async {
    final response =
        await _provider.get("/product/subdistrict/$subdistrictId", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key':_adsKey
    });

    return ResellerShopProductDataResponse.fromJson(response);
  }

  Future<ResellerShopDataResponse> getDataResellerShop(
      {@required String nameSlugReseller}) async {
    final response =
        await _provider.get("/reseller/profile/$nameSlugReseller", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key':_adsKey
    });

    return ResellerShopDataResponse.fromJson(response);
  }

  Future<void> updateProfileShop(
      {
        @required String name,
        @required String phoneNumber,
        @required String logo,
        @required String subdistrictId,
        @required String address
      }) async {
    
    final token = await _authenticationRepository.getToken();
    var formData = 
    new FormData.fromMap({
      "name": name,
      "phonenumber": phoneNumber,
      "logo": logo != null ? await MultipartFile.fromFile(
          logo, filename: "logo"
      ) : null,
      "subdistrict_id": subdistrictId,
      "address": address,
    });

    debugPrint("formdata ${formData.fields}");

   var response = await dio.post(
      "${AppConst.API_URL}/reseller/update-profile",
      data: formData,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
          'ADS-Key':_adsKey
        },
        validateStatus: (status) => true
      ),
    );

    // debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      debugPrint("success update shop");
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }


  Future<ListWarungDataResponse> getListWarungBySubdistrict(
      {@required int subdistrictId,@required String keyword}) async {
    final response =
        await _provider.get("/reseller/subdistrict/$subdistrictId", headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      'ADS-Key':_adsKey
    });

    List<dynamic> dataList = response['data'];
    Map<String, dynamic> mappingResult = {};
    if (keyword != null) {
      final filteredData =
      dataList.where((data) => data["name"].toLowerCase().contains(keyword)).toList();
      mappingResult = {"data": filteredData};
      return ListWarungDataResponse.fromJson(mappingResult);
    } else {
      return ListWarungDataResponse.fromJson(response);
    }
  }


  void setSlugReseller({
    @required String slug,
  }) {
    gs.write("slugReseller", slug);
  }

  String getSlugReseller() {
   return gs.read('slugReseller');
  }

}