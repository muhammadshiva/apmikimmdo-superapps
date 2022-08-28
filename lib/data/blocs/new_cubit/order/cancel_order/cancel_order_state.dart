part of 'cancel_order_cubit.dart';

abstract class CancelOrderState extends Equatable {
  const CancelOrderState();

  @override
  List<Object> get props => [];
}

class CancelOrderInitial extends CancelOrderState {}

class CancelOrderLoading extends CancelOrderState {}

class CancelOrderFailure extends CancelOrderState {
  CancelOrderFailure({@required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class CancelOrderSuccess extends CancelOrderState {}
