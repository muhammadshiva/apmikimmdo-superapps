import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/delete_cart_item/delete_cart_item_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/inc_dec_cart/inc_dec_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/wpp_cart/add_to_cart_offline/add_to_cart_offline_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cache_image.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class CartStoreItem extends StatefulWidget {
  const CartStoreItem({
    Key key,
    @required this.image,
    @required this.nama,
    @required this.variantSelected,
    @required this.harga,
    @required this.id,
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
  _CartStoreItemState createState() => _CartStoreItemState();
}

class _CartStoreItemState extends State<CartStoreItem> {
  DeleteCartItemCubit _deleteCartItemCubit;
  FetchRecipentCubit _fetchRecipentCubit;

  // FetchCartCubit _fetchCartCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _fetchCartCubit = FetchCartCubit();
    _deleteCartItemCubit = DeleteCartItemCubit(
        userDataCubit: BlocProvider.of<UserDataCubit>(context));
    _fetchRecipentCubit = FetchRecipentCubit();
  }

  @override
  void dispose() {
    _deleteCartItemCubit.close();
    _fetchRecipentCubit.close();
    // _fetchCartCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("indexStore ${widget.indexStore} indexItem ${widget.indexItem}");
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteCartItemCubit, DeleteCartItemState>(
          cubit: _deleteCartItemCubit,
          listener: (context, state) {
            if (state is DeleteCartItemSuccess) {
              _fetchRecipentCubit.fetchRecipents();
            }
          },
        ),
        BlocListener<FetchRecipentCubit, FetchRecipentState>(
          cubit: _fetchRecipentCubit,
          listener: (context, state) {
            if (state is FetchRecipentSuccess) {
              debugPrint("myrecipient ${state.recipent}");
              final recipient = state.recipent.singleWhere(
                  (element) => element.isMainAddress == 1,
                  orElse: () => null);
              debugPrint("CITY ID : ${recipient.cityId}");
              if (recipient != null) {
                final cityId = recipient.cityId;
                context
                    .read<FetchCartCubit>()
                    .fetchCartWithCityId(cityId: cityId);
              } else {
                context.read<FetchCartCubit>().load();
              }
            }
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BlocBuilder<IncDecCartCubit, IncDecCartState>(
                builder: (context, state) {
                  debugPrint("myStore ${state.store}");
                  return Checkbox(
                      activeColor: AppColor.primary,
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
              CacheImage(
                image: widget.image,
                width: 50,
                height: 45,
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
                      if (BlocProvider.of<UserDataCubit>(context).state.user ==
                              null &&
                          kIsWeb) {
                        context
                            .read<AddToCartOfflineCubit>()
                            .deleteProduct(widget.productId);

                        final offlineCart =
                            context.read<AddToCartOfflineCubit>().state;
                        // _fetchCartCubit.fetchCartOffline(List<CartResponseElement>.from(offlineCart.cart));
                        context.read<FetchCartCubit>().fetchCartOffline(
                            List<CartResponseElement>.from(offlineCart.cart));
                      } else {
                        _deleteCartItemCubit
                            .deleteCartItem(listCartId: [widget.id]);
                        // context.read<FetchCartCubit>().load();
                      }
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
                    splashColor: AppColor.bgBadgePink,
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
                    splashColor: AppColor.bgBadgePink,
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
