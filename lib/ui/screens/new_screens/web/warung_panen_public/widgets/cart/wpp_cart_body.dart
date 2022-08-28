import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/delete_cart_item/delete_cart_item_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cart_store.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/cart/wpp_cart_store.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'wpp_cart_store_uncovered.dart';

class WppCartBody extends StatefulWidget {
  const WppCartBody({Key key, @required this.cart,  this.uncovered})
      : super(key: key);

  final List<CartResponseElement> cart;
  final List<CartResponseElement> uncovered;

  @override
  _WppCartBodyState createState() => _WppCartBodyState();
}

class _WppCartBodyState extends State<WppCartBody> {
  DeleteCartItemCubit _deleteCartItemCubit;
  int totalUncoveredItems = 0;
  List<int> listCartIdUncovered = [];

  @override
  void initState() {
    super.initState();
    _deleteCartItemCubit = DeleteCartItemCubit(
        userDataCubit: BlocProvider.of<UserDataCubit>(context));
    if (widget.uncovered != null){
      totalUncoveredItems = widget.uncovered
          .map((e) => e.products.length)
          .toList()
          .reduce((a, b) => a + b);
      widget.uncovered
          .map((c) =>
          c.products.map((p) => listCartIdUncovered.add(p.id)).toList())
          .toList();
    }
  }

  @override
  void dispose() {
    _deleteCartItemCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<DeleteCartItemCubit, DeleteCartItemState>(
      cubit: _deleteCartItemCubit,
      listener: (context, state) {
        if (state is DeleteCartItemSuccess) {
          context.read<FetchCartCubit>().fetchCart();
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
             widget.cart != null ?
              Column(
                children: [
                  for (var i = 0; i <  widget.cart.length; i++)
                  WppCartStore(
                    resellerName: widget.cart[i].reseller.name,
                    resellerCity: widget.cart[i].reseller.city,
                    cart: widget.cart[i].products,
                    indexStore: i,
                  ),
                ],
              ) : SizedBox(),
            
            SizedBox(
              height: 16,
            ),
            widget.uncovered != null ? Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tidak dapat diproses ($totalUncoveredItems)",
                    style:
                    AppTypo.caption.copyWith(fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<DeleteCartItemCubit, DeleteCartItemState>(
                    cubit: _deleteCartItemCubit,
                    builder: (context, state) {
                      if (state is DeleteCartItemLoading){
                        return CircularProgressIndicator();
                      }
                      return TextButton(
                          onPressed: () {
                            _deleteCartItemCubit.deleteCartItem(
                                listCartId: listCartIdUncovered);
                            // debugPrint(listCartIdUncovered);
                          },
                          child: Text(
                            "Hapus",
                            style: AppTypo.caption
                                .copyWith(color: Theme
                                .of(context)
                                .primaryColor),
                          ));
                    },
                  ),
                ],
              ),
            ) : SizedBox(),
            
            widget.uncovered != null ?
              Column(
                children: [
                  for (var i = 0; i < widget.uncovered.length; i++)
                  WppCartStoreUncovered(
                    resellerName: widget.uncovered[i].reseller.name,
                    resellerCity: widget.uncovered[i].reseller.city,
                    cart: widget.uncovered[i].products,
                    indexStore: i,
                  ),
                ],
              ) : SizedBox()
            
          ],
        ),
      ),
    );
  }
}
