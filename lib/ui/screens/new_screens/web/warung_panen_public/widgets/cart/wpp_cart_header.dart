import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/delete_cart_item/delete_cart_item_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/inc_dec_cart/inc_dec_cart_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class WppCartHeader extends StatefulWidget {
  const WppCartHeader({Key key}) : super(key: key);

  @override
  _WppCartHeaderState createState() => _WppCartHeaderState();
}

class _WppCartHeaderState extends State<WppCartHeader> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<IncDecCartCubit, IncDecCartState>(
                builder: (context, state) {
                  return Checkbox(
                    value: state.checked,
                    onChanged: (bool value) {
                      context
                          .read<IncDecCartCubit>()
                          .updateAllItem(value: value);
                    },
                  );
                },
              ),
              Text(
                "Pilih Semua",
                style: AppTypo.caption,
              )
            ],
          ),
          // BlocBuilder<DeleteCartItemCubit, DeleteCartItemState>(
          //   cubit: _deleteCartItemCubit,
          //   builder: (context, state) {
          //     if (state is DeleteCartItemLoading){
          //       return CircularProgressIndicator();
          //     }
          //     return TextButton(
          //         onPressed: () {
          //           final cart = context.read<IncDecCartCubit>().state.store;
          //           List<int> productId = [];
          //           for (var stores in cart) {
          //             for (var items in stores.item) {
          //               if (items.checked) {
          //                 productId.add(items.cartId);
          //               }
          //             }
          //           }
          //           _deleteCartItemCubit.deleteCartItem(
          //               listCartId: productId);
          //         },
          //         child: Text(
          //           "Hapus",
          //           style: AppTypo.caption
          //               .copyWith(color: Theme.of(context).primaryColor),
          //         ));
          //   },
          // )
        ],
      ),
    );
  }
}
