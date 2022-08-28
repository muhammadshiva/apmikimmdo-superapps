import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

part 'fetch_cart_state.dart';

class FetchCartCubit extends Cubit<FetchCartState> {
  FetchCartCubit() : super(FetchCartInitial());

  final CartRepository _cartRepository = CartRepository();

  void reset() =>
      emit(FetchCartInitial());

  Future<void> load() async {
    emit(FetchCartLoading());
    await fetchCart();
  }

  Future<void> reload() async {
    await fetchCart();
  }

  Future<void> fetchCart() async {
    FetchCartLoading();
    try {
      final response = await _cartRepository.fetchCart();
      emit(FetchCartSuccess(cart: response.data.covered, uncovered: response.data.uncovered));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchCartFailure.network(error.toString()));
        return;
      }
      emit(FetchCartFailure.general(error.toString()));
    }
  }

  Future<void> fetchCartWithCityId({int cityId}) async {
    FetchCartLoading();
    try {
      final response = await _cartRepository.fetchCart(param: "?city_id=$cityId");
      emit(FetchCartSuccess(cart: response.data.covered, uncovered: response.data.uncovered));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchCartFailure.network(error.toString()));
        return;
      }
      emit(FetchCartFailure.general(error.toString()));
    }
  }

  void fetchCartOffline(List<CartResponseElement> data){
    emit(FetchCartInitial());
    emit(FetchCartLoading());
    try {
      debugPrint("fetch offline cubit $data");
      emit(FetchCartSuccess(cart: List<CartResponseElement>.from(data)));

      debugPrint("state offline ${state}");
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchCartFailure.network(error.toString()));
        return;
      }
      emit(FetchCartFailure.general(error.toString()));
    }
  }
}
