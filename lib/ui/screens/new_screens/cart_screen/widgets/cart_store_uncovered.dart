import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/inc_dec_cart/inc_dec_cart_cubit.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_store_item_uncovered.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/rounded_container.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class CartStoreUncovered extends StatelessWidget {
  const CartStoreUncovered({
    Key key,
    @required this.resellerName,
    @required this.resellerCity,
    @required this.cart,
    this.indexStore,
  }) : super(key: key);

  final String resellerName;
  final String resellerCity;
  final List<ProductsCart> cart;
  final int indexStore;

  @override
  Widget build(BuildContext context) {

    return RoundedContainer(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resellerName,
                style:
                AppTypo.caption.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                resellerCity,
                style: AppTypo.caption.copyWith(color: Colors.grey),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var p = 0; p < cart.length; p++)
                CartStoreItemUncovered(
                  id: cart[p].id,
                  productId: cart[p].productId,
                  variantSelected: cart[p].product.productVariant.length > 0 ? cart[p].product.productVariant[0].variantName : null,
                  indexStore: indexStore,
                  indexItem: p,
                  image: "images/img_outofstock.png",
                  nama: cart[p].product.name,
                  harga: cart[p].product.productVariant.length > 0 ? cart[p].product.productVariant[0].variantDisc != 0 ?  cart[p].product.productVariant[0].variantDiscPrice :  cart[p].product.productVariant[0].variantSellPrice  : cart[p].product.discPrice != 0 ? cart[p].product.discPrice : cart[p].product.sellingPrice,
                )
            ],
          ),
        ],
      ),
    );
  }
}
