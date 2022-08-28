part of 'edit_profile_supplier_cubit.dart';

abstract class EditProfileSupplierState extends Equatable {
  const EditProfileSupplierState();

  @override
  List<Object> get props => [];
}

class EditProfileSupplierInitial extends EditProfileSupplierState {}

class EditProfileSupplierLoading extends EditProfileSupplierState {}

class EditProfileSupplierSuccess extends EditProfileSupplierState {}

class EditProfileSupplierFailure extends EditProfileSupplierState {
  EditProfileSupplierFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
