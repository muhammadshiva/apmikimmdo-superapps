import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'fetch_transaction_new_event.dart';

part 'fetch_transaction_new_state.dart';

class FetchTransactionNewBloc
    extends Bloc<FetchTransactionNewEvent, FetchTransactionNewState> {
  FetchTransactionNewBloc() : super(FetchTransactionNewState());

  final TransactionRepository repository = TransactionRepository();

  @override
  Stream<Transition<FetchTransactionNewEvent, FetchTransactionNewState>>
      transformEvents(
    Stream<FetchTransactionNewEvent> events,
    TransitionFunction<FetchTransactionNewEvent, FetchTransactionNewState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.throttleTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<FetchTransactionNewState> mapEventToState(
      FetchTransactionNewEvent event) async* {
    if (event is TransactionFetched) {
      debugPrint("print loading transacion");
      yield FetchTransactionNewState(status: FetchTransactionNewStatus.loading);
      yield await _mapTransactionFetchedToState(state, event);
    }
    if (event is TransactionLoadedNext) {

      yield state.copyWith(status: FetchTransactionNewStatus.loadingNext);
      yield await _mapTransactionFetchedNextPageToState(state);
    }
  }

  Future<FetchTransactionNewState> _mapTransactionFetchedToState(
      FetchTransactionNewState state, TransactionFetched event) async {
    try {
      debugPrint("stat3e $state");
      if (state.nextPage == null) return state;
      String newFrom, newTo;
      final now = DateTime.now();

      String _kategoriId =
          event.kategoriId != null ? event.kategoriId.toString() : "";
      int status = event.status ?? 0;

      if (event.tanggalIndex == 1) {
        newFrom =
            AppExt.getDateFrom(DateTime(now.year, now.month - 3, now.day));
        newTo = AppExt.getDateTo(DateTime.now());
      } else if (event.tanggalIndex == 2) {
        newFrom =
            AppExt.getDateFrom(DateTime(now.year, now.month - 1, now.day));
        newTo = AppExt.getDateTo(DateTime.now());
      } else if (event.tanggalIndex == 3) {
        final _from = event.from ?? now.subtract(Duration(days: 1));
        final _to = event.to ?? now;
        newFrom =
            AppExt.getDateFrom(DateTime(_from.year, _from.month, _from.day));
        newTo = AppExt.getDateTo(DateTime(_to.year, _to.month, _to.day));
      }
      debugPrint("status ${event.status}");

      if (status >= 1) {
        final response = await repository.fetchFilterTransactions(
          status: status.toString(),
          kategori: _kategoriId,
          dateFrom: newFrom ?? "",
          dateTo: newTo ?? "",
        );
        final hideMenungguPembayaran = response.data.where((element) 
        => element.status.toLowerCase() != "menunggu pembayaran").toList();
        return FetchTransactionNewState(
            status: FetchTransactionNewStatus.success,
            order: hideMenungguPembayaran,
            nextPage: response.links.next);
      } else {
        debugPrint("status ${event.status}");
        final response = await repository.fetchFilterTransactions(
            status: "",
            kategori: _kategoriId,
            dateFrom: newFrom ?? "",
            dateTo: newTo ?? "");
        final hideMenungguPembayaran = response.data.where((element) 
        => element.status.toLowerCase() != "menunggu pembayaran").toList();
        return FetchTransactionNewState(
            status: FetchTransactionNewStatus.success,
            order: hideMenungguPembayaran,
            nextPage: response.links.next
        );
      }
    } catch (error) {
      return FetchTransactionNewState(status: FetchTransactionNewStatus.failure, message: error.toString());
    }
  }

  Future<FetchTransactionNewState> _mapTransactionFetchedNextPageToState(
      FetchTransactionNewState state) async {
    try {
      debugPrint("next ${state.nextPage}");
      if (state.nextPage == null) {
        return state.copyWith(status: FetchTransactionNewStatus.empty);
      }
      final response = await repository.fetchTransactionsWithoutBaseurl(state.nextPage);
      final hideMenungguPembayaran = response.data.where((element) 
        => element.status.toLowerCase() != "menunggu pembayaran").toList();
      return FetchTransactionNewState(
          status: FetchTransactionNewStatus.success,
          order: state.order..addAll(hideMenungguPembayaran),
          nextPage: response.links.next
      );
    } catch (error){
      return state.copyWith(
          status: FetchTransactionNewStatus.failure, message: error.toString());
    }
  }
}
