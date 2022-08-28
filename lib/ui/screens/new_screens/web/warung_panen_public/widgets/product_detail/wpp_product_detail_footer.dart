import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/ui/widgets/border_button.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';

import 'package:marketplace/utils/typography.dart' as AppTypo;


class WppProductDetailFooter extends StatelessWidget {
  const WppProductDetailFooter(
      {Key key, @required this.onPressed, @required this.phone, @required this.stock, this.isButtonBeliEnable = false})
      : super(key: key);

  final Function() onPressed;
  final Function() phone;
  final int stock;
  final bool isButtonBeliEnable;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: BorderButton(
              height: 45,
              onPressed:
                  /*() {
                // context.read<AddToCartOfflineCubit>().reset();
              }*/
                  phone,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    "Chat Penjual",
                    style: AppTypo.caption
                        .copyWith(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: FilledButton(
              onPressed: isButtonBeliEnable ? onPressed : null,
              height: 45,
              color: stock > 0 ? Theme.of(context).primaryColor : Colors.grey[350],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  Text(
                    "Beli",
                    style: AppTypo.caption.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ) ,
          ),
        ],
      ),
    );
  }
}
