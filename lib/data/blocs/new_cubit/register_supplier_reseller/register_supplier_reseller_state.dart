part of 'register_supplier_reseller_cubit.dart';

@immutable
abstract class RegisterSupplierResellerState extends Equatable {
  const RegisterSupplierResellerState();

  @override
  List<Object> get props => [];
}

class RegisterSupplierResellerInitial extends RegisterSupplierResellerState {}

class RegisterSupplierResellerLoading extends RegisterSupplierResellerState {}

class RegisterSupplierResellerSuccess extends RegisterSupplierResellerState {}

class RegisterSupplierResellerFailure extends RegisterSupplierResellerState {
  final ErrorType type;
  final String message;

  RegisterSupplierResellerFailure({this.type = ErrorType.general, this.message});

  RegisterSupplierResellerFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  RegisterSupplierResellerFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
