import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'transaksi_filter_supplier_status_state.dart';

class TransaksiFilterSupplierStatusCubit extends Cubit<TransaksiFilterSupplierStatusState> {
  TransaksiFilterSupplierStatusCubit() : super(TransaksiFilterSupplierStatusState());

  void chooseStatus(String status, int index) {
    emit(state.copyWith(kategori: status, index: index));
    debugPrint(state.toString());
  }

  void resetStatus() => emit(TransaksiFilterSupplierStatusState());
}
