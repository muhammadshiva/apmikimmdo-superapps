part of 'add_to_cart_offline_cubit.dart';

class AddToCartOfflineState {
  final List<CartResponseElement> cart;

  const AddToCartOfflineState({
    this.cart = const [],
  });

  AddToCartOfflineState copyWith({
    List<CartResponseElement> cart,
  }) {
    return AddToCartOfflineState(
      cart: cart ?? this.cart,
    );
  }

  @override
  String toString() {
    return 'AddToCartOfflineState{cart: $cart}';
  }
}
