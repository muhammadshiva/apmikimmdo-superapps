import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/ticker.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class HorizontalFlashSale extends StatelessWidget {
  final String section;
  final List<Products> products;
  final Function() viewAll;

  const HorizontalFlashSale(
      {Key key,
      @required this.section,
      @required this.products,
      @required this.viewAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final bool isUpgradeUser =
        BlocProvider.of<UserDataCubit>(context).state.user != null &&
                BlocProvider.of<UserDataCubit>(context).state.user.reseller !=
                    null ||
            BlocProvider.of<UserDataCubit>(context).state.user != null &&
                BlocProvider.of<UserDataCubit>(context).state.user.supplier !=
                    null;
    // final userData = BlocProvider.of<UserDataCubit>(context).state.user;

    int _duration(DateTime orderDate) {
      final expired = orderDate.add(const Duration(hours: 8));
      final now = DateTime.now();
      final diff = expired.difference(now);
      return diff.inSeconds;
    }

    Widget _containerTimer(String text) {
      return Container(
        decoration: BoxDecoration(
            color: Color(0xFFE7366B), borderRadius: BorderRadius.circular(3)),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
        child: Text(
          text,
          style: AppTypo.body2Lato.copyWith(color: Colors.white),
        ),
      );
    }

    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _screenWidth * (5 / 100),
          ),
          child: Text(section,
              style: AppTypo.LatoBold.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              )),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _screenWidth * (5 / 100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Berakhir dalam",
                        style: AppTypo.body2Lato.copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      StreamBuilder<int>(
                          stream:
                              Ticker().tick(ticks: _duration(DateTime.now())),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final duration = snapshot.data;
                              final hoursStr = ((duration / 3600) % 60)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                              final minutesStr = ((duration / 60) % 60)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                              final secondsStr = (duration % 60)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _containerTimer(hoursStr),
                                  Text(
                                    "  :  ",
                                    style: AppTypo.body2Lato.copyWith(
                                        color: Color(0xFFE7366B),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  _containerTimer(minutesStr),
                                  Text(
                                    "  :  ",
                                    style: AppTypo.body2Lato.copyWith(
                                        color: Color(0xFFE7366B),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  _containerTimer(secondsStr),
                                ],
                              );
                            }
                            return SizedBox();
                          })
                    ],
                  ),
                ],
              ),
              viewAll != null
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: viewAll,
                        borderRadius: BorderRadius.circular(5),
                        child: Text(
                          "Lihat Semua",
                          textAlign: TextAlign.right,
                          style: AppTypo.LatoBold.copyWith(
                              color: AppColor.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: isUpgradeUser ? 410 : 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFF4406F),
                Color(0xFFFF658B),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 25),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    Products _item = products[index];
                    if (index == 0) {
                      return Row(
                        children: [
                          Image.asset(
                            "images/banner_flashsale.png",
                            width: 140,
                            height: 280,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            width: 135,
                            child: ProductListItem(
                              product: _item,
                              // isDiscount: true,
                              // isKomisi:   true,
                              isDiscount: _item.disc != 0,
                              isKomisi:
                                  _item.komisi != null && _item.komisi > 0,
                              useLineProgress: true,
                              isFlashSale: true,
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox(
                      width: 135,
                      child: ProductListItem(
                        product: _item,
                        isKomisi: _item.komisi != null && _item.komisi > 0,
                        isDiscount: _item.disc != 0,
                        // isDiscount: true,
                        //       isKomisi:   true,
                        useLineProgress: true,
                        isFlashSale: true,
                      ),
                    );
                  },
                  separatorBuilder: (context, _) => SizedBox(
                    width: 10,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 15,
        // ),
      ],
    );
  }
}
