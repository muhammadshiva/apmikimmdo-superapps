part of 'update_quantity_cubit.dart';

abstract class UpdateQuantityState extends Equatable {
  const UpdateQuantityState();

  @override
  List<Object> get props => [];
}

class UpdateQuantityInitial extends UpdateQuantityState {}

class UpdateQuantityLoading extends UpdateQuantityState {}

class UpdateQuantitySuccess extends UpdateQuantityState {}

class UpdateQuantityFailure extends UpdateQuantityState {
  final ErrorType type;
  final String message;

  UpdateQuantityFailure({this.type = ErrorType.general, this.message});

  UpdateQuantityFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  UpdateQuantityFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
