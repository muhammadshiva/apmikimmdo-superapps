part of 'transaksi_filter_tanggal_cubit.dart';

class TransaksiFilterTanggalState {
  final String status;
  final int indexStatus;
  final DateTime startDate;
  final DateTime endDate;

  const TransaksiFilterTanggalState({
    this.status = "Semua Tanggal Transaksi",
    this.indexStatus = 0,
    this.startDate,
    this.endDate,
  });

  TransaksiFilterTanggalState copyWith({
    String status,
    int indexStatus,
    DateTime startDate,
    DateTime endDate,
  }) {
    return TransaksiFilterTanggalState(
      status: status ?? this.status,
      indexStatus: indexStatus ?? this.indexStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
