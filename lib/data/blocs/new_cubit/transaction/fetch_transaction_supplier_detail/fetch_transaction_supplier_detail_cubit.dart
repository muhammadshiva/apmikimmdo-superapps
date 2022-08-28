import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/api/api_exceptions.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'fetch_transaction_supplier_detail_state.dart';

class FetchTransactionSupplierDetailCubit extends Cubit<FetchTransactionSupplierDetailState> {
  FetchTransactionSupplierDetailCubit() : super(FetchTransactionSupplierDetailInitial());

  final TransactionRepository _repository = TransactionRepository();

  Future<void> fetchDetail({@required int orderId}) async {
    try {
      debugPrint("id $orderId");
      final response =
      await _repository.fetchProductSupplierDetail(orderId: orderId);
      emit(FetchTransactionSupplierDetailSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchTransactionSupplierDetailFailure.network(error.toString()));
        return;
      }
      emit(FetchTransactionSupplierDetailFailure.general(error.toString()));
    }
  }
}
