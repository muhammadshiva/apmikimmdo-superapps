import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'edit_stock_product_supplier_state.dart';

class EditStockProductSupplierCubit
    extends Cubit<EditStockProductSupplierState> {
  EditStockProductSupplierCubit() : super(EditStockProductSupplierInitial());

  final JoinUserRepository _joinUserRepository = JoinUserRepository();

  Future<void> editStock({@required int id, @required int stock}) async {
    emit(EditStockProductSupplierLoading());
    try {
      final response =
          await _joinUserRepository.editStock(id: id, stock: stock);
      emit(EditStockProductSupplierSuccess());
    } catch (error) {
      if (error is NetworkException) {
        emit(EditStockProductSupplierFailure.network(error.toString()));
        return;
      }
      emit(EditStockProductSupplierFailure.general(error.toString()));
    }
  }
}