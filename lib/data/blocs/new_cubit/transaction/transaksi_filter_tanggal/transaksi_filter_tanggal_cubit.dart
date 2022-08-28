import 'package:bloc/bloc.dart';

part 'transaksi_filter_tanggal_state.dart';

class TransaksiFilterTanggalCubit extends Cubit<TransaksiFilterTanggalState> {
  TransaksiFilterTanggalCubit() : super(TransaksiFilterTanggalState());

  void reset() => emit(state.copyWith(status: "Semua Tanggal Transaksi"));

  void changeStatus(String value, int index) => emit(state.copyWith(status: value, indexStatus: index));

  void changeStartDate(DateTime date) => emit(state.copyWith(startDate: date));

  void changeEndDate(DateTime date) => emit(state.copyWith(endDate: date));
}
