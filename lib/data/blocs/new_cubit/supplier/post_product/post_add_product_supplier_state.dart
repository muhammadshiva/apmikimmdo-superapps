part of 'post_add_product_supplier_cubit.dart';

abstract class PostAddProductSupplierState extends Equatable {
  const PostAddProductSupplierState();

  @override
  List<Object> get props => [];
}

class PostAddProductSupplierInitial extends PostAddProductSupplierState {}

class PostAddProductSupplierLoading extends PostAddProductSupplierState {}

class PostAddProductSupplierSuccess extends PostAddProductSupplierState {
  PostAddProductSupplierSuccess(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class PostAddProductSupplierFailure extends PostAddProductSupplierState {
  PostAddProductSupplierFailure(this.result);

  final String result;

  @override
  List<Object> get props => [result];
}