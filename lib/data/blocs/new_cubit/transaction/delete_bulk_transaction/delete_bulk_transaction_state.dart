part of 'delete_bulk_transaction_cubit.dart';

@immutable
abstract class DeleteBulkTransactionState {}

class DeleteBulkTransactionInitial extends DeleteBulkTransactionState {}

class DeleteBulkTransactionLoading extends DeleteBulkTransactionState {}

class DeleteBulkTransactionSuccess extends DeleteBulkTransactionState {
  final OrderMenungguPembayaran order;

  DeleteBulkTransactionSuccess({
    @required this.order,
  });
}

class DeleteBulkTransactionFailure extends DeleteBulkTransactionState {
  final ErrorType type;
  final String message;

  DeleteBulkTransactionFailure({this.type = ErrorType.general, this.message});

  DeleteBulkTransactionFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  DeleteBulkTransactionFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
