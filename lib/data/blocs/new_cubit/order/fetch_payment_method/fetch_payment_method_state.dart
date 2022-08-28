part of 'fetch_payment_method_cubit.dart';

abstract class FetchPaymentMethodState extends Equatable {
  const FetchPaymentMethodState();

  @override
  List<Object> get props => [];
}

class FetchPaymentMethodInitial extends FetchPaymentMethodState {}

class FetchPaymentMethodSuccess extends FetchPaymentMethodState {
  FetchPaymentMethodSuccess(this.paymentMethods);

  final List<PaymentMethod> paymentMethods;

  @override
  List<Object> get props => [paymentMethods];
}

class FetchPaymentMethodLoading extends FetchPaymentMethodState {}

class FetchPaymentMethodFailure extends FetchPaymentMethodState {
  FetchPaymentMethodFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
