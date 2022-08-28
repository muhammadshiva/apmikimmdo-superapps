part of 'add_product_toko_saya_cubit.dart';

abstract class AddProductTokoSayaState extends Equatable {
  const AddProductTokoSayaState();

  @override
  List<Object> get props => [];
}

class AddProductTokoSayaInitial extends AddProductTokoSayaState {}

class AddProductTokoSayaLoading extends AddProductTokoSayaState {}

class AddProductTokoSayaSuccess extends AddProductTokoSayaState {
  AddProductTokoSayaSuccess(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class AddProductTokoSayaFailure extends AddProductTokoSayaState {
  AddProductTokoSayaFailure(this.result);

  final String result;

  @override
  List<Object> get props => [result];
}




