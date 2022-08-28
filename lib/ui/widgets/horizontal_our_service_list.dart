import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:url_launcher/url_launcher.dart';

class OurServiceList extends StatelessWidget {
  final String section;
  final Function() viewAll;

  const OurServiceList({
    Key key,
    @required this.section,
    this.viewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _screenWidth * (5 / 100), vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section,
                style: AppTypo.LatoBold.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
          height: 85,
          color: AppColor.white,
          padding: EdgeInsets.zero,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: _screenWidth * (2 / 100)),
            scrollDirection: Axis.horizontal,
            children: [
              InkWell(
                onTap: () {
                  launch("https://apmikimdo.org/");
                },
                child: Container(
                  width: 73,
                  height: 80,
                  child: Column(
                    children: [
                      Image.asset(
                        AppImg.ic_apmikimmdo_png,
                        fit: BoxFit.contain,
                        height: 35,
                      ),
                      SizedBox(
                        height: 7.5,
                      ),
                      FittedBox(
                        child: Container(
                          width: 82,
                          child: RichText(
                            maxLines: kIsWeb ? null : 2,
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Pendaftaran Anggota",
                              style: AppTypo.overline.copyWith(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 73,
                height: 80,
                child: Column(
                  children: [
                    Image.asset(
                      AppImg.ic_mui,
                      fit: BoxFit.contain,
                      height: 35,
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    FittedBox(
                      child: Container(
                        width: 82,
                        child: RichText(
                          maxLines: kIsWeb ? null : 2,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Sertifikasi Halal",
                            style: AppTypo.overline.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 73,
                height: 80,
                child: Column(
                  children: [
                    Image.asset(
                      AppImg.ic_bpom,
                      fit: BoxFit.contain,
                      height: 35,
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    FittedBox(
                      child: Container(
                        width: 82,
                        child: RichText(
                          maxLines: kIsWeb ? null : 2,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Izin BPOM",
                            style: AppTypo.overline.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 73,
                height: 80,
                child: Column(
                  children: [
                    Image.asset(
                      AppImg.ic_nib,
                      fit: BoxFit.contain,
                      height: 35,
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    FittedBox(
                      child: Container(
                        width: 82,
                        child: RichText(
                          maxLines: kIsWeb ? null : 2,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Nomor Induk Berusaha",
                            style: AppTypo.overline.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 73,
                height: 80,
                child: Column(
                  children: [
                    Image.asset(
                      AppImg.ic_pirt,
                      fit: BoxFit.contain,
                      height: 35,
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    FittedBox(
                      child: Container(
                        width: 82,
                        child: RichText(
                          maxLines: kIsWeb ? null : 2,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "SPP-IRT",
                            style: AppTypo.overline.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 73,
                height: 80,
                child: Column(
                  children: [
                    Image.asset(
                      AppImg.ic_kopukm,
                      fit: BoxFit.contain,
                      height: 35,
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    FittedBox(
                      child: Container(
                        width: 82,
                        child: RichText(
                          maxLines: kIsWeb ? null : 2,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Pendaftaran Merk",
                            style: AppTypo.overline.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
