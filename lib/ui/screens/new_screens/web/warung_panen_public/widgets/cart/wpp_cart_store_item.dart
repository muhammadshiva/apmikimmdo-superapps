import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/delete_cart_item/delete_cart_item_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/inc_dec_cart/inc_dec_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/wpp_cart/add_to_cart_offline/add_to_cart_offline_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cache_image.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/widgets/cart/wpp_product_image.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppCartStoreItem extends StatefulWidget {
  const WppCartStoreItem({
    Key key,
    @required this.image,
    @required this.nama,
    @required this.harga,
    @required this.id,
    @required this.variantSelected,
    this.indexItem,
    this.indexStore,
    this.productId,
  }) : super(key: key);

  final String image;
  final String nama;
  final String variantSelected;
  final int harga;
  final int id;
  final int indexStore;
  final int indexItem;

  final int productId;

  @override
  _WppCartStoreItemState createState() => _WppCartStoreItemState();
}

class _WppCartStoreItemState extends State<WppCartStoreItem> {
  DeleteCartItemCubit _deleteCartItemCubit;

  // FetchCartCubit _fetchCartCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _fetchCartCubit = FetchCartCubit();
    _deleteCartItemCubit = DeleteCartItemCubit(
        userDataCubit: BlocProvider.of<UserDataCubit>(context));
  }

  @override
  void dispose() {
    _deleteCartItemCubit.close();
    // _fetchCartCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("indexStore ${widget.indexStore} indexItem ${widget.indexItem}");
    return BlocListener<DeleteCartItemCubit, DeleteCartItemState>(
      cubit: _deleteCartItemCubit,
      listener: (context, state) {
        if (state is DeleteCartItemSuccess) {
          context.read<FetchCartCubit>().load();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BlocBuilder<IncDecCartCubit, IncDecCartState>(
                builder: (context, state) {
                  debugPrint("myStore ${state.store}");
                  return Checkbox(
                      value: state.store[widget.indexStore]
                          .item[widget.indexItem].checked,
                      onChanged: (value) {
                        debugPrint(
                            "check val $value, store i ${widget.indexStore}, i i ${widget.indexItem}");
                        context.read<IncDecCartCubit>().updateCheckedStoreItem(
                              value: value,
                              indexStore: widget.indexStore,
                              indexItem: widget.indexItem,
                            );
                      });
                },
              ),
              WppProductImage(
                image: widget.image,
                width: 50,
                height: 50,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nama,
                      style: AppTypo.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    widget.variantSelected != null
                        ? Text("${widget.variantSelected}")
                        : SizedBox(),
                    Text("Rp ${AppExt.toRupiah(widget.harga ?? 0)}",
                        style: AppTypo.caption
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<DeleteCartItemCubit, DeleteCartItemState>(
                cubit: _deleteCartItemCubit,
                builder: (context, state) {
                  if (state is DeleteCartItemLoading) {
                    return CircularProgressIndicator();
                  }
                  return IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      // LoadingDialog.show(context);
                      context
                            .read<AddToCartOfflineCubit>()
                            .deleteProduct(widget.productId);

                        final offlineCart =
                            context.read<AddToCartOfflineCubit>().state;
                        // _fetchCartCubit.fetchCartOffline(List<CartResponseElement>.from(offlineCart.cart));
                        context.read<FetchCartCubit>().fetchCartOffline(
                            List<CartResponseElement>.from(offlineCart.cart));
                    },
                  );
                },
              ),
              BlocBuilder<IncDecCartCubit, IncDecCartState>(
                builder: (context, state) {
                  final qty =
                      state.store[widget.indexStore].item[widget.indexItem].qty;
                  debugPrint("myqty $qty");
                  // final unchecked = state.store[widget.indexStore].item[widget.indexItem].checked == false;
                  // debugPrint("unchecked $unchecked");
                  final checked = state.store[widget.indexStore]
                          .item[widget.indexItem].checked ==
                      true;
                  return IconButton(
                    splashColor: Colors.orangeAccent,
                    iconSize: 30,
                    color: (qty > 1)
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                    icon: Icon(
                      Icons.remove_circle_outline,
                    ),
                    onPressed: () {
                      if (qty != 1) {
                        context.read<IncDecCartCubit>().decrement(
                            indexStore: widget.indexStore,
                            indexItem: widget.indexItem);
                      }
                    },
                  );
                },
              ),
              BlocBuilder<IncDecCartCubit, IncDecCartState>(
                builder: (context, state) {
                  return Text(
                    state.store[widget.indexStore].item[widget.indexItem].qty
                        .toString(),
                    style: AppTypo.h3.copyWith(fontWeight: FontWeight.w600),
                  );
                },
              ),
              BlocBuilder<IncDecCartCubit, IncDecCartState>(
                builder: (context, state) {
                  final item =
                      state.store[widget.indexStore].item[widget.indexItem];
                  final checked = item.checked == true;
                  final productEmpty = item.stock == item.qty;
                  debugPrint("isEmpty $productEmpty");
                  return IconButton(
                    splashColor: Colors.orangeAccent,
                    iconSize: 30,
                    color: !productEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    icon: Icon(
                      Icons.add_circle_outline,
                    ),
                    onPressed: () {
                      /*if (checked) {
                      }*/
                      if (!productEmpty) {
                        context.read<IncDecCartCubit>().increment(
                            indexStore: widget.indexStore,
                            indexItem: widget.indexItem);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
