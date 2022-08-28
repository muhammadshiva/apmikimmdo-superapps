import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/repositories/new_repositories/join_user_repository.dart';
import 'package:meta/meta.dart';

part 'post_add_product_supplier_state.dart';

class PostAddProductSupplierCubit extends Cubit<PostAddProductSupplierState> {
  PostAddProductSupplierCubit() : super(PostAddProductSupplierInitial());

  final JoinUserRepository _joinRepository = JoinUserRepository();

  Future<void> addProduct(
      {@required String name,
        @required int categoryId,
        @required int weight,
        @required String unit,
        @required int price,
        @required int stock,
        @required String description,
        @required int commision,
        @required String link,
        @required List<String> productPhoto,
        @required List<Uint8List> productPhotoByte,
        @required List<int> hargaGrosir,
        @required List<int> minimumOrder,
        @required List<String> varianType,
        @required List<String> varianName,
        @required List<int> varianPrice,
        @required List<int> varianStock}) async {
    emit(PostAddProductSupplierLoading());
    try {
      final response = await _joinRepository.addProductSupplier(
          name: name,
          categoryId: categoryId,
          weight: weight,
          unit: unit,
          price: price,
          stock: stock,
          description: description,
          commision: commision,
          link: link,
          productPhoto: productPhoto,
          productPhotoByte: productPhotoByte,
          hargaGrosir: hargaGrosir,
          minimumOrder: minimumOrder,
          varianType: varianType,
          varianName: varianName,
          varianPrice: varianPrice,
          varianStock: varianStock);
      emit(PostAddProductSupplierSuccess(response.message));
    } catch (error) {
      emit(PostAddProductSupplierFailure(error.toString()));
    }
    debugPrint(state.toString());
  }

  Future<void> editProduct(
      {
        @required int productId,
        @required String name,
        @required int categoryId,
        @required int weight,
        @required String unit,
        @required int price,
        @required int stock,
        @required String description,
        @required int commision,
        @required String link,
        @required List<String> productPhoto,
        @required List<Uint8List> productPhotoByte,
        @required List<int> hargaGrosir,
        @required List<int> minimumOrder,
        @required List<String> varianType,
        @required List<String> varianName,
        @required List<int> varianPrice,
        @required List<int> varianStock}) async {
    emit(PostAddProductSupplierLoading());
    try {
      final response = await _joinRepository.updateProductSupplier(
          productId: productId,
          name: name,
          categoryId: categoryId,
          weight: weight,
          unit: unit,
          price: price,
          stock: stock,
          description: description,
          commision: commision,
          link: link,
          productPhoto: productPhoto,
          productPhotoByte: productPhotoByte,
          hargaGrosir: hargaGrosir,
          minimumOrder: minimumOrder,
          varianType: varianType,
          varianName: varianName,
          varianPrice: varianPrice,
          varianStock: varianStock);
      emit(PostAddProductSupplierSuccess(response.message));
    } catch (error) {
      emit(PostAddProductSupplierFailure(error.toString()));
    }
  }
}