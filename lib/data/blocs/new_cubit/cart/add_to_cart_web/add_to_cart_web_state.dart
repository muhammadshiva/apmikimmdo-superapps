part of 'add_to_cart_web_cubit.dart';

abstract class AddToCartWebState extends Equatable {
  const AddToCartWebState();

  @override
  List<Object> get props => [];
}

class AddToCartWebInitial extends AddToCartWebState {}

class AddToCartWebLoading extends AddToCartWebState {}

class AddToCartWebSuccess extends AddToCartWebState {
  //Web
  AddToCartWebSuccess(this.cartProductUpdated);

  final CartProductUpdated cartProductUpdated;

  @override
  List<Object> get props => [cartProductUpdated];
}

class AddToCartWebFailure extends AddToCartWebState {
  AddToCartWebFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

