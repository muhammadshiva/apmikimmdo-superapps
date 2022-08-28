part of 'fetch_products_reseller_shop_cubit.dart';

abstract class FetchProductsResellerShopState extends Equatable {
  const FetchProductsResellerShopState();

  @override
  List<Object> get props => [];
}

class FetchProductsResellerShopInitial extends FetchProductsResellerShopState {}

class FetchProductsResellerShopLoading extends FetchProductsResellerShopState {}

class FetchProductsResellerShopSuccess extends FetchProductsResellerShopState {
  FetchProductsResellerShopSuccess({this.resellerProducts});

  final List<Products> resellerProducts;
  

  @override
  List<Object> get props => [resellerProducts];
}

class FetchProductsResellerShopFailure extends FetchProductsResellerShopState {

  final ErrorType type;
  final String message;

  FetchProductsResellerShopFailure({this.type = ErrorType.general, this.message});

  FetchProductsResellerShopFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchProductsResellerShopFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}


