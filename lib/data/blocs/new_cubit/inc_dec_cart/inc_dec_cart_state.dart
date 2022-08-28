part of 'inc_dec_cart_cubit.dart';

class IncDecCartState {
  final double total;
  final List<CartStore> store;
  final List<double> subTotal;
  final bool checked;

  const IncDecCartState({
    this.total = 0,
    this.store,
    this.subTotal = const [],
    this.checked = false,
  });

  @override
  String toString() {
    return 'IncDecCartState{total: $total, subTotal: $subTotal, checked: $checked, store $store}';
  }

  IncDecCartState copyWith({
    double total,
    List<CartStore> store,
    List<double> subTotal,
    bool checked,
  }) {
    return IncDecCartState(
      total: total ?? this.total,
      store: store ?? this.store,
      subTotal: subTotal ?? this.subTotal,
      checked: checked ?? this.checked,
    );
  }
}
