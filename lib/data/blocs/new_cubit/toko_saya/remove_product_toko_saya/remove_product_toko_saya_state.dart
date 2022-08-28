part of 'remove_product_toko_saya_cubit.dart';

abstract class RemoveProductTokoSayaState extends Equatable {
  const RemoveProductTokoSayaState();

  @override
  List<Object> get props => [];
}

class RemoveProductTokoSayaInitial extends RemoveProductTokoSayaState {}

class RemoveProductTokoSayaLoading extends RemoveProductTokoSayaState {}

class RemoveProductTokoSayaSuccess extends RemoveProductTokoSayaState {
  RemoveProductTokoSayaSuccess(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class RemoveProductTokoSayaFailure extends RemoveProductTokoSayaState {
  RemoveProductTokoSayaFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}



