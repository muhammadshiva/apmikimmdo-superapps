// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:beamer/beamer.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/blocs/warung_panen/edit_warung_profile/edit_warung_profile_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/data/repositories/address_repository.dart';
// import 'package:marketplace/ui/widgets/web/dialog_alert_web.dart';
// import 'package:marketplace/ui/widgets/web/dialog_web.dart';
// import 'package:marketplace/ui/widgets/web/footer_web.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/validator.dart';

// class WpDataWebScreen extends StatefulWidget {
//   WpDataWebScreen({Key key}) : super(key: key);

//   @override
//   _WpDataWebScreenState createState() => _WpDataWebScreenState();
// }

// class _WpDataWebScreenState extends State<WpDataWebScreen> {
//   final AddressRepository _addressRepository = AddressRepository();
//   final ValidatorCustom _v = ValidatorCustom();
//   EditWarungProfileCubit _editWarungProfileCubit;

//   TextEditingController _nameController;
//   TextEditingController _nameWarungController;
//   TextEditingController _addressController;
//   TextEditingController _phoneController;

//   TextEditingController _provinceController;
//   TextEditingController _cityController;
//   TextEditingController _subDistrictController;
//   TextEditingController _rtController;
//   TextEditingController _rwController;
//   TextEditingController _kelurahanController;

//   List<Province> _provinceList;
//   List<City> _cityList;
//   List<SubDistrict> _subDistrictList;

//   int _selectedProvinceId;
//   int _selectedCityId;
//   int _selectedSubDistrictId;

//   bool _isProvinceLoading;
//   bool _isCityLoading;
//   bool _isSubdistrictLoading;

//   bool _isInit;
//   bool _showEditName;
//   bool _showEditNameWarung;
//   bool _showEditAddress;
//   bool _showEditPhone;
//   bool _isButtonNameEnabled;
//   bool _isButtonNameWarungEnabled;
//   bool _isButtonPhoneEnabled;
//   bool _isButtonAddressEnabled;
//   UserDataCubit _userDataCubit;

//   @override
//   void initState() {
//     _isInit = true;
//     _showEditName = false;
//     _showEditNameWarung = false;
//     _showEditAddress = false;
//     _showEditPhone = false;
//     _isButtonNameEnabled = false;
//     _isButtonNameWarungEnabled = false;
//     _isButtonPhoneEnabled = false;
//     _isButtonAddressEnabled = false;
//     _userDataCubit = BlocProvider.of<UserDataCubit>(context);
//     _editWarungProfileCubit = EditWarungProfileCubit();

//     // _nameController = TextEditingController(
//     //     text: '${BlocProvider.of<UserDataCubit>(context).state.user.name}');
//     // _nameWarungController = TextEditingController(
//     //     text:
//     //         '${BlocProvider.of<UserDataCubit>(context).state.seller.nameSeller}');
//     // _addressController = TextEditingController(
//     //     text:
//     //         '${BlocProvider.of<UserDataCubit>(context).state.seller.addressSeller}');
//     // _phoneController = TextEditingController(
//     //     text:
//     //         '${BlocProvider.of<UserDataCubit>(context).state.user.phonenumber.substring(2)}');

//     // _provinceController = TextEditingController(text: '');
//     // _cityController = TextEditingController(text: '');
//     // _subDistrictController = TextEditingController(text: '');
//     // _rtController = TextEditingController(
//     //     text: '${BlocProvider.of<UserDataCubit>(context).state.seller.rt}');
//     // _rwController = TextEditingController(
//     //     text: '${BlocProvider.of<UserDataCubit>(context).state.seller.rw}');
//     // _kelurahanController = TextEditingController(
//     //     text:
//     //         '${BlocProvider.of<UserDataCubit>(context).state.seller.kelurahan}');

//     _nameController.addListener(_checkEmpty);
//     _nameWarungController.addListener(_checkEmpty);
//     _phoneController.addListener(_checkEmpty);
//     _addressController.addListener(_checkEmpty);
//     _rtController.addListener(_checkEmpty);
//     _rwController.addListener(_checkEmpty);
//     _kelurahanController.addListener(_checkEmpty);
//     _provinceController.addListener(_checkEmpty);
//     _cityController.addListener(_checkEmpty);
//     _subDistrictController.addListener(_checkEmpty);

//     _isProvinceLoading = false;
//     _isCityLoading = false;
//     _isSubdistrictLoading = false;

//     _provinceList = null;
//     _cityList = null;
//     _subDistrictList = null;

//     _selectedProvinceId = null;
//     _selectedCityId = null;
//     _selectedSubDistrictId = null;

//     _getProvince();
//     _checkEmpty();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _nameWarungController.dispose();
//     _nameController.dispose();
//     _addressController.dispose();
//     _subDistrictController.dispose();
//     _provinceController.dispose();
//     _cityController.dispose();
//     _rtController.dispose();
//     _rwController.dispose();
//     _kelurahanController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   void _checkEmpty() {
//     if (_nameController.text.trim().isEmpty ||
//         _nameController.text ==
//             BlocProvider.of<UserDataCubit>(context).state.user.name) {
//       setState(() {
//         _isButtonNameEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonNameEnabled = true;
//       });
//     if (_nameWarungController.text.trim().isEmpty ||
//         _nameWarungController.text == ""
//             // BlocProvider.of<UserDataCubit>(context).state.seller.nameSeller
//             ) {
//       setState(() {
//         _isButtonNameWarungEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonNameWarungEnabled = true;
//       });
//     if (_phoneController.text.trim().isEmpty ||
//         _phoneController.text ==
//             BlocProvider.of<UserDataCubit>(context)
//                 .state
//                 .user
//                 .phonenumber
//                 .substring(2)) {
//       setState(() {
//         _isButtonPhoneEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonPhoneEnabled = true;
//       });
//     if (_addressController.text.trim().isEmpty ||
//         _provinceController.text.trim().isEmpty ||
//         _subDistrictController.text.trim().isEmpty ||
//         _kelurahanController.text.trim().isEmpty ||
//         _rtController.text.trim().isEmpty ||
//         _rwController.text.trim().isEmpty ||
//         _cityController.text.trim().isEmpty) {
//       setState(() {
//         _isButtonAddressEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonAddressEnabled = true;
//       });
//   }

//   void _handleEditSubmit() async {
//     LoadingDialog.show(context);
//     await Future.delayed(Duration(milliseconds: 200));

//     _editWarungProfileCubit.updateDataWarung(
//       nameUser: _nameController.text,
//       nameSeller: _nameWarungController.text,
//       addressSeller: _addressController.text,
//       provinceId: _provinceList[_selectedProvinceId].id,
//       cityId: _cityList[_selectedCityId].id,
//       subDistrictId: _subDistrictList[_selectedSubDistrictId].id,
//       photo: null,
//       kelurahan: _kelurahanController.text,
//       rt: _rtController.text,
//       rw: _rwController.text,
//       phoneNumber: '62' + _phoneController.text,
//     );
//   }

//   void _handleError(dynamic e) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(e.toString())));
//   }

//   _searchProvince() {
//     final index = _provinceList.indexWhere((element) =>
//         element.id == ""
//         // BlocProvider.of<UserDataCubit>(context).state.seller.provinceId
//         );
//     if (index >= 0) {
//       setState(() {
//         _selectedProvinceId = index;
//         _provinceController =
//             TextEditingController(text: "${_provinceList[index].name}");
//       });
//     }
//   }

//   _searchCity() {
//     final index = _cityList.indexWhere((element) =>
//         element.id == ""
//         // BlocProvider.of<UserDataCubit>(context).state.seller.cityId
//         );
//     if (index >= 0) {
//       setState(() {
//         _selectedCityId = index;
//         _cityController.text = _cityList[index].name;
//       });
//     }
//   }

//   _searchSubDistrict() {
//     final index = _subDistrictList.indexWhere((element) =>
//         element.id == ""
//         // BlocProvider.of<UserDataCubit>(context).state.seller.subdistrictId
//         );
//     if (index >= 0) {
//       setState(() {
//         _selectedSubDistrictId = index;
//         _subDistrictController.text = _subDistrictList[index].subdistrictName;
//       });
//     }
//   }

//   void _getProvince() async {
//     setState(() => _isProvinceLoading = true);
//     try {
//       final ProvinceResponse response =
//           await _addressRepository.fetchProvince();
//       setState(() {
//         _provinceList = response.data;
//       });
//       if (_isInit == true) {
//         await _searchProvince();
//         _getCity(_provinceList[_selectedProvinceId].id);
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() => _isProvinceLoading = false);
//   }

//   void _getCity(int provinceId) async {
//     setState(() => _isCityLoading = true);
//     try {
//       final CityResponse response =
//           await _addressRepository.fetchCity(provinceId);
//       setState(() {
//         _cityList = response.data;
//       });
//       if (_isInit == true) {
//         await _searchCity();
//         _getSubDistrict(_cityList[_selectedCityId].id);
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() => _isCityLoading = false);
//   }

//   void _getSubDistrict(int cityId) async {
//     setState(() => _isSubdistrictLoading = true);
//     try {
//       final SubDistrictResponse response =
//           await _addressRepository.fetchSubDistrict(cityId);
//       setState(() {
//         _subDistrictList = response.data;
//       });
//       if (_isInit == true) {
//         await _searchSubDistrict();
//         setState(() {
//           // _addressController.text = BlocProvider.of<UserDataCubit>(context)
//           //     .state
//           //     .seller
//           //     .addressSeller;
//           _isInit = false;
//         });
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() => _isSubdistrictLoading = false);
//   }

//   void _resetTextInput() {
//     _hideTextInput();
//     setState(() {
//       _isInit = true;
//       // _nameController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.user.name}';
//       // _nameWarungController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.seller.nameSeller}';
//       // _addressController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.seller.addressSeller}';
//       // _phoneController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.user.phonenumber.substring(2)}';
//       // _rtController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.seller.rt}';
//       // _rwController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.seller.rw}';
//       // _kelurahanController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.seller.kelurahan}';
//       // _provinceController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.seller.subdistrict.province}';
//       // _cityController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.seller.subdistrict.city}';
//       // _subDistrictController.text =
//       //     '${BlocProvider.of<UserDataCubit>(context).state.seller.subdistrict.subdistrictName}';
//     });
//     _getProvince();
//   }

//   void _hideTextInput() {
//     setState(() {
//       _showEditName = false;
//       _showEditNameWarung = false;
//       _showEditAddress = false;
//       _showEditPhone = false;
//       _isButtonNameEnabled = false;
//       _isButtonNameWarungEnabled = false;
//       _isButtonPhoneEnabled = false;
//       _isButtonAddressEnabled = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => _editWarungProfileCubit,
//         ),
//       ],
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener(
//             cubit: _editWarungProfileCubit,
//             listener: (context, state) async {
//               if (state is EditWarungProfileSuccess) {
//                 await BlocProvider.of<UserDataCubit>(context).loadUser();
//                 _resetTextInput();
//                 AppExt.popScreen(context);
//                 showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     useRootNavigator: false,
//                     builder: (ctx) {
//                       return AlertSuccessWeb(
//                         onPressClose: () {
//                           AppExt.popScreen(context);
//                         },
//                         title: "Update Sukses",
//                         description: "Data warung berhasil diperbarui",
//                       );
//                     });
//               }
//               if (state is EditWarungProfileFailure) {
//                 AppExt.popScreen(context);
//                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content:
//                         Text("Terjadi kesalahan, data warung gagal diubah")));
//                 return;
//               }
//             },
//           ),
//         ],
//         child: AppTrans.SharedAxisTransitionSwitcher(
//           fillColor: Colors.transparent,
//           transitionType: SharedAxisTransitionType.vertical,
//           child: Scrollbar(
//             isAlwaysShown: true,
//             child: ListView(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 82, vertical: 40),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Ubah Data Reseller",
//                         style: AppTypo.h2.copyWith(
//                             fontWeight: FontWeight.w600, fontSize: 24),
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Nama",
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w700)),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                     InkWell(
//                                         onTap: _showEditAddress ||
//                                                 _showEditNameWarung ||
//                                                 _showEditPhone
//                                             ? null
//                                             : () {
//                                                 setState(() {
//                                                   if (_showEditName == true) {
//                                                     _showEditName = false;
//                                                   } else {
//                                                     _showEditName = true;
//                                                   }
//                                                 });
//                                               },
//                                         child: _showEditName == true
//                                             ? Text("Batal",
//                                                 style: AppTypo.subtitle2
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color:
//                                                             AppColor.primary))
//                                             : Text("Edit",
//                                                 style: AppTypo.subtitle2.copyWith(
//                                                     fontWeight: FontWeight.w700,
//                                                     color: _showEditAddress ||
//                                                             _showEditNameWarung ||
//                                                             _showEditPhone
//                                                         ? AppColor.grey
//                                                         : AppColor.primary)))
//                                   ],
//                                 ),
//                                 _showEditName == true
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           EditText(
//                                             hintText: "",
//                                             inputType: InputType.text,
//                                             controller: this._nameController,
//                                             autoValidateMode: AutovalidateMode
//                                                 .onUserInteraction,
//                                             validator: _v.vNameShop,
                                            
//                                           ),
//                                           SizedBox(
//                                             width: 120,
//                                             child: RoundedButton.contained(
//                                               label: "Simpan",
//                                               isUpperCase: false,
//                                               isSmall: true,
//                                               onPressed: _isButtonNameEnabled
//                                                   ? () => _handleEditSubmit()
//                                                   : null,
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : Text(
//                                         _userDataCubit.state.user.name,
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                 SizedBox(height: 15),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Nama Warung",
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w700)),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                     InkWell(
//                                         onTap: _showEditAddress ||
//                                                 _showEditName ||
//                                                 _showEditPhone
//                                             ? null
//                                             : () {
//                                                 setState(() {
//                                                   if (_showEditNameWarung ==
//                                                       true) {
//                                                     _showEditNameWarung = false;
//                                                   } else {
//                                                     _showEditNameWarung = true;
//                                                   }
//                                                 });
//                                               },
//                                         child: _showEditNameWarung == true
//                                             ? Text("Batal",
//                                                 style: AppTypo.subtitle2
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color:
//                                                             AppColor.primary))
//                                             : Text("Edit",
//                                                 style: AppTypo.subtitle2.copyWith(
//                                                     fontWeight: FontWeight.w700,
//                                                     color: _showEditAddress ||
//                                                             _showEditName ||
//                                                             _showEditPhone
//                                                         ? AppColor.grey
//                                                         : AppColor.primary)))
//                                   ],
//                                 ),
//                                 _showEditNameWarung == true
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           EditText(
//                                             hintText: "",
//                                             inputType: InputType.text,
//                                             controller:
//                                                 this._nameWarungController,
//                                             autoValidateMode: AutovalidateMode
//                                                 .onUserInteraction,
//                                             validator: _v.vNameShop,
                                            
//                                           ),
//                                           SizedBox(
//                                             width: 120,
//                                             child: RoundedButton.contained(
//                                               label: "Simpan",
//                                               isUpperCase: false,
//                                               isSmall: true,
//                                               onPressed:
//                                                   _isButtonNameWarungEnabled
//                                                       ? () =>
//                                                           _handleEditSubmit()
//                                                       : null,
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "",
//                                             // _userDataCubit
//                                             //     .state.seller.nameSeller,
//                                             style: AppTypo.subtitle2.copyWith(
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                           Text("")
//                                         ],
//                                       ),
//                                 SizedBox(height: 15),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Nomor Telepon",
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w700)),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                     InkWell(
//                                         onTap: _showEditName ||
//                                                 _showEditNameWarung ||
//                                                 _showEditAddress
//                                             ? null
//                                             : () {
//                                                 setState(() {
//                                                   if (_showEditPhone == true) {
//                                                     _showEditPhone = false;
//                                                   } else {
//                                                     _showEditPhone = true;
//                                                   }
//                                                 });
//                                               },
//                                         child: _showEditPhone == true
//                                             ? Text("Batal",
//                                                 style: AppTypo.subtitle2
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color:
//                                                             AppColor.primary))
//                                             : Text("Edit",
//                                                 style: AppTypo.subtitle2.copyWith(
//                                                     fontWeight: FontWeight.w700,
//                                                     color: _showEditName ||
//                                                             _showEditNameWarung ||
//                                                             _showEditAddress
//                                                         ? AppColor.grey
//                                                         : AppColor.primary)))
//                                   ],
//                                 ),
//                                 _showEditPhone == true
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           EditText(
//                                             hintText: "",
//                                             inputType: InputType.phone,
//                                             controller: this._phoneController,
                                            
//                                           ),
//                                           SizedBox(
//                                             width: 200,
//                                             child: RoundedButton.contained(
//                                               label: "Simpan",
//                                               isUpperCase: false,
//                                               isSmall: true,
//                                               onPressed: _isButtonPhoneEnabled
//                                                   ? () => _handleEditSubmit()
//                                                   : null,
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : Text(
//                                         _userDataCubit.state.user.phonenumber,
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w400)),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 50),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Alamat",
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w700)),
//                                     InkWell(
//                                         onTap: _showEditName ||
//                                                 _showEditNameWarung ||
//                                                 _showEditPhone
//                                             ? null
//                                             : () {
//                                                 setState(() {
//                                                   if (_showEditAddress ==
//                                                       true) {
//                                                     _showEditAddress = false;
//                                                   } else {
//                                                     _showEditAddress = true;
//                                                   }
//                                                 });
//                                               },
//                                         child: _showEditAddress == true
//                                             ? Text("Batal",
//                                                 style: AppTypo.subtitle2
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color:
//                                                             AppColor.primary))
//                                             : Text("Edit",
//                                                 style: AppTypo.subtitle2.copyWith(
//                                                     fontWeight: FontWeight.w700,
//                                                     color: _showEditName ||
//                                                             _showEditNameWarung ||
//                                                             _showEditPhone
//                                                         ? AppColor.grey
//                                                         : AppColor.primary)))
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 _showEditAddress == true
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "RT",
//                                                         style: AppTypo.subtitle2
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 8,
//                                                       ),
//                                                       EditText(
//                                                         hintText: "",
//                                                         validator: _v.vRt,
//                                                         autoValidateMode:
//                                                             AutovalidateMode
//                                                                 .onUserInteraction,
//                                                         inputType:
//                                                             InputType.text,
//                                                         controller:
//                                                             this._rtController,
//                                                         keyboardType:
//                                                             TextInputType
//                                                                 .number,
                                                        
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 20,
//                                               ),
//                                               Expanded(
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "RW",
//                                                         style: AppTypo.subtitle2
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 8,
//                                                       ),
//                                                       EditText(
//                                                         hintText: "",
//                                                         validator: _v.vRw,
//                                                         autoValidateMode:
//                                                             AutovalidateMode
//                                                                 .onUserInteraction,
//                                                         inputType:
//                                                             InputType.text,
//                                                         controller:
//                                                             this._rwController,
//                                                         keyboardType:
//                                                             TextInputType
//                                                                 .number,
                                                        
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           SizedBox(height: 15),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Provinsi",
//                                                         style: AppTypo.subtitle2
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 8,
//                                                       ),
//                                                       EditText(
//                                                         hintText: "",
//                                                         isLoading:
//                                                             _isProvinceLoading,
//                                                         validator:
//                                                             _v.vProvinceShop,
//                                                         autoValidateMode:
//                                                             AutovalidateMode
//                                                                 .onUserInteraction,
//                                                         enabled:
//                                                             _provinceList !=
//                                                                 null,
//                                                         inputType:
//                                                             InputType.option,
//                                                         controller: this
//                                                             ._provinceController,
                                                        
//                                                         onTap: () =>
//                                                             _showRegionDialog(
//                                                                 title:
//                                                                     "Pilih Provinsi",
//                                                                 items: _provinceList
//                                                                     .map((e) =>
//                                                                         e.name)
//                                                                     .toList(),
//                                                                 onSelected:
//                                                                     (id) {
//                                                                   setState(() {
//                                                                     _selectedProvinceId =
//                                                                         id;
//                                                                     _provinceController
//                                                                         .text = _provinceList[
//                                                                             _selectedProvinceId]
//                                                                         .name;
//                                                                     _selectedCityId =
//                                                                         null;
//                                                                     _selectedSubDistrictId =
//                                                                         null;
//                                                                     _cityController
//                                                                         .text = '';
//                                                                     _subDistrictController
//                                                                         .text = '';
//                                                                     _cityList =
//                                                                         null;
//                                                                     _subDistrictList =
//                                                                         null;
//                                                                     _getCity(
//                                                                         _provinceList[id]
//                                                                             .id);
//                                                                   });
//                                                                 }),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 20,
//                                               ),
//                                               Expanded(
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Kota/Kabupaten",
//                                                         style: AppTypo.subtitle2
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 8,
//                                                       ),
//                                                       EditText(
//                                                         hintText: "",
//                                                         isLoading:
//                                                             _isCityLoading,
//                                                         enabled:
//                                                             _cityList != null,
//                                                         validator: _v.vCityShop,
//                                                         autoValidateMode:
//                                                             AutovalidateMode
//                                                                 .onUserInteraction,
//                                                         inputType:
//                                                             InputType.option,
//                                                         controller: this
//                                                             ._cityController,
                                                        
//                                                         onTap: () =>
//                                                             _showRegionDialog(
//                                                                 title:
//                                                                     "Pilih Kota/Kabupaten",
//                                                                 items: _cityList
//                                                                     .map((e) =>
//                                                                         e.name)
//                                                                     .toList(),
//                                                                 onSelected:
//                                                                     (id) {
//                                                                   setState(() {
//                                                                     _selectedCityId =
//                                                                         id;
//                                                                     _cityController
//                                                                         .text = _cityList[
//                                                                             _selectedCityId]
//                                                                         .name;
//                                                                     _selectedSubDistrictId =
//                                                                         null;
//                                                                     _subDistrictController
//                                                                         .text = '';
//                                                                     _subDistrictList =
//                                                                         null;

//                                                                     _getSubDistrict(
//                                                                         _cityList[id]
//                                                                             .id);
//                                                                   });
//                                                                 }),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 16,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Kecamatan",
//                                                         style: AppTypo.subtitle2
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 8,
//                                                       ),
//                                                       EditText(
//                                                         hintText: "",
//                                                         isLoading:
//                                                             _isSubdistrictLoading,
//                                                         validator:
//                                                             _v.vDistrictShop,
//                                                         autoValidateMode:
//                                                             AutovalidateMode
//                                                                 .onUserInteraction,
//                                                         enabled:
//                                                             _subDistrictList !=
//                                                                 null,
//                                                         inputType:
//                                                             InputType.option,
//                                                         controller: this
//                                                             ._subDistrictController,
                                                        
//                                                         onTap: () =>
//                                                             _showRegionDialog(
//                                                                 title:
//                                                                     "Pilih Kecamatan",
//                                                                 items: _subDistrictList
//                                                                     .map((e) => e
//                                                                         .subdistrictName)
//                                                                     .toList(),
//                                                                 onSelected:
//                                                                     (id) {
//                                                                   setState(() {
//                                                                     _selectedSubDistrictId =
//                                                                         id;
//                                                                     _subDistrictController
//                                                                         .text = _subDistrictList[
//                                                                             _selectedSubDistrictId]
//                                                                         .subdistrictName;
//                                                                   });
//                                                                 }),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 20,
//                                               ),
//                                               Expanded(
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Kelurahan/Desa",
//                                                         style: AppTypo.subtitle2
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 8,
//                                                       ),
//                                                       EditText(
//                                                         hintText: "",
//                                                         validator:
//                                                             _v.vKelurahan,
//                                                         autoValidateMode:
//                                                             AutovalidateMode
//                                                                 .onUserInteraction,
//                                                         inputType:
//                                                             InputType.text,
//                                                         controller: this
//                                                             ._kelurahanController,
                                                        
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(height: 15),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Detail alamat",
//                                                 style: AppTypo.subtitle2
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w400),
//                                               ),
//                                               SizedBox(
//                                                 height: 8,
//                                               ),
//                                               EditText(
//                                                 hintText: "",
//                                                 inputType: InputType.text,
//                                                 validator: _v.vAddress,
//                                                 autoValidateMode:
//                                                     AutovalidateMode
//                                                         .onUserInteraction,
//                                                 controller:
//                                                     this._addressController,
                                                
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 20,
//                                           ),
//                                           SizedBox(
//                                             width: 120,
//                                             child: RoundedButton.contained(
//                                               // isLoading: _isSubmitLoading,
//                                               label: "Simpan",
//                                               isUpperCase: false,
//                                               isSmall: true,
//                                               onPressed: _isButtonAddressEnabled
//                                                   ? _handleEditSubmit
//                                                   : null,
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : Text(
//                                         "${_addressController.text} RT ${_rtController.text}/RW ${_rwController.text}, Kel. ${_kelurahanController.text}, Kecamatan ${_subDistrictController.text}, ${_cityController.text}, ${_provinceController.text}"),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 120,
//                 ),
//                 FooterWeb()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showRegionDialog({
//     @required List<String> items,
//     @required void Function(int id) onSelected,
//     @required String title,
//   }) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return DialogWeb(
//           hasTitle: true,
//           title: title,
//           onPressedClose: () {
//             AppExt.popScreen(context);
//           },
//           child: Container(
//             child: ListView.separated(
//               // padding: EdgeInsets.symmetric(vertical: 5),
//               shrinkWrap: true,
//               itemCount: items.length,
//               separatorBuilder: (context, index) => Divider(
//                 height: 0.5,
//                 thickness: 0.5,
//               ),
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   visualDensity: VisualDensity.compact,
//                   trailing: Icon(FlutterIcons.chevron_right_mco),
//                   title: Text(items[index]),
//                   onTap: () {
//                     onSelected(index);
//                     Navigator.pop(context);
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
