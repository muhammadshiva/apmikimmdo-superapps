import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/cart/cart_stock_validation/cart_stock_validation_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/inc_dec_cart/inc_dec_cart_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/voucher/voucher_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_alamat_pelanggan_screen.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppCartFooter extends StatelessWidget {
  const WppCartFooter({Key key, this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total Harga",
                  style: AppTypo.caption.copyWith(color: Colors.grey)),
              BlocBuilder<IncDecCartCubit, IncDecCartState>(
                builder: (context, state) {
                  var total = 0;
                  for (var i in state.store) {
                    total += i.total.toInt();
                  }
                  return Text(
                    "Rp ${AppExt.toRupiah(total)}",
                    style:
                        AppTypo.subtitle1.copyWith(fontWeight: FontWeight.bold),
                  );
                  return SizedBox();
                },
              ),
            ],
          ),
          BlocBuilder<IncDecCartCubit, IncDecCartState>(
            builder: (context, state) {
              debugPrint("button beli ${state.store}");
              int totalItem = 0;
              for (var c in state.store) {
                for (var i in c.item) {
                  if (i.checked) {
                    totalItem++;
                  }
                }
              }

              return FilledButton(
                onPressed: totalItem > 0 ? onPressed : null,
                color: totalItem > 0
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                child: Text(
                  "Beli ($totalItem)",
                  style: AppTypo.caption.copyWith(color: Colors.white),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
