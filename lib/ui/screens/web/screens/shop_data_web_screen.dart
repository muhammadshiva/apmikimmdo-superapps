// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:beamer/beamer.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/data/repositories/repositories.dart';
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

// class ShopDataWebScreen extends StatefulWidget {
//   final AddressRepository _addressRepository = AddressRepository();
  
//   final User user;

//   ShopDataWebScreen({Key key, this.user}) : super(key: key);

//   @override
//   _ShopDataWebScreenState createState() => _ShopDataWebScreenState();
// }

// class _ShopDataWebScreenState extends State<ShopDataWebScreen> {
//   final ValidatorCustom _v = ValidatorCustom();

//   TextEditingController _nameController;
//   TextEditingController _addressController;
//   TextEditingController _provinceController;
//   TextEditingController _cityController;
//   TextEditingController _subDistrictController;
//   TextEditingController _kelurahanController;
//   TextEditingController _rtController;
//   TextEditingController _rwController;

//   List<Province> _provinceList;
//   List<City> _cityList;
//   List<SubDistrict> _subDistrictList;

//   int _selectedProvinceId;
//   int _selectedCityId;
//   int _selectedSubDistrictId;
//   int _roleId;

//   bool _isProvinceLoading;
//   bool _isCityLoading;
//   bool _isSubdistrictLoading;

//   bool _isInit;
//   bool _showEditName;
//   bool _showEditAddress;
//   bool _isButtonNameEnabled;
//   bool _isButtonAddressEnabled;

//   String _image;
//   dynamic _pickedImage;

//   @override
//   void initState() {
//     _isInit = true;
//     _image = null;
//     _showEditName = false;
//     _showEditAddress = false;
//     _isButtonNameEnabled = false;
//     _isButtonAddressEnabled = false;

//     _nameController = TextEditingController(text: '${widget.user.name}');
//     _addressController = TextEditingController(text: '');

//     _provinceController = TextEditingController(text: '');
//     _cityController = TextEditingController(text: '');
//     _subDistrictController = TextEditingController(text: '');
//     _kelurahanController =
//         TextEditingController(text: '${"widget.producer.kelurahan"}');
//     _rtController = TextEditingController(text: '${"widget.producer.rt"}');
//     _rwController = TextEditingController(text: '${"widget.producer.rw"}');

//     _nameController.addListener(_checkEmpty);
//     _addressController.addListener(_checkEmpty);
//     _provinceController.addListener(_checkEmpty);
//     _cityController.addListener(_checkEmpty);
//     _subDistrictController.addListener(_checkEmpty);
//     _kelurahanController.addListener(_checkEmpty);
//     _rtController.addListener(_checkEmpty);
//     _rwController.addListener(_checkEmpty);

//     _isProvinceLoading = false;
//     _isCityLoading = false;
//     _isSubdistrictLoading = false;

//     _provinceList = null;
//     _cityList = null;
//     _subDistrictList = null;

//     _selectedProvinceId = null;
//     _selectedCityId = null;
//     _selectedSubDistrictId = null;

//     // _roleId = BlocProvider.of<UserDataCubit>(context).state.seller.roleId;

//     _getProvince();
//     _checkEmpty();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _subDistrictController.dispose();
//     _provinceController.dispose();
//     _cityController.dispose();
//     _kelurahanController.dispose();
//     _rtController.dispose();
//     _rwController.dispose();
//     super.dispose();
//   }

//   void _checkEmpty() {
//     if (_nameController.text.trim().isEmpty ||
//         _nameController.text == "widget.producer.nameSeller") {
//       setState(() {
//         _isButtonNameEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonNameEnabled = true;
//       });
//     if (_addressController.text.trim().isEmpty ||
//         _provinceController.text.trim().isEmpty ||
//         _subDistrictController.text.trim().isEmpty ||
//         _cityController.text.trim().isEmpty ||
//         _kelurahanController.text.trim().isEmpty ||
//         _rtController.text.trim().isEmpty ||
//         _rwController.text.trim().isEmpty) {
//       setState(() {
//         _isButtonAddressEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonAddressEnabled = true;
//       });
//   }

//   void _handleEditSubmit() {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Cooming Soon... Nantikan updatenya segera")),
//     );
//   }

//   void _handleError(dynamic e) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(e.toString())));
//   }

//   _searchProvince() {
//     final index = _provinceList
//         .indexWhere((element) => element.id == "widget.producer.provinceId");
//     if (index >= 0) {
//       setState(() {
//         _selectedProvinceId = index;
//         _provinceController =
//             TextEditingController(text: "${_provinceList[index].name}");
//       });
//     }
//   }

//   _searchCity() {
//     final index =
//         _cityList.indexWhere((element) => element.id == "widget.producer.cityId");
//     if (index >= 0) {
//       setState(() {
//         _selectedCityId = index;
//         _cityController.text = _cityList[index].name;
//       });
//     }
//   }

//   _searchSubDistrict() {
//     final index = _subDistrictList
//         .indexWhere((element) => element.id == "widget.producer.subdistrictId");
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
//           await widget._addressRepository.fetchProvince();
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
//           await widget._addressRepository.fetchCity(provinceId);
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
//           await widget._addressRepository.fetchSubDistrict(cityId);
//       setState(() {
//         _subDistrictList = response.data;
//       });
//       if (_isInit == true) {
//         await _searchSubDistrict();
//         setState(() {
//           _addressController.text = "widget.producer.addressSeller";
//           _isInit = false;
//         });
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() => _isSubdistrictLoading = false);
//   }

//   _pickImage() async {
//     var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         // _imageController.text = pickedFile.path;
//         _image = pickedFile.path;
//         _pickedImage = pickedFile;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppTrans.SharedAxisTransitionSwitcher(
//       fillColor: Colors.transparent,
//       transitionType: SharedAxisTransitionType.vertical,
//       child: Scrollbar(
//         isAlwaysShown: true,
//         child: ListView(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 82, vertical: 40),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                       flex: 1,
//                       child: BasicCard(
//                           child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.all(15),
//                             child: Row(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(65),
//                                   child: Image.network(
//                                     "${AppConst.STORAGE_URL}/shop/${"widget.producer.shopPhoto"}",
//                                     height: 50,
//                                     width: 50,
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
//                                                   width: 50,
//                                                   height: 50,
//                                                   color: Color(0xFFD1F5B9),
//                                                   child: child,
//                                                 )
//                                               : Container(
//                                                   width: 50,
//                                                   height: 50,
//                                                   color: Color(0xFFD1F5B9),
//                                                   child: Image.asset(
//                                                     AppImg.img_empty_user,
//                                                     width: 50,
//                                                     height: 50,
//                                                   ),
//                                                 ),
//                                         );
//                                       }
//                                     },
//                                     errorBuilder: (context, url, error) =>
//                                         Container(
//                                       width: 50,
//                                       height: 50,
//                                       color: Color(0xFFD1F5B9),
//                                       child: Image.asset(
//                                         AppImg.img_empty_user,
//                                         width: 50,
//                                         height: 50,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 12,
//                                 ),
//                                 Text("widget.producer.nameSeller",
//                                     style: AppTypo.subtitle1.copyWith(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w700))
//                               ],
//                             ),
//                           ),
//                           Divider(
//                             thickness: 1,
//                             color: Colors.grey,
//                             indent: 1,
//                             endIndent: 1,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     context.beamToNamed(
//                                         '/account/shop/productlist');
//                                   },
//                                   child: Text(
//                                     "Daftar produk",
//                                     style: AppTypo.subtitle2
//                                         .copyWith(fontWeight: FontWeight.w400),
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 InkWell(
//                                   onTap: () {
//                                     context.beamToNamed(
//                                         '/account/shop/transaction');
//                                   },
//                                   child: Text(
//                                     "Daftar pesanan",
//                                     style: AppTypo.subtitle2
//                                         .copyWith(fontWeight: FontWeight.w400),
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 _roleId == 4
//                                     ? InkWell(
//                                         onTap: () {
//                                           //  context.beamToNamed(
//                                           //     '/account/shop/config');
//                                         },
//                                         child: Text(
//                                           "Potensi Komoditas",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       )
//                                     : SizedBox(),
//                                 SizedBox(height: _roleId == 4 ? 8 : 0),
//                                 InkWell(
//                                   onTap: () {
//                                     context.beamToNamed('/account/shop/config');
//                                   },
//                                   child: Text(
//                                     "Data ${_roleId == 4 ? 'supplier' : 'catering'}",
//                                     style: AppTypo.subtitle2
//                                         .copyWith(fontWeight: FontWeight.w400),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ))),
//                   SizedBox(width: 40),
//                   Expanded(
//                       flex: 2,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Data ${_roleId == 4 ? 'supplier' : 'catering'}",
//                             style: AppTypo.h2.copyWith(
//                                 fontWeight: FontWeight.w600, fontSize: 24),
//                           ),
//                           SizedBox(
//                             height: 16,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Nama",
//                                   style: AppTypo.subtitle2
//                                       .copyWith(fontWeight: FontWeight.w700)),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               InkWell(
//                                   onTap: _showEditAddress
//                                       ? null
//                                       : () {
//                                           setState(() {
//                                             if (_showEditName == true) {
//                                               _showEditName = false;
//                                             } else {
//                                               _showEditName = true;
//                                             }
//                                           });
//                                         },
//                                   child: _showEditName == true
//                                       ? Text("Batal",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: AppColor.primary))
//                                       : Text("Edit",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: _showEditAddress
//                                                   ? AppColor.grey
//                                                   : AppColor.primary)))
//                             ],
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           _showEditName == true
//                               ? Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     EditText(
//                                       hintText: "",
//                                       inputType: InputType.text,
//                                       controller: this._nameController,
//                                       autoValidateMode:
//                                           AutovalidateMode.onUserInteraction,
//                                       validator: _v.vNameShop,
                                      
//                                       // onTap: (){
//                                       //   setState(() {
//                                       //     _isButtonNameEnabled = false;
//                                       //   });
//                                       // },
//                                     ),
//                                     SizedBox(
//                                       width: 120,
//                                       child: RoundedButton.contained(
//                                         label: "Simpan",
//                                         isUpperCase: false,
//                                         isSmall: true,
//                                         onPressed: _isButtonNameEnabled
//                                             ? () => _handleEditSubmit()
//                                             : null,
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               : Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "widget.producer.nameSeller",
//                                       style: AppTypo.subtitle2.copyWith(
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                     Text("")
//                                   ],
//                                 ),
//                           SizedBox(
//                             height: 23,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Alamat",
//                                   style: AppTypo.subtitle2
//                                       .copyWith(fontWeight: FontWeight.w700)),
//                               InkWell(
//                                   onTap: _showEditName
//                                       ? null
//                                       : () {
//                                           setState(() {
//                                             if (_showEditAddress == true) {
//                                               _showEditAddress = false;
//                                             } else {
//                                               _showEditAddress = true;
//                                             }
//                                           });
//                                         },
//                                   child: _showEditAddress == true
//                                       ? Text("Batal",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: AppColor.primary))
//                                       : Text("Edit",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: _showEditName
//                                                   ? AppColor.grey
//                                                   : AppColor.primary)))
//                             ],
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           _showEditAddress == true
//                               ? Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Detail alamat",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                         SizedBox(
//                                           height: 8,
//                                         ),
//                                         EditText(
//                                           hintText: "",
//                                           inputType: InputType.text,
//                                           validator: _v.vAddress,
//                                           autoValidateMode: AutovalidateMode
//                                               .onUserInteraction,
//                                           controller: this._addressController,
                                          
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child: Container(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "Provinsi",
//                                                   style: AppTypo.subtitle2
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w400),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 8,
//                                                 ),
//                                                 EditText(
//                                                   hintText: "",
//                                                   isLoading: _isProvinceLoading,
//                                                   validator: _v.vProvinceShop,
//                                                   autoValidateMode:
//                                                       AutovalidateMode
//                                                           .onUserInteraction,
//                                                   enabled:
//                                                       _provinceList != null,
//                                                   inputType: InputType.option,
//                                                   controller:
//                                                       this._provinceController,
                                                  
//                                                   onTap: () =>
//                                                       _showRegionDialog(
//                                                           title:
//                                                               "Pilih Provinsi",
//                                                           items: _provinceList
//                                                               .map(
//                                                                   (e) => e.name)
//                                                               .toList(),
//                                                           onSelected: (id) {
//                                                             setState(() {
//                                                               _selectedProvinceId =
//                                                                   id;
//                                                               _provinceController
//                                                                       .text =
//                                                                   _provinceList[
//                                                                           _selectedProvinceId]
//                                                                       .name;
//                                                               _selectedCityId =
//                                                                   null;
//                                                               _selectedSubDistrictId =
//                                                                   null;
//                                                               _cityController
//                                                                   .text = '';
//                                                               _subDistrictController
//                                                                   .text = '';
//                                                               _cityList = null;
//                                                               _subDistrictList =
//                                                                   null;
//                                                               _getCity(
//                                                                   _provinceList[
//                                                                           id]
//                                                                       .id);
//                                                             });
//                                                           }),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 20,
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "Kota/Kabupaten",
//                                                   style: AppTypo.subtitle2
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w400),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 8,
//                                                 ),
//                                                 EditText(
//                                                   hintText: "",
//                                                   isLoading: _isCityLoading,
//                                                   enabled: _cityList != null,
//                                                   validator: _v.vCityShop,
//                                                   autoValidateMode:
//                                                       AutovalidateMode
//                                                           .onUserInteraction,
//                                                   inputType: InputType.option,
//                                                   controller:
//                                                       this._cityController,
                                                  
//                                                   onTap: () =>
//                                                       _showRegionDialog(
//                                                           title:
//                                                               "Pilih Kota/Kabupaten",
//                                                           items: _cityList
//                                                               .map(
//                                                                   (e) => e.name)
//                                                               .toList(),
//                                                           onSelected: (id) {
//                                                             setState(() {
//                                                               _selectedCityId =
//                                                                   id;
//                                                               _cityController
//                                                                   .text = _cityList[
//                                                                       _selectedCityId]
//                                                                   .name;
//                                                               _selectedSubDistrictId =
//                                                                   null;
//                                                               _subDistrictController
//                                                                   .text = '';
//                                                               _subDistrictList =
//                                                                   null;

//                                                               _getSubDistrict(
//                                                                   _cityList[id]
//                                                                       .id);
//                                                             });
//                                                           }),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           child: Container(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "Kecamatan",
//                                                   style: AppTypo.subtitle2
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w400),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 8,
//                                                 ),
//                                                 EditText(
//                                                   hintText: "",
//                                                   isLoading:
//                                                       _isSubdistrictLoading,
//                                                   validator: _v.vDistrictShop,
//                                                   autoValidateMode:
//                                                       AutovalidateMode
//                                                           .onUserInteraction,
//                                                   enabled:
//                                                       _subDistrictList != null,
//                                                   inputType: InputType.option,
//                                                   controller: this
//                                                       ._subDistrictController,
                                                  
//                                                   onTap: () =>
//                                                       _showRegionDialog(
//                                                           title:
//                                                               "Pilih Kecamatan",
//                                                           items: _subDistrictList
//                                                               .map((e) => e
//                                                                   .subdistrictName)
//                                                               .toList(),
//                                                           onSelected: (id) {
//                                                             setState(() {
//                                                               _selectedSubDistrictId =
//                                                                   id;
//                                                               _subDistrictController
//                                                                   .text = _subDistrictList[
//                                                                       _selectedSubDistrictId]
//                                                                   .subdistrictName;
//                                                             });
//                                                           }),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 20,
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Kelurahan",
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
//                                                 validator: _v.vKelurahan,
//                                                 autoValidateMode:
//                                                     AutovalidateMode
//                                                         .onUserInteraction,
//                                                 controller:
//                                                     this._kelurahanController,
                                                
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "RT",
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
//                                                 validator: _v.vRt,
//                                                 autoValidateMode:
//                                                     AutovalidateMode
//                                                         .onUserInteraction,
//                                                 controller: this._rtController,
                                                
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 20,
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "RW",
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
//                                                 validator: _v.vRw,
//                                                 autoValidateMode:
//                                                     AutovalidateMode
//                                                         .onUserInteraction,
//                                                 controller: this._rwController,
                                                
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     SizedBox(
//                                       width: 120,
//                                       child: RoundedButton.contained(
//                                         // isLoading: _isSubmitLoading,
//                                         label: "Simpan",
//                                         isUpperCase: false,
//                                         isSmall: true,
//                                         onPressed: _isButtonAddressEnabled
//                                             ? _handleEditSubmit
//                                             : null,
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               : Text(
//                                   "",
//                                   style: AppTypo.subtitle2.copyWith(
//                                     fontWeight: FontWeight.w400,
//                                   )),
//                           SizedBox(
//                             height: 23,
//                           ),
//                           Text(
//                             "Upload cover",
//                             style: AppTypo.subtitle2
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           ),
//                           SizedBox(height: 12),
//                           SizedBox(
//                             width: 190,
//                             height: 190,
//                             child: InkWell(
//                               onTap: _pickImage,
//                               child: ImagePickerFrame(
//                                   imageWeb: _image,
//                                   hintText: "Unggah Gambar",
//                                   width: double.infinity,
//                                   height: 190,
//                                   radius: 20),
//                             ),
//                           ),
//                         ],
//                       )),
//                   Expanded(flex: 1, child: SizedBox()),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 120,
//             ),
//             FooterWeb()
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

// class ShopDataWarungHorecaWebScreen extends StatefulWidget {
//   ShopDataWarungHorecaWebScreen(
//       {Key key, @required this.user})
//       : super(key: key);

//   final AddressRepository _addressRepository = AddressRepository();
//   final User user;

//   @override
//   _ShopDataWarungHorecaWebScreenState createState() =>
//       _ShopDataWarungHorecaWebScreenState();
// }

// class _ShopDataWarungHorecaWebScreenState
//     extends State<ShopDataWarungHorecaWebScreen> {
//   final ValidatorCustom _v = ValidatorCustom();

//   TextEditingController _nameController;
//   TextEditingController _nameShopController;
//   TextEditingController _phoneNumberController;
//   TextEditingController _addressController;
//   TextEditingController _provinceController;
//   TextEditingController _cityController;
//   TextEditingController _subDistrictController;
//   TextEditingController _kelurahanController;
//   TextEditingController _rtController;
//   TextEditingController _rwController;

//   List<Province> _provinceList;
//   List<City> _cityList;
//   List<SubDistrict> _subDistrictList;

//   int _selectedProvinceId;
//   int _selectedCityId;
//   int _selectedSubDistrictId;
//   int _roleId;

//   bool _isProvinceLoading;
//   bool _isCityLoading;
//   bool _isSubdistrictLoading;

//   bool _isInit;
//   bool _showEditName;
//   bool _showEditNameShop;
//   bool _showEditPhoneNumber;
//   bool _showEditAddress;
//   bool _isButtonNameEnabled;
//   bool _isButtonNameShopEnabled;
//   bool _isButtonPhoneNumber;
//   bool _isButtonAddressEnabled;

//   @override
//   void initState() {
//     _isInit = true;
//     // _image = null;
//     _showEditName = false;
//     _showEditAddress = false;
//     _showEditNameShop = false;
//     _showEditPhoneNumber = false;
//     _isButtonNameEnabled = false;
//     _isButtonPhoneNumber = false;
//     _isButtonAddressEnabled = false;
//     _isButtonNameShopEnabled = false;

//     _nameController = TextEditingController(text: '${widget.user.name}');
//     _nameShopController =
//         TextEditingController(text: '');
//     _phoneNumberController =
//         TextEditingController(text: '${widget.user.phonenumber}');
//     _addressController = TextEditingController(text: '');
//     _provinceController = TextEditingController(text: '');
//     _cityController = TextEditingController(text: '');
//     _subDistrictController = TextEditingController(text: '');
//     _kelurahanController =
//         TextEditingController(text: '');
//     _rtController = TextEditingController(text: '');
//     _rwController = TextEditingController(text: '');

//     _nameController.addListener(_checkEmpty);
//     _nameShopController.addListener(_checkEmpty);
//     _phoneNumberController.addListener(_checkEmpty);
//     _addressController.addListener(_checkEmpty);
//     _provinceController.addListener(_checkEmpty);
//     _cityController.addListener(_checkEmpty);
//     _subDistrictController.addListener(_checkEmpty);
//     _kelurahanController.addListener(_checkEmpty);
//     _rtController.addListener(_checkEmpty);
//     _rwController.addListener(_checkEmpty);

//     _isProvinceLoading = false;
//     _isCityLoading = false;
//     _isSubdistrictLoading = false;

//     _provinceList = null;
//     _cityList = null;
//     _subDistrictList = null;

//     _selectedProvinceId = null;
//     _selectedCityId = null;
//     _selectedSubDistrictId = null;

//     // _roleId = BlocProvider.of<UserDataCubit>(context).state.seller.roleId;

//     _getProvince();
//     _checkEmpty();
//     super.initState();
//   }

//   void _checkEmpty() {
//     if (_nameController.text.trim().isEmpty ||
//         _nameController.text == "") {
//       setState(() {
//         _isButtonNameEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonNameEnabled = true;
//       });
//     if (_nameShopController.text.trim().isEmpty ||
//         _nameShopController.text == widget.user.name) {
//       setState(() {
//         _isButtonNameShopEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonNameShopEnabled = true;
//       });
//     if (_phoneNumberController.text.trim().isEmpty ||
//         _phoneNumberController.text == widget.user.name) {
//       setState(() {
//         _isButtonPhoneNumber = false;
//       });
//     } else
//       setState(() {
//         _isButtonPhoneNumber = true;
//       });
//     if (_addressController.text.trim().isEmpty ||
//         _provinceController.text.trim().isEmpty ||
//         _subDistrictController.text.trim().isEmpty ||
//         _cityController.text.trim().isEmpty ||
//         _kelurahanController.text.trim().isEmpty ||
//         _rtController.text.trim().isEmpty ||
//         _rwController.text.trim().isEmpty) {
//       setState(() {
//         _isButtonAddressEnabled = false;
//       });
//     } else
//       setState(() {
//         _isButtonAddressEnabled = true;
//       });
//   }

//   void _handleEditSubmit() {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Cooming Soon... Nantikan updatenya segera")),
//     );
//   }

//   void _handleError(dynamic e) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(e.toString())));
//   }

//   _searchProvince() {
//     final index = _provinceList
//         .indexWhere((element) => element.id == "");
//     if (index >= 0) {
//       setState(() {
//         _selectedProvinceId = index;
//         _provinceController =
//             TextEditingController(text: "${_provinceList[index].name}");
//       });
//     }
//   }

//   _searchCity() {
//     final index =
//         _cityList.indexWhere((element) => element.id == "");
//     if (index >= 0) {
//       setState(() {
//         _selectedCityId = index;
//         _cityController.text = _cityList[index].name;
//       });
//     }
//   }

//   _searchSubDistrict() {
//     final index = _subDistrictList
//         .indexWhere((element) => element.id == "");
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
//           await widget._addressRepository.fetchProvince();
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
//           await widget._addressRepository.fetchCity(provinceId);
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
//           await widget._addressRepository.fetchSubDistrict(cityId);
//       setState(() {
//         _subDistrictList = response.data;
//       });
//       if (_isInit == true) {
//         await _searchSubDistrict();
//         setState(() {
//           _addressController.text ="";
//           _isInit = false;
//         });
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//     setState(() => _isSubdistrictLoading = false);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _nameShopController.dispose();
//     _phoneNumberController.dispose();
//     _addressController.dispose();
//     _subDistrictController.dispose();
//     _provinceController.dispose();
//     _cityController.dispose();
//     _kelurahanController.dispose();
//     _rtController.dispose();
//     _rwController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppTrans.SharedAxisTransitionSwitcher(
//       fillColor: Colors.transparent,
//       transitionType: SharedAxisTransitionType.vertical,
//       child: Scrollbar(
//         isAlwaysShown: true,
//         child: ListView(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 82, vertical: 40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Ubah data ${_roleId == 5 ? 'Reseller' : 'HORECA'}",style: AppTypo.h2.copyWith(fontSize: 24,fontWeight: FontWeight.w600)),
//                   SizedBox(height:45),
//                   Row(
//                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                           child: Column(
//                         children: [
//                           //===============================NAMA===============================
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Nama",
//                                   style: AppTypo.subtitle2
//                                       .copyWith(fontWeight: FontWeight.w700)),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               InkWell(
//                                   onTap: _showEditAddress ||
//                                           _showEditNameShop ||
//                                           _showEditPhoneNumber
//                                       ? null
//                                       : () {
//                                           setState(() {
//                                             if (_showEditName == true) {
//                                               _showEditName = false;
//                                             } else {
//                                               _showEditName = true;
//                                             }
//                                           });
//                                         },
//                                   child: _showEditName == true
//                                       ? Text("Batal",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: AppColor.primary))
//                                       : Text("Edit",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: _showEditAddress ||
//                                                       _showEditNameShop ||
//                                                       _showEditPhoneNumber
//                                                   ? AppColor.grey
//                                                   : AppColor.primary)))
//                             ],
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           _showEditName == true
//                               ? Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     EditText(
//                                       hintText: "",
//                                       inputType: InputType.text,
//                                       controller: this._nameController,
//                                       autoValidateMode:
//                                           AutovalidateMode.onUserInteraction,
//                                       validator: _v.vNameShop,
                                      
//                                       // onTap: (){
//                                       //   setState(() {
//                                       //     _isButtonNameEnabled = false;
//                                       //   });
//                                       // },
//                                     ),
//                                     SizedBox(
//                                       width: 120,
//                                       child: RoundedButton.contained(
//                                         label: "Simpan",
//                                         isUpperCase: false,
//                                         isSmall: true,
//                                         onPressed: _isButtonNameEnabled
//                                             ? () => _handleEditSubmit()
//                                             : null,
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               : Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       widget.user.name,
//                                       style: AppTypo.subtitle2
//                                           .copyWith(fontWeight: FontWeight.w400),
//                                     ),
//                                     Text("")
//                                   ],
//                                 ),
//                           //===============================NAMA WARUNG/HORECA===============================
//                           SizedBox(height: 30,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Nama ${_roleId == 5 ? 'Reseller' : 'HORECA'}",
//                                   style: AppTypo.subtitle2
//                                       .copyWith(fontWeight: FontWeight.w700)),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               InkWell(
//                                   onTap: _showEditName ||
//                                           _showEditPhoneNumber ||
//                                           _showEditAddress
//                                       ? null
//                                       : () {
//                                           setState(() {
//                                             if (_showEditNameShop == true) {
//                                               _showEditNameShop = false;
//                                             } else {
//                                               _showEditNameShop = true;
//                                             }
//                                           });
//                                         },
//                                   child: _showEditNameShop == true
//                                       ? Text("Batal",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: AppColor.primary))
//                                       : Text("Edit",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: _showEditAddress ||
//                                                       _showEditPhoneNumber ||
//                                                       _showEditName
//                                                   ? AppColor.grey
//                                                   : AppColor.primary)))
//                             ],
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           _showEditNameShop == true
//                               ? Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     EditText(
//                                       hintText: "",
//                                       inputType: InputType.text,
//                                       controller: this._nameShopController,
//                                       autoValidateMode:
//                                           AutovalidateMode.onUserInteraction,
//                                       validator: _v.vNameShop,
                                      
//                                       // onTap: (){
//                                       //   setState(() {
//                                       //     _isButtonNameEnabled = false;
//                                       //   });
//                                       // },
//                                     ),
//                                     SizedBox(
//                                       width: 120,
//                                       child: RoundedButton.contained(
//                                         label: "Simpan",
//                                         isUpperCase: false,
//                                         isSmall: true,
//                                         onPressed: _isButtonNameShopEnabled
//                                             ? () => _handleEditSubmit()
//                                             : null,
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               : Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                      " widget.producer.nameSeller",
//                                       style: AppTypo.subtitle2
//                                           .copyWith(fontWeight: FontWeight.w400),
//                                     ),
//                                     Text("")
//                                   ],
//                                 ),
//                           //===============================NUMBER PHONE===============================
//                           SizedBox(height: 30,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Nomor telepon",
//                                   style: AppTypo.subtitle2
//                                       .copyWith(fontWeight: FontWeight.w700)),
//                               SizedBox(
//                                 height: 8,
//                               ),
//                               InkWell(
//                                   onTap: _showEditAddress ||
//                                           _showEditNameShop ||
//                                           _showEditName
//                                       ? null
//                                       : () {
//                                           setState(() {
//                                             if (_showEditPhoneNumber == true) {
//                                               _showEditPhoneNumber = false;
//                                             } else {
//                                               _showEditPhoneNumber = true;
//                                             }
//                                           });
//                                         },
//                                   child: _showEditPhoneNumber == true
//                                       ? Text("Batal",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: AppColor.primary))
//                                       : Text("Edit",
//                                           style: AppTypo.subtitle2.copyWith(
//                                               fontWeight: FontWeight.w700,
//                                               color: _showEditAddress ||
//                                                       _showEditNameShop ||
//                                                       _showEditName
//                                                   ? AppColor.grey
//                                                   : AppColor.primary)))
//                             ],
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           _showEditPhoneNumber == true
//                               ? Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     EditText(
//                                       hintText: "",
//                                       inputType: InputType.text,
//                                       controller: this._phoneNumberController,
//                                       autoValidateMode:
//                                           AutovalidateMode.onUserInteraction,
//                                       validator: _v.vNameShop,
                                      
//                                       // onTap: (){
//                                       //   setState(() {
//                                       //     _isButtonNameEnabled = false;
//                                       //   });
//                                       // },
//                                     ),
//                                     SizedBox(
//                                       width: 120,
//                                       child: RoundedButton.contained(
//                                         label: "Simpan",
//                                         isUpperCase: false,
//                                         isSmall: true,
//                                         onPressed: _isButtonNameEnabled
//                                             ? () => _handleEditSubmit()
//                                             : null,
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               : Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       widget.user.phonenumber,
//                                       style: AppTypo.subtitle2
//                                           .copyWith(fontWeight: FontWeight.w400),
//                                     ),
//                                     Text("")
//                                   ],
//                                 ),
//                         ],
//                       )),
//                       SizedBox(
//                         width: 40,
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("Alamat",
//                                     style: AppTypo.subtitle2
//                                         .copyWith(fontWeight: FontWeight.w700)),
//                                 InkWell(
//                                     onTap: _showEditName ||
//                                             _showEditNameShop ||
//                                             _showEditPhoneNumber
//                                         ? null
//                                         : () {
//                                             setState(() {
//                                               if (_showEditAddress == true) {
//                                                 _showEditAddress = false;
//                                               } else {
//                                                 _showEditAddress = true;
//                                               }
//                                             });
//                                           },
//                                     child: _showEditAddress == true
//                                         ? Text("Batal",
//                                             style: AppTypo.subtitle2.copyWith(
//                                                 fontWeight: FontWeight.w700,
//                                                 color: AppColor.primary))
//                                         : Text("Edit",
//                                             style: AppTypo.subtitle2.copyWith(
//                                                 fontWeight: FontWeight.w700,
//                                                 color: _showEditName ||
//                                                         _showEditNameShop ||
//                                                         _showEditPhoneNumber
//                                                     ? AppColor.grey
//                                                     : AppColor.primary)))
//                               ],
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             _showEditAddress == true
//                                 ? Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "RT",
//                                                   style: AppTypo.subtitle2
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w400),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 8,
//                                                 ),
//                                                 EditText(
//                                                   hintText: "",
//                                                   inputType: InputType.text,
//                                                   validator: _v.vRt,
//                                                   autoValidateMode:
//                                                       AutovalidateMode
//                                                           .onUserInteraction,
//                                                   controller: this._rtController,
                                                  
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 20,
//                                           ),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "RW",
//                                                   style: AppTypo.subtitle2
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w400),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 8,
//                                                 ),
//                                                 EditText(
//                                                   hintText: "",
//                                                   inputType: InputType.text,
//                                                   validator: _v.vRw,
//                                                   autoValidateMode:
//                                                       AutovalidateMode
//                                                           .onUserInteraction,
//                                                   controller: this._rwController,
                                                  
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 16,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "Kecamatan",
//                                                     style: AppTypo.subtitle2
//                                                         .copyWith(
//                                                             fontWeight:
//                                                                 FontWeight.w400),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 8,
//                                                   ),
//                                                   EditText(
//                                                     hintText: "",
//                                                     isLoading:
//                                                         _isSubdistrictLoading,
//                                                     validator: _v.vDistrictShop,
//                                                     autoValidateMode:
//                                                         AutovalidateMode
//                                                             .onUserInteraction,
//                                                     enabled:
//                                                         _subDistrictList != null,
//                                                     inputType: InputType.option,
//                                                     controller: this
//                                                         ._subDistrictController,
                                                    
//                                                     onTap: () =>
//                                                         _showRegionDialog(
//                                                             title:
//                                                                 "Pilih Kecamatan",
//                                                             items: _subDistrictList
//                                                                 .map((e) => e
//                                                                     .subdistrictName)
//                                                                 .toList(),
//                                                             onSelected: (id) {
//                                                               setState(() {
//                                                                 _selectedSubDistrictId =
//                                                                     id;
//                                                                 _subDistrictController
//                                                                     .text = _subDistrictList[
//                                                                         _selectedSubDistrictId]
//                                                                     .subdistrictName;
//                                                               });
//                                                             }),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 20,
//                                           ),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "Kelurahan",
//                                                   style: AppTypo.subtitle2
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w400),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 8,
//                                                 ),
//                                                 EditText(
//                                                   hintText: "",
//                                                   inputType: InputType.text,
//                                                   validator: _v.vKelurahan,
//                                                   autoValidateMode:
//                                                       AutovalidateMode
//                                                           .onUserInteraction,
//                                                   controller:
//                                                       this._kelurahanController,
                                                  
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 16,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "Provinsi",
//                                                     style: AppTypo.subtitle2
//                                                         .copyWith(
//                                                             fontWeight:
//                                                                 FontWeight.w400),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 8,
//                                                   ),
//                                                   EditText(
//                                                     hintText: "",
//                                                     isLoading: _isProvinceLoading,
//                                                     validator: _v.vProvinceShop,
//                                                     autoValidateMode:
//                                                         AutovalidateMode
//                                                             .onUserInteraction,
//                                                     enabled:
//                                                         _provinceList != null,
//                                                     inputType: InputType.option,
//                                                     controller:
//                                                         this._provinceController,
                                                    
//                                                     onTap: () =>
//                                                         _showRegionDialog(
//                                                             title:
//                                                                 "Pilih Provinsi",
//                                                             items: _provinceList
//                                                                 .map(
//                                                                     (e) => e.name)
//                                                                 .toList(),
//                                                             onSelected: (id) {
//                                                               setState(() {
//                                                                 _selectedProvinceId =
//                                                                     id;
//                                                                 _provinceController
//                                                                         .text =
//                                                                     _provinceList[
//                                                                             _selectedProvinceId]
//                                                                         .name;
//                                                                 _selectedCityId =
//                                                                     null;
//                                                                 _selectedSubDistrictId =
//                                                                     null;
//                                                                 _cityController
//                                                                     .text = '';
//                                                                 _subDistrictController
//                                                                     .text = '';
//                                                                 _cityList = null;
//                                                                 _subDistrictList =
//                                                                     null;
//                                                                 _getCity(
//                                                                     _provinceList[
//                                                                             id]
//                                                                         .id);
//                                                               });
//                                                             }),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 20,
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "Kota/Kabupaten",
//                                                     style: AppTypo.subtitle2
//                                                         .copyWith(
//                                                             fontWeight:
//                                                                 FontWeight.w400),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 8,
//                                                   ),
//                                                   EditText(
//                                                     hintText: "",
//                                                     isLoading: _isCityLoading,
//                                                     enabled: _cityList != null,
//                                                     validator: _v.vCityShop,
//                                                     autoValidateMode:
//                                                         AutovalidateMode
//                                                             .onUserInteraction,
//                                                     inputType: InputType.option,
//                                                     controller:
//                                                         this._cityController,
                                                    
//                                                     onTap: () =>
//                                                         _showRegionDialog(
//                                                             title:
//                                                                 "Pilih Kota/Kabupaten",
//                                                             items: _cityList
//                                                                 .map(
//                                                                     (e) => e.name)
//                                                                 .toList(),
//                                                             onSelected: (id) {
//                                                               setState(() {
//                                                                 _selectedCityId =
//                                                                     id;
//                                                                 _cityController
//                                                                     .text = _cityList[
//                                                                         _selectedCityId]
//                                                                     .name;
//                                                                 _selectedSubDistrictId =
//                                                                     null;
//                                                                 _subDistrictController
//                                                                     .text = '';
//                                                                 _subDistrictList =
//                                                                     null;

//                                                                 _getSubDistrict(
//                                                                     _cityList[id]
//                                                                         .id);
//                                                               });
//                                                             }),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 16,
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Detail alamat",
//                                             style: AppTypo.subtitle2.copyWith(
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                           SizedBox(
//                                             height: 8,
//                                           ),
//                                           EditText(
//                                             hintText: "",
//                                             inputType: InputType.text,
//                                             validator: _v.vAddress,
//                                             autoValidateMode: AutovalidateMode
//                                                 .onUserInteraction,
//                                             controller: this._addressController,
                                            
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       SizedBox(
//                                         width: 120,
//                                         child: RoundedButton.contained(
//                                           // isLoading: _isSubmitLoading,
//                                           label: "Simpan",
//                                           isUpperCase: false,
//                                           isSmall: true,
//                                           onPressed: _isButtonAddressEnabled
//                                               ? _handleEditSubmit
//                                               : null,
//                                         ),
//                                       )
//                                     ],
//                                   )
//                                 : Text(
//                                     "${"widget.producer.addressSeller"}, RT${"widget.producer.rt" ?? '-'}/RW${"widget.producer.rw" ?? '-'}, kel. ${"widget.producer.kelurahan "?? '-'}, kec. ${_subDistrictController.text},\n${_cityController.text}, ${_provinceController.text}",
//                                     style: AppTypo.subtitle2.copyWith(
//                                       fontWeight: FontWeight.w400,
//                                     )),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             )
//             ,SizedBox(height: 100)
//             ,FooterWeb()
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
