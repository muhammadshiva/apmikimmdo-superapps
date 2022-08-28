part of 'fetch_products_by_seller_cubit.dart';

abstract class FetchProductsBySellerState extends Equatable {
  const FetchProductsBySellerState();

  @override
  List<Object> get props => [];
}

class FetchProductsBySellerInitial extends FetchProductsBySellerState {}

class FetchProductsBySellerLoading extends FetchProductsBySellerState {}

class FetchProductsBySellerSuccess extends FetchProductsBySellerState {
  FetchProductsBySellerSuccess(this.products);

  final List<Products> products;

  @override
  List<Object> get props => [products];
}

class FetchProductsBySellerFailure extends FetchProductsBySellerState {
  final ErrorType type;
  final String message;

  FetchProductsBySellerFailure({this.type = ErrorType.general, this.message});

  FetchProductsBySellerFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchProductsBySellerFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
