import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/main.dart';
import 'package:beamer/beamer.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class FooterWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AAppConfig.of(context);

    _launchUrl(String _url) async => await canLaunch(_url)
        ? await launch(_url)
        : BSFeedback.show(
            context,
            icon: Boxicons.bx_x_circle,
            color: AppColor.red,
            title: "Gagal mengakses halaman",
            description: "Halaman atau koneksi internet bermasalah",
          );

    return Container(
        padding: EdgeInsets.only(left: 40, top: 45, right: 40, bottom: 45),
        // color: Colors.red,
        width: double.infinity,
        decoration: BoxDecoration(
            color: config.appType == AppType.bisnisogrosir ||
                    config.appType == AppType.bisnisomarket
                ? AppColor.primary
                : Colors.white,
            border: Border(
              top: BorderSide(width: 1, color: AppColor.grey),
            )),
        child: config.appType == AppType.panenpanen
            ? footerPanenPanen(_launchUrl, context)
            : SizedBox());
  }

  Wrap footerPanenPanen(
      Future<Object> _launchUrl(String _url), BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 10,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Container(
          width: 350,
          child: Column(
            children: [
              Text("Customer Service",
                  style: AppTypo.h2.copyWith(fontSize: 23)),
              SizedBox(
                height: 5,
              ),
              Text("08:00 - 16:00",
                  style: AppTypo.subtitle2.copyWith(color: Color(0xFF6C727C))),
              Image.asset(
                AppImg.img_cs,
                height: 150,
              ),
              Container(
                width: 250,
                child: RoundedButton.contained(
                  isUpperCase: false,
                  isSmall: true,
                  label: "Hubungi Kami",
                  textColor: Colors.white,
                  onPressed: () {
                    _launchUrl(
                        "https://api.whatsapp.com/send?phone=6281132271374&text=Halo%20PanenPanen");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                    "Jl. Sidosermo Airdas A-8, Kota Surabaya, Jawa Timur",
                    style: AppTypo.caption
                        .copyWith(color: Color(0xFF6C727C), fontSize: 12)),
              ),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl("https://www.facebook.com/panenpanen.id/");
                        },
                        child: Image.asset(
                          AppImg.img_btn_fb,
                          height: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Image.asset(
                      AppImg.img_btn_tweet,
                      height: 30,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl("https://www.instagram.com/bisnisomall/");
                        },
                        child: Image.asset(
                          AppImg.img_btn_ig,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("Hubungi Kami", style: AppTypo.h2.copyWith(fontSize: 23)),
              // SizedBox(
              //   height: 12,
              // ),
              // Row(
              //   children: [
              //     Icon(
              //       Icons.phone,
              //       color: Color(0xFF6C727C),
              //     ),
              //     SizedBox(
              //       width: 12,
              //     ),
              //     Text("081132271374",
              //         style:
              //             AppTypo.subtitle2.copyWith(color: Color(0xFF6C727C)))
              //   ],
              // ),
              // SizedBox(
              //   height: 12,
              // ),
              // Row(
              //   children: [
              //     Icon(Icons.pin_drop, color: Color(0xFF6C727C)),
              //     SizedBox(
              //       width: 12,
              //     ),
              //     Text("Jl. Sidosermo Aridas A-8, Kota Surabaya, Jawa Timur",
              //         style:
              //             AppTypo.subtitle2.copyWith(color: Color(0xFF6C727C)))
              //   ],
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   children: [
              //     MouseRegion(
              //       cursor: SystemMouseCursors.click,
              //       child: GestureDetector(
              //         onTap: () {
              //           _launchUrl("https://www.facebook.com/Bisniso.id/");
              //         },
              //         child: Image.asset(
              //           AppImg.img_btn_fb,
              //           height: 30,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 16,
              //     ),
              //     Image.asset(
              //       AppImg.img_btn_tweet,
              //       height: 30,
              //     ),
              //     SizedBox(
              //       width: 16,
              //     ),
              //     MouseRegion(
              //       cursor: SystemMouseCursors.click,
              //       child: GestureDetector(
              //         onTap: () {
              //           _launchUrl("https://www.instagram.com/Bisniso.id/");
              //         },
              //         child: Image.asset(
              //           AppImg.img_btn_ig,
              //           height: 30,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              Text("Metode Pembayaran",
                  style: AppTypo.h2.copyWith(fontSize: 23)),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AppImg.img_pay_bca,
                    height: 25,
                  ),
                  Image.asset(
                    AppImg.img_pay_mandiri,
                    height: 25,
                  ),
                  Image.asset(
                    AppImg.img_pay_bni,
                    height: 25,
                  ),
                  Image.asset(
                    AppImg.img_pay_visa,
                    height: 25,
                  ),
                  Image.asset(
                    AppImg.img_pay_americaex,
                    height: 25,
                  ),
                ],
              ),
              SizedBox(
                height: 36,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AppImg.img_pay_gopay,
                    height: 25,
                  ),
                  Image.asset(
                    AppImg.img_pay_qris,
                    height: 25,
                  ),
                  Image.asset(
                    AppImg.img_pay_permata,
                    height: 25,
                  ),
                  Image.asset(
                    AppImg.img_pay_mastercard,
                    height: 25,
                  ),
                  Image.asset(
                    AppImg.img_pay_jcb,
                    height: 25,
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text("Panduan", style: AppTypo.h2.copyWith(fontSize: 23)),
              SizedBox(
                height: 12,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    _launchUrl("https://admasolusi.com/privacy");
                  },
                  child: Text("Ketentuan Layanan",
                      style: AppTypo.body1
                          .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    _launchUrl("https://admasolusi.com/privacy");
                  },
                  child: Text("Kebijakan Privasi",
                      style: AppTypo.body1
                          .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _launchUrl(
                          "https://play.google.com/store/apps/details?id=com.panenpanen.marketplace");
                    },
                    child: Image.asset(
                      AppImg.img_btn_gplay,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bantuan dan Panduan",
                style: AppTypo.h2.copyWith(fontSize: 23),
              ),
              SizedBox(
                height: 12,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // showDialog(
                    //     context: context,
                    //     useRootNavigator: false,
                    //     builder: (ctx) {
                    //       return AlertMaintenanceWeb(
                    //         title: "Coming Soon",
                    //         description:
                    //             "Nantikan updatenya segera, hanya di Bisnisomall!",
                    //         onPressClose: () {
                    //           AppExt.popScreen(context);
                    //         },
                    //       );
                    //     });
                    // BlocProvider.of<UserDataCubit>(context).state.user != null
                    //     ? context.beamToNamed('/join/reseller')
                    //     : showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           return Dialog(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(20.0),
                    //             ), //this right here
                    //             child: Container(
                    //               constraints: BoxConstraints(
                    //                 maxWidth: 500,
                    //               ),
                    //               // height: 200,
                    //               child: AuthDialog(),
                    //             ),
                    //           );
                    //         });
                    // _launchUrl('https://forms.gle/nNCF7w1Jcafg5wjh9');
                  },
                  child: Text("Join Reseller",
                      style: AppTypo.subtitle2
                          .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // showDialog(
                    //     context: context,
                    //     useRootNavigator: false,
                    //     builder: (ctx) {
                    //       return AlertMaintenanceWeb(
                    //         title: "Coming Soon",
                    //         description:
                    //             "Nantikan updatenya segera, hanya di Bisnisomall!",
                    //         onPressClose: () {
                    //           AppExt.popScreen(context);
                    //         },
                    //       );
                    //     });
                    // BlocProvider.of<UserDataCubit>(context).state.user != null
                    //     ? context.beamToNamed('/join/supplier')
                    //     : showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           return Dialog(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(20.0),
                    //             ), //this right here
                    //             child: Container(
                    //               constraints: BoxConstraints(
                    //                 maxWidth: 500,
                    //               ),
                    //               // height: 200,
                    //               child: AuthDialog(),
                    //             ),
                    //           );
                    //         });
                    // _launchUrl('${AppConst.TOOLBOX_URL}/supplier/offering');
                  },
                  child: Text("Join Mitra Supplier",
                      style: AppTypo.subtitle2
                          .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (ctx) {
                          return AlertMaintenanceWeb(
                            title: "Coming Soon",
                            description:
                                "Nantikan updatenya segera, hanya di PanenPanen!",
                            onPressClose: () {
                              AppExt.popScreen(context);
                            },
                          );
                        });
                    // BlocProvider.of<UserDataCubit>(context).state.user != null
                    //     ? context.beamToNamed('/join/catering')
                    //     : showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           return Dialog(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(20.0),
                    //             ), //this right here
                    //             child: Container(
                    //               constraints: BoxConstraints(
                    //                 maxWidth: 500,
                    //               ),
                    //               // height: 200,
                    //               child: AuthDialog(),
                    //             ),
                    //           );
                    //         });
                    // _launchUrl('${AppConst.TOOLBOX_URL}/register/catering');
                  },
                  child: Text("Pusat Bantuan",
                      style: AppTypo.subtitle2
                          .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
                ),
              ),
              // SizedBox(
              //   height: 15,
              // ),
              // MouseRegion(
              //   cursor: SystemMouseCursors.click,
              //   child: GestureDetector(
              //     onTap: () {
              //       BlocProvider.of<UserDataCubit>(context).state.user != null
              //           ? context.beamToNamed('/join/horeca')
              //           : showDialog(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return Dialog(
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(20.0),
              //                   ), //this right here
              //                   child: Container(
              //                     constraints: BoxConstraints(
              //                       maxWidth: 500,
              //                     ),
              //                     // height: 200,
              //                     child: AuthDialog(),
              //                   ),
              //                 );
              //               });
              //       // _launchUrl('${AppConst.TOOLBOX_URL}/register/catering');
              //     },
              //     child: Text("HORECA",
              //         style: AppTypo.subtitle2
              //             .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
              //   ),
              // ),
              // SizedBox(
              //   height: 36,
              // ),
              // Text(
              //   "Simulasi Proses Budidaya",
              //   style: AppTypo.h2.copyWith(fontSize: 23),
              // ),
              // SizedBox(
              //   height: 12,
              // ),
              // MouseRegion(
              //   cursor: SystemMouseCursors.click,
              //   child: GestureDetector(
              //     onTap: () {
              //       _launchUrl(
              //           'https://play.google.com/store/apps/details?id=com.panenpanen.pembudidaya');
              //     },
              //     child: Text("Ikan",
              //         style: AppTypo.subtitle2
              //             .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
              //   ),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // MouseRegion(
              //   cursor: SystemMouseCursors.click,
              //   child: GestureDetector(
              //     onTap: () {
              //       _launchUrl(
              //           'https://play.google.com/store/apps/details?id=com.panenpanen.petani');
              //     },
              //     child: Text("Sayur",
              //         style: AppTypo.subtitle2
              //             .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
              //   ),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // MouseRegion(
              //   cursor: SystemMouseCursors.click,
              //   child: GestureDetector(
              //     onTap: () => showDialog(
              //         context: context,
              //         useRootNavigator: false,
              //         builder: (ctx) {
              //           return AlertMaintenanceWeb(
              //             title: "Coming Soon",
              //             description:
              //                 "Nantikan updatenya segera, hanya di Bisnisomall!",
              //             onPressClose: () {
              //               AppExt.popScreen(context);
              //             },
              //           );
              //         }),
              //     child: Text("Buah",
              //         style: AppTypo.subtitle2
              //             .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
              //   ),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // MouseRegion(
              //   cursor: SystemMouseCursors.click,
              //   child: GestureDetector(
              //     onTap: () => showDialog(
              //         context: context,
              //         useRootNavigator: false,
              //         builder: (ctx) {
              //           return AlertMaintenanceWeb(
              //             title: "Coming Soon",
              //             description:
              //                 "Nantikan updatenya segera, hanya di Bisnisomall!",
              //             onPressClose: () {
              //               AppExt.popScreen(context);
              //             },
              //           );
              //         }),
              //     child: Text("Ternak",
              //         style: AppTypo.subtitle2
              //             .copyWith(color: Color(0xFF6C727C), fontSize: 14)),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
