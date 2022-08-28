import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/repositories/new_repositories/products_repository.dart';

part 'product_coverage_validation_state.dart';

class ProductCoverageValidationCubit extends Cubit<ProductCoverageValidationState> {
  ProductCoverageValidationCubit() : super(ProductCoverageValidationInitial());

  final ProductsRepository _productsRepository = ProductsRepository();

  Future<void> productCoverageValidate({
    @required int productId,
    @required int subdistrictId,
  }) async {
    emit(ProductCoverageValidationLoading());
    try {
      final response =
      await _productsRepository.productCoverageValidation(productId: productId, subdistrictId: subdistrictId);
      emit(ProductCoverageValidationSuccess(response.status));
    } catch (error) {
      if (error is NetworkException) {
        emit(ProductCoverageValidationFailure.network(error.toString()));
        return;
      }
      emit(ProductCoverageValidationFailure.general(error.toString()));
    }
  }
}
