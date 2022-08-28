import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/products_repository.dart';

part 'fetch_products_state.dart';

class FetchProductsCubit extends Cubit<FetchProductsState> {
  FetchProductsCubit({this.type, this.phonenumber})
      : super(FetchProductsInitial());

  final ProductsRepository _productsRepository = ProductsRepository();
  final FetchProductsType type;
  String phonenumber;

  Future<void> fetchProductsBestSell() async {
    emit(FetchProductsLoading());
    try {
      final response = await _productsRepository.fetchProductsBestSell();
      emit(FetchProductsSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsFailure.general(error.toString()));
    }
  }

  Future<void> fetchProductsFlashSale() async {
    emit(FetchProductsLoading());
    try {
      final response = await _productsRepository.fetchProductsFlashSale();
      emit(FetchProductsSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsFailure.general(error.toString()));
    }
  }

  Future<void> fetchProductsPromo() async {
    emit(FetchProductsLoading());
    try {
      final response = await _productsRepository.fetchProductsPromo();
      emit(FetchProductsSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsFailure.general(error.toString()));
    }
  }

  Future<void> fetchProductsBumdes() async {
    emit(FetchProductsLoading());
    try {
      final response = await _productsRepository.fetchProductsBumdes();
      emit(FetchProductsSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsFailure.general(error.toString()));
    }
  }

  Future<void> fetchReadyToEat() async {
    emit(FetchProductsLoading());
    try {
      final response = await _productsRepository.fetchReadyToEat();
      emit(FetchProductsSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsFailure.network(error.toString()));

        return;
      }
      emit(FetchProductsFailure.general(error.toString()));
    }
  }

//=====================================================================================================
//=====================================================================================================
//=====================================================================================================
//=====================================================================================================
//=====================================================================================================

  // Future<void> fetchProductsLimitedReseller({String phonenumber}) async {
  //   emit(FetchProductsLoading());
  //   try {
  //     phonenumber = phonenumber;
  //     final response = await _productsRepository.fetchProductsReseller(
  //         phonenumber: phonenumber);
  //     emit(FetchProductsSuccess(response.data));
  //   } catch (error) {
  //     if (error is NetworkException) {
  //       emit(FetchProductsFailure.network(error.toString()));
  //       return;
  //     }
  //     emit(FetchProductsFailure.general(error.toString()));
  //   }
  // }

  // Future<void> fetchProductsLimited() async {
  //   emit(FetchProductsLoading());
  //   try {
  //     if (phonenumber != null) {
  //       final response = await _productsRepository.fetchProductsReseller(
  //           phonenumber: phonenumber);
  //       emit(FetchProductsSuccess(response.data));
  //     } else {
  //       final response = await _productsRepository.fetchProducts();
  //       emit(FetchProductsSuccess(response.data));
  //     }
  //   } catch (error) {
  //     if (error is NetworkException) {
  //       emit(FetchProductsFailure.network(error.toString()));
  //       return;
  //     }
  //     emit(FetchProductsFailure.general(error.toString()));
  //   }
  // }

  Future<void> fetchProductsSpecialOffer() async {
    emit(FetchProductsLoading());
    // try {
    //   if (phonenumber != null) {
    //     final response =
    //         await _productsRepository.fetchProductsSpecialOfferReseller(
    //              phonenumber: phonenumber);
    //     emit(FetchProductsSuccess(response.data));
    //   } else {
    //     final response =
    //         await _productsRepository.fetchProductsSpecialOffer();
    //     emit(FetchProductsSuccess(response.data));
    //   }
    // } catch (error) {
    //   if (error is NetworkException) {
    //     emit(FetchProductsFailure.network(error.toString()));
    //     return;
    //   }
    //   emit(FetchProductsFailure.general(error.toString()));
    // }
  }

  Future<void> fetchProductsRandomByCategory({@required int categoryId}) async {
    emit(FetchProductsLoading());
    // try {
    //   if (phonenumber != null) {
    //     final response =
    //         await _productsRepository.fetchProductsByCategoryReseller(
    //             categoryId: categoryId, phonenumber: phonenumber);
    //     emit(FetchProductsSuccess(response.data));
    //   } else {
    //     final response = await _productsRepository.fetchRandomProducts(categoryId: categoryId);
    //     emit(FetchProductsSuccess(response.data));
    //   }
    // } catch (error) {
    //   if (error is NetworkException) {
    //     emit(FetchProductsFailure.network(error.toString()));
    //     return;
    //   }
    //   emit(FetchProductsFailure.general(error.toString()));
    // }
  }
}
