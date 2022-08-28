part of 'fetch_cart_cubit.dart';

abstract class FetchCartState extends Equatable {
  const FetchCartState();

  @override
  List<Object> get props => [];
}

class FetchCartInitial extends FetchCartState {}

class FetchCartLoading extends FetchCartState {}

class FetchCartSuccess extends FetchCartState {
  FetchCartSuccess({this.cart, this.uncovered});

  final List<CartResponseElement> cart;
  final List<CartResponseElement> uncovered;

  @override
  List<Object> get props => [this.cart, uncovered];

  @override
  String toString() {
    return 'FetchCartSuccess{cart: $cart}';
  }
}

class FetchCartFailure extends FetchCartState {
  final ErrorType type;
  final String message;

  FetchCartFailure({this.type = ErrorType.general, this.message});

  FetchCartFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchCartFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
