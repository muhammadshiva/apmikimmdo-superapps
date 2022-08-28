import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'widgets/voucher_item.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voucher"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              height: MediaQuery.of(context).size.height * 0.80,
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    VoucherItem(
                      name: "Gratis Ongkir Min. Belanja Rp 50 RB",
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    VoucherItem(
                      name: "Cashback 100% hingga Rp 10 RB",
                      isChosen: true,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    VoucherItem(
                      name: "Gratis Ongkir Min. Belanja Rp 100 RB",
                      isExpired: true,
                    ),
                    VoucherItem(
                      name: "Gratis Ongkir Min. Belanja Rp 100 RB",
                      isExpired: true,
                    ),
                    VoucherItem(
                      name: "Gratis Ongkir Min. Belanja Rp 100 RB",
                      isExpired: true,
                    ),
                    VoucherItem(
                      name: "Gratis Ongkir Min. Belanja Rp 100 RB",
                      isExpired: true,
                    ),
                    VoucherItem(
                      name: "Gratis Ongkir Min. Belanja Rp 100 RB",
                      isExpired: true,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hemat",
                          style: AppTypo.caption.copyWith(color: Colors.grey),
                        ),
                        Text(
                          "Rp.15.000,-",
                          style: AppTypo.subtitle2
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    FilledButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Pakai Voucher",
                        style: AppTypo.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
