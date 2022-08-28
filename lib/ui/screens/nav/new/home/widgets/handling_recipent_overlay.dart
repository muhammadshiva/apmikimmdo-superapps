import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/main_screen.dart';
import 'package:marketplace/ui/screens/nav/nav.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:beamer/beamer.dart';

class HandlingRecipentOverlay extends StatefulWidget {
  const HandlingRecipentOverlay({Key key, this.isFromDeliverTo = true})
      : super(key: key);

  final bool isFromDeliverTo;

  @override
  State<HandlingRecipentOverlay> createState() =>
      _HandlingRecipentOverlayState();
}

class _HandlingRecipentOverlayState extends State<HandlingRecipentOverlay> {
  final RecipentRepository _recipentRepo = RecipentRepository();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        if (!widget.isFromDeliverTo) {
          SystemNavigator.pop();
        } else {
          AppExt.popScreen(context);
        }

        return;
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
          child: Scaffold(
              body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 125),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImg.img_delivery_road,
                    width: 300,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Mau kirim belanjaan kemana?",
                    style: AppTypo.LatoBold.copyWith(
                        fontSize: 22,
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                        "Tentukan alamat pengiriman mu agar kami bisa memberikan rekomendasi produk yang sesuai.",
                        textAlign: TextAlign.center,
                        style: AppTypo.body1Lato
                            .copyWith(color: AppColor.grey, fontSize: 16)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE0E3E6)),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        tileColor: AppColor.editText,
                        onTap: () => showBSRegion(_screenWidth),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Cari kecamatan",
                              style:
                                  AppTypo.caption.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.search,
                          color: AppColor.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  void showBSRegion(double screenWidth, {void Function() onTap}) {
    // final topPadding = MediaQuery.of(context).padding.top;
    // final getRecipentSelected = gs.read('recipentSelected');
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        builder: (ctx) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: screenWidth * (15 / 100),
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(7.5 / 2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Lokasi",
                  style: AppTypo.LatoBold.copyWith(fontSize: 18),
                ),
                SizedBox(
                  height: 16,
                ),
                EditText(
                  hintText: "Tulis min 3 karakter",
                  inputType: InputType.text,
                  onChanged: (String value) {
                    if (value.length >= 3) {
                      context
                          .read<KecamatanSearchCubit>()
                          .search(keyword: value);
                    }
                  },
                ),
                Expanded(
                  child:
                      BlocBuilder<KecamatanSearchCubit, KecamatanSearchState>(
                    builder: (context, state) {
                      if (state is KecamatanSearchLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is KecamatanSearchFailure) {
                        return Text("Failure");
                      }
                      if (state is KecamatanSearchSuccess) {
                        final items = state.result;
                        return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {
                                  AppExt.popScreen(context);
                                  context
                                      .read<ChooseKecamatanCubit>()
                                      .chooseKecamatan(
                                        kecamatan:
                                            "${items[i].subdistrictName}, ${items[i].type} ${items[i].city}, ${items[i].province}",
                                        subDistrict: items[i].subdistrictId,
                                      );
                                  _recipentRepo.setSubdistrictStorage(
                                      subdistrict: items[i].subdistrictName,
                                      subdistrictId: items[i].subdistrictId);
                                  AppExt.popScreen(context, true);
                                  // _recipentRepo.setRecipent(
                                  //     subdistrictId: items[i].subdistrictId,
                                  //     subdistrict: items[i].subdistrictName,
                                  //     address: '-');
                                },
                                leading: Icon(
                                  Icons.location_on_outlined,
                                ),
                                title: Text(
                                  "${items[i].subdistrictName}, ${items[i].type} ${items[i].city}, ${items[i].province}",
                                  style: AppTypo.body1Lato
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                minLeadingWidth: 5,
                                contentPadding: EdgeInsets.zero,
                              );
                            });
                      }
                      return SizedBox();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
