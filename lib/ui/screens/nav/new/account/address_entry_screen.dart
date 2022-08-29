import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/add_recipent/add_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/edit_recipent/edit_recipent_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/widgets/widgets.dart';

import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/colors.dart' as AppColor;

class AddressEntryScreen extends StatefulWidget {
  const AddressEntryScreen({
    Key key,
    this.recipent,
    this.isFromBsDeliveryAddress = false,
    this.triggerRefreshRecipent,
  }) : super(key: key);

  final Recipent recipent;
  final void Function() triggerRefreshRecipent;
  final bool isFromBsDeliveryAddress;

  @override
  _AddressEntryScreenState createState() => _AddressEntryScreenState();
}

class _AddressEntryScreenState extends State<AddressEntryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final RecipentRepository _recipentRepo = RecipentRepository();
  final _formKey = GlobalKey<FormState>();

  final gs = GetStorage();

  AddRecipentCubit _addRecipentCubit;
  EditRecipentCubit _editRecipentCubit;

  TextEditingController _nameController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;
  TextEditingController _emailController;
  TextEditingController _postalCodeController;
  TextEditingController _noteController;

  int selectedSubdistrictId;
  String selectedLocation;
  bool _isSubmitLoading;
  bool isUpdateEntry;
  bool isKecamatanValid = true;

  @override
  void initState() {
    isUpdateEntry = widget.recipent != null;
    _addRecipentCubit = AddRecipentCubit();
    _editRecipentCubit = EditRecipentCubit();

    _nameController = TextEditingController(
        text: isUpdateEntry ? widget.recipent.name : null);
    _phoneNumberController = TextEditingController(
        text: isUpdateEntry
            ? AppExt.removeCodePhone(widget.recipent.phone)
            : null);
    _addressController = TextEditingController(
        text: isUpdateEntry ? widget.recipent.address : null);
    _postalCodeController = TextEditingController(
        text: isUpdateEntry ? widget.recipent.postalCode : null);
    _emailController = TextEditingController(
        text: isUpdateEntry ? widget.recipent.email : null);
    _noteController = TextEditingController(
        text: isUpdateEntry ? widget.recipent.note : null);
    _isSubmitLoading = false;

    if (isUpdateEntry) {
      selectedLocation =
          "${widget.recipent.subdistrict},${widget.recipent.city},${widget.recipent.province}";
      selectedSubdistrictId = widget.recipent.subdistrictId;
    }

    super.initState();
  }

  String validation(String value) {
    if (value.isEmpty) {
      return "Wajib diisi";
    }
    return null;
  }

  String validationPhone(String value) {
    if (value.isEmpty) {
      return "Wajib diisi";
    }
    if (value.length < 10) {
      return "Nomor telpon harus minimal 10 digit";
    }
    return null;
  }

  String validationEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Email tidak valid";
    }
    return null;
  }

  void _handleSubmit() async {
    // if (_isNotValid()) {
    //   _scaffoldKey.currentState.hideCurrentSnackBar();
    //   _scaffoldKey.currentState.showSnackBar(
    //     new SnackBar(
    //       content: new Text(
    //         "Input tidak valid",
    //       ),
    //     ),
    //   );
    //   return;
    // }

    // setState(() => _isSubmitLoading = true);
    // await Future.delayed(Duration(milliseconds: 500));

    if (selectedSubdistrictId == null) {
      setState(() {
        isKecamatanValid = false;
      });
    } else {
      setState(() {
        isKecamatanValid = true;
      });
    }

    if (_formKey.currentState.validate()) {
      if (isKecamatanValid) {
        if (isUpdateEntry) {
          _editRecipentCubit.editRecipentAddress(
              recipentId: widget.recipent.id,
              name: _nameController.text.trim(),
              phone: int.parse('62${_phoneNumberController.text}'),
              address: _addressController.text.trim(),
              email: _emailController.text.trim(),
              subdistrictId:
                  selectedSubdistrictId ?? widget.recipent.subdistrictId,
              postalCode: int.parse(_postalCodeController.text.trim()),
              note: _noteController.text.trim(),
              isMainAddress: widget.recipent.isMainAddress);
        } else {
          _addRecipentCubit.addRecipent(
              name: _nameController.text.trim(),
              phone: int.parse('62${_phoneNumberController.text}'),
              address: _addressController.text.trim(),
              email: _emailController.text.trim(),
              subdistrictId: selectedSubdistrictId,
              postalCode: int.parse(_postalCodeController.text.trim()),
              note: _noteController.text.trim());
        }
        setState(() => _isSubmitLoading = false);
        // AppExt.popScreen(context, true);
      }
    }

    setState(() => _isSubmitLoading = false);
  }

  void _handleError(dynamic e) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    /* _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          e.toString(),
        ),
      ),
    ); */
  }

  // bool _isNotValid() {
  //   bool isNotValid = _nameController.text.trim().isEmpty ||
  //       _addressController.text.trim().isEmpty ||
  //       _emailController.text.trim().isEmpty ||
  //       _postalCodeController.text.trim().isEmpty ||
  //       _noteController.text.trim().isEmpty ||
  //       _phoneNumberController.text.trim().isEmpty;

  //   return isNotValid;
  // }

  @override
  void dispose() {
    _addRecipentCubit.close();
    _editRecipentCubit.close();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _postalCodeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        if (widget.isFromBsDeliveryAddress) {
          AppExt.popScreen(context, false);
        } else {
          AppExt.popScreen(context);
        }
        return;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _addRecipentCubit),
          BlocProvider(create: (_) => _editRecipentCubit)
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener(
                cubit: _addRecipentCubit,
                listener: (context, state) {
                  if (state is AddRecipentSuccess) {
                    if (widget.isFromBsDeliveryAddress) {
                      AppExt.popScreen(context, true);
                    } else {
                      AppExt.popScreen(context, state.data.id);
                    }
                    _recipentRepo.setRecipent(
                        id: state.data.id,
                        isMainAddress: state.data.isMainAddress,
                        name: state.data.name,
                        phone: state.data.phone,
                        email: state.data.email,
                        address: state.data.address,
                        subdistrictId: state.data.subdistrictId,
                        subdistrict: state.data.subdistrict,
                        postalCode: state.data.postalCode,
                        note: state.data.note);
                    ScaffoldMessenger.of(context)
                      ..showSnackBar(
                        SnackBar(
                          margin: EdgeInsets.zero,
                          duration: Duration(seconds: 2),
                          content: Text('Tambah alamat sukses'),
                          backgroundColor: AppColor.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  }
                  if (state is AddRecipentFailure) {
                    ScaffoldMessenger.of(context)
                      ..showSnackBar(
                        SnackBar(
                          margin: EdgeInsets.zero,
                          duration: Duration(seconds: 2),
                          content: Text('${state.message}'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    debugPrint("ERROR ALAMAT :" + state.message);
                  }
                }),
            BlocListener(
                cubit: _editRecipentCubit,
                listener: (context, state) {
                  if (state is EditRecipentSuccess) {
                    AppExt.popScreen(context, true);
                    ScaffoldMessenger.of(context)
                      ..showSnackBar(
                        SnackBar(
                          margin: EdgeInsets.zero,
                          duration: Duration(seconds: 2),
                          content: Text('Ubah alamat berhasil'),
                          backgroundColor: AppColor.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  }
                  if (state is EditRecipentFailure) {
                    ScaffoldMessenger.of(context)
                      ..showSnackBar(
                        SnackBar(
                          margin: EdgeInsets.zero,
                          duration: Duration(seconds: 2),
                          content: Text('${state.message}'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    debugPrint(state.message);
                  }
                })
          ],
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
            child: GestureDetector(
              onTap: () => AppExt.hideKeyboard(context),
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Stack(
                    children: [
                      NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              textTheme:
                                  TextTheme(headline6: AppTypo.subtitle2),
                              iconTheme: IconThemeData(color: Colors.black),
                              backgroundColor: Colors.white,
                              centerTitle: true,
                              forceElevated: false,
                              pinned: true,
                              shadowColor: Colors.black54,
                              floating: true,
                              title: Text(isUpdateEntry
                                  ? "Ubah Alamat"
                                  : "Alamat Saya"),
                              brightness: Brightness.dark,
                            ),
                          ];
                        },
                        body: SingleChildScrollView(
                          physics: new BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _screenWidth * (5 / 100),
                                vertical: _screenWidth * (3 / 100)),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  !isUpdateEntry
                                      ? Text(
                                          "Mau dikirim kemana produk yang kamu beli?",
                                          style: AppTypo.h2.copyWith(
                                              fontWeight: FontWeight.w500),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: !isUpdateEntry ? 25 : 0,
                                  ),
                                  InputLabel(
                                      title: "Nama Penerima", required: true),
                                  SizedBox(height: 8),
                                  EditText(
                                    hintText: "Nama Penerima",
                                    inputType: InputType.text,
                                    controller: this._nameController,
                                    validator: validation,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InputLabel(
                                      title: "No Telepon", required: true),
                                  SizedBox(height: 8),
                                  EditText(
                                    keyboardType: TextInputType.phone,
                                    hintText: "Nomor Telepon Penerima",
                                    inputType: InputType.phone,
                                    controller: this._phoneNumberController,
                                    validator: validationPhone,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'^0')),
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'^62+')),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InputLabel(title: "Email", required: false),
                                  SizedBox(height: 8),
                                  EditText(
                                    hintText: "Email ",
                                    inputType: InputType.text,
                                    controller: this._emailController,
                                    validator: validationEmail,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InputLabel(
                                      title: "Kecamatan", required: true),
                                  SizedBox(height: 8),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    onTap: () => showBSRegion(_screenWidth,
                                        onTap: (kecamatan, kota, provinsi,
                                            valueIdKecamatan) {
                                      setState(() {
                                        selectedLocation =
                                            "$kecamatan,$kota,$provinsi";
                                        selectedSubdistrictId =
                                            valueIdKecamatan;
                                      });
                                    }),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          selectedLocation ??
                                              "Pilih kota atau kecamatan",
                                          style: AppTypo.caption
                                              .copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: AppColor.grey,
                                    ),
                                  ),
                                  !isKecamatanValid
                                      ? Text(
                                          "Wajib diisi",
                                          style: AppTypo.body1.copyWith(
                                              color: AppColor.danger,
                                              fontSize: 12),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InputLabel(title: "Kodepos", required: true),
                                  SizedBox(height: 8),
                                  EditText(
                                    hintText: "Kodepos",
                                    controller: this._postalCodeController,
                                    keyboardType: TextInputType.number,
                                    validator: validation,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InputLabel(
                                      title: "Alamat Penerima", required: true),
                                  SizedBox(height: 8),
                                  EditText(
                                    hintText: "Alamat Penerima",
                                    inputType: InputType.field,
                                    controller: this._addressController,
                                    validator: validation,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InputLabel(title: "Catatan", required: false),
                                  SizedBox(height: 8),
                                  EditText(
                                    hintText: "",
                                    inputType: InputType.field,
                                    controller: this._noteController,
                                  ),
                                  SizedBox(height: 20),
                                  RoundedButton.contained(
                                    textColor: Colors.white,
                                    isLoading: _isSubmitLoading,
                                    isUpperCase: false,
                                    label: isUpdateEntry ? "Ubah" : "Simpan",
                                    onPressed: _handleSubmit,
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText InputLabel({String title, bool required}) {
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(color: AppColor.textPrimary),
        children: <TextSpan>[
          required == true
              ? TextSpan(
                  text: " *",
                  style: TextStyle(color: AppColor.red),
                )
              : TextSpan(
                  text: " ",
                  style: TextStyle(color: AppColor.red),
                ),
        ],
      ),
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
        // isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75),
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
                      child: BlocBuilder<KecamatanSearchCubit,
                          KecamatanSearchState>(
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
                                      style: AppTypo.body1Lato.copyWith(
                                          fontWeight: FontWeight.w600),
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
              ),
            ],
          );
        });
  }
}
