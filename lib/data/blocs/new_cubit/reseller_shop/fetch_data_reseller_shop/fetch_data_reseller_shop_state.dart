part of 'fetch_data_reseller_shop_cubit.dart';

abstract class FetchDataResellerShopState extends Equatable {
  const FetchDataResellerShopState();

  @override
  List<Object> get props => [];
}

class FetchDataResellerShopInitial extends FetchDataResellerShopState {}

class FetchDataResellerShopLoading extends FetchDataResellerShopState {}

class FetchDataResellerShopSuccess extends FetchDataResellerShopState {
  FetchDataResellerShopSuccess({this.reseller, this.listWarung});

  final Reseller reseller;
  final List<Reseller> listWarung;

  @override
  List<Object> get props => [reseller,listWarung];
}

class FetchDataResellerShopFailure extends FetchDataResellerShopState {
  FetchDataResellerShopFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}


