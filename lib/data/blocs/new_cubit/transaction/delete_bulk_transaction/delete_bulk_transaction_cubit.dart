import 'package:bloc/bloc.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'delete_bulk_transaction_state.dart';

class DeleteBulkTransactionCubit extends Cubit<DeleteBulkTransactionState> {
  DeleteBulkTransactionCubit() : super(DeleteBulkTransactionInitial());

  final TransactionRepository _transactionRepository = TransactionRepository();

  Future<void> delete(
      {@required List<int> paymentId}) async {
    emit(DeleteBulkTransactionLoading());
    try {
      final response = await _transactionRepository.deleteExpired(paymentId: paymentId);
      emit(DeleteBulkTransactionSuccess(order: response));
    } catch (error) {
      if (error is NetworkException) {
        emit(DeleteBulkTransactionFailure.network(error.toString()));
        return;
      }
      emit(DeleteBulkTransactionFailure.general(error.toString()));
    }
  }
}
