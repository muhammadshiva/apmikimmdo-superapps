import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

const String tokenKey = 'token';

class AuthenticationRepository {
  final ApiProvider _provider = ApiProvider();
  final String _adsKey = AppConst.API_ADS_KEY;

  /// Fetch sign in response from api
  Future<SignInResponse> authenticate({
    @required String phoneNumber,
  }) async {
    SignInRequest body = SignInRequest(phoneNumber: phoneNumber);
    final response = await _provider
        .post("/login", body: jsonEncode(body.toJson()), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key':_adsKey
    });
    return SignInResponse.fromJson(response);
  }

  Future<SignInResponse> direct({
    @required String phoneNumber,
  }) async {
    SignInRequest body = SignInRequest(
      phoneNumber: phoneNumber,
      isUsingWa: false,
    );
    final response = await _provider
        .post("/get-token-debug", body: jsonEncode(body.toJson()), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key':_adsKey
    });
    return SignInResponse.fromJson(response);
  }

  Future<SignInResponse> otpVerification({
    @required String phoneNumber,
    @required String token,
  }) async {
    Map<String, dynamic> body = {
      'phonenumber': phoneNumber,
      'token': token,
    };
    final response =
        await _provider.post("/input-token", body: jsonEncode(body), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key':_adsKey
    });
    return SignInResponse.fromJson(response);
  }

  /// Delete available token
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
    return;
  }

  /// Write to keystore/keychain
  Future<void> persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
    return;
  }

  /// Read and check if token exists
  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) == null ? false : true;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }
}
