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
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppCartStoreItemUncovered extends StatefulWidget {
  const WppCartStoreItemUncovered({
    Key key,
    @required this.image,
    @required this.nama,
    @required this.harga,
    @required this.id,
    this.indexItem,
    this.indexStore,
    this.productId, 
    @required this.variantSelected,
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
  _WppCartStoreItemUncoveredState createState() => _WppCartStoreItemUncoveredState();
}

class _WppCartStoreItemUncoveredState extends State<WppCartStoreItemUncovered> {
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
              CacheImage(
                image: widget.image,
                width: 50,
                height: 50,
                color: Colors.grey,
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
                      style: AppTypo.caption.copyWith(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("Rp ${AppExt.toRupiah(widget.harga ?? 0)}",
                        style: AppTypo.caption
                            .copyWith(fontWeight: FontWeight.w600, color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: BlocBuilder<DeleteCartItemCubit, DeleteCartItemState>(
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
                      _deleteCartItemCubit.deleteCartItem(listCartId: [widget.id]);
                      // context.read<FetchCartCubit>().load();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
