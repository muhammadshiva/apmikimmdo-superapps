import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'fetch_transaction_detail_state.dart';

class FetchTransactionDetailCubit extends Cubit<FetchTransactionDetailState> {
  FetchTransactionDetailCubit() : super(FetchTransactionDetailInitial());

  final TransactionRepository _repository = TransactionRepository();

  Future<void> fetchDetail({@required int orderId}) async {
    emit(FetchTransactionDetailLoading());
    try {
      debugPrint("id $orderId");
      final response =
      await _repository.fetchProductDetail(orderId: orderId);
      emit(FetchTransactionDetailSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchTransactionDetailFailure.network(error.toString()));
        return;
      }
      emit(FetchTransactionDetailFailure.general(error.toString()));
    }
  }
}
