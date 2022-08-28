import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;

part 'fetch_transaction_supplier_state.dart';

class FetchTransactionSupplierCubit extends Cubit<FetchTransactionSupplierState> {
  FetchTransactionSupplierCubit() : super(FetchTransactionSupplierInitial());

  final TransactionRepository repository = TransactionRepository();

  Future<void> fetch() async {
    emit(FetchTransactionSupplierLoading());
    try {
      final response = await repository.fetchSupplierTransactions();
      emit(FetchTransactionSupplierSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchTransactionSupplierFailure.network(error.toString()));
        return;
      }
      emit(FetchTransactionSupplierFailure.general(error.toString()));
    }
  }

  Future<void> fetchFilterTransaction({int status, int tanggalIndex, DateTime from, DateTime to, int kategoriId}) async {
    emit(FetchTransactionSupplierLoading());
    try {
      String newFrom, newTo;
      final now = DateTime.now();

      if (tanggalIndex == 1){
        newFrom = AppExt.getDateFrom(DateTime(now.year, now.month - 3, now.day));
        newTo = AppExt.getDateTo(DateTime.now());
      } else if (tanggalIndex == 2){
        newFrom = AppExt.getDateFrom(DateTime(now.year, now.month - 1, now.day));
        newTo = AppExt.getDateTo(DateTime.now());
      } else if (tanggalIndex == 3){
        final _from = from ?? now.subtract(Duration(days: 1));
        final _to = to ?? now;
        newFrom = AppExt.getDateFrom(DateTime(_from.year, _from.month, _from.day));
        newTo = AppExt.getDateTo(DateTime(_to.year, _to.month, _to.day));
      }

      if (status >= 1){
        final response = await repository.fetchFilterSupplierTransactions(status: status.toString(), dateFrom: newFrom ?? "", dateTo: newTo ?? "", );
        emit(FetchTransactionSupplierSuccess(response.data));
      } else {
        final response = await repository.fetchFilterSupplierTransactions(status: "", dateFrom: newFrom ?? "", dateTo: newTo ?? "");
        emit(FetchTransactionSupplierSuccess(response.data));
      }
    } catch (error) {
      debugPrint("error type ${error.runtimeType}");
      if (error is NetworkException) {
        emit(FetchTransactionSupplierFailure.network(error.toString()));
        return;
      }
      emit(FetchTransactionSupplierFailure.general(error.toString()));
    }
  }
}
