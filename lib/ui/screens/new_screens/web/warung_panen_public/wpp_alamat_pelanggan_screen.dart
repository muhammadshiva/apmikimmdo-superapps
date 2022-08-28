import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/register_supplier_reseller/register_supplier_reseller_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/alamat_pelanggan.dart';
import 'package:marketplace/data/repositories/new_repositories/recipent_repository.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppAlamatPelangganScreen extends StatefulWidget {
  const WppAlamatPelangganScreen({Key key, @required this.cart})
      : super(key: key);

  final List<NewCart> cart;

  @override
  _WppAlamatPelangganScreenState createState() =>
      _WppAlamatPelangganScreenState();
}

class _WppAlamatPelangganScreenState extends State<WppAlamatPelangganScreen> {
  final _formKey = GlobalKey<FormState>();
  final RecipentRepository recipentRepo = RecipentRepository();
  // UserDataCubit _userDataCubit;

  /// untuk boolean checkbox seller

  final nameController = TextEditingController();
  final alamatController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final kecamatanController = TextEditingController();

  String selectedLocation;
  int selectedSubdistrictId;

  @override
  void initState() {
    // _userDataCubit = BlocProvider.of<UserDataCubit>(context);
    debugPrint("ISI CART E " + widget.cart.toString());
    kecamatanController.text = "${recipentRepo.getSelectedRecipentNoAuth()['subdistrict']}, ${recipentRepo.getSelectedRecipentNoAuth()['city']}, ${recipentRepo.getSelectedRecipentNoAuth()['province']}";
    context.read<ChooseKecamatanCubit>().reset();
    // selectedLocation =
    //     "${recipentRepo.getSelectedRecipentNoAuth()['subdistrict']}, ${recipentRepo.getSelectedRecipentNoAuth()['city']}, ${recipentRepo.getSelectedRecipentNoAuth()['province']}";
    // selectedSubdistrictId =
    //     recipentRepo.getSelectedRecipentNoAuth()['subdistrict_id'];
    // debugPrint("roleid ${_userDataCubit.state.user}");
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    alamatController.dispose();
    emailController.dispose();
    kecamatanController.dispose();
    super.dispose();
  }

  // handleRegisteration(UserType userType) {
  //   final subDistrictId =
  //       context.read<ChooseKecamatanCubit>().state.subDistrict;
  // }

  String validation(String value) {
    if (value.isEmpty) {
      return "Wajib diisi";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 450),
          child: Scaffold(
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      textTheme: TextTheme(headline6: AppTypo.subtitle2),
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      forceElevated: false,
                      pinned: true,
                      shadowColor: Colors.black54,
                      floating: true,
                      iconTheme: IconThemeData(color: Colors.black),
                      title: Text("Alamat Pelanggan"),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  physics: new BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nama"),
                          SizedBox(height: 8),
                          EditText(
                            controller: nameController,
                            hintText: "Nama",
                            validator: validation,
                          ),
                          SizedBox(height: 16),
                          Text("No Telepon"),
                          SizedBox(height: 8),
                          EditText(
                            controller: phoneController,
                            hintText: "No Telepon (Whatsapp)",
                            inputType: InputType.phone,
                            keyboardType: TextInputType.number,
                            validator: validation,
                          ),
                          SizedBox(height: 16),
                          Text("Email"),
                          SizedBox(height: 8),
                          EditText(
                            controller: emailController,
                            hintText: "Email Anda",
                          ),
                          SizedBox(height: 16),
                          Text("Kecamatan"),
                          SizedBox(height: 8),
                          EditText(
                            enabled: false,
                            controller: kecamatanController,
                            hintText: "Pilih kecamatan"
                          ),
                          // ListTile(
                          //   contentPadding: EdgeInsets.zero,
                          //   onTap: () => showBSRegion(_screenWidth, onTap:
                          //       (kecamatan, kota, provinsi, valueIdKecamatan) {
                          //     setState(() {
                          //       selectedLocation = "$kecamatan,$kota,$provinsi";
                          //       selectedSubdistrictId = valueIdKecamatan;
                          //     });
                          //   }),
                          //   title: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       Icon(
                          //         Icons.location_on_outlined,
                          //         color: Colors.grey,
                          //       ),
                          //       SizedBox(
                          //         width: 8,
                          //       ),
                          //       Text(
                          //         selectedLocation ??
                          //             "Pilih kota atau kecamatan",
                          //         style: AppTypo.caption
                          //             .copyWith(color: Colors.grey),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          Text("Detail Alamat"),
                          SizedBox(height: 8),
                          EditText(
                            controller: alamatController,
                            hintText: "Detail Alamat",
                            inputType: InputType.field,
                            validator: validation,
                          ),
                          SizedBox(height: 36),
                          RoundedButton.contained(
                              label: "Selanjutnya",
                              textColor: Colors.white,
                              isUpperCase: false,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  final AlamatPelangganWithCart alamatWithCart =
                                      AlamatPelangganWithCart(
                                          nama: nameController.text,
                                          alamat: alamatController.text,
                                          email: emailController.text,
                                          telepon: phoneController.text,
                                          kecamatan: kecamatanController.text,
                                          idKecamatan: recipentRepo
                                                  .getSelectedRecipentNoAuth()[
                                              'subdistrict_id'],
                                          newCart: widget.cart);

                                  recipentRepo.setRecipentUserNoAuth(
                                      subdistrictId: recipentRepo
                                              .getSelectedRecipentNoAuth()[
                                          'subdistrict_id'],
                                      subdistrict: recipentRepo
                                              .getSelectedRecipentNoAuth()[
                                          'subdistrict'],
                                      city: recipentRepo
                                          .getSelectedRecipentNoAuth()['city'],
                                      province: recipentRepo
                                              .getSelectedRecipentNoAuth()[
                                          'province'],
                                      name: nameController.text,
                                      address: alamatController.text,
                                      phone: phoneController.text);

                                  // recipentRepo.setRecipentUserNoAuthDashboard(
                                  //     subdistrictId: recipentRepo
                                  //             .getSelectedRecipentNoAuthDashboard()[
                                  //         'subdistrict_id'],
                                  //     subdistrict: recipentRepo
                                  //             .getSelectedRecipentNoAuthDashboard()[
                                  //         'subdistrict'],
                                  //     city: recipentRepo
                                  //             .getSelectedRecipentNoAuthDashboard()[
                                  //         'city'],
                                  //     province: recipentRepo
                                  //             .getSelectedRecipentNoAuthDashboard()[
                                  //         'province'],
                                  //     name: nameController.text,
                                  //     address: alamatController.text,
                                  //     phone: phoneController.text);

                                  // recipentRepo.setRecipentUserNoAuthDetailProduct(
                                  //     subdistrictId: recipentRepo
                                  //             .getSelectedRecipentNoAuthDashboard()[
                                  //         'subdistrict_id'],
                                  //     subdistrict: recipentRepo
                                  //             .getSelectedRecipentNoAuthDashboard()[
                                  //         'subdistrict'],
                                  //     city: recipentRepo
                                  //             .getSelectedRecipentNoAuthDashboard()[
                                  //         'city'],
                                  //     province: recipentRepo
                                  //             .getSelectedRecipentNoAuthDashboard()[
                                  //         'province'],
                                  //     name: nameController.text,
                                  //     address: alamatController.text,
                                  //     phone: phoneController.text);

                                  debugPrint("cart ${widget.cart}");
                                  if (kIsWeb) {
                                    context.beamToNamed(
                                        '/wpp/checkout?dt=${AppExt.encryptMyData(jsonEncode(alamatWithCart))}');
                                  }
                                }

                                // AppExt.pushScreen(context, CheckoutScreen(cart: widget.cart,));
                              })
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  // void showBSRegion(double screenWidth,
  //     {void Function(
  //             String kecamatan, String kota, String provinsi, int idKecamatan)
  //         onTap}) {
  //   final topPadding = MediaQuery.of(context).padding.top;
  //   showModalBottomSheet(
  //       context: context,
  //       isDismissible: false,
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
  //       builder: (ctx) {
  //         return Container(
  //           padding: EdgeInsets.all(16),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: Container(
  //                   width: screenWidth * (15 / 100),
  //                   height: 7,
  //                   decoration: BoxDecoration(
  //                     color: Colors.black.withOpacity(0.15),
  //                     borderRadius: BorderRadius.circular(7.5 / 2),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 16,
  //               ),
  //               Text(
  //                 "Lokasi",
  //                 style: AppTypo.LatoBold.copyWith(fontSize: 18),
  //               ),
  //               SizedBox(
  //                 height: 16,
  //               ),
  //               EditText(
  //                 hintText: "Tulis min 3 karakter",
  //                 inputType: InputType.text,
  //                 onChanged: (String value) {
  //                   if (value.length >= 3) {
  //                     context
  //                         .read<KecamatanSearchCubit>()
  //                         .search(keyword: value);
  //                   }
  //                 },
  //               ),
  //               Expanded(
  //                 child:
  //                     BlocBuilder<KecamatanSearchCubit, KecamatanSearchState>(
  //                   builder: (context, state) {
  //                     if (state is KecamatanSearchLoading) {
  //                       return Center(
  //                         child: CircularProgressIndicator(),
  //                       );
  //                     }
  //                     if (state is KecamatanSearchFailure) {
  //                       return Text("Failure");
  //                     }
  //                     if (state is KecamatanSearchSuccess) {
  //                       final items = state.result;
  //                       return ListView.builder(
  //                           itemCount: items.length,
  //                           itemBuilder: (context, i) {
  //                             return ListTile(
  //                               onTap: () {
  //                                 AppExt.popScreen(context);
  //                                 context
  //                                     .read<ChooseKecamatanCubit>()
  //                                     .chooseKecamatan(
  //                                       kecamatan:
  //                                           "${items[i].subdistrictName}, ${items[i].type} ${items[i].city}, ${items[i].province}",
  //                                       subDistrict: items[i].subdistrictId,
  //                                     );
  //                                 onTap(
  //                                     items[i].subdistrictName,
  //                                     items[i].city,
  //                                     items[i].province,
  //                                     items[i].subdistrictId);
  //                                 recipentRepo.setRecipentUserNoAuth(
  //                                     subdistrictId: items[i].subdistrictId,
  //                                     subdistrict: items[i].subdistrictName,
  //                                     city:items[i].city,
  //                                     province:  items[i].province,
  //                                     name: nameController.text,
  //                                     address: alamatController.text,
  //                                     phone: phoneController.text);

  //                                 recipentRepo.setRecipentUserNoAuthDashboard(
  //                                     subdistrictId: items[i].subdistrictId,
  //                                     subdistrict: items[i].subdistrictName,
  //                                     city:items[i].city,
  //                                     province:  items[i].province,
  //                                     name: nameController.text,
  //                                     address: alamatController.text,
  //                                     phone: phoneController.text);
                                  
  //                                 recipentRepo.setRecipentUserNoAuthDetailProduct(
  //                                     subdistrictId: items[i].subdistrictId,
  //                                     subdistrict: items[i].subdistrictName,
  //                                     city:items[i].city,
  //                                     province:  items[i].province,
  //                                     name: nameController.text,
  //                                     address: alamatController.text,
  //                                     phone: phoneController.text);
  //                               },
  //                               leading: Icon(
  //                                 Icons.location_on_outlined,
  //                               ),
  //                               title: Text(
  //                                 "${items[i].subdistrictName}, ${items[i].type} ${items[i].city}, ${items[i].province}",
  //                                 style: AppTypo.body1Lato
  //                                     .copyWith(fontWeight: FontWeight.w600),
  //                               ),
  //                               minLeadingWidth: 5,
  //                               contentPadding: EdgeInsets.zero,
  //                             );
  //                           });
  //                     }
  //                     return SizedBox();
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }
}
