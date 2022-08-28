import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'transaksi_filter_status_state.dart';

class TransaksiFilterStatusCubit extends Cubit<TransaksiFilterStatusState> {
  TransaksiFilterStatusCubit() : super(TransaksiFilterStatusState());

  void chooseStatus(String status, int index) {
    emit(state.copyWith(kategori: status, index: index));
    debugPrint(state.toString());
  }

  void resetStatus() => emit(TransaksiFilterStatusState());
}
