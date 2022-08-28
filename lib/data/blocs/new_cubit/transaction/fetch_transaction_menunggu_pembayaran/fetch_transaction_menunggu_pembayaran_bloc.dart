import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:meta/meta.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'fetch_transaction_menunggu_pembayaran_event.dart';
part 'fetch_transaction_menunggu_pembayaran_state.dart';

class FetchTransactionMenungguPembayaranBloc
    extends Bloc<FetchTransactionMenungguPembayaranEvent, FetchTransactionMenungguPembayaranState> {
  FetchTransactionMenungguPembayaranBloc() : super(FetchTransactionMenungguPembayaranInitial());

  final TransactionRepository repository = TransactionRepository();

  @override
  Stream<Transition<FetchTransactionMenungguPembayaranEvent, FetchTransactionMenungguPembayaranState>> transformEvents(
      Stream<FetchTransactionMenungguPembayaranEvent> events,
      TransitionFunction<FetchTransactionMenungguPembayaranEvent, FetchTransactionMenungguPembayaranState> transitionFn,
      ) {
    return super.transformEvents(
      events.throttleTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<FetchTransactionMenungguPembayaranState> mapEventToState(
      FetchTransactionMenungguPembayaranEvent event) async* {
    if (event is TransactionMenungguPembayaranFetched) {
      yield FetchTransactionMenungguPembayaranLoading();
      yield await _mapTransactionMenungguPembayaranFetchedToState(state, event);
    }
    if (event is TransactionMenungguPembayaranLoadedAfterDelete) {
      final menungguPembayaran = event.order.data
          .where((element) =>
      element.status.toLowerCase() == "menunggu pembayaran")
          .toList();
      yield FetchTransactionMenungguPembayaranSuccessAfterDelete(menungguPembayaran);
    }
  }

  Future<FetchTransactionMenungguPembayaranState> _mapTransactionMenungguPembayaranFetchedToState(
      FetchTransactionMenungguPembayaranState state, TransactionMenungguPembayaranFetched event) async {
    try {
      final response = await repository.fetchMenungguPembayaranTransactions();
      return FetchTransactionMenungguPembayaranSuccess(response.data);
    } catch (error) {
      return FetchTransactionMenungguPembayaranFailure(error.toString());
    }
  }
}