import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_best_product_by_category_state.dart';

class FetchBestProductByCategoryCubit extends Cubit<FetchBestProductByCategoryState> {
  FetchBestProductByCategoryCubit() : super(FetchBestProductByCategoryInitial());

   final ProductsRepository _productsRepository = ProductsRepository();
   
  Future<void> fetchBestProductByCategory({@required int categoryId}) async {
    emit(FetchBestProductByCategoryLoading());
    try {
      final response = await _productsRepository.fetchProductsByCategory(
          categoryId: categoryId);
      emit(FetchBestProductByCategorySuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchBestProductByCategoryFailure.network(error.toString()));
        return;
      }
      emit(FetchBestProductByCategoryFailure.general(error.toString()));
    }
  }

  
}
