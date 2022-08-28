part of 'change_payment_method_cubit.dart';

abstract class ChangePaymentMethodState extends Equatable {
  const ChangePaymentMethodState();

  @override
  List<Object> get props => [];
}

class ChangePaymentMethodInitial extends ChangePaymentMethodState {}

class ChangePaymentMethodSuccess extends ChangePaymentMethodState {
  ChangePaymentMethodSuccess(this.data);

  final GeneralOrderResponseData data;

  @override
  List<Object> get props => [data];
}

class ChangePaymentMethodLoading extends ChangePaymentMethodState {}

class ChangePaymentMethodFailure extends ChangePaymentMethodState {
  ChangePaymentMethodFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
