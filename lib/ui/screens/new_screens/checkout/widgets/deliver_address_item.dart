import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_account_screen.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_address_screen.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/shimmer_widget.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:shimmer/shimmer.dart';

class DeliverAddressItem extends StatefulWidget {
  const DeliverAddressItem(
      {Key key,
      this.cart,
      this.recipentIdNow,
      this.isAlreadyCheckout = false,
      this.triggerRefreshRecipent})
      : super(key: key);

  final List<NewCart> cart;
  final ValueChanged<int> recipentIdNow;
  final void Function() triggerRefreshRecipent; //buat trigger di checkoutscreen
  final bool isAlreadyCheckout;

  @override
  _DeliverAddressItemState createState() => _DeliverAddressItemState();
}

class _DeliverAddressItemState extends State<DeliverAddressItem> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final RecipentRepository _recipentRepo = RecipentRepository();

  FetchRecipentCubit _fetchRecipentCubit;
  FetchSelectedRecipentCubit _fetchSelectedRecipentCubit;

  @override
  void initState() {
    _fetchRecipentCubit = FetchRecipentCubit()..fetchRecipents();
    _fetchSelectedRecipentCubit = FetchSelectedRecipentCubit()
      ..fetchSelectedRecipent();
    super.initState();
  }

  void _handleAddAddress() async {
    int recipentId = await AppExt.pushScreen(
      context,
      AddressEntryScreen(),
    );
    if (recipentId != null) {
      _fetchRecipentCubit.fetchRecipents();
      widget.triggerRefreshRecipent();
    }
  }

  void _handleChangeAddress() async {
    var recipent = await AppExt.pushScreen(
      context,
      UpdateAddressScreen(
        isFromCheckout: true,
      ),
    );
    if (recipent != null) {
      _fetchRecipentCubit.fetchRecipents();
      widget.recipentIdNow(recipent);
      widget.triggerRefreshRecipent();
    } else {
      _fetchRecipentCubit.fetchRecipents();
      widget.triggerRefreshRecipent();
    }
  }

  @override
  void dispose() {
    _fetchRecipentCubit.close();
    _fetchSelectedRecipentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => _fetchRecipentCubit,
        ),
        BlocProvider(
          create: (_) => _fetchSelectedRecipentCubit,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener(
            cubit: _fetchRecipentCubit,
            listener: (_, state) async {
              if (state is FetchRecipentSuccess) {
                _fetchSelectedRecipentCubit.fetchSelectedRecipent();
                final getSelectedRecipent = _recipentRepo.getSelectedRecipent();
                List<Recipent> recipents = [];
                // debugPrint("ID RECIPENT SEKARANG : ${getSelectedRecipent['subdistrict_id']}");
                if (getSelectedRecipent['id'] == 0) {
                  // Menandakan yang dipilih melalui kecamatan / kota
                  for (int i = 0; i < state.recipent.length; i++) {
                    if (state.recipent[i].subdistrictId ==
                        getSelectedRecipent['subdistrict_id']) {
                      recipents.add(state.recipent[i]);
                    }
                  }
                  if (recipents.length > 0) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text(
                            "Kami melihat ada ${recipents.length} alamat pengiriman sesuai pada wilayah yang anda pilih. Silahkan pilih alamat pengiriman")));
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text(
                            "Alamat pengiriman tidak ada pada wilayah yang anda pilih. Silahkan pilih alamat pengiriman")));
                  }
                }
              }
              if (state is FetchRecipentFailure) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                return;
              }
            },
          ),
        ],
        child: BlocBuilder(
            cubit: _fetchRecipentCubit,
            builder: (context, fetchRecipentState) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Alamat Pengiriman',
                            style: AppTypo.subtitle1
                                .copyWith(fontWeight: FontWeight.w700)),
                      ),
                      fetchRecipentState is FetchRecipentSuccess
                          ? FlatButton(
                              textColor: AppColor.primaryDark,
                              onPressed: fetchRecipentState.recipent.length > 0
                                  ? _handleChangeAddress
                                  : _handleAddAddress,
                              child: Text(
                                fetchRecipentState.recipent.length > 0
                                    ? "Pilih Alamat"
                                    : "Tambah Alamat",
                                style: AppTypo.overline.copyWith(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w900),
                              ),
                            )
                          : FlatButton(
                              textColor: AppColor.primaryDark,
                              onPressed: _handleAddAddress,
                              child: Text(
                                "Tambah Alamat",
                                style: AppTypo.overline.copyWith(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  fetchRecipentState is FetchRecipentSuccess
                      ? Container(
                          padding: EdgeInsets.all(_screenWidth * (4.5 / 100)),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.line, width: 1),
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: fetchRecipentState.recipent.length > 0
                              ? BlocBuilder(
                                  cubit: _fetchSelectedRecipentCubit,
                                  builder: (context, selectedRecipentState) =>
                                      selectedRecipentState
                                              is FetchSelectedRecipentSuccess
                                          ? selectedRecipentState.recipent.id !=
                                                  0
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Text(
                                                            "${selectedRecipentState.recipent.name}",
                                                            style: AppTypo
                                                                .overline
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Text(
                                                              "${selectedRecipentState.recipent.address}, ${selectedRecipentState.recipent.subdistrict}",
                                                              style: AppTypo
                                                                  .overline),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              "+${selectedRecipentState.recipent.phone}",
                                                              style: AppTypo
                                                                  .overline),
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                      FlutterIcons
                                                          .check_circle_mco,
                                                      color: AppColor.primary,
                                                      size: 35,
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                )
                                              : Center(
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          FlutterIcons
                                                              .map_marker_plus_mco,
                                                          size: 45,
                                                          color:
                                                              AppColor.primary,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Pilih alamat pengiriman",
                                                          style: AppTypo
                                                              .overlineAccent,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                          : Center(
                                              child: Text("Terjadi Kesalahan"),
                                            ))
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FlutterIcons.map_marker_plus_mco,
                                        size: 45,
                                        color: AppColor.primary,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Alamat pengiriman anda kosong",
                                        style: AppTypo.overlineAccent,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      : Container(
                          padding: EdgeInsets.all(_screenWidth * (4.5 / 100)),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.line, width: 1),
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: ShimmerAddress()),
                ],
              );
            }),
      ),
    );
  }

// Widget _buildAddressesItem({
//   BuildContext context,
//   @required Recipent address,
//   @required void Function() onTap,
//   @required bool isSelected,
//   @required bool isDisabled,
// }) {
//   final double _screenWidth = MediaQuery.of(context).size.width;

//   return InkWell(
//     borderRadius: BorderRadius.circular(7.5),
//     onTap: isDisabled ? null : onTap,
//     child: Container(
//       padding: EdgeInsets.all(_screenWidth * (4.5 / 100)),
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColor.line, width: 1),
//         borderRadius: BorderRadius.circular(7.5),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   "${address.name}",
//                   style: AppTypo.overline.copyWith(
//                       fontWeight: FontWeight.w700,
//                       color: isDisabled
//                           ? AppColor.textSecondary
//                           : AppColor.textPrimary),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "${address.address}, ${address.subdistrict}",
//                   style: AppTypo.overline.copyWith(
//                       color: isDisabled
//                           ? AppColor.textSecondary
//                           : AppColor.textPrimary),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "+${address.phone}",
//                   style: AppTypo.overline.copyWith(
//                       color: isDisabled
//                           ? AppColor.textSecondary
//                           : AppColor.textPrimary),
//                 ),
//               ],
//             ),
//           ),
//           Icon(
//             isSelected
//                 ? FlutterIcons.check_circle_mco
//                 : FlutterIcons.checkbox_blank_circle_outline_mco,
//             color: isDisabled ? AppColor.textSecondary : AppColor.primary,
//             size: 35,
//           ),
//           SizedBox(
//             height: 15,
//           ),
//         ],
//       ),
//     ),
//   );
// }

// void _showShippingAddressesDialog({
//   @required int lastSelectedId,
//   @required List<Recipent> addresses,
//   @required void Function(int id) onSelected,
// }) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         backgroundColor: Colors.white,
//         insetPadding: EdgeInsets.all(10),
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 30.0, left: 30, right: 30),
//           child: SingleChildScrollView(
//             physics: new BouncingScrollPhysics(),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Pilih Alamat Pengiriman',
//                       style: AppTypo.subtitle1
//                           .copyWith(fontWeight: FontWeight.w700),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 ListView.separated(
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: addresses.length,
//                   separatorBuilder: (context, index) => SizedBox(
//                     height: 15,
//                   ),
//                   itemBuilder: (context, index) {
//                     return _buildAddressesItem(
//                       context: context,
//                       isSelected: index == lastSelectedId,
//                       isDisabled: !addresses[index].isActive,
//                       address: addresses[index],
//                       onTap: () {
//                         onSelected(index);
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 RoundedButton.contained(
//                   isCompact: true,
//                   label: "Tambah Alamat Baru",
//                   onPressed: () {
//                     AppExt.popScreen(context);
//                     _handleAddAddress();
//                   },
//                   isUpperCase: false,
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
}
