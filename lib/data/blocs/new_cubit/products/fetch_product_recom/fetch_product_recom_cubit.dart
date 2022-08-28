import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_product_recom_state.dart';

class FetchProductRecomCubit extends Cubit<FetchProductRecomState> {
  FetchProductRecomCubit()
      : super(FetchProductRecomInitial());

  final ProductsRepository _productsRepository = ProductsRepository();

  Future<void> fetchProductRecom() async {
    emit(FetchProductRecomLoading());
    try {
      final response =
      await _productsRepository.fetchProductRecom();

      emit(FetchProductRecomSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductRecomFailure.network(error.toString()));
        return;
      }
      emit(FetchProductRecomFailure.general(error.toString()));
    }
  }
}
