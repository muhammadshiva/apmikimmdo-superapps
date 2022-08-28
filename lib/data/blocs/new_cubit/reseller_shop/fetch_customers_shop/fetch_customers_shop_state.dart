part of 'fetch_customers_shop_cubit.dart';

abstract class FetchCustomersShopState extends Equatable {
  const FetchCustomersShopState();

  @override
  List<Object> get props => [];
}

class FetchCustomersShopInitial extends FetchCustomersShopState {}

class FetchCustomersShopLoading extends FetchCustomersShopState {}

class FetchCustomersShopSuccess extends FetchCustomersShopState {
  FetchCustomersShopSuccess(this.customers);

  final List<TokoSayaCustomer> customers;

  @override
  List<Object> get props => [customers];
}

class FetchCustomersShopFailure extends FetchCustomersShopState {
  FetchCustomersShopFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
