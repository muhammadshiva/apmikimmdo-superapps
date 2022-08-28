import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/register_supplier_reseller/register_supplier_reseller_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class JoinUserScreen extends StatefulWidget {
  const JoinUserScreen({Key key, @required this.userType}) : super(key: key);

  final UserType userType;

  @override
  _JoinUserScreenState createState() => _JoinUserScreenState();
}

class _JoinUserScreenState extends State<JoinUserScreen> {
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  UserDataCubit _userDataCubit;

  bool isReseller = false;
  bool isSupplier = false;
  bool isUpdateEntry = false;

  String joinUserType;

  bool registerAsReseller = false;

  final namaSellerController = TextEditingController();
  final alamatController = TextEditingController();
  final kecamatanController = TextEditingController();
  final namaTokoController = TextEditingController();

  @override
  void initState() {
    _userDataCubit = BlocProvider.of<UserDataCubit>(context);
    context.read<ChooseKecamatanCubit>().reset();
    debugPrint("roleid ${_userDataCubit.state.user}");
    updateState();
    super.initState();
  }

  @override
  void dispose() {
    namaSellerController.dispose();
    alamatController.dispose();
    kecamatanController.dispose();
    namaTokoController.dispose();
    super.dispose();
  }

  void _checkUser() async {
    if (await _authRepo.hasToken()) {
      await BlocProvider.of<UserDataCubit>(context).loadUser();
    }
  }

  void updateState() {
    joinUserType = widget.userType == UserType.reseller
        ? "Reseller"
        : widget.userType == UserType.supplier
            ? "Supplier"
            : "No data";

    isReseller = _userDataCubit.state.user?.reseller != null &&
        _userDataCubit.state.user?.supplier == null;
    isSupplier = _userDataCubit.state.user?.supplier != null &&
        _userDataCubit.state.user?.reseller != null;
    isUpdateEntry = !isReseller && widget.userType == UserType.reseller
        ? false
        : //Membuat reseller saat menjadi user customer
        !isSupplier && widget.userType == UserType.supplier
            ? false
            : //Membuat supplier saat menjadi user customer
            isReseller && widget.userType == UserType.supplier
                ? false
                : //Membuat supplier saat menjadi user reseller
                isReseller && widget.userType == UserType.reseller
                    ? true
                    : //Update reseller
                    isSupplier && widget.userType == UserType.supplier
                        ? true
                        : //Update supplier
                        false;

    debugPrint("iUpdateEntry $isUpdateEntry");
  }

  handleRegisteration(UserType userType) {
    final subDistrictId =
        context.read<ChooseKecamatanCubit>().state.subDistrict;

    if (kecamatanController.text.isNotEmpty &&
        alamatController.text.isNotEmpty) {
      context.read<RegisterSupplierResellerCubit>().register(
          userType: userType,
          addressSeller: alamatController.text,
          shopName: namaSellerController.text,
          isAlsoRegisterSeller:
              userType == UserType.reseller ? true : registerAsReseller,
          subDistrictId: subDistrictId);
    } else {
      AppExt.hideKeyboard(context);
      BsConfirmation()
          .warning(context: context, title: "Data input tidak lengkap");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: BlocListener<RegisterSupplierResellerCubit,
          RegisterSupplierResellerState>(
        listener: (context, state) {
          if (state is RegisterSupplierResellerSuccess) {
            AppExt.popUntilRoot(context);
            if (widget.userType == UserType.reseller) {
              BlocProvider.of<BottomNavCubit>(context).navItemTapped(1);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Registerasi sukses"),
                backgroundColor: AppColor.primary,
              ));
            } else {
              BlocProvider.of<BottomNavCubit>(context).navItemTapped(3);
              AppExt.pushScreen(
                  context,
                  JoinUserSuccessScreen(
                    userType: widget.userType,
                  ));
            }
          }
          if (state is RegisterSupplierResellerFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
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
                        ? Text("Ubah $joinUserType")
                        : Text("Daftar $joinUserType"),
                  ),
                ];
              },
              body: SingleChildScrollView(
                physics: new BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _screenWidth * (5 / 100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama",
                        style: AppTypo.body2Lato,
                      ),
                      SizedBox(height: 8),
                      Text(
                        _userDataCubit.state.user.name,
                        style: AppTypo.body1.copyWith(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text("No Telepon"),
                      SizedBox(height: 8),
                      Text(
                          AppExt.formatPhoneNumber(
                              _userDataCubit.state.user.phonenumber),
                          style: AppTypo.body1.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text("Kecamatan"),
                      SizedBox(height: 8),
                      BlocBuilder<ChooseKecamatanCubit, ChooseKecamatanState>(
                        builder: (context, state) {
                          return EditText(
                              controller: kecamatanController
                                ..text = state.kecamatan,
                              hintText: "Kecamatan",
                              inputType: InputType.option,
                              onTap: () => showBSRegion(_screenWidth));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Detail Alamat"),
                      SizedBox(height: 8),
                      EditText(
                        controller: alamatController,
                        hintText: "Detail Alamat",
                        inputType: InputType.field,
                      ),
                      widget.userType == UserType.reseller
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Nama Toko Anda"),
                                SizedBox(height: 8),
                                EditText(
                                  controller: namaSellerController,
                                  hintText: "Nama Toko",
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 16),
                      Text("Kode Referal"),
                      SizedBox(height: 8),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: TextField(
                                  decoration: InputDecoration(
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: AppColor.silverFlashSale,
                                            width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: AppColor.silverFlashSale,
                                            width: 1),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("Gunakan",
                                      style: AppTypo.body1.copyWith(
                                          color: Colors.white, fontSize: 12)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      _userDataCubit.state.user?.reseller == null &&
                              widget.userType == UserType.supplier
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    "Apakah anda juga ingin mendaftar sebagai reseller?",
                                    style: AppTypo.caption,
                                  ),
                                ),
                                Expanded(
                                  child: Checkbox(
                                      value: registerAsReseller,
                                      onChanged: (value) {
                                        setState(() {
                                          registerAsReseller = value;
                                        });
                                      }),
                                ),
                              ],
                            )
                          : SizedBox(),
                      registerAsReseller
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Text("Nama Warung Anda"),
                                SizedBox(height: 8),
                                EditText(
                                  controller: namaSellerController,
                                  hintText: "Nama Warung",
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 36),
                      BlocBuilder<RegisterSupplierResellerCubit,
                          RegisterSupplierResellerState>(
                        builder: (context, state) {
                          if (state is RegisterSupplierResellerLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return RoundedButton.contained(
                              label: !isUpdateEntry
                                  ? "Daftar $joinUserType"
                                  : "Ubah data $joinUserType",
                              textColor: Colors.white,
                              isUpperCase: false,
                              onPressed: () =>
                                  handleRegisteration(widget.userType));
                        },
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  void showBSRegion(double screenWidth) {
    final topPadding = MediaQuery.of(context).padding.top;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height - topPadding,
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
                      return Expanded(
                        child: ListView.builder(
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
                                          subDistrict: items[i].subdistrictId);
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
                            }),
                      );
                    }
                    return SizedBox();
                  },
                )
              ],
            ),
          );
        });
  }
}
