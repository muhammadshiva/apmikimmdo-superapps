part of 'edit_stock_product_supplier_cubit.dart';

abstract class EditStockProductSupplierState extends Equatable {
  const EditStockProductSupplierState();

  @override
  List<Object> get props => [];
}

class EditStockProductSupplierInitial extends EditStockProductSupplierState {}

class EditStockProductSupplierLoading extends EditStockProductSupplierState {}

class EditStockProductSupplierSuccess extends EditStockProductSupplierState {}

class EditStockProductSupplierFailure extends EditStockProductSupplierState {
  final ErrorType type;
  final String message;

  EditStockProductSupplierFailure(
      {this.type = ErrorType.general, this.message});

  EditStockProductSupplierFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  EditStockProductSupplierFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
