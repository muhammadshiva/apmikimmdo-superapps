part of 'transaksi_filter_kategori_cubit.dart';

class TransaksiFilterKategoriState {
  final String kategori;
  final int kategoriId;
  final bool isRebuild;

  const TransaksiFilterKategoriState({
    this.kategori = "Semua Kategori",
    this.kategoriId,
    this.isRebuild,
  });

  TransaksiFilterKategoriState copyWith({
    String kategori,
    int kategoriId,
    bool isRebuild,
  }) {
    return TransaksiFilterKategoriState(
      kategori: kategori ?? this.kategori,
      kategoriId: kategoriId ?? this.kategoriId,
      isRebuild: isRebuild ?? this.isRebuild,
    );
  }

  @override
  String toString() {
    return 'TransaksiFilterKategoriState{kategori: $kategori, kategoriId: $kategoriId, isRebuild: $isRebuild}';
  }
}
