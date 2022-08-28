import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/reseller_shop/entry_shop/entry_shop_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/supplier/edit_profile_supplier/edit_profile_supplier_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/user.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/image_picker_frame.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class JoinUserProfileEntryScreen extends StatefulWidget {
  const JoinUserProfileEntryScreen({Key key, this.userData, this.userType})
      : super(key: key);

  final User userData;
  final UserType userType;

  @override
  State<JoinUserProfileEntryScreen> createState() =>
      _JoinUserProfileEntryScreenState();
}

class _JoinUserProfileEntryScreenState
    extends State<JoinUserProfileEntryScreen> {
  final picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController nameShopController;
  TextEditingController addressShopController;

  EntryShopCubit _entryShopCubit;
  EditProfileSupplierCubit _editProfileSupplierCubit;

  File _image;

  bool isReseller = false;
  bool isSupplier = false;
  bool isUpdateEntry = false;
  bool hasOpenedShop = false;
  bool _isSubmitLoading;

  int selectedSubdistrictId = 0;
  String selectedLocation;

  @override
  void initState() {
    _image = null;
    _entryShopCubit = EntryShopCubit();
    _editProfileSupplierCubit = EditProfileSupplierCubit();

    updateState();

    _isSubmitLoading = false;

    super.initState();
  }

  void updateState() {
    isReseller = widget.userType == UserType.reseller;
    isSupplier = widget.userType == UserType.supplier;
    isUpdateEntry = isReseller || isSupplier;
    debugPrint("isWarungPanen $isReseller");
    debugPrint("isSupplier $isSupplier");
    debugPrint("iUpdateEntry $isUpdateEntry");

    nameShopController = TextEditingController(
        text: isUpdateEntry
            ? isReseller
                ? widget.userData.reseller.name
                : widget.userData.supplier.name
            : null);
    addressShopController = TextEditingController(
        text: isUpdateEntry
            ? isReseller
                ? widget.userData.reseller.address
                : widget.userData.supplier.address
            : null);
    selectedLocation = isUpdateEntry
        ? isReseller
            ? "${widget.userData.reseller.subdistrict},${widget.userData.reseller.city},${widget.userData.reseller.province}"
            : "${widget.userData.supplier.subdistrict},${widget.userData.supplier.city},${widget.userData.supplier.province}"
        : null;

    selectedSubdistrictId = isReseller
        ? widget.userData.reseller.subdistrictId
        : widget.userData.supplier.subdistrictId;
  }

  _pickImageFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    AppExt.popScreen(context);
  }

  _pickImageFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    AppExt.popScreen(context);
  }

  void handleEntryShop() async {
    if (_isNotValid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Input tidak valid"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() => _isSubmitLoading = true);
    await Future.delayed(Duration(milliseconds: 500));

    try {
      if (isUpdateEntry) {
        if (isReseller) {
          _entryShopCubit.editProfileShop(
              nameShop: nameShopController.text.trim(),
              phoneNumber: null,
              logo: _image != null ? _image.path.toString() : null,
              subdistrictId: selectedSubdistrictId.toString(),
              address: addressShopController.text);
        } else {
          _editProfileSupplierCubit.editProfileSupplier(
              nameShop: nameShopController.text.trim(),
              phoneNumber: widget.userData.supplier.phone,
              logo: _image != null ? _image.path.toString() : null,
              subdistrictId: selectedSubdistrictId.toString(),
              address: addressShopController.text);
        }
      } else {
        BSFeedback.show(context,
            title: "Buat toko masih dalam tahap pengembangan",
            color: AppColor.primary);
      }
      setState(() => _isSubmitLoading = false);
    } catch (e) {
      _handleError(e);
    }
    setState(() => _isSubmitLoading = false);
  }

  void _handleError(dynamic e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: AppColor.primary,
    ));
  }

  bool _isNotValid() {
    bool isNotValid = nameShopController.text.trim().isEmpty ||
        addressShopController.text.trim().isEmpty ||
        selectedLocation == null;

    return isNotValid;
  }

  @override
  void dispose() {
    _entryShopCubit.close();
    _editProfileSupplierCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => _entryShopCubit,
        ),
        BlocProvider(
          create: (context) => _editProfileSupplierCubit,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EntryShopCubit, EntryShopState>(
            listener: (context, state) {
              if (state is EntryShopSuccess) {
                AppExt.popScreen(context, true);
                BSFeedback.show(context,
                    title: "ubah profil toko berhasil",
                    color: AppColor.primary);
              }
              if (state is EntryShopFailure) {
                debugPrint(state.message);
                BSFeedback.show(context,
                    title: "ubah profil toko gagal", color: AppColor.danger);
              }
            },
          ),
          BlocListener<EditProfileSupplierCubit, EditProfileSupplierState>(
            listener: (context, state) {
              if (state is EditProfileSupplierSuccess) {
                AppExt.popScreen(context, true);
                BSFeedback.show(context,
                    title: "ubah profil supplier berhasil",
                    color: AppColor.primary);
              }
              if (state is EditProfileSupplierFailure) {
                debugPrint(state.message);
                BSFeedback.show(context,
                    title: "ubah profil supplier gagal",
                    color: AppColor.danger);
              }
            },
          ),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
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
                      title: isUpdateEntry
                          ? Text(
                              "Ubah Profil ${isSupplier ? 'Supplier' : 'Toko'} ")
                          : Text("Lengkapi Profil Toko"),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _screenWidth * (5 / 100)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama",
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.userData.name,
                          style: AppTypo.body1.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No Telepon",
                        ),
                        SizedBox(height: 8),
                        Text(
                            AppExt.formatPhoneNumber(
                                widget.userData.phonenumber),
                            style: AppTypo.body1.copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                          "Nama ${isReseller ? 'Toko' : 'Supplier'}",
                        ),
                        SizedBox(height: 8),
                        EditText(
                          hintText: "Nama toko anda",
                          controller: nameShopController,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Kecamatan",
                        ),
                        SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 20,
                          onTap: () => showBSRegion(_screenWidth, onTap:
                              (kecamatan, kota, provinsi, valueIdKecamatan) {
                            setState(() {
                              selectedLocation = ",,";
                              selectedSubdistrictId = valueIdKecamatan;
                            });
                          }),
                          leading: Icon(
                            EvaIcons.pinOutline,
                            color: Colors.grey,
                          ),
                          title: Text(
                            selectedLocation ?? "Pilih kota atau kecamatan",
                            style:
                                AppTypo.caption.copyWith(color: Colors.black),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColor.grey,
                          ),
                        ),
                        Text("Alamat"),
                        SizedBox(height: 8),
                        EditText(
                          hintText: "",
                          inputType: InputType.field,
                          controller: addressShopController,
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Upload Logo Toko"),
                            IconButton(
                              icon: Icon(
                                EvaIcons.editOutline,
                                color: AppColor.grey,
                              ),
                              onPressed: () => showSheetImage(context),
                            ),
                          ],
                        ),
                        // SizedBox(height: 5),
                        ImagePickerFrame(
                            hostedImage: isReseller
                                ? widget.userData.reseller.logo
                                : widget.userData.supplier.logo ?? null,
                            image: _image,
                            width: _screenWidth,
                            height: 250,
                            radius: 20),
                        SizedBox(height: 28),
                        RoundedButton.contained(
                          label: !isUpdateEntry ? "Simpan" : "Ubah",
                          textColor: Colors.white,
                          isLoading: _isSubmitLoading,
                          isUpperCase: false,
                          onPressed: () {
                            if (isUpdateEntry) {
                              BsConfirmation().dialog(
                                context: context,
                                onYes: handleEntryShop,
                                title:
                                    "Dengan mengganti nama toko akan menghapus url link toko lama anda.",
                                subtitle:
                                    "Apakah anda yakin untuk mengganti nama toko anda?",
                              );
                            } else {
                              handleEntryShop();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future showSheetImage(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 130,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _pickImageFromGallery();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FlutterIcons.image_faw,
                        color: AppColor.primary,
                        size: 50,
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          "Galeri",
                          style: AppTypo.captionAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _pickImageFromCamera();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FlutterIcons.camera_outline_mco,
                        color: AppColor.primary,
                        size: 50,
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          "Kamera",
                          style: AppTypo.captionAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showBSRegion(double screenWidth,
      {void Function(
              String kecamatan, String kota, String provinsi, int idKecamatan)
          onTap}) {
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
                                  onTap(
                                      items[i].subdistrictName,
                                      items[i].city,
                                      items[i].province,
                                      items[i].subdistrictId);
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
