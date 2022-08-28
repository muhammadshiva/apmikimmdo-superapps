import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/cart.dart';
import 'package:marketplace/data/models/new_models/cart_store.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:meta/meta.dart';

part 'inc_dec_cart_state.dart';

class IncDecCartCubit extends Cubit<IncDecCartState> {
  IncDecCartCubit() : super(IncDecCartState());

  void initialization(List<CartResponseElement> cart, bool isSupplier) {
    debugPrint("init");
    _reset();
    debugPrint("mycart $cart");

    List<double> subTotal = [];

    double total = 0;
    // final List<bool> checkedItem = [];
    List<CartStore> checkedStore = [];

    for (var c = 0; c < cart.length; c++) {
      List<CartItem> checkedItem = [];
      var _total = 0.0;
      for (var p = 0; p < cart[c].products.length; p++) {
        final qty = cart[c].products[p].quantity;
        final stock = cart[c].products[p].product.stock;
        final _subTotal = (cart[c].products[p].product.discPrice != 0 ? cart[c].products[p].product.discPrice : cart[c].products[p].product.sellingPrice) * qty;
        final _price = cart[c].products[p].product.discPrice != 0 ? cart[c].products[p].product.discPrice : cart[c].products[p].product.sellingPrice ;
        final _cartId = cart[c].products[p].id;
        final _productId = cart[c].products[p].product.id;
        // _total += cart[c].products[p].product.sellingPrice * qty; // init all checked items

        checkedItem.add(CartItem(
            cartId: _cartId,
            productId: _productId,
            checked: false,
            qty: qty,
            stock: stock,
            subTotal: _subTotal,
            price: _price));
        /*ListBoolCartStore(
            store: true, item: ListBoolCartStoreItem(item: true, true));*/
      }
      if (isSupplier == true) {
        final _sellerId = cart[c].supplier.id;
      checkedStore
          .add(CartStore(checked: false, total: _total, sellerId: _sellerId, resellerId: null, nameSeller: cart[c].supplier.name, item: checkedItem,),);
      }else{
        final _sellerId = cart[c].supplier != null ? cart[c].supplier.id : 0 ;
        final _resellerId = cart[c].reseller != null ? cart[c].reseller.id : 0 ;
      checkedStore
          .add(CartStore(checked: false, total: _total, sellerId: _sellerId, resellerId: _resellerId, nameSeller: cart[c].reseller.name, item: checkedItem,),);
      }
      
      subTotal.add(_total);
      total += _total;
    }
    debugPrint(
        "total $total, subTotal $subTotal, store $checkedStore");
    emit(IncDecCartState(
        total: total,
        // total: 0,
        subTotal: subTotal,
        checked: false,
        store: checkedStore));
    debugPrint("mystate $state");
  }

  void _reset() => emit(IncDecCartState());

  void increment(
      {int value, int indexStore, int indexItem, List<CartStore> myStore}) {
    final _state = this.state;
    var store = myStore ?? _state.store;
    var item = store[indexStore].item;

    debugPrint("qty ${store[indexStore].item[indexItem].qty}");
    // final subTotal = store[indexStore].total + value;

    // final subTotal = incrementQty * store[indexStore].item[indexItem].price;
    int subTotal = 0;
    double total = store[indexStore].total;
    if (value != null) {
      final incrementQty = store[indexStore].item[indexItem].qty;
      // subTotal = (store[indexStore].total + value).toInt();
      subTotal = (store[indexStore].total + value).toInt();
      debugPrint("just increment $subTotal");
      var tempItem = store[indexStore].item[indexItem].copyWith(
          qty: incrementQty,
          subTotal: store[indexStore].item[indexItem].subTotal);
      item[indexItem] = tempItem;
      total = subTotal.toDouble();
    } else {
      final incrementQty = store[indexStore].item[indexItem].qty + 1;
      // subTotal = incrementQty * store[indexStore].item[indexItem].price;
      if (store[indexStore].item[indexItem].checked){
        subTotal = store[indexStore].item[indexItem].price;
        debugPrint("just increment $subTotal");
        var tempItem = store[indexStore]
            .item[indexItem]
            .copyWith(qty: incrementQty, subTotal: subTotal.toInt());
        item[indexItem] = tempItem;

        total += subTotal.toDouble();
      } else {
        var tempItem = store[indexStore]
            .item[indexItem]
            .copyWith(qty: incrementQty, subTotal: subTotal.toInt());
        item[indexItem] = tempItem;

        total += subTotal.toDouble();
      }
    }

    /*double total = 0;
    for (var i in item) {
      total += i.subTotal;
    }*/

    var tempStore = store[indexStore].copyWith(total: total, item: item);
    store[indexStore] = tempStore;

    emit(state.copyWith(store: store));
    debugPrint(state.toString());
  }

  void decrement(
      {int value, int indexStore, int indexItem, List<CartStore> myStore}) {
    final _state = this.state;
    var store = myStore ?? _state.store;
    var item = store[indexStore].item;

    // final subTotal = store[indexStore].total - value;

    // final subTotal = incrementQty * store[indexStore].item[indexItem].price;
    int subTotal = 0;
    double total = store[indexStore].total;
    if (value != null) {
      final incrementQty = store[indexStore].item[indexItem].qty;
      subTotal = (store[indexStore].total - value).toInt();
      debugPrint("just decrement $subTotal");
      // subTotal = value;
      var tempItem = store[indexStore].item[indexItem].copyWith(
          qty: incrementQty,
          subTotal: store[indexStore].item[indexItem].subTotal);
      item[indexItem] = tempItem;
      total = subTotal.toDouble();
    } else {
      // subTotal = incrementQty * store[indexStore].item[indexItem].price;
      final incrementQty = store[indexStore].item[indexItem].qty - 1;
      if (store[indexStore].item[indexItem].checked){
        subTotal = store[indexStore].item[indexItem].price;
        debugPrint("just decrement $subTotal");
        var tempItem = store[indexStore]
            .item[indexItem]
            .copyWith(qty: incrementQty, subTotal: subTotal.toInt());
        item[indexItem] = tempItem;

        total -= subTotal;
      } else {
        var tempItem = store[indexStore]
            .item[indexItem]
            .copyWith(qty: incrementQty, subTotal: subTotal.toInt());
        item[indexItem] = tempItem;

        total += subTotal.toDouble();
      }
    }

    /*var tempItem = store[indexStore]
        .item[indexItem]
        .copyWith(qty: incrementQty, subTotal: subTotal.toInt());
    item[indexItem] = tempItem;*/

    /// find sum
    /*double total = store[indexStore].total;
    for (var i in item) {
      total -= i.subTotal;
    }*/

    var tempStore = store[indexStore].copyWith(total: total, item: item);
    store[indexStore] = tempStore;

    emit(state.copyWith(store: store));
    debugPrint(state.toString());
  }

  void updateAllItem({@required bool value}){
    final _state = this.state;
    final store = _state.store;
    emit(state.copyWith(checked: value));
    for (var c = 0; c < store.length; c++){
      if (value){
        updateCheckedStore(value: true, indexStore: c);
      } else {
        updateCheckedStore(value: false, indexStore: c);
      }
    }
  }

  void updateCheckedStore({
    @required bool value,
    @required int indexStore,

  }) {
    final _state = this.state;
    final store = _state.store;
    final item = _state.store[indexStore].item;

    final tempStore = store[indexStore].copyWith(checked: value);
    store[indexStore] = tempStore;

    _checkStoreStatus();

    /// increment
    if (store[indexStore].checked == value && store[indexStore].checked) {
      for (var c = 0; c < store[indexStore].item.length; c++) {
        debugPrint("item store ${item[c]}");

        int subTotal = 0;
        if (store[indexStore].item[c].checked) {
          continue;
        } else {
          // subTotal = store[indexStore].item[c].subTotal;
          updateCheckedStoreItem(
              value: true, indexStore: indexStore, indexItem: c);
        }

        /*final tempItem =
            item[c].copyWith(checked: value, subTotal: item[c].price);
        item[c] = tempItem;
        var tempStore = store[indexStore].copyWith(checked: value, item: item);
        store[indexStore] = tempStore;
        debugPrint("my inc store $store");

        increment(
            // value: price[c],
            // value: store[indexStore].total.toInt(),
            value: subTotal,
            indexStore: indexStore,
            indexItem: c,
            myStore: store);*/
      }
    } else if (store[indexStore].checked == value &&
        !store[indexStore].checked) {
      int price = 0;
      for (var c = 0; c < store[indexStore].item.length; c++) {
        int subTotal = 0;
        if (!store[indexStore].item[c].checked) {
          continue;
        } else {
          // subTotal = store[indexStore].item[c].subTotal;

          updateCheckedStoreItem(
              value: false, indexStore: indexStore, indexItem: c);
        }
        /*int subTotal = 0;
        if (!store[indexStore].item[c].checked) {
          continue;
        } else {
          subTotal = store[indexStore].item[c].subTotal;
        }

        final tempItem = item[c].copyWith(
          checked: value,
        );
        item[c] = tempItem;
        var tempStore = store[indexStore].copyWith(checked: value, item: item);
        store[indexStore] = tempStore;
        debugPrint("store dec $store");

        decrement(
            // value: price[c],
            // value: store[indexStore].total.toInt(),
            value: subTotal,
            indexStore: indexStore,
            indexItem: c,
            myStore: store);*/
      }
    }
  }

  void updateCheckedStoreItem({
    @required bool value,
    @required int indexStore,
    @required int indexItem,
  }) {
    final _state = this.state;
    final store = _state.store;
    final item = _state.store[indexStore].item;

    var tempItem = item[indexItem].copyWith(checked: value);
    item[indexItem] = tempItem;

    var tempStore = store[indexStore].copyWith(item: item);
    store[indexStore] = tempStore;

    debugPrint("myulu store $store");

    List<bool> listCheck = [];
    for (var i = 0; i < store[indexStore].item.length; i++) {
      listCheck.add(store[indexStore].item[i].checked);
    }

    /// if all items is checked
    final allItemsIsChecked =
        listCheck.where((element) => element == true).toList().length ==
            listCheck.length;
    if (allItemsIsChecked) {
      tempStore = store[indexStore].copyWith(checked: true);
      store[indexStore] = tempStore;
    }

    /// if all items is unchecked
    final allItemsIsUnChecked =
        listCheck.where((element) => element == false).toList().length ==
            listCheck.length;
    if (allItemsIsUnChecked || !value) {
      tempStore = store[indexStore].copyWith(checked: false);
      store[indexStore] = tempStore;
      emit(state.copyWith(checked: false));
    }

    _checkStoreStatus();

    /*debugPrint(
        "value $value, indexStore $indexStore, indexItem $indexItem, store $store");

    debugPrint("store ${store[indexStore].item[indexItem].checked} val $value");*/

    // tambah
    if (store[indexStore].item[indexItem].checked == value &&
        store[indexStore].item[indexItem].checked) {
      debugPrint("tambah store item $store");
      final tempItem1 = store[indexStore]
          .item[indexItem]
          .copyWith(qty: store[indexStore].item[indexItem].qty, subTotal: store[indexStore].item[indexItem].price * store[indexStore].item[indexItem].qty);
      item[indexItem] = tempItem1;
      final tempStore1 = store[indexStore].copyWith(item: item);
      store[indexStore] = tempStore1;

      increment(
          value: store[indexStore].item[indexItem].subTotal,
          indexStore: indexStore,
          indexItem: indexItem,
          myStore: store);
    } else if (store[indexStore].item[indexItem].checked == value &&
        !store[indexStore].item[indexItem].checked) {
      debugPrint("dec store item $store");
      if (store[indexStore].item[indexItem].qty > 1) {
        debugPrint(
            "store[indexStore].total ${store[indexStore].total} - dec ${(store[indexStore].item[indexItem].qty - 1) *
                store[indexStore].item[indexItem].price} = total ${store[indexStore].total - (store[indexStore].item[indexItem].qty - 1) * store[indexStore].item[indexItem].price}");
        final tempTotal = store[indexStore].total -
            (store[indexStore].item[indexItem].qty) *
                store[indexStore].item[indexItem].price;
        final tempItem1 = store[indexStore].item[indexItem].copyWith(subTotal: 0);
        item[indexItem] = tempItem1;
        final tempStore1 =
            store[indexStore].copyWith(total: tempTotal.toDouble(), item: item);
        store[indexStore] = tempStore1;
      }

      debugPrint("temp store dec $store");

      decrement(
          value: store[indexStore].item[indexItem].subTotal,
          indexStore: indexStore,
          indexItem: indexItem,
          myStore: store);
    }

    debugPrint("state $state");
  }

  void _checkStoreStatus(){
    final store = this.state.store;
    int totalStoreChecked = 0;
    int totalStoreUnchecked = 0;
    for (var c = 0; c < store.length; c++){
      if (store[c].checked){
        totalStoreChecked++;
      }
    }

    for (var c = 0; c < store.length; c++){
      if (!store[c].checked){
        totalStoreUnchecked++;
      }
    }
    if (totalStoreChecked == store.length){
      emit(state.copyWith(checked: true));
    }

    if (totalStoreUnchecked == store.length){
      emit(state.copyWith(checked: false));
    }
  }

  void _unchecked() {}
}
