// import 'dart:io';

// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:marketplace/data/blocs/edit_user_profile/edit_user_profile_cubit.dart';
// import 'package:marketplace/data/blocs/shipping/delete_shipping_address/delete_shipping_address_cubit.dart';
// import 'package:marketplace/data/blocs/upload_user_avatar/upload_user_avatar_cubit.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/data/repositories/address_repository.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:marketplace/ui/widgets/web/dialog_web.dart';
// import 'package:marketplace/ui/widgets/web/footer_web.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;

// class AccountWebScreen extends StatefulWidget {
//   final AddressRepository _addressRepository = AddressRepository();
//   // const AccountWebScreen({Key key}) : super(key: key);

//   @override
//   _AccountWebScreenState createState() => _AccountWebScreenState();
// }

// class _AccountWebScreenState extends State<AccountWebScreen> {
//   UploadUserAvatarCubit _uploadUserAvatarCubit;
//   // FetchShippingAddressesCubit _fetchShippingAddressesCubit;
//   DeleteShippingAddressCubit _deleteShippingAddressCubit;
//   EditUserProfileCubit _editUserProfileCubit;
//   User _user;

//   bool _showEditName = false;
//   bool _showEditPhone = false;
//   bool _showEditAddress = false;
//   bool _isButtonNameEnabled = false;
//   bool _isButtonPhoneEnabled = false;

//   //Zone Variabel
//   List<Province> _provinceList;
//   List<City> _cityList;
//   List<SubDistrict> _subDistrictList;

//   int _selectedProvinceId;
//   int _selectedCityId;
//   int _selectedSubDistrictId;

//   bool _isProvinceLoading = false;
//   bool _isCityLoading = false;
//   bool _isSubdistrictLoading = false;

//   bool _isSubmitLoading;

//   //Controller Variabel
//   TextEditingController _nameController;
//   TextEditingController _phoneController;
//   TextEditingController _namePeopleController;
//   TextEditingController _phonePeopleController;
//   TextEditingController _addressController;
//   TextEditingController _provinceController;
//   TextEditingController _cityController;
//   TextEditingController _subDistrictController;

//   @override
//   void initState() {
//     _user = BlocProvider.of<UserDataCubit>(context).state.user;
//     _uploadUserAvatarCubit = UploadUserAvatarCubit(
//         userDataCubit: BlocProvider.of<UserDataCubit>(context));
//     // _fetchShippingAddressesCubit = FetchShippingAddressesCubit()..load();
//     _editUserProfileCubit = EditUserProfileCubit(
//         userDataCubit: BlocProvider.of<UserDataCubit>(context));
//     _deleteShippingAddressCubit = DeleteShippingAddressCubit();
//     _nameController = TextEditingController(text: _user.name);
//     _phoneController = TextEditingController(text: _user.phonenumber);
//     _nameController.addListener(_checkEmpty);
//     _phoneController.addListener(_checkEmpty);
//     _namePeopleController = TextEditingController(text: '');
//     _phonePeopleController = TextEditingController(text: '');
//     _addressController = TextEditingController(text: '');
//     _provinceController = TextEditingController(text: '');
//     _cityController = TextEditingController(text: '');
//     _subDistrictController = TextEditingController(text: '');
//     _provinceList = null;
//     _cityList = null;
//     _subDistrictList = null;

//     _selectedProvinceId = null;
//     _selectedCityId = null;
//     _selectedSubDistrictId = null;

//     _isSubmitLoading = false;
//     _getProvince();
//     super.initState();
//     _checkEmpty();
//   }

//   @override
//   void dispose() {
//     _uploadUserAvatarCubit.close();
//     // _fetchShippingAddressesCubit.close();
//     _deleteShippingAddressCubit.close();
//     _editUserProfileCubit.close();
//     _nameController.dispose();
//     _namePeopleController.dispose();
//     _phoneController.dispose();
//     _phonePeopleController.dispose();
//     _addressController.dispose();
//     _provinceController.dispose();
//     _cityController.dispose();
//     _subDistrictController.dispose();
//     super.dispose();
//   }

//   void _handleDeleteAddress({@required int recipentId}) {
//     AppExt.hideKeyboard(context);
//     LoadingDialog.show(context);
//     _deleteShippingAddressCubit.deleteShippingAddress(recipentId: recipentId);
//   }

//   void _handleEditProfile() {
//     LoadingDialog.show(context);
//     _editUserProfileCubit.editProfile(name: _nameController.text);
//   }

//   void _handleSubmit() async {
//     if (_isNotValid()) {
//       // AppExt.popScreen(context);
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Input tidak valid")));
//       return;
//     }

//     setState(() => _isSubmitLoading = true);
//     await Future.delayed(Duration(milliseconds: 500));

//     try {
//       final GeneralResponse response =
//           await widget._addressRepository.addShippingAddress(
//         name: _namePeopleController.text.trim(),
//         phone: '62${_phonePeopleController.text}',
//         address: _addressController.text.trim(),
//         cityId: _cityList[_selectedCityId].id,
//         provinceId: _provinceList[_selectedProvinceId].id,
//         // TODO: Postal code gurung tak nganu
//         postalCode: _subDistrictList[_selectedSubDistrictId].subdistrictId,
//         subdistrictId: _subDistrictList[_selectedSubDistrictId].subdistrictId,
//       );
//       setState(() => _isSubmitLoading = false);
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() {
//       _isSubmitLoading = false;
//       _showEditAddress = false;
//       // _fetchShippingAddressesCubit.load();
//     });
//   }

//   void _checkEmpty() {
//     if (_nameController.text.trim().isEmpty ||
//         _nameController.text == _user.name) {
//       setState(() {
//         _isButtonNameEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonNameEnabled = true;
//       });

//     if (_phoneController.text.trim().isEmpty ||
//         _phoneController.text == _user.phonenumber) {
//       setState(() {
//         _isButtonPhoneEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonPhoneEnabled = true;
//       });
//   }

//   void _handleError(dynamic e) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(e.toString())));
//   }

//   void _getProvince() async {
//     setState(() => _isProvinceLoading = true);
//     try {
//       final ProvinceResponse response =
//           await widget._addressRepository.fetchProvince();
//       setState(() {
//         _provinceList = response.data;
//       });
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() => _isProvinceLoading = false);
//   }

//   void _getCity(int provinceId) async {
//     setState(() => _isCityLoading = true);
//     try {
//       final CityResponse response =
//           await widget._addressRepository.fetchCity(provinceId);
//       setState(() {
//         _cityList = response.data;
//       });
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() => _isCityLoading = false);
//   }

//   void _getSubDistrict(int cityId) async {
//     setState(() => _isSubdistrictLoading = true);
//     try {
//       final SubDistrictResponse response =
//           await widget._addressRepository.fetchSubDistrict(cityId);
//       setState(() {
//         _subDistrictList = response.data;
//       });
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() => _isSubdistrictLoading = false);
//   }

//   bool _isNotValid() {
//     bool isNotValid = _selectedProvinceId == null ||
//         _selectedCityId == null ||
//         _selectedSubDistrictId == null ||
//         _nameController.text.trim().isEmpty ||
//         _addressController.text.trim().isEmpty;
//     try {
//       int.parse(_phonePeopleController.text);
//     } catch (e) {
//       isNotValid = true;
//     }

//     return isNotValid;
//   }

//   _pickImageFromGallery() async {
//     var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       // _handleUploadAvatar(image: File(pickedFile.path));
//       _handleUploadAvatar(pickedFile);
//     }
//   }

//   _handleUploadAvatar(pickedfile) {
//     LoadingDialog.show(context);
//     // debugPrint("PATHHHH" + image.toString());
//     _uploadUserAvatarCubit.uploadAvatarWeb(pickedfile);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => _uploadUserAvatarCubit),
//         BlocProvider(create: (_) => _editUserProfileCubit)
//       ],
//       child: MultiBlocListener(
//           listeners: [
//             BlocListener(
//               cubit: _uploadUserAvatarCubit,
//               listener: (_, state) async {
//                 if (state is UploadUserAvatarSuccess) {
//                   AppExt.popScreen(context);
//                   return;
//                 }
//                 if (state is UploadUserAvatarFailure) {
//                   AppExt.popScreen(context);
//                   ScaffoldMessenger.of(context)
//                     ..removeCurrentSnackBar()
//                     ..showSnackBar(
//                       new SnackBar(
//                         content: new Text(
//                           state.message,
//                         ),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   return;
//                 }
//               },
//             ),
//             BlocListener(
//               cubit: _deleteShippingAddressCubit,
//               listener: (context, state) {
//                 if (state is DeleteShippingAddressFailure) {
//                   AppExt.popScreen(context);
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(state.message)));
//                   return;
//                 }
//                 if (state is DeleteShippingAddressSuccess) {
//                   AppExt.popScreen(context);
//                   // _fetchShippingAddressesCubit.load();
//                   return;
//                 }
//               },
//             ),
//             BlocListener(
//               cubit: _editUserProfileCubit,
//               listener: (context, state) {
//                 if (state is EditUserProfileFailure) {
//                   AppExt.popScreen(context);
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(state.message)));
//                   return;
//                 }
//                 if (state is EditUserProfileSuccess) {
//                   AppExt.popScreen(context);
//                   setState(() {
//                     _user = BlocProvider.of<UserDataCubit>(context).state.user;
//                     _isButtonNameEnabled = false;
//                   });
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertSuccessWeb(
//                             title: "Update Sukses",
//                             description: "Profile berhasil diperbarui",
//                             onPressClose: () {
//                               AppExt.popScreen(context);
//                             });
//                       });
//                   return;
//                 }
//               },
//             ),
//           ],
//           child: AppTrans.SharedAxisTransitionSwitcher(
//             fillColor: Colors.transparent,
//             transitionType: SharedAxisTransitionType.vertical,
//             child: Scrollbar(
//               isAlwaysShown: true,
//               child: ListView(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 82, vertical: 40),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: BasicCard(
//                               child: Column(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(16),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(65),
//                                   child: Image.network(
//                                     "${AppConst.STORAGE_URL}/user/avatar/${BlocProvider.of<UserDataCubit>(context).state.user.avatar}",
//                                     height: 130,
//                                     width: 130,
//                                     frameBuilder: (context, child, frame,
//                                         wasSynchronouslyLoaded) {
//                                       if (wasSynchronouslyLoaded) {
//                                         return child;
//                                       } else {
//                                         return AnimatedSwitcher(
//                                           duration: const Duration(
//                                               milliseconds: 1000),
//                                           child: frame != null
//                                               ? Container(
//                                                   width: 130,
//                                                   height: 130,
//                                                   color: Color(0xFFD1F5B9),
//                                                   child: child,
//                                                 )
//                                               : Container(
//                                                   width: 130,
//                                                   height: 130,
//                                                   color: Color(0xFFD1F5B9),
//                                                   child: Image.asset(
//                                                     AppImg.img_empty_user,
//                                                     width: 130,
//                                                     height: 130,
//                                                   ),
//                                                 ),
//                                         );
//                                       }
//                                     },
//                                     errorBuilder: (context, url, error) =>
//                                         Container(
//                                       width: 130,
//                                       height: 130,
//                                       color: Color(0xFFD1F5B9),
//                                       child: Image.asset(
//                                         AppImg.img_empty_user,
//                                         width: 130,
//                                         height: 130,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               InkWell(
//                                   onTap: () {
//                                     _pickImageFromGallery();
//                                   },
//                                   child: Text("Ubah Foto")),
//                               SizedBox(height: 16),
//                             ],
//                           )),
//                         ),
//                         SizedBox(
//                           width: 45,
//                         ),
//                         Expanded(
//                             flex: 2,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Personal Info",
//                                   style: AppTypo.h2.copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 24),
//                                 ),
//                                 SizedBox(
//                                   height: 16,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Nama",
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w700)),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     InkWell(
//                                         onTap: _showEditPhone ||
//                                                 _showEditAddress
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
//                                                 style: AppTypo.subtitle2
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color: _showEditPhone ||
//                                                                 _showEditAddress
//                                                             ? AppColor.grey
//                                                             : AppColor
//                                                                 .primary)))
//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 _showEditName == true
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           EditText(
//                                             hintText: "",
//                                             inputType: InputType.text,
//                                             controller: this._nameController,
                                            
//                                             // onTap: (){
//                                             //   setState(() {
//                                             //     _isButtonNameEnabled = false;
//                                             //   });
//                                             // },
//                                           ),
//                                           SizedBox(
//                                             width: 120,
//                                             child: RoundedButton.contained(
//                                               label: "Simpan",
//                                               isUpperCase: false,
//                                               isSmall: true,
//                                               onPressed: _isButtonNameEnabled
//                                                   ? () => _handleEditProfile()
//                                                   : null,
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             BlocProvider.of<UserDataCubit>(
//                                                     context)
//                                                 .state
//                                                 .user
//                                                 .name,
//                                             style: AppTypo.subtitle2.copyWith(
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                           Text("")
//                                         ],
//                                       ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Nomor Telepon",
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w700)),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     InkWell(
//                                         onTap: _showEditName || _showEditAddress
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
//                                                 style: AppTypo.subtitle2
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color: _showEditName ||
//                                                                 _showEditAddress
//                                                             ? AppColor.grey
//                                                             : AppColor
//                                                                 .primary)))
//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 _showEditPhone == true
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           EditText(
//                                             hintText: "",
//                                             inputType: InputType.text,
//                                             controller: this._phoneController,
                                            
//                                           ),
//                                           SizedBox(
//                                             width: 200,
//                                             child: RoundedButton.contained(
//                                               label: "Fitur belum tersedia",
//                                               isUpperCase: false,
//                                               isSmall: true,
//                                               onPressed: null,
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               BlocProvider.of<UserDataCubit>(
//                                                       context)
//                                                   .state
//                                                   .user
//                                                   .phonenumber,
//                                               style: AppTypo.subtitle2.copyWith(
//                                                   fontWeight: FontWeight.w400)),
//                                           Text("")
//                                         ],
//                                       ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Alamat",
//                                         style: AppTypo.subtitle2.copyWith(
//                                             fontWeight: FontWeight.w700)),
//                                     InkWell(
//                                         onTap: _showEditPhone || _showEditName
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
//                                             : Text("Tambah",
//                                                 style: AppTypo.subtitle2
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color: _showEditName ||
//                                                                 _showEditPhone
//                                                             ? AppColor.grey
//                                                             : AppColor
//                                                                 .primary)))
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
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Nama Penerima",
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
//                                                         inputType:
//                                                             InputType.text,
//                                                         controller: this
//                                                             ._namePeopleController,
                                                        
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
//                                                         "No Telepon",
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
//                                                         inputType:
//                                                             InputType.phone,
//                                                         controller: this
//                                                             ._phonePeopleController,
                                                        
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
//                                                 controller:
//                                                     this._addressController,
                                                
//                                               ),
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
//                                               Expanded(child: SizedBox())
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 20,
//                                           ),
//                                           SizedBox(
//                                             width: 120,
//                                             child: RoundedButton.contained(
//                                               isLoading: _isSubmitLoading,
//                                               label: "Simpan",
//                                               isUpperCase: false,
//                                               isSmall: true,
//                                               onPressed: _handleSubmit,
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : 
//                                     BlocBuilder(
//                                         cubit: _fetchShippingAddressesCubit,
//                                         builder: (context, state) => AppTrans
//                                             .SharedAxisTransitionSwitcher(
//                                           transitionType:
//                                               SharedAxisTransitionType.vertical,
//                                           fillColor: Colors.transparent,
//                                           child: state
//                                                   is FetchShippingAddressesLoading
//                                               ? Center(
//                                                   child:
//                                                       CircularProgressIndicator())
//                                               : state
//                                                       is FetchShippingAddressesFailure
//                                                   ? Center(
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                           Icon(
//                                                             FlutterIcons
//                                                                 .error_outline_mdi,
//                                                             size: 45,
//                                                             color: AppColor
//                                                                 .primaryDark,
//                                                           ),
//                                                           SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 250,
//                                                             child: Text(
//                                                               "Data Alamat Gagal Dimuat",
//                                                               style: AppTypo
//                                                                   .overlineAccent,
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 7,
//                                                           ),
//                                                           OutlineButton(
//                                                             child: Text(
//                                                                 "Coba lagi"),
//                                                             onPressed: () =>
//                                                                 _fetchShippingAddressesCubit
//                                                                     .load(),
//                                                             textColor: AppColor
//                                                                 .primaryDark,
//                                                             color:
//                                                                 AppColor.danger,
//                                                           ),
//                                                           SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )
//                                                   : state
//                                                           is FetchShippingAddressesSuccess
//                                                       ? state.shippingAddresses
//                                                                   .length >
//                                                               0
//                                                           ? ListView.separated(
//                                                               physics:
//                                                                   NeverScrollableScrollPhysics(),
//                                                               shrinkWrap: true,
//                                                               itemCount: state
//                                                                   .shippingAddresses
//                                                                   .length,
//                                                               separatorBuilder:
//                                                                   (context,
//                                                                           index) =>
//                                                                       SizedBox(
//                                                                 height: 15,
//                                                               ),
//                                                               itemBuilder:
//                                                                   (context,
//                                                                       index) {
//                                                                 Recipent
//                                                                     address =
//                                                                     state.shippingAddresses[
//                                                                         index];
//                                                                 return _buildAddressesItem(
//                                                                   address:
//                                                                       address,
//                                                                   onTap: () => _handleDeleteAddress(
//                                                                       recipentId:
//                                                                           address
//                                                                               .id),
//                                                                 );
//                                                               },
//                                                             )
//                                                           : Center(
//                                                               child: Column(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                 children: [
//                                                                   SizedBox(
//                                                                     height: 10,
//                                                                   ),
//                                                                   Icon(
//                                                                     FlutterIcons
//                                                                         .map_marker_plus_mco,
//                                                                     size: 45,
//                                                                     color: AppColor
//                                                                         .primary,
//                                                                   ),
//                                                                   SizedBox(
//                                                                     height: 10,
//                                                                   ),
//                                                                   Text(
//                                                                     "Belum ada alamat",
//                                                                     style: AppTypo
//                                                                         .overlineAccent,
//                                                                     textAlign:
//                                                                         TextAlign
//                                                                             .center,
//                                                                   ),
//                                                                   SizedBox(
//                                                                     height: 10,
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             )
//                                                       : SizedBox.shrink(),
//                                         ),
//                                       ),
//                               ],
//                             )),
//                         Expanded(flex: 1, child: SizedBox())
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 120,
//                   ),
//                   FooterWeb()
//                 ],
//               ),
//             ),
//           )),
//     );
//   }

//   Widget _buildAddressesItem({
//     @required Recipent address,
//     @required void Function() onTap,
//   }) {
//     return BasicCard(
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     "${address.name}",
//                     style: AppTypo.body1
//                         .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text("+${address.phone}", style: AppTypo.overline),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                       "${address.address}",
//                       style: AppTypo.body1.copyWith(
//                         fontSize: 14,
//                       )),
//                 ],
//               ),
//             ),
//             IconButton(
//                 hoverColor: Colors.transparent,
//                 icon: Icon(
//                   Icons.delete,
//                   color: AppColor.danger,
//                   size: 30,
//                 ),
//                 onPressed: onTap),
//             SizedBox(
//               height: 15,
//             ),
//           ],
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
