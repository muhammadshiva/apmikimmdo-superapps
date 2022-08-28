import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:beamer/beamer.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/nav/new/account/address_entry_screen.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_account_screen.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;

class WppBsSearchKecamatan {
  static Future show(BuildContext context,
      {void Function(int subdistrictId, String subdistrict) onTap,
      bool useCloseButton = true,
      String title = "this title",
      String description = "this description",
      bool isRouteToListWarung = false,
      String image}) async {
    double _screenWidth = MediaQuery.of(context).size.width;
    AppExt.hideKeyboard(context);

    await showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return WppBsSearchKecamatanItem(
          onTap: onTap,
          title: title,
          description: description,
          isRouteToListWarung: isRouteToListWarung,
          useCloseButton: useCloseButton,
          image: image,
        );
      },
    );
  }
}

class WppBsSearchKecamatanItem extends StatefulWidget {
  const WppBsSearchKecamatanItem({
    Key key,
    this.onTap,
    this.useCloseButton,
    this.title,
    this.description,
    this.isRouteToListWarung, this.image,
  }) : super(key: key);

  final void Function(int subdistrictId, String subdistrict) onTap;
  final bool useCloseButton, isRouteToListWarung;
  final String title, description, image;

  @override
  State<WppBsSearchKecamatanItem> createState() =>
      _WppBsSearchKecamatanItemState();
}

class _WppBsSearchKecamatanItemState extends State<WppBsSearchKecamatanItem> {
  final RecipentRepository _recipentRepo = RecipentRepository();
  int recipentId = 0;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.image,
                width: 300,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppTypo.LatoBold.copyWith(
                    fontSize: 18, color: AppColor.primary),
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(widget.description,
                    textAlign: TextAlign.center,
                    style: AppTypo.body1Lato.copyWith(color: AppColor.grey)),
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
                    // contentPadding: EdgeInsets.zero,
                    onTap: () => showBSRegion(_screenWidth),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Cari kecamatan",
                          style: AppTypo.caption.copyWith(color: Colors.grey),
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
      ),
    );
  }

  void showBSRegion(double screenWidth,
      {void Function(int subdistrictId, String subdistrict) onTap}) {
    final topPadding = MediaQuery.of(context).padding.top;
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (ctx) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: screenWidth * (15 / 100),
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7.5 / 2),
                  ),
                ),
                Text("Pilih Kecamatan",style: AppTypo.LatoBold.copyWith(fontSize: 18),),
                SizedBox(height: 10,),
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
                                  AppExt.popScreen(context);
                                  context
                                      .read<ChooseKecamatanCubit>()
                                      .chooseKecamatan(
                                        kecamatan:
                                            "${items[i].subdistrictName}, ${items[i].type} ${items[i].city}, ${items[i].province}",
                                        subDistrict: items[i].subdistrictId,
                                      );
                                  _recipentRepo.setRecipentUserNoAuth(
                                      subdistrictId: items[i].subdistrictId,
                                      subdistrict: items[i].subdistrictName,
                                      city: items[i].city,
                                      province: items[i].province);
                                  _recipentRepo.setRecipentUserNoAuthDashboard(
                                      subdistrictId: items[i].subdistrictId,
                                      subdistrict: items[i].subdistrictName,
                                      city: items[i].city,
                                      province: items[i].province);
                                  widget.onTap(items[i].subdistrictId,
                                      items[i].subdistrictName);
                                  _recipentRepo.setRecipentUserNoAuthDetailProduct(
                                      subdistrictId: items[i].subdistrictId,
                                      subdistrict: items[i].subdistrictName,
                                      city: items[i].city,
                                      province: items[i].province);
                                  widget.onTap(items[i].subdistrictId,
                                      items[i].subdistrictName);

                                  if (widget.isRouteToListWarung == true)
                                    context.beamToNamed(
                                        '/wpp/listwarung/${items[i].subdistrictId}');
                                },
                                leading: Icon(
                                  Icons.location_on_outlined,
                                ),
                                title: Text(
                                  "${items[i].subdistrictName}, ${items[i].type} ${items[i].city}, ${items[i].province}",
                                  style: AppTypo.body1Lato
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
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
