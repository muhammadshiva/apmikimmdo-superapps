part of 'fetch_transaction_detail_cubit.dart';

abstract class FetchTransactionDetailState extends Equatable {
  const FetchTransactionDetailState();

  @override
  List<Object> get props => [];
}

class FetchTransactionDetailInitial extends FetchTransactionDetailState {}

class FetchTransactionDetailLoading extends FetchTransactionDetailState {}

class FetchTransactionDetailSuccess extends FetchTransactionDetailState {
  FetchTransactionDetailSuccess(this.items);

  final OrderDetailResponseData items;

  @override
  List<Object> get props => [items];
}

class FetchTransactionDetailFailure extends FetchTransactionDetailState {
  final ErrorType type;
  final String message;

  FetchTransactionDetailFailure({this.type = ErrorType.general, this.message});

  FetchTransactionDetailFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchTransactionDetailFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}