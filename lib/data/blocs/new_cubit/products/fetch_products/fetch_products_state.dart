part of 'fetch_products_cubit.dart';

abstract class FetchProductsState extends Equatable {
  const FetchProductsState();

  @override
  List<Object> get props => [];
}

class FetchProductsInitial extends FetchProductsState {}

class FetchProductsLoading extends FetchProductsState {}

class FetchProductsSuccess extends FetchProductsState {
  FetchProductsSuccess(this.products);

  final List<Products> products;

  @override
  List<Object> get props => [products];
}

class FetchProductsFailure extends FetchProductsState {
  final ErrorType type;
  final String message;

  FetchProductsFailure({this.type = ErrorType.general, this.message});

  FetchProductsFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchProductsFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
