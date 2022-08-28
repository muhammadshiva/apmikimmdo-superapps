part of 'fetch_transaction_menunggu_pembayaran_detail_cubit.dart';

@immutable
abstract class FetchTransactionMenungguPembayaranDetailState extends Equatable {
  const FetchTransactionMenungguPembayaranDetailState();

  @override
  List<Object> get props => [];
}

class FetchTransactionMenungguPembayaranDetailInitial extends FetchTransactionMenungguPembayaranDetailState {}

class FetchTransactionMenungguPembayaranDetailLoading extends FetchTransactionMenungguPembayaranDetailState {}

class FetchTransactionMenungguPembayaranDetailSuccess extends FetchTransactionMenungguPembayaranDetailState {
  FetchTransactionMenungguPembayaranDetailSuccess(this.items);

  final OrderDetailMenungguPembayaranResponseData items;

  @override
  List<Object> get props => [items];
}

class FetchTransactionMenungguPembayaranDetailFailure extends FetchTransactionMenungguPembayaranDetailState {
  final ErrorType type;
  final String message;

  FetchTransactionMenungguPembayaranDetailFailure({this.type = ErrorType.general, this.message});

  FetchTransactionMenungguPembayaranDetailFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchTransactionMenungguPembayaranDetailFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
