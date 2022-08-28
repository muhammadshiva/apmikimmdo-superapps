part of 'transaksi_filter_status_cubit.dart';

class TransaksiFilterStatusState {
  final String kategori;
  final int index;
  final bool isRebuild;

  const TransaksiFilterStatusState({
    this.kategori = "Semua Status",
    this.index = 0,
    this.isRebuild = false,
  });

  TransaksiFilterStatusState copyWith({
    String kategori,
    int index,
    bool isRebuild,
  }) {
    return TransaksiFilterStatusState(
      kategori: kategori ?? this.kategori,
      index: index ?? this.index,
      isRebuild: isRebuild ?? this.isRebuild,
    );
  }

  @override
  String toString() {
    return 'TransaksiFilterStatusState{kategori: $kategori, index: $index, isRebuild: $isRebuild}';
  }
}
