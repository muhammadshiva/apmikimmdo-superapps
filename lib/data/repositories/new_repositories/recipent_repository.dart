import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class RecipentRepository {
  final ApiProvider _provider = ApiProvider();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final String _baseUrl = AppConst.API_URL;
  final String _adsKey = AppConst.API_ADS_KEY;
  final gs = GetStorage();

  final Map<String, dynamic> tempRecipent = {
    //Untuk mengisi saat data address null
    // "is_main_address": 0,
    "name": "-",
    "phonenumber": null,
    "email": "-",
    "address": "-",
    "subdistrict_id": 502,
    "city_id": null,
    "subdistrict": "",
    "postal_code": "",
    "note": "-"
  };

  Future<RecipentResponse> getRecipents() async {
    final token = await _authenticationRepository.getToken();
    final response = await _provider.get('/user/recipient', headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'ADS-Key': _adsKey
    });
    if (response['data'].length == 0) {
      debugPrint("MASUKK KOSONG");
      gs.write('recipentSelected', tempRecipent);
      // setSubdistrictStorage(subdistrict:"haha",subdistrictId: 0);
    }else{
      gs.remove('selectedSubdistrictStorage');
    }
     
    return RecipentResponse.fromJson(response);
  }

  Future<RecipentObjectResponse> getMainAddress() async {
    final token = await _authenticationRepository.getToken();
    if (token != null) {
      final response = await _provider.get('/user/recipient/main', headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'ADS-Key': _adsKey
      });
      if (response["data"] != null) {
        setRecipent(
            id: response['data']['id'],
            isMainAddress: response['data']['is_main_address'],
            name: response['data']['name'],
            phone: response['data']['phonenumber'],
            email: response['data']['email'],
            address: response['address'],
            subdistrictId: response['data']['subdistrict_id'],
            subdistrict: response['data']['subdistrict'],
            postalCode: response['data']['postal_code'],
            note: response['data']['note']);
           
        //  setSubdistrictStorage(subdistrict:response['data']['subdistrict'],subdistrictId: response['data']['subdistrict_id']);
        return RecipentObjectResponse.fromJson(response);
      } else {
        // setSubdistrictStorage(subdistrict:"",subdistrictId: 0);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<int> getMainAddressSubdistrictId() async {
    final token = await _authenticationRepository.getToken();
    if (token != null) {
      final response = await _provider.get('/user/recipient/main', headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'ADS-Key': _adsKey
      });
      if (response['data'] != null) {
        //  setSubdistrictStorage(subdistrict:response['data']['subdistrict'],subdistrictId: response['data']['subdistrict_id']);
        return response['data']['subdistrict_id'];
      } else {
       
        return 0;
      }
    } else {
      return 0;
    }
  }

  Future<void> getMainAddressFilter() async {
    final token = await _authenticationRepository.getToken();
    final response = await _provider.get('/user/recipient', headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'ADS-Key': _adsKey
    });

    Recipent recipent;

    for (int i = 0; i < response['data'].length; i++) {
      if (response['data'][i]['is_main_address'] == 1) {
        setRecipent(
            id: response['data'][i]['id'],
            isMainAddress: response['data'][i]['is_main_address'],
            name: response['data'][i]['name'],
            phone: response['data'][i]['phonenumber'],
            email: response['data'][i]['email'],
            address: response['data'][i]['address'],
            subdistrictId: response['data'][i]['subdistrict_id'],
            subdistrict: response['data'][i]['subdistrict'],
            postalCode: response['data'][i]['postal_code'],
            note: response['data'][i]['note']);
      }
    }
  }

  Future<RecipentObjectResponse> addRecipent({
    @required String name,
    @required int phone,
    @required String address,
    @required String email,
    @required int subdistrictId,
    @required int postalCode,
    @required String note,
  }) async {
    final token = await _authenticationRepository.getToken();
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      "name": name,
      "phonenumber": phone,
      "address": address,
      "email": email,
      "subdistrict_id": subdistrictId,
      "postal_code": postalCode,
      "note": note,
      "is_main_address": 1
    });

    var response = await dio.post(
      "$_baseUrl/user/recipient",
      data: formData,
      options: Options(
        // validateStatus: (status) => true,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'text/plain',
          "ADS-Key": _adsKey
        },
      ),
    );

    if (response.statusCode == 200) {
      debugPrint("SUKSESSS");
      return RecipentObjectResponse.fromJson(response.data);
    } else {
      throw GeneralException(response.data.toString());
    }
  }

  Future<RecipentObjectResponse> updateAddressRecipent({
    @required int recipentId,
    @required String name,
    @required int phone,
    @required String address,
    @required String email,
    @required int subdistrictId,
    @required int postalCode,
    @required String note,
    @required int isMainAddress,
  }) async {
    final token = await _authenticationRepository.getToken();
    final Map<String, dynamic> body = {
      "name": name,
      "phonenumber": phone.toString(),
      "email": email,
      "subdistrict_id": subdistrictId.toString(),
      "postal_code": postalCode.toString(),
      "address": address,
      "note": note,
      "is_main_address": isMainAddress
    };

    final response = await _provider.put(
      "/user/recipient/$recipentId",
      body: jsonEncode(body),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'ADS-Key': _adsKey
      },
    );
    return RecipentObjectResponse.fromJson(response);
  }

  Future<GeneralResponse> deleteRecipent({
    @required int recipentId,
  }) async {
    final token = await _authenticationRepository.getToken();
    final response =
        await _provider.delete("/user/recipient/$recipentId", headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'text/plain',
      "ADS-Key": _adsKey
    });
    gs.write('recipentSelected', tempRecipent);
    return GeneralResponse.fromJson(response);
  }

  Future<RecipentObjectResponse> updateMainAddress({
    @required int recipentId,
  }) async {
    final token = await _authenticationRepository.getToken();
    Map<String, dynamic> body = {
      "is_main_address": 1,
    };
    final response = await _provider
        .put("/user/recipient/$recipentId", body: jsonEncode(body), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key': _adsKey
    });
    // debugPrint("TEST : ${response['data']['subdistrict']}");
    setRecipent(
        id: response['data']['id'],
        isMainAddress: response['data']['is_main_address'],
        name: response['data']['name'],
        phone: response['data']['phonenumber'],
        email: response['data']['email'],
        address: response['data']['address'],
        subdistrictId: response['data']['subdistrict_id'],
        subdistrict: response['data']['subdistrict'],
        postalCode: response['data']['postal_code'],
        note: response['data']['note']);
        // setSubdistrictStorage(subdistrict:response['data']['subdistrict'] ,subdistrictId: response['data']['subdistrict_id']);
    return RecipentObjectResponse.fromJson(response);
  }

  // int getSubdistrictId() {
  //   final recipentSelected = gs.read('recipentSelected');
  //   RecipentLocation recipentLocation = recipentSelected['subdistrict'];
  //   return recipentLocation.subdistrictId;
  // }

  //==================================== Get Storage ====================================
  Map<String, dynamic> getSelectedRecipent() {
    return gs.read('recipentSelected') ?? null;
  }

 Map<String, dynamic> getSelectedSubdistrictStorage() {
    return gs.read('selectedSubdistrictStorage') ?? null;
  }

  int getSelectedSubdistrictIdStorage() {
    return getSelectedSubdistrictStorage() != null ? getSelectedSubdistrictStorage()['subdistrict_id'] : 0 ?? 0 ;
  }

  Map<String, dynamic> getSelectedRecipentNoAuth() {
    return gs.read('recipentUserNoAuth') ?? null;
  }

  Map<String, dynamic> getSelectedRecipentNoAuthDashboard() {
    return gs.read('recipentUserNoAuthDashboard') ?? null;
  }

  Map<String, dynamic> getSelectedRecipentNoAuthDetailProduct() {
    return gs.read('recipentUserNoAuthDetailProduct') ?? null;
  }

  bool getFromWppDashboardCheck() {
    return gs.read('isFromWppDashboard') ?? false;
  }

  bool getFromWppDetailProductCheck() {
    return gs.read('isFromWppDetailProduct') ?? false;
  }

  void destroyGsRecipent() {
    gs.remove('recipentSelected');
    gs.remove('recipentIdSelected');
  }

  void setSubdistrictStorage({
    @required int subdistrictId,
     @required String subdistrict,
  }) {
    gs.write('selectedSubdistrictStorage', {
      "subdistrict": subdistrict,
      "subdistrict_id": subdistrictId,});
  }

  void setRecipent({
    int id = 0,
    int isMainAddress = 0,
    String name,
    String phone,
    String email,
    String address = "",
    @required int subdistrictId,
    @required String subdistrict,
    String postalCode = "",
    String note = "",
  }) {
    gs.write("recipentSelected", {
      "id": id,
      "is_main_address": isMainAddress,
      "name": name,
      "phonenumber": phone,
      "email": email,
      "address": address,
      "subdistrict_id": subdistrictId,
      "subdistrict": subdistrict == null ? "" : subdistrict,
      "postal_code": postalCode,
      "note": note
    });
  }

  void setRecipentUserNoAuth({
    @required int subdistrictId,
    @required String subdistrict,
    String name,
    String city,
    String address,
    String province,
    String phone,
  }) {
    gs.write("recipentUserNoAuth", {
      "name": name,
      "subdistrict_id": subdistrictId,
      "subdistrict": subdistrict,
      "city": city,
      "province": province,
      "address": address,
      "phonenumber": phone,
    });
  }

  void setRecipentUserNoAuthDashboard({
    @required int subdistrictId,
    @required String subdistrict,
    String name,
    String city,
    String address,
    String province,
    String phone,
  }) {
    gs.write("recipentUserNoAuthDashboard", {
      "name": name,
      "subdistrict_id": subdistrictId,
      "subdistrict": subdistrict,
      "city": city,
      "province": province,
      "address": address,
      "phonenumber": phone,
    });
  }

  void setRecipentUserNoAuthDetailProduct({
    @required int subdistrictId,
    @required String subdistrict,
    String name,
    String city,
    String address,
    String province,
    String phone,
  }) {
    gs.write("recipentUserNoAuthDetailProduct", {
      "name": name,
      "subdistrict_id": subdistrictId,
      "subdistrict": subdistrict,
      "city": city,
      "province": province,
      "address": address,
      "phonenumber": phone,
    });
  }

  void isFromWppDashboard({
    @required bool value,
  }) {
    gs.write("isFromWppDashboard", value);
  }

  void isFromWppDetailProductDetail({
    @required bool value,
  }) {
    gs.write("isFromWppDetailProduct", value);
  }

  // void setRecipentId({@required int recipentId}) {
  //   gs.write("recipentIdSelected", recipentId);
  // }

}
