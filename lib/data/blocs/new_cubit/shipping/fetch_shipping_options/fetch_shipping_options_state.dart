part of 'fetch_shipping_options_cubit.dart';

abstract class FetchShippingOptionsState extends Equatable {
  const FetchShippingOptionsState();

  @override
  List<Object> get props => [];
}

class FetchShippingOptionsInitial extends FetchShippingOptionsState {}

class FetchShippingOptionsLoading extends FetchShippingOptionsState {}

class FetchShippingOptionsSuccess extends FetchShippingOptionsState {
  FetchShippingOptionsSuccess(this.data);

  final List<ShippingOptionItem> data;

  @override
  List<Object> get props => [data];

  @override
  String toString() => '$data';
}

class FetchShippingOptionsFailure extends FetchShippingOptionsState {
  FetchShippingOptionsFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  String toString() => '$message';
}
