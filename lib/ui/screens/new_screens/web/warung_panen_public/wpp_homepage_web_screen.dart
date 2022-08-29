import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:beamer/beamer.dart';

class WppHomepageWebScreen extends StatefulWidget {
  const WppHomepageWebScreen({ Key key }) : super(key: key);

  @override
  State<WppHomepageWebScreen> createState() => _WppHomepageWebScreenState();
}

class _WppHomepageWebScreenState extends State<WppHomepageWebScreen> {
  final RecipentRepository _recipentRepo = RecipentRepository();
  
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImg.img_delivery_road,width: 300,),
                  SizedBox(height: 20,),
                  Text("Mau kirim belanjaan kemana",style: AppTypo.LatoBold.copyWith(fontSize: 20,color: AppColor.primary),),
                  SizedBox(height: 6,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text("tentukan alamat pengiriman mu agar kami bisa memberikan rekomendasi produk yang sesuai.",textAlign: TextAlign.center,style: AppTypo.body1Lato.copyWith(color: AppColor.grey,fontSize: 16)),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE0E3E6)),
                      borderRadius: BorderRadius.circular(10)
                    ),
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
          )
        ),
      ),
    );
  }

  void showBSRegion(double screenWidth, {void Function(int subdistrictId,String subdistrict) onTap}) {
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
                Center(
                  child: Container(
                    width: screenWidth * (15 / 100),
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(7.5 / 2),
                    ),
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
                        return Text(state.message);
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
                                  _recipentRepo.setRecipentUserNoAuth(subdistrictId: items[i].subdistrictId, subdistrict: items[i].subdistrictName,city: items[i].city,province: items[i].province);
                                  _recipentRepo.setRecipentUserNoAuthDashboard(subdistrictId: items[i].subdistrictId, subdistrict: items[i].subdistrictName,city: items[i].city,province: items[i].province);
                                  _recipentRepo.setRecipentUserNoAuthDetailProduct(subdistrictId: items[i].subdistrictId, subdistrict: items[i].subdistrictName,city: items[i].city,province: items[i].province);
                                  context.beamToNamed('/wpp/listwarung/${items[i].subdistrictId}');
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