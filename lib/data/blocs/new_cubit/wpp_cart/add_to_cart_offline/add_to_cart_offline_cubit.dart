import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/data/models/new_models/products.dart';
import 'package:meta/meta.dart';

part 'add_to_cart_offline_state.dart';

class AddToCartOfflineCubit extends Cubit<AddToCartOfflineState> {
  AddToCartOfflineCubit() : super(AddToCartOfflineState());

  void addToCartOffline({
    @required Products product,
    @required int productId,
    @required ProductVariant variantSelected,
  }) {
    final stateCart = state.cart;
    if (stateCart.isEmpty) {
      emit(state.copyWith(
          cart: List<CartResponseElement>.from(state.cart)
            ..add(CartResponseElement(supplier: product.supplier, reseller: product.reseller, products: [
              ProductsCart(
                  id: 1, quantity: 1, productId: productId, product: product, variantSelected: variantSelected)
            ]))));
      // debugPrint("singlert ${state.cart}");
      debugPrint("state1 ${state.cart}");
    } else {
      for (var i = 0; i < stateCart.length; i++) {
        final currentReseller = stateCart[i].reseller;
        final currentProducts = stateCart[i].products;

        for (var p = 0; p < currentProducts.length; p++) {
          // if product_id duplicate
          final cartId = stateCart[i].products[p].id;
          // final theSame = List<CartResponseElement>.from(state.cart)[i].products.map((e) => e.productId == productId).toList().contains(true);
          // kalo supplier sama
          if (currentProducts[p].productId == productId && currentReseller.id == product.reseller.id){
          // if (theSame){
            // inc qty
            final newQty = stateCart[i].products[p].quantity + 1;
            final newProducts = List<CartResponseElement>.from(state.cart)[i].products[p];
            final newProduct = ProductsCart(id: newProducts.id, quantity: newQty, productId: newProducts.productId, product: newProducts.product,variantSelected: variantSelected);

            // replace
            final result = List<CartResponseElement>.from(state.cart)[i].products..removeAt(p)..add(newProduct);
            // emit(state.copyWith(
            //     cart: List<CartResponseElement>.from(state.cart)
            //       ..add(CartResponseElement(supplier: product.supplier, products: result))));

            emit(state.copyWith(
                cart: List<CartResponseElement>.from(state.cart)..removeAt(i)
                  ..add(CartResponseElement(supplier: product.supplier,reseller: product.reseller, products: result))));
            break;
          } else if (currentProducts[p].productId != productId && currentReseller.id == product.reseller.id) {
            final sameProductId = List<CartResponseElement>.from(state.cart)[i].products.map((e) => e.productId == productId).toList().contains(true);
            if (sameProductId) continue;
            // final data = List<CartResponseElement>.from(state.cart)[i].products.singleWhere((element) => element.productId == productId);
            // debugPrint("data ${data is Exception}"); 1 - 2, 1
            // isTheSame++;

            final newCartId = cartId + 1;

            emit(state.copyWith(
                cart: List<CartResponseElement>.from(state.cart)..removeAt(i)..add(CartResponseElement(supplier: null,reseller: product.reseller, products:
                List<ProductsCart>.from(state.cart[i].products)..add(ProductsCart(
                    id: newCartId, quantity: 1, productId: productId, product: product,variantSelected: variantSelected))
                ))));
            debugPrint("state3 ${state.cart}\n\n");

            break;
          } else if (currentReseller.id != product.reseller.id){
            final sameResellerId = List<CartResponseElement>.from(state.cart).map((e) => e.reseller.id == product.reseller.id).toList().contains(true);
            if (sameResellerId) continue;

            final newCartId = cartId + 1;
            emit(state.copyWith(
                cart: List<CartResponseElement>.from(state.cart)
                  ..add(CartResponseElement(supplier: product.supplier,reseller: product.reseller, products:
                  List<ProductsCart>.from([])..add(ProductsCart(
                      id: newCartId, quantity: 1, productId: productId, product: product, variantSelected: variantSelected))
                  ))));
            debugPrint("state4 ${state.cart}\n\n");

            break;
          }
        }
      }
    }
  }

  void deleteProduct(int productId){
    final currentCart = List<CartResponseElement>.from(state.cart);
    List<CartResponseElement> resultCart = [];
    for (var i = 0; i < currentCart.length; i++){
      final currProduct = currentCart[i].products;
      for (var p = 0; p < currProduct.length; p++){
        if (productId == currProduct[p].productId){
          currentCart[i].products.removeWhere((element) => element.productId == productId);
        }
      }
      debugPrint("currCart $currentCart");
      final isEmptyProduct = currentCart[i].products.isEmpty;
      if (isEmptyProduct){
        resultCart = List<CartResponseElement>.from(state.cart)..removeAt(i);
      } else {
        resultCart = List<CartResponseElement>.from(state.cart)..removeAt(i)..add(currentCart[i]);
      }
    }
    debugPrint("resultCart $resultCart");
    emit(AddToCartOfflineState(cart: List<CartResponseElement>.from(resultCart)));
  }

  void reset(){
    emit(AddToCartOfflineState());
  }
}
