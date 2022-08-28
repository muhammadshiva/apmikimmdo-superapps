import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;

part 'fetch_transaction_state.dart';

class FetchTransactionCubit extends Cubit<FetchTransactionState> {
  FetchTransactionCubit() : super(FetchTransactionInitial());

  final TransactionRepository repository = TransactionRepository();

  Future<void> fetch() async {
    emit(FetchTransactionLoading());
    try {
      final response = await repository.fetchTransactions();
      emit(FetchTransactionSuccess(response.data));
    } catch (error) {
      emit(FetchTransactionFailure(error.toString()));
    }
  }

  Future<void> fetchFilterTransaction({int status, int tanggalIndex, DateTime from, DateTime to, int kategoriId}) async {
    emit(FetchTransactionLoading());
    try {
      String newFrom, newTo;
      final now = DateTime.now();

      String _kategoriId = kategoriId != null ? kategoriId.toString() : "";

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
        final response = await repository.fetchFilterTransactions(status: status.toString(), kategori: _kategoriId, dateFrom: newFrom ?? "", dateTo: newTo ?? "", );
        emit(FetchTransactionSuccess(response.data));
      } else {
        final response = await repository.fetchFilterTransactions(status: "", kategori: _kategoriId, dateFrom: newFrom ?? "", dateTo: newTo ?? "");
        emit(FetchTransactionSuccess(response.data));
      }
    } catch (error) {
      emit(FetchTransactionFailure(error.toString()));
    }
  }
}
