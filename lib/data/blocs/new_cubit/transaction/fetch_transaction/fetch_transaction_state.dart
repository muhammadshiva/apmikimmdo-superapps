part of 'fetch_transaction_cubit.dart';

abstract class FetchTransactionState extends Equatable {
  const FetchTransactionState();

  @override
  List<Object> get props => [];
}

class FetchTransactionInitial extends FetchTransactionState {}

class FetchTransactionLoading extends FetchTransactionState {}

class FetchTransactionSuccess extends FetchTransactionState {
  FetchTransactionSuccess(this.order);

  final List<OrderResponseData> order;

  @override
  List<Object> get props => [order];
}

class FetchTransactionFailure extends FetchTransactionState {
  FetchTransactionFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}



