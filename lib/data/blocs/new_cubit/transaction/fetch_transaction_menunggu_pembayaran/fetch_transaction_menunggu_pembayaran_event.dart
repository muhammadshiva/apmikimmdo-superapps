part of 'fetch_transaction_menunggu_pembayaran_bloc.dart';

@immutable
abstract class FetchTransactionMenungguPembayaranEvent {}

class TransactionMenungguPembayaranFetched extends FetchTransactionMenungguPembayaranEvent {
  final String search;

  TransactionMenungguPembayaranFetched({
    this.search,
  });
}

class TransactionMenungguPembayaranLoadedAfterDelete extends FetchTransactionMenungguPembayaranEvent {
  final OrderMenungguPembayaran order;

  TransactionMenungguPembayaranLoadedAfterDelete({
    this.order,
  });
}
