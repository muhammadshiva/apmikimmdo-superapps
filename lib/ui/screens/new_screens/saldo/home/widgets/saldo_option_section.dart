import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/history_saldo/history_saldo_screen.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/tarik_saldo/tarik_saldo_screen.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class SaldoOptionSection extends StatelessWidget {
  const SaldoOptionSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26),
      alignment: Alignment.center,
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 65,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    AppExt.pushScreen(context, HistorySaldoScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/icons/ic_wallet_history.png",
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Riwayat",
                        style: AppTypo.caption.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: VerticalDivider(),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    BsConfirmation().warning(
                        context: context,
                        title: "Nantikan fitur terbaru dari kami.");
                    // AppExt.pushScreen(context, TarikSaldoScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/icons/ic_redeem_wallet.png",
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Tarik Saldo",
                        style: AppTypo.caption.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
