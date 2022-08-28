import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:marketplace/utils/typography.dart' as AppTypo;

import '../../../../widgets/border_button.dart';
import '../../../../widgets/filled_button.dart';

class FooterProductDetail extends StatelessWidget {
  const FooterProductDetail({
    Key key,
    @required this.onPressed,
    @required this.phone,
    @required this.stock,
  }) : super(key: key);

  final Function() onPressed;
  final Function() phone;
  final int stock;

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
                    EvaIcons.messageSquare,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 5,
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
              onPressed: onPressed,
              height: 45,
              color:
                  stock > 0 ? Theme.of(context).primaryColor : Colors.grey[350],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    EvaIcons.shoppingCart,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Beli",
                    style: AppTypo.caption.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
