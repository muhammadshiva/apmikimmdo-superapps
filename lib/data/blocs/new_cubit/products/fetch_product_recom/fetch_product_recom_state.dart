part of 'fetch_product_recom_cubit.dart';

abstract class FetchProductRecomState extends Equatable {
  const FetchProductRecomState();

  @override
  List<Object> get props => [];
}

class FetchProductRecomInitial extends FetchProductRecomState {}

class FetchProductRecomLoading extends FetchProductRecomState {}

class FetchProductRecomSuccess extends FetchProductRecomState {
  FetchProductRecomSuccess(this.products);

  final List<Products> products;

  @override
  List<Object> get props => [products];
}

class FetchProductRecomFailure extends FetchProductRecomState {
  final ErrorType type;
  final String message;

  FetchProductRecomFailure({this.type = ErrorType.general, this.message});

  FetchProductRecomFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchProductRecomFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
