import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/data/models/new_models/supplier.dart';

part 'add_product_supplier_state.dart';

class AddProductSupplierCubit extends Cubit<AddProductSupplierState> {
  AddProductSupplierCubit() : super(AddProductSupplierState());

  void addPhoto1(PickedFile file) async {
    final byte = await file.readAsBytes();
    emit(state.copyWith(foto1: file.path, fotoByte1: byte));
  }

  void addPhoto2(PickedFile file) async {
    final byte = await file.readAsBytes();
    emit(state.copyWith(foto2: file.path, fotoByte2: byte));
  }

  void addPhoto3(PickedFile file) async {
    final byte = await file.readAsBytes();
    emit(state.copyWith(foto3: file.path, fotoByte3: byte));
  }

  void addPhoto4(PickedFile file) async {
    final byte = await file.readAsBytes();
    final list = byte.cast<int>();
    emit(state.copyWith(foto4: file.path, fotoByte4: byte));
  }

  void addKategori(String name, int id) {
    emit(state.copyWith(categoryId: id, categoryName: name));
  }

  void addSubKategori(String name, int id) {
    emit(state.copyWith(subCategoryId: id, subCategoryName: name));
  }

  void addSatuan(String satuan) => emit(state.copyWith(satuan: satuan));

  void addGrosir({int harga, int minimum}) {
    emit(state.copyWith(
        grosirHarga: List.from(state.grosirHarga)..add(harga),
        grosirMinimumBeli: List.from(state.grosirMinimumBeli)..add(minimum)));
  }

  void editGrosir({int harga, int minimum, int index}) {
    emit(state.copyWith(
        grosirHarga: List.from(state.grosirHarga)
          ..removeAt(index)
          ..add(harga),
        grosirMinimumBeli: List.from(state.grosirMinimumBeli)
          ..removeAt(index)
          ..add(minimum)));
  }

  void removeGrosir(int index) {
    emit(state.copyWith(
        grosirHarga: List.from(state.grosirHarga)..removeAt(index),
        grosirMinimumBeli: List.from(state.grosirMinimumBeli)
          ..removeAt(index)));
  }

  void addVarian(
      {String varianId1,
      String varianId2,
      String varianName1,
      String varianName2,
      int harga,
      int stok}) {
    emit(state.copyWith(
      varianId1: List.from(state.varianId1)..add(varianId1),
      varianId2: List.from(state.varianId2)..add(varianId2),
      varianName1: List.from(state.varianName1)..add(varianName1),
      varianName2: List.from(state.varianName2)..add(varianName2 ?? ""),
      varianHarga: List.from(state.varianHarga)..add(harga),
      varianStok: List.from(state.varianStok)..add(stok),
    ));
  }

  void editVarian(
      {String varianId1,
      String varianId2,
      String varianName1,
      String varianName2,
      int harga,
      int stok,
      int index}) {
    emit(state.copyWith(
      varianId1: List.from(state.varianId1)
        ..removeAt(index)
        ..add(varianId1),
      varianId2: List.from(state.varianId2)
        ..removeAt(index)
        ..add(varianId2),
      varianName1: List.from(state.varianName1)
        ..removeAt(index)
        ..add(varianName1),
      varianName2: List.from(state.varianName2)
        ..removeAt(index)
        ..add(varianName2 ?? ""),
      varianHarga: List.from(state.varianHarga)
        ..removeAt(index)
        ..add(harga),
      varianStok: List.from(state.varianStok)
        ..removeAt(index)
        ..add(stok),
    ));
  }

  void removeVariant(int index) {
    emit(state.copyWith(
      varianId1: List.from(state.varianId1)..removeAt(index),
      varianId2: List.from(state.varianId2)..removeAt(index),
      varianName1: List.from(state.varianName1)..removeAt(index),
      varianName2: List.from(state.varianName2)..removeAt(index),
      varianHarga: List.from(state.varianHarga)..removeAt(index),
      varianStok: List.from(state.varianStok)..removeAt(index),
    ));
  }

  void addItem(SupplierDataResponseItem item) {
    reset();
    var link = "";
    String productPhoto1, productPhoto2, productPhoto3, productPhoto4;
    var satuan;
    var loop = 1;
    List<int> grosirHarga = [];
    List<int> grosirMinimumBeli = [];
    List<String> variant1Name = [];
    List<String> variant1Type = [];
    List<String> variant2Name = [];
    List<String> variant2Type = [];
    List<int> variant1Price = [];
    List<int> variant1Stock = [];

    for (var photo in item.productAssets) {
      debugPrint("link ${photo.link}");
      if (photo.image != null) {
        if (loop == 1) {
          productPhoto1 = photo.image;
        } else if (loop == 2) {
          productPhoto2 = photo.image;
        } else if (loop == 3) {
          productPhoto3 = photo.image;
        } else if (loop == 4) {
          productPhoto4 = photo.image;
        }
        loop++;
      } else {
        link = photo.link;
      }
    }
    debugPrint("link $link, photo1 $productPhoto1, photo2 $productPhoto2");
    satuan = item.productUnit; // satuan

    for (var grosir in item.productGroceries) {
      grosirHarga.add(grosir.price);
      grosirMinimumBeli.add(grosir.minimumOrder);
    }

    for (var varian in item.productVariants) {
      variant1Type.add(varian.variantType);
      variant2Type.add("Warna");
      variant1Name.add(varian.variantName);
      variant2Name.add("");
      variant1Price.add(varian.variantPrice);
      variant1Stock.add(varian.variantStock);
    }
    emit(state.copyWith(
        foto1: productPhoto1,
        foto2: productPhoto2,
        foto3: productPhoto3,
        foto4: productPhoto4,
        link: link,
        satuan: satuan,
        grosirHarga: grosirHarga,
        grosirMinimumBeli: grosirMinimumBeli,
        varianId1: variant1Type,
        varianId2: variant2Type,
        varianName1: variant1Name,
        varianName2: variant2Name,
        varianStok: variant1Stock,
        varianHarga: variant1Price,
    ));
    debugPrint("mystate $state");
  }

  void reset() => emit(AddProductSupplierState());
}
