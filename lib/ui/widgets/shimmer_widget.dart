import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/decorations.dart' as AppDecor;

class BuildMenuItemShimmer extends StatelessWidget {
  const BuildMenuItemShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Column _comp = Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(
          height: 7.5,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(height: 15, color: Colors.grey[300])),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: kIsWeb
          ? _comp
          : Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[200],
              period: Duration(milliseconds: 1000),
              child: _comp,
            ),
    );
  }
}

class ShimmerCartItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Random rnd;
    rnd = new Random();
    double rTitle = (100 + rnd.nextInt(160 - 100)).toDouble();

    Widget _unShim = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 18,
          width: rTitle,
          color: Colors.grey[200],
        ),
        SizedBox(height: 10),
        ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ShimmerCartProductItem();
            },
            separatorBuilder: (context, index) => SizedBox(height: 7),
            itemCount: 2),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: AppDecor.customElevation.copyWith(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: kIsWeb
          ? _unShim
          : Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[200],
              period: Duration(milliseconds: 1000),
              child: _unShim),
    );
  }
}

class ShimmerCartProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _unShim = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              child: Container(
                width: 65,
                height: 47,
                color: Colors.grey[200],
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.grey[200],
                ),
                SizedBox(height: 7),
                Container(
                  width: 70,
                  height: 20,
                  color: Colors.grey[200],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  disabledColor: AppColor.grey,
                  icon: Icon(Boxicons.bxs_trash, size: 28),
                  onPressed: null,
                ),
                Container(
                  width: 50,
                  height: 15,
                  color: Colors.grey[200],
                ),
              ],
            ),
            Row(children: [
              IconButton(
                disabledColor: AppColor.grey,
                icon: Icon(FlutterIcons.minus_circle_outline_mco, size: 30),
                onPressed: null,
              ),
              Container(
                width: 30,
                height: 20,
                color: Colors.grey[200],
              ),
              IconButton(
                disabledColor: AppColor.grey,
                icon: Icon(FlutterIcons.plus_circle_outline_mco, size: 30),
                onPressed: null,
              ),
            ])
          ],
        ),
      ],
    );
    return kIsWeb
        ? _unShim
        : Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[200],
            period: Duration(milliseconds: 1000),
            child: _unShim,
          );
  }
}

class ShimmerAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _unShim = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 15,
                width: 90,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 10,
                width: 150,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 10,
                width: 130,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 10,
                width: 140,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 10,
                width: 140,
                color: Colors.grey[200],
              ),
            ],
          ),
          Icon(
            FlutterIcons.check_circle_mco,
            color: AppColor.primary,
            size: 35,
          ),
        ],
      ),
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[200],
      period: Duration(milliseconds: 1000),
      child: _unShim,
    );
  }
}

class ShimmerProductDetail extends StatelessWidget {
  final bool isFromShop;
  final bool isPrediction;

  const ShimmerProductDetail({
    Key key,
    this.isFromShop = false,
    this.isPrediction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    Widget _unShimContainer(double width, double height) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey[200],
      );
    }

    Widget _unShim = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kIsWeb
            ? _unShimContainer(40, 12)
            : Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[200],
                period: Duration(milliseconds: 1000),
                child: _unShimContainer(40, 12),
              ),
        SizedBox(height: 5),
        kIsWeb
            ? _unShimContainer(150, 25)
            : Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[200],
                period: Duration(milliseconds: 1000),
                child: _unShimContainer(150, 25)),
        SizedBox(height: 5),
        kIsWeb
            ? _unShimContainer(100, 20)
            : Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[200],
                period: Duration(milliseconds: 1000),
                child: _unShimContainer(100, 20),
              ),
        SizedBox(height: 5),
        kIsWeb
            ? _unShimContainer(70, 20)
            : Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[200],
                period: Duration(milliseconds: 1000),
                child: _unShimContainer(70, 20),
              ),
      ],
    );

    Widget _unShimRow1 = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _unShimContainer(70, 25),
        SizedBox(height: 2),
        Icon(
          Icons.chevron_right,
          color: Colors.grey[200],
          size: 26,
        ),
      ],
    );

    Widget _unShimColumn1 = Column(
      children: [
        _unShimContainer(50, 25),
        SizedBox(height: 2),
        _unShimContainer(65, 15),
      ],
    );

    Widget _unShimColumn2 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _unShimContainer(80, 25),
        SizedBox(height: 5),
        _unShimContainer(double.infinity, 15),
        SizedBox(height: 2),
        _unShimContainer(double.infinity, 15),
        SizedBox(height: 2),
        _unShimContainer(double.infinity, 15),
        SizedBox(height: 2),
        _unShimContainer(double.infinity, 15),
        SizedBox(height: 2),
        _unShimContainer(100, 15),
      ],
    );

    return ListView(
      children: [
        kIsWeb
            ? Container(
                height: 220,
                color: Colors.grey[200],
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[200],
                period: Duration(milliseconds: 1000),
                child: Container(
                  height: 220,
                  color: Colors.grey[200],
                ),
              ),
        Container(
          decoration: AppDecor.customElevation,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: _unShim,
        ),
        SizedBox(height: 20),
        !isFromShop
            ? Container(
                decoration: AppDecor.customElevation,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      isPrediction
                          ? kIsWeb
                              ? _unShimRow1
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[200],
                                  period: Duration(milliseconds: 1000),
                                  child: _unShimRow1,
                                )
                          : SizedBox.shrink(),
                      isPrediction
                          ? VerticalDivider(
                              color: AppColor.grey,
                              thickness: 1,
                            )
                          : SizedBox.shrink(),
                      kIsWeb
                          ? _unShimColumn1
                          : Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[200],
                              period: Duration(milliseconds: 1000),
                              child: _unShimColumn1,
                            ),
                      VerticalDivider(color: AppColor.grey),
                      kIsWeb
                          ? _unShimColumn1
                          : Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[200],
                              period: Duration(milliseconds: 1000),
                              child: _unShimColumn1,
                            ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
        !isFromShop ? SizedBox(height: 20) : SizedBox.shrink(),
        Container(
          decoration: AppDecor.customElevation,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: kIsWeb
              ? _unShimColumn2
              : Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  period: Duration(milliseconds: 1000),
                  child: _unShimColumn2,
                ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class ShimmerProductItem extends StatelessWidget {
  final bool isPromo;
  final bool isFromShop;

  const ShimmerProductItem({
    Key key,
    this.isPromo = false,
    this.isFromShop = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random rnd;
    rnd = new Random();
    double rTitle = (60 + rnd.nextInt(140 - 60)).toDouble();
    double rSub1 = (80 + rnd.nextInt(120 - 80)).toDouble();
    double rSub2 = (50 + rnd.nextInt(100 - 50)).toDouble();
    double rSub3 = (50 + rnd.nextInt(80 - 50)).toDouble();

    Widget wid = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          child: Container(
            color: Colors.grey[200],
            width: double.infinity,
            height: 80,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 18,
                width: rTitle,
                color: Colors.grey[200],
              ),
              isPromo ? SizedBox(height: 3) : SizedBox.shrink(),
              isPromo
                  ? Container(
                      height: 15,
                      width: rSub1,
                      color: Colors.grey[200],
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 3),
              Container(
                height: 15,
                width: rSub2,
                color: Colors.grey[200],
              ),
              !isFromShop ? SizedBox(height: 3) : SizedBox.shrink(),
              !isFromShop
                  ? Container(
                      height: 15,
                      width: rSub3,
                      color: Colors.grey[200],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );

    return Container(
      decoration: AppDecor.customElevation,
      child: kIsWeb
          ? wid
          : Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[200],
              period: Duration(milliseconds: 1000),
              child: wid),
    );
  }
}

class ShimmerProductList extends StatelessWidget {
  final bool isPromo;

  const ShimmerProductList({Key key, this.isPromo = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    Random rnd;
    rnd = new Random();
    double rTitle = (70 + rnd.nextInt(130 - 70)).toDouble();
    // TODO: ganti warna
    final Widget sectionSkeleton = Container(
      color: Colors.grey[200],
      width: rTitle,
      height: 20,
    );

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 10,
          ),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: kIsWeb
                    ? sectionSkeleton
                    : Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[200],
                        period: Duration(milliseconds: 1000),
                        child: sectionSkeleton,
                      ),
              ),
              SizedBox(height: 10),
              Container(
                height: 230,
                child: StaggeredGridView.countBuilder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  crossAxisCount: 6,
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return ShimmerProductItem(isPromo: isPromo);
                  },
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(4),
                  mainAxisSpacing: 13,
                  crossAxisSpacing: 13,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class ShimmerNewsActivity extends StatelessWidget {
  const ShimmerNewsActivity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget wid = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 96,
            height: 96,
            color: Colors.grey[200],
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // TITLE
            Container(
              width: 220,
              height: 72,
              color: Colors.grey[200],
            ),
            SizedBox(
              height: 5,
            ),
            // CREATED AT
            Container(
              width: 220,
              height: 14,
              color: Colors.grey[200],
            ),
          ],
        ),
      ],
    );

    return Container(
      decoration: AppDecor.customElevation,
      child: kIsWeb
          ? wid
          : Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[200],
              period: Duration(milliseconds: 1000),
              child: wid,
            ),
    );
  }
}
