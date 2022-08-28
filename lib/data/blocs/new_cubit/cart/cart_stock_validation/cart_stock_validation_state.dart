part of 'cart_stock_validation_cubit.dart';

abstract class CartStockValidationState extends Equatable {
  const CartStockValidationState();

  @override
  List<Object> get props => [];
}

class CartStockValidationInitial extends CartStockValidationState {}

class CartStockValidationLoading extends CartStockValidationState {}

class CartStockValidationSuccess extends CartStockValidationState {}

class CartStockValidationFailure extends CartStockValidationState {
  final ErrorType type;
  final String message;

  CartStockValidationFailure({this.type = ErrorType.general, this.message});

  CartStockValidationFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  CartStockValidationFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
