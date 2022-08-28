import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'transaksi_filter_kategori_state.dart';

class TransaksiFilterKategoriCubit extends Cubit<TransaksiFilterKategoriState> {
  TransaksiFilterKategoriCubit() : super(TransaksiFilterKategoriState());

  void reset() => emit(TransaksiFilterKategoriState());

  void chooseStatus(String status, int kategoriId) {
    emit(state.copyWith(kategori: status, kategoriId: kategoriId));
    debugPrint(state.toString());
  }

  /*void addKategori(String value) {
    if (value == "Semua Kategori") {
      emit(List.from(state)
        ..clear()
        ..add(value));
    } else {
      emit(List.from(state)
        ..remove("Semua Kategori")
        ..add(value));
    }
  }

  void removeKategori(String value) {
    if (state.length <= 1) {
      emit(List.from(state)
        ..remove(value)
        ..add("Semua Kategori"));
    } else {
      emit(List.from(state)..remove(value));
    }
  }*/


}
