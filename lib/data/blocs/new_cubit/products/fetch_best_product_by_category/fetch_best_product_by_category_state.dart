part of 'fetch_best_product_by_category_cubit.dart';

abstract class FetchBestProductByCategoryState extends Equatable {
  const FetchBestProductByCategoryState();

  @override
  List<Object> get props => [];
}

class FetchBestProductByCategoryInitial extends FetchBestProductByCategoryState {}

class FetchBestProductByCategoryLoading extends FetchBestProductByCategoryState {}

class FetchBestProductByCategorySuccess extends FetchBestProductByCategoryState {
  FetchBestProductByCategorySuccess(this.products);

  final List<Products> products;

  @override
  List<Object> get props => [products];
}

class FetchBestProductByCategoryFailure extends FetchBestProductByCategoryState {
  final ErrorType type;
  final String message;

  FetchBestProductByCategoryFailure({this.type = ErrorType.general, this.message});

  FetchBestProductByCategoryFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchBestProductByCategoryFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}

