part of 'delete_cart_item_cubit.dart';

abstract class DeleteCartItemState extends Equatable {
  const DeleteCartItemState();

  @override
  List<Object> get props => [];
}

class DeleteCartItemInitial extends DeleteCartItemState {}

class DeleteCartItemLoading extends DeleteCartItemState {}

class DeleteCartItemSuccess extends DeleteCartItemState {}

class DeleteCartItemFailure extends DeleteCartItemState {
  final ErrorType type;
  final String message;

  DeleteCartItemFailure({this.type = ErrorType.general, this.message});

  DeleteCartItemFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  DeleteCartItemFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
