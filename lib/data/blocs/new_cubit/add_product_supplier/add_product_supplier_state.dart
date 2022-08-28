part of 'add_product_supplier_cubit.dart';

class AddProductSupplierState {
  final String foto1;
  final Uint8List fotoByte1;
  final String foto2;
  final Uint8List fotoByte2;
  final String foto3;
  final Uint8List fotoByte3;
  final String foto4;
  final Uint8List fotoByte4;
  final String link;
  final int categoryId;
  final String categoryName;
  final int subCategoryId;
  final String subCategoryName;
  final String satuan;
  final List<int> grosirHarga;
  final List<int> grosirMinimumBeli;
  final List<String> varianId1;
  final List<String> varianName1;
  final List<String> varianId2;
  final List<String> varianName2;
  final List<int> varianHarga;
  final List<int> varianStok;

  const AddProductSupplierState({
     this.foto1,
    this.fotoByte1,
     this.foto2,
    this.fotoByte2,
     this.foto3,
    this.fotoByte3,
     this.foto4,
    this.fotoByte4,
    this.link,
     this.categoryId,
     this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.satuan,
     this.grosirHarga = const [],
     this.grosirMinimumBeli = const [],
    this.varianId1 = const [],
    this.varianName1 = const [],
    this.varianId2 = const [],
    this.varianName2 = const [],
    this.varianHarga = const [],
    this.varianStok = const [],
  });

  AddProductSupplierState copyWith({
    String foto1,
    Uint8List fotoByte1,
    String foto2,
    Uint8List fotoByte2,
    String foto3,
    Uint8List fotoByte3,
    String foto4,
    Uint8List fotoByte4,
    String link,
    int categoryId,
    String categoryName,
    int subCategoryId,
    String subCategoryName,
    String satuan,
    List<int> grosirHarga,
    List<int> grosirMinimumBeli,
    List<String> varianId1,
    List<String> varianName1,
    List<String> varianId2,
    List<String> varianName2,
    List<int> varianHarga,
    List<int> varianStok,
  }) {
    return AddProductSupplierState(
      foto1: foto1 ?? this.foto1,
      fotoByte1: fotoByte1 ?? this.fotoByte1,
      foto2: foto2 ?? this.foto2,
      fotoByte2: fotoByte2 ?? this.fotoByte2,
      foto3: foto3 ?? this.foto3,
      fotoByte3: fotoByte3 ?? this.fotoByte3,
      foto4: foto4 ?? this.foto4,
      fotoByte4: fotoByte4 ?? this.fotoByte4,
      link: link ?? this.link,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      satuan: satuan ?? this.satuan,
      grosirHarga: grosirHarga ?? this.grosirHarga,
      grosirMinimumBeli: grosirMinimumBeli ?? this.grosirMinimumBeli,
      varianId1: varianId1 ?? this.varianId1,
      varianId2: varianId2 ?? this.varianId2,
      varianName1: varianName1 ?? this.varianName1,
      varianName2: varianName2 ?? this.varianName2,
      varianHarga: varianHarga ?? this.varianHarga,
      varianStok: varianStok ?? this.varianStok,
    );
  }

  @override
  String toString() {
    return 'AddProductSupplierState{varianId1: $varianId1, varianName1: $varianName1, varianHarga: $varianHarga, varianStok: $varianStok}';
  }
}
