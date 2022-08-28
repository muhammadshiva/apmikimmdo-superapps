import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/delete_cart_item/delete_cart_item_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/inc_dec_cart/inc_dec_cart_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class CartHeader extends StatefulWidget {
  const CartHeader({Key key}) : super(key: key);

  @override
  _CartHeaderState createState() => _CartHeaderState();
}

class _CartHeaderState extends State<CartHeader> {
  DeleteCartItemCubit _deleteCartItemCubit;
  FetchRecipentCubit _fetchRecipentCubit;

  List<int> productIdList = [];

  @override
  void initState() {
    super.initState();
    _deleteCartItemCubit = DeleteCartItemCubit(
        userDataCubit: BlocProvider.of<UserDataCubit>(context));
    _fetchRecipentCubit = FetchRecipentCubit();
  }

  @override
  void dispose() {
    _deleteCartItemCubit.close();
    _fetchRecipentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
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
                      activeColor: AppColor.primary,
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
            BlocBuilder<DeleteCartItemCubit, DeleteCartItemState>(
              cubit: _deleteCartItemCubit,
              builder: (context, state) {
                if (state is DeleteCartItemLoading) {
                  return CircularProgressIndicator();
                }
                return TextButton(
                    onPressed: () {
                      final cart = context.read<IncDecCartCubit>().state.store;
                      for (var stores in cart) {
                        for (var items in stores.item) {
                          if (items.checked) {
                            productIdList.add(items.cartId);
                          }
                        }
                      }
                      if (productIdList.length > 0) {
                        _deleteCartItemCubit.deleteCartItem(
                            listCartId: productIdList);
                      } else {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            margin: EdgeInsets.zero,
                            duration: Duration(seconds: 2),
                            content: Text('Centang pilih semua terlebih dahulu atau tekan icon hapus untuk produk yang akan dihapus'),
                            backgroundColor: Colors.grey[900],
                            behavior: SnackBarBehavior.floating,
                          ));
                      }
                    },
                    child: Text(
                      "Hapus",
                      style: AppTypo.caption
                          .copyWith(color: Theme.of(context).primaryColor),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
