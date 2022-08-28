import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaksi_filter_supplier_tanggal_state.dart';

class TransaksiFilterSupplierTanggalCubit extends Cubit<TransaksiFilterSupplierTanggalState> {
  TransaksiFilterSupplierTanggalCubit() : super(TransaksiFilterSupplierTanggalState());

  void reset() => emit(state.copyWith(status: "Semua Tanggal Transaksi"));

  void changeStatus(String value, int index) => emit(state.copyWith(status: value, indexStatus: index));

  void changeStartDate(DateTime date) => emit(state.copyWith(startDate: date));

  void changeEndDate(DateTime date) => emit(state.copyWith(endDate: date));
}
