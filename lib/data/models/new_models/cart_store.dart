class CartStore {
  final bool checked;
  final double total;
  final int sellerId;
  final int resellerId;
  final String nameSeller;
  final List<CartItem> item;

  CartStore({
    this.checked = true,
    this.total,
    this.sellerId,
    this.resellerId,
    this.item,
    this.nameSeller,
  });

  CartStore copyWith({
    bool checked,
    double total,
    int sellerId,
    int resellerId,
    String nameSeller,
    List<CartItem> item,
  }) {
    return CartStore(
      checked: checked ?? this.checked,
      total: total ?? this.total,
      sellerId: sellerId ?? this.sellerId,
      resellerId: resellerId ?? this.resellerId,
      nameSeller: nameSeller ?? this.nameSeller,
      item: item ?? this.item,
    );
  }

  @override
  String toString() {
    return 'CartStore{checked: $checked, total: $total, item len: ${item.length} item: $item}';
  }
}

class CartItem {
  final bool checked;
  final int subTotal;
  final int price;
  final int qty;
  final int stock;
  final int cartId;
  final int productId;

  CartItem({
    this.checked = true,
    this.subTotal,
    this.qty = 1,
    this.price,
    this.stock,
    this.cartId,
    this.productId,
  });

  CartItem copyWith({
    bool checked,
    int subTotal,
    int qty,
    int price,
    int stock,
    int cartId,
    int productId,
  }) {
    return CartItem(
      checked: checked ?? this.checked,
      subTotal: subTotal ?? this.subTotal,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      stock: stock ?? this.stock,
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
    );
  }

  @override
  String toString() {
    return 'CartItem{checked: $checked}';
  }
}