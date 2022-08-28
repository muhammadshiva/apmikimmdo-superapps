import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/nav/new/account/address_entry_screen.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_account_screen.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_address_screen.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class BsDeliveryAddress {
  static Future show(BuildContext context, {void Function() onTap}) async {
    double _screenWidth = MediaQuery.of(context).size.width;
    AppExt.hideKeyboard(context);

    await showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext bc) {
          return BsDeliveryAddressItem(
            onTap: onTap,
          );
        });
  }
}

class BsDeliveryAddressItem extends StatefulWidget {
  const BsDeliveryAddressItem({
    Key key,
    this.onTap,
  }) : super(key: key);

  final void Function() onTap;

  @override
  State<BsDeliveryAddressItem> createState() => _BsDeliveryAddressItemState();
}

class _BsDeliveryAddressItemState extends State<BsDeliveryAddressItem> {
  //Gs = GetStorage
  final gs = GetStorage();
  final RecipentRepository _recipentRepo = RecipentRepository();
  FetchRecipentCubit _fetchRecipentCubit = FetchRecipentCubit()
    ..fetchRecipents();
  FetchSelectedRecipentCubit _fetchSelectedRecipentCubit =
      FetchSelectedRecipentCubit()..fetchSelectedRecipent();

  int recipentId = 0;
  int recipentIdFromGs;

  Recipent recipentMainAddress;

  @override
  void dispose() {
    _fetchRecipentCubit.close();
    _fetchSelectedRecipentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    // final dataRecipentSelected = gs.read('recipentSelected');
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _fetchRecipentCubit,
          ),
          BlocProvider(
            create: (_) => _fetchSelectedRecipentCubit,
          ),
        ],
        child: BlocListener(
          cubit: _fetchSelectedRecipentCubit,
          listener: (context, state) {
            if (state is FetchSelectedRecipentSuccess) {
              setState(() {
                recipentMainAddress = state.recipent;
              });
            }
            if (state is FetchSelectedRecipentFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    margin: EdgeInsets.zero,
                    duration: Duration(seconds: 2),
                    content: Text('Terjadi Kesalahan'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pilih Alamat Pengiriman",
                      style: AppTypo.subtitle1
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        AppExt.popScreen(context);
                      },
                      icon: Icon(Icons.close),
                    )
                  ],
                ),
                BlocProvider.of<UserDataCubit>(context).state.user != null
                    ? BlocBuilder(
                        cubit: _fetchRecipentCubit,
                        builder: (context, state) => state
                                is FetchRecipentLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : state is FetchRecipentFailure
                                ? Center(
                                    child: Text("Terjadi Kesalahan"),
                                  )
                                : state is FetchRecipentSuccess
                                    ? state.recipent.length > 0
                                        ? Container(
                                            height: 130,
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              separatorBuilder: (ctx, index) =>
                                                  SizedBox(
                                                width: 10,
                                              ),
                                              itemCount:
                                                  state.recipent.length + 1,
                                              itemBuilder: (context, index) {
                                                return index ==
                                                        state.recipent.length
                                                    ? InkWell(
                                                        onTap: () {
                                                          AppExt.pushScreen(
                                                            context,
                                                            UpdateAddressScreen(),
                                                          );
                                                        },
                                                        child: Material(
                                                          elevation: 0,
                                                          child: Container(
                                                            width: 120,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                border: Border.all(
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                    width:
                                                                        1.4)),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Material(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  elevation: 3,
                                                                  child:
                                                                      CircleAvatar(
                                                                    child: Icon(
                                                                      EvaIcons
                                                                          .chevronRight,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  "Cek Alamat Lainnya",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: AppTypo.caption.copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            recipentId = state
                                                                .recipent[index]
                                                                .id;
                                                          });
                                                          _recipentRepo
                                                              .updateMainAddress(
                                                                  recipentId: state
                                                                      .recipent[
                                                                          index]
                                                                      .id);
                                                          _recipentRepo.setRecipent(
                                                              id: state
                                                                  .recipent[
                                                                      index]
                                                                  .id,
                                                              isMainAddress: state
                                                                  .recipent[
                                                                      index]
                                                                  .isMainAddress,
                                                              name: state
                                                                  .recipent[
                                                                      index]
                                                                  .name,
                                                              phone: state
                                                                  .recipent[
                                                                      index]
                                                                  .phone,
                                                              email: state
                                                                  .recipent[
                                                                      index]
                                                                  .email,
                                                              address: state
                                                                  .recipent[
                                                                      index]
                                                                  .address,
                                                              subdistrictId: state
                                                                  .recipent[
                                                                      index]
                                                                  .subdistrictId,
                                                              subdistrict: state
                                                                  .recipent[
                                                                      index]
                                                                  .subdistrict,
                                                              postalCode: state
                                                                  .recipent[
                                                                      index]
                                                                  .postalCode,
                                                              note: state
                                                                  .recipent[
                                                                      index]
                                                                  .note);
                                                          widget.onTap();
                                                        },
                                                        child: Material(
                                                          elevation: 0,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            width: 200,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: recipentMainAddress != null &&
                                                                          recipentMainAddress.isMainAddress ==
                                                                              1 &&
                                                                          state.recipent[index].isMainAddress ==
                                                                              1
                                                                      ? AppColor
                                                                          .bgBadgePink
                                                                      : Colors
                                                                          .grey[
                                                                              300]
                                                                          .withOpacity(
                                                                              0.6),
                                                                  width: 1.4),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color: recipentMainAddress !=
                                                                          null &&
                                                                      recipentMainAddress
                                                                              .isMainAddress ==
                                                                          1 &&
                                                                      state.recipent[index].isMainAddress ==
                                                                          1
                                                                  ? AppColor
                                                                      .bgBadgePink
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  state
                                                                      .recipent[
                                                                          index]
                                                                      .name,
                                                                  style: AppTypo
                                                                      .caption
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                    "+${state.recipent[index].phone}",
                                                                    style: AppTypo
                                                                        .caption,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "${state.recipent[index].address}, ${state.recipent[index].subdistrict}, ${state.recipent[index].city}, ${state.recipent[index].province}",
                                                                  style: AppTypo
                                                                      .caption,
                                                                  maxLines: 3,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                              },
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              SizedBox(
                                                height: 32,
                                              ),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Alamat Kosong",
                                                    style: AppTypo.subtitle2
                                                        .copyWith(
                                                            color: Colors.grey),
                                                    textAlign: TextAlign.center,
                                                  )),
                                              SizedBox(
                                                height: 32,
                                              ),
                                              RoundedButton.contained(
                                                  label: "Tambah Alamat Baru",
                                                  isUpperCase: false,
                                                  onPressed: () async {
                                                    bool isChanged =
                                                        await AppExt.pushScreen(
                                                      context,
                                                      AddressEntryScreen(
                                                        isFromBsDeliveryAddress:
                                                            true,
                                                        triggerRefreshRecipent:
                                                            () {
                                                          _fetchRecipentCubit
                                                              .fetchRecipents();
                                                        },
                                                      ),
                                                    );
                                                    if (isChanged == true) {
                                                      widget.onTap();
                                                    }
                                                  })
                                            ],
                                          )
                                    : SizedBox.shrink())
                    : Column(
                        children: [
                          Text(
                            "Tentukan alamat pengiriman dengan klik “pilih kecamatan”. Agar kami bisa memberikan rekomendasi produk yang sesuai.",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: AppColor.silverFlashSale,
                  height: 2,
                  thickness: 2,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Mau pakai cara lain",
                  style: AppTypo.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () => showBSRegion(_screenWidth, onTap: widget.onTap),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        EvaIcons.pinOutline,
                        color: AppColor.textSecondary2,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Pilih kecamatan",
                        style: AppTypo.caption.copyWith(
                            color: AppColor.textSecondary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    EvaIcons.chevronRight,
                    color: AppColor.textSecondary2,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
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
                                  _recipentRepo.setRecipent(
                                      subdistrictId: items[i].subdistrictId,
                                      subdistrict: items[i].subdistrictName,
                                      address: '-');
                                  widget.onTap();
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
