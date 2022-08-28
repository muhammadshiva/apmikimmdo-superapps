import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/products.dart';
import 'package:marketplace/data/repositories/new_repositories/products_repository.dart';

part 'fetch_products_by_category_state.dart';

class FetchProductsByCategoryCubit extends Cubit<FetchProductsByCategoryState> {
  FetchProductsByCategoryCubit()
      : super(FetchProductsByCategoryInitial());

  final ProductsRepository _productsRepository = ProductsRepository();

  Future<void> fetchProductsByCategory({@required int categoryId}) async {
    emit(FetchProductsByCategoryLoading());
    try {
      if (categoryId != 0) {
          final response = await _productsRepository.fetchProductsByCategory(
            categoryId: categoryId);
        emit(FetchProductsByCategorySuccess(response.data));
      }else{
        final response = await _productsRepository.fetchProductsByAllCategory();
        emit(FetchProductsByCategorySuccess(response.data));
      }
      
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsByCategoryFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsByCategoryFailure.general(error.toString()));
    }
  }

  Future<void> fetchFilterProducts({
      String sortByLowestPrice,
      String sortByHighestPrice,
      String sortByReview,
      String sortByLatest ,
      String lowestPrice,
      String highestPrice,
      String cityId
  }) async {
    emit(FetchProductsByCategoryLoading());
    try {
       final response = await _productsRepository.filterProduct(sortByLowestPrice: sortByLowestPrice, sortByHighestPrice: sortByHighestPrice, sortByReview: sortByReview, sortByLatest: sortByLatest, lowestPrice: lowestPrice, highestPrice: highestPrice, cityId: cityId);
        emit(FetchProductsByCategorySuccess(response.data));
      
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsByCategoryFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsByCategoryFailure.general(error.toString()));
    }
  }

  Future<void> fetchProductsBySubcategory(
      {@required int categoryId, @required int subcategoryId}) async {
    emit(FetchProductsByCategoryLoading());
    try {
      // if (phonenumber != null) {
      //   final response =
      //       await _productsRepository.fetchProductsBySubcategoryReseller(
      //           categoryId: categoryId,
      //           subcategoryId: subcategoryId,
      //           phonenumber: phonenumber);
      //   emit(FetchProductsByCategorySuccess(response.data));
      // } else {
      //   final response = await _productsRepository.fetchProductsBySubcategory(
      //       categoryId: categoryId, subcategoryId: subcategoryId);
      //   emit(FetchProductsByCategorySuccess(response.data));
      // }
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsByCategoryFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsByCategoryFailure.general(error.toString()));
    }
  }

  // Future<void> fetchProductsRandomByCategory({@required int categoryId}) async {
  //   emit(FetchProductsByCategoryLoading());
  //   try {
  //     if (phonenumber != null) {
  //       final response =
  //           await _productsRepository.fetchProductsByCategoryReseller(
  //               categoryId: categoryId, phonenumber: phonenumber);
  //       emit(FetchProductsByCategorySuccess(response.data));
  //     } else {
  //       final response = await _productsRepository.fetchRandomProducts(categoryId: categoryId);
  //       emit(FetchProductsByCategorySuccess(response.data));
  //     }
  //   } catch (error) {
  //     if (error is NetworkException) {
  //       emit(FetchProductsByCategoryFailure.network(error.toString()));
  //       return;
  //     }
  //     emit(FetchProductsByCategoryFailure.general(error.toString()));
  //   }
  // }
}
