import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/inc_dec_cart/inc_dec_cart_cubit.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_store_item.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/rounded_container.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class CartStore extends StatelessWidget {
  const CartStore({
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
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              BlocBuilder<IncDecCartCubit, IncDecCartState>(
                builder: (context, state) {
                  return Checkbox(
                      value: state.store[indexStore].checked,
                      activeColor: AppColor.primary,
                      onChanged: (value) {
                        List<int> listPrice = [];

                        for (var c = 0;
                            c < state.store[indexStore].item.length;
                            c++) {
                          if (!state.store[indexStore].item[c].checked) {
                            debugPrint(
                                "listprice item checked = ${cart[c].product.sellingPrice}");
                            listPrice.add(cart[c].product.sellingPrice);
                            continue;
                          } else {
                            debugPrint(
                                "listprice item unchecked = ${cart[c].product.sellingPrice}");
                            listPrice.add(cart[c].product.sellingPrice);
                            // continue;
                          }
                        }

                        /*for (var c in cart) {
                          listPrice.add(c.enduserPrice);
                        }*/
                        debugPrint("listPrice $listPrice");
                        context.read<IncDecCartCubit>().updateCheckedStore(
                            value: value, indexStore: indexStore);
                      });
                },
              ),
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
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Column(
            children: [
              for (var p = 0; p < cart.length; p++)
                CartStoreItem(
                  id: cart[p].id,
                  productId: cart[p].productId,
                  indexStore: indexStore,
                  indexItem: p,
                  variantSelected: cart[p].product.productVariant.length > 0 ? cart[p].product.productVariant[0].variantName : null,
                  image: cart[p].product.coverPhoto,
                  nama: cart[p].product.name,
                  harga: cart[p].product.productVariant.length > 0 ? cart[p].product.productVariant[0].variantDisc != 0 ?  cart[p].product.productVariant[0].variantDiscPrice :  cart[p].product.productVariant[0].variantSellPrice  : cart[p].product.discPrice != 0 ? cart[p].product.discPrice : cart[p].product.sellingPrice,
                ),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Total Pembelian",
                style: AppTypo.caption.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: BlocBuilder<IncDecCartCubit, IncDecCartState>(
              builder: (context, state) {
                debugPrint("anu build");
                return Text(
                  "Rp ${AppExt.toRupiah(state.store[indexStore].total.toInt() ?? 0)}",
                  style: AppTypo.subtitle2.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
