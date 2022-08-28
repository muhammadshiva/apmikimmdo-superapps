part of 'transaksi_filter_supplier_tanggal_cubit.dart';

class TransaksiFilterSupplierTanggalState {
  final String status;
  final int indexStatus;
  final DateTime startDate;
  final DateTime endDate;

  const TransaksiFilterSupplierTanggalState({
    this.status = "Semua Tanggal Transaksi",
    this.indexStatus = 0,
    this.startDate,
    this.endDate,
  });

  TransaksiFilterSupplierTanggalState copyWith({
    String status,
    int indexStatus,
    DateTime startDate,
    DateTime endDate,
  }) {
    return TransaksiFilterSupplierTanggalState(
      status: status ?? this.status,
      indexStatus: indexStatus ?? this.indexStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
