part of 'fetch_transaction_new_bloc.dart';

@immutable
abstract class FetchTransactionNewEvent {}

class TransactionFetched extends FetchTransactionNewEvent {
  final int status;
  final int tanggalIndex;
  final DateTime from;
  final DateTime to;
  final int kategoriId;

  TransactionFetched({
    this.status,
    this.tanggalIndex,
    this.from,
    this.to,
    this.kategoriId,
  });
}

class TransactionLoadedNext extends FetchTransactionNewEvent {}
