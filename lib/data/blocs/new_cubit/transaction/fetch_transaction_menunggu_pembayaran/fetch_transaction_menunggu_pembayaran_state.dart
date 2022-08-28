part of 'fetch_transaction_menunggu_pembayaran_bloc.dart';

@immutable
abstract class FetchTransactionMenungguPembayaranState {}

class FetchTransactionMenungguPembayaranInitial extends FetchTransactionMenungguPembayaranState {}

class FetchTransactionMenungguPembayaranLoading extends FetchTransactionMenungguPembayaranState {}

class FetchTransactionMenungguPembayaranSuccess extends FetchTransactionMenungguPembayaranState {
  FetchTransactionMenungguPembayaranSuccess(this.order);

  final List<OrderMenungguPembayaranData> order;
}

class FetchTransactionMenungguPembayaranSuccessAfterDelete extends FetchTransactionMenungguPembayaranState {
  FetchTransactionMenungguPembayaranSuccessAfterDelete(this.order);

  final List<OrderMenungguPembayaranData> order;
}

class FetchTransactionMenungguPembayaranFailure extends FetchTransactionMenungguPembayaranState {
  FetchTransactionMenungguPembayaranFailure(this.message);

  final String message;
}
