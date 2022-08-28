import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/comment/comment_screen.dart';
import 'package:marketplace/ui/screens/new_screens/koin/koin_screen.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/home/saldo_home_screen.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class AccountInfoItem extends StatelessWidget {
  const AccountInfoItem({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
            style: BorderStyle.solid,
            color: AppColor.silverFlashSale,
            width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              highlightColor: AppColor.transparent,
              onTap: () {
                /*BsConfirmation().warning(
                  context: context, title: "Nantikan fitur terbaru dari kami.");*/
                AppExt.pushScreen(context, SaldoHomeScreen(user: user));
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppImg.ic_dompet,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text("Dompet",
                      style: AppTypo.body2Lato
                          .copyWith(fontSize: 11, color: AppColor.grey)),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    user.walletBalance ?? 'Rp. 0',
                    style: AppTypo.LatoBold.copyWith(fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              highlightColor: AppColor.transparent,
              onTap: () => BsConfirmation().warning(
                  context: context, title: "Nantikan fitur terbaru dari kami."),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right:
                        BorderSide(width: 1, color: AppColor.silverFlashSale),
                    left: BorderSide(width: 1, color: AppColor.silverFlashSale),
                  ),
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AppImg.ic_coin,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text("Koin",
                        style: AppTypo.body2Lato
                            .copyWith(fontSize: 11, color: AppColor.grey)),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Rp 0",
                      style: AppTypo.LatoBold.copyWith(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              highlightColor: AppColor.transparent,
              onTap: () => BsConfirmation().warning(
                  context: context, title: "Nantikan fitur terbaru dari kami."),
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppImg.ic_voucher,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text("Voucher",
                      style: AppTypo.body2Lato
                          .copyWith(fontSize: 11, color: AppColor.grey)),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "0",
                    style: AppTypo.LatoBold.copyWith(fontSize: 12),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
