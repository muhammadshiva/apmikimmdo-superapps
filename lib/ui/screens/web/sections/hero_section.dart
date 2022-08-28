import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/home/saldo_home_screen.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/ui/widgets/web/dialog_alert_web.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  final List<HomeSlider> sliders;
  final bool isLoading, useIndicator;
  final User user;

  const HeroSection({
    Key key,
    this.sliders,
    this.isLoading = false,
    this.useIndicator,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget _carouselPromo = CarouselPromo(
      sliders: sliders,
      isLoading: isLoading,
      useIndicator: useIndicator,
    );
    final _screenWidth = MediaQuery.of(context).size.width;

    if (!context.isPhone)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _carouselPromo),
          SizedBox(width: 20),
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ValueSection(),
                SizedBox(height: 20),
                _MenuSection(),
              ],
            ),
          )
        ],
      );

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              _carouselPromo,
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 8,
            left: _screenWidth * (5 / 100),
            right: _screenWidth * (5 / 100),
            child: AmountIndicator(user: user)),
      ],
    );
  }
}

class AmountIndicator extends StatelessWidget {
  const AmountIndicator({Key key, @required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if (BlocProvider.of<UserDataCubit>(context).state.user == null) {
                AppExt.pushScreen(context, SignInScreen());
              } else {
                /*BsConfirmation().warning(
                  context: context, title: "Nantikan fitur terbaru dari kami.");*/
                AppExt.pushScreen(context, SaldoHomeScreen(user: user));
              }
            },
            child: Container(
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImg.ic_dompet,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dompet",
                          style: AppTypo.body1Lato
                              .copyWith(fontSize: 11, color: AppColor.grey)),
                      SizedBox(
                        height: 2,
                      ),
                      user.isNullOrBlank
                          ? Text("0",
                              style: AppTypo.LatoBold.copyWith(
                                fontSize: 12,
                              ))
                          : Text("${user.walletBalance}",
                              style: AppTypo.LatoBold.copyWith(
                                fontSize: 12,
                              )),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => BsConfirmation().warning(
                context: context, title: "Nantikan fitur terbaru dari kami."),
            child: Container(
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImg.ic_coin,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Koin",
                          style: AppTypo.body1Lato
                              .copyWith(fontSize: 11, color: AppColor.grey)),
                      SizedBox(
                        height: 2,
                      ),
                      Text("0",
                          style: AppTypo.LatoBold.copyWith(
                            fontSize: 12,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => BsConfirmation().warning(
                context: context, title: "Nantikan fitur terbaru dari kami."),
            child: Container(
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImg.ic_voucher,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Voucher",
                          style: AppTypo.body1Lato
                              .copyWith(fontSize: 11, color: AppColor.grey)),
                      SizedBox(
                        height: 2,
                      ),
                      Text("0",
                          style: AppTypo.LatoBold.copyWith(
                            fontSize: 12,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  void _launchUrl(BuildContext context, String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (ctx) {
            return AlertFailureWeb(
              onPressClose: () {
                AppExt.popScreen(context);
              },
              title: "Gagal mengakses halaman",
              description: "Halaman atau koneksi internet bermasalah",
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    final bool isWarung = userDataCubit.state.user?.roleId == '5';

    return BasicCard(
      child: Padding(
        padding: const EdgeInsets.all(20).copyWith(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Menu",
              style: AppTypo.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       child: _MenuSectionButton(
            //         icon: Icon(
            //           Boxicons.bxs_hourglass,
            //           color: AppColor.primary,
            //           size: 28,
            //         ),
            //         name: "Lelang",
            //         onTap: () {
            //           kIsWeb
            //               ? context.beamToNamed('/auction')
            //               : AppExt.pushScreen(context, AuctionOfferScreen());
            //         },
            //       ),
            //     ),
            //     SizedBox(
            //       width: 7,
            //     ),
            //     Expanded(
            //       child: _MenuSectionButton(
            //         icon: Icon(
            //           Boxicons.bxs_star,
            //           color: AppColor.primary,
            //           size: 28,
            //         ),
            //         name: "Potensi",
            //         onTap: () {
            //           kIsWeb
            //               ? context.beamToNamed('/potency')
            //               : AppExt.pushScreen(context, PotencyNav());
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 8),
            // Row(
            //   children: [
            //     Expanded(
            //       child: _MenuSectionButton(
            //         icon: ClipRRect(
            //           borderRadius: BorderRadius.circular(40),
            //           child: Container(
            //             width: 40,
            //             height: 40,
            //             padding: EdgeInsets.all(7),
            //             color: AppColor.primary.withOpacity(0.70),
            //             child: WebsafeSvg.asset(
            //               AppImg.ic_shop_fill,
            //             ),
            //           ),
            //         ),
            //         name: "Reseller",
            //         onTap: () {
            //           context.beamToNamed(
            //               '/list/reseller?recid=${BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent != null ? AppExt.encryptMyData(jsonEncode(BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent.id)) : AppExt.encryptMyData(jsonEncode(null))}');
            //         },
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class _MenuSectionButton extends StatelessWidget {
  const _MenuSectionButton({
    Key key,
    @required this.icon,
    @required this.name,
    @required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Colors.grey[400],
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              icon ?? SizedBox.shrink(),
              SizedBox(
                height: 5,
              ),
              Text(
                "$name",
                style: AppTypo.body1.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueSection extends StatelessWidget {
  const _ValueSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget coin = _ValueSectionButton(
      icon: Icon(Boxicons.bxs_coin, color: AppColor.yellow),
      value: AppExt.toRupiah(0),
      name: "Koin",
      onTap: () => showDialog(
          context: context,
          useRootNavigator: false,
          builder: (ctx) {
            return AlertMaintenanceWeb(
              title: "Coming Soon",
              description: "Nantikan updatenya segera, hanya di PanenPanen!",
              onPressClose: () {
                AppExt.popScreen(context);
              },
            );
          }),
    );

    final Widget voucher = _ValueSectionButton(
      icon: Icon(Boxicons.bxs_coupon, color: AppColor.blue),
      value: "${0}",
      name: "Voucher Anda",
      onTap: () => showDialog(
          context: context,
          useRootNavigator: false,
          builder: (ctx) {
            return AlertMaintenanceWeb(
              title: "Coming Soon",
              description: "Nantikan updatenya segera, hanya di PanenPanen!",
              onPressClose: () {
                AppExt.popScreen(context);
              },
            );
          }),
    );

    if (!context.isPhone)
      return BasicCard(
        child: Column(
          children: [
            coin,
            Divider(
              height: 0.5,
              thickness: 0.5,
            ),
            voucher,
          ],
        ),
      );
    else
      return Row(
        children: [
          Expanded(
            child: BasicCard(
              child: coin,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: BasicCard(
              child: voucher,
            ),
          ),
        ],
      );
  }
}

class _ValueSectionButton extends StatelessWidget {
  const _ValueSectionButton({
    Key key,
    @required this.icon,
    @required this.value,
    @required this.name,
    @required this.onTap,
  }) : super(key: key);

  final Icon icon;
  final String value;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$value",
                    style:
                        AppTypo.caption.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$name",
                    style: AppTypo.overline.copyWith(color: AppColor.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
