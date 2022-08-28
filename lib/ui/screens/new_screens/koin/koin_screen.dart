import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class KoinScreen extends StatelessWidget {
  const KoinScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Koin",
          style: AppTypo.subtitle2,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.black,
          ),
          onPressed: () {
            AppExt.popScreen(context);
          },
        ),
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: deviceSize.width / 2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "images/decorations/bgground_coins.png"))),
                  ),
                  Container(
                    width: 200,
                    height: deviceSize.width / 6,
                    padding: EdgeInsets.all(14),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        "images/icons/ic_coin.svg",
                        width: 36,
                        height: 36,
                      ),
                      title: Text(
                        "Koin",
                        style: AppTypo.subtitle2.copyWith(color: Colors.grey),
                      ),
                      subtitle: Text(
                        "0",
                        style: AppTypo.subtitle2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Transaksi Terakhir",
                  style:
                      AppTypo.subtitle2.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "images/icons/ic_dompet.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pemasukan",
                                    style: AppTypo.caption,
                                  ),
                                  Text(
                                    "10-01-2022",
                                    style: AppTypo.caption
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "+ Rp 125,-",
                                style: AppTypo.caption
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "BANK BCA",
                                style: AppTypo.caption
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, _) {
                    return SizedBox(
                      height: 16,
                      child: Divider(
                        thickness: 1,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
