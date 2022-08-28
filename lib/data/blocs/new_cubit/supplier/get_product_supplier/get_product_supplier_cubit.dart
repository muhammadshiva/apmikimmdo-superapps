import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/supplier.dart';
import 'package:marketplace/data/repositories/new_repositories/join_user_repository.dart';
import 'package:meta/meta.dart';

part 'get_product_supplier_state.dart';

class GetProductSupplierCubit extends Cubit<GetProductSupplierState> {
  GetProductSupplierCubit() : super(GetProductSupplierInitial());

  final JoinUserRepository _joinUserRepository = JoinUserRepository();

  Future<void> fetchProduct({
    String keyword
  }) async {
    emit(GetProductSupplierLoading());
    try {
      final response = await _joinUserRepository.getSupplierProductList(keyword: keyword);
      emit(GetProductSupplierSuccess(products: response.data ));
    } catch (error) {
      if (error is NetworkException) {
        emit(GetProductSupplierFailure.network(error.toString()));
        return;
      }
      emit(GetProductSupplierFailure.general(error.toString()));
    }
  }

  Future<void> fetchProductApproved({
    String keyword
  }) async {
    emit(GetProductSupplierLoading());
    try {
      final response = await _joinUserRepository.getSupplierProductApprovedList(keyword: keyword);
      emit(GetProductSupplierSuccess(products: response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(GetProductSupplierFailure.network(error.toString()));
        return;
      }
      emit(GetProductSupplierFailure.general(error.toString()));
    }
  }

  Future<void> deleteProduct(int id) async {
    emit(GetProductSupplierLoading());
    try {
      await _joinUserRepository.deleteSupplierProductList(id);
      emit(GetProductSupplierDeleteSuccess());
      fetchProduct();
    } catch (error) {
      if (error is NetworkException) {
        emit(GetProductSupplierFailure.network(error.toString()));
        return;
      }
      emit(GetProductSupplierFailure.general(error.toString()));
    }
  }

  Future<void> deleteProductApproved(int id) async {
    emit(GetProductSupplierLoading());
    try {
      await _joinUserRepository.deleteSupplierProductApprovedList(id);
      emit(GetProductSupplierDeleteSuccess());
    } catch (error) {
      if (error is NetworkException) {
        emit(GetProductSupplierFailure.network(error.toString()));
        return;
      }
      emit(GetProductSupplierFailure.general(error.toString()));
    }
  }
}