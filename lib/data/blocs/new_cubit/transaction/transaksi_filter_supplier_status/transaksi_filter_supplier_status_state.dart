part of 'transaksi_filter_supplier_status_cubit.dart';

class TransaksiFilterSupplierStatusState {
  final String kategori;
  final int index;
  final bool isRebuild;

  const TransaksiFilterSupplierStatusState({
    this.kategori = "Semua Status",
    this.index = 0,
    this.isRebuild = false,
  });

  TransaksiFilterSupplierStatusState copyWith({
    String kategori,
    int index,
    bool isRebuild,
  }) {
    return TransaksiFilterSupplierStatusState(
      kategori: kategori ?? this.kategori,
      index: index ?? this.index,
      isRebuild: isRebuild ?? this.isRebuild,
    );
  }
}
