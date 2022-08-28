part of 'add_order_cubit.dart';

abstract class AddOrderState extends Equatable {
  const AddOrderState();

  @override
  List<Object> get props => [];
}

class AddOrderInitial extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

class AddOrderSuccess extends AddOrderState {
  AddOrderSuccess(this.data);
  final GeneralOrderResponseData data;

  @override
  List<Object> get props => [data];
}

class AddOrderFailure extends AddOrderState {
  AddOrderFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
