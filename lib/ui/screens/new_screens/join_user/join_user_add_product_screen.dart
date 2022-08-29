import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:marketplace/data/blocs/fetch_subcategories/fetch_subcategories_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/supplier/post_product/post_add_product_supplier_cubit.dart';
import 'package:marketplace/data/models/new_models/supplier.dart';
import 'package:marketplace/ui/screens/new_screens/join_user/widgets/add_subkategori_product.dart';
import 'package:marketplace/ui/screens/new_screens/join_user/widgets/add_varian_list.dart';
import 'package:marketplace/ui/screens/new_screens/producer_dashboard/producer_dashboard_screen.dart';
import 'package:marketplace/ui/widgets/bs_feedback.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:pattern_formatter/pattern_formatter.dart';

import 'widgets/add_grosir_list.dart';
import 'widgets/add_kategori_product.dart';
import 'widgets/add_photo_product.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;

class JoinUserAddProductScreen extends StatefulWidget {
  const JoinUserAddProductScreen({Key key, this.item}) : super(key: key);

  final SupplierDataResponseItem item;

  @override
  _JoinUserAddProductScreenState createState() =>
      _JoinUserAddProductScreenState();
}

class _JoinUserAddProductScreenState extends State<JoinUserAddProductScreen> {
  FetchCategoriesCubit _fetchCategoriesCubit;
  FetchSubcategoriesCubit _fetchSubcategoriesCubit;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _namaController,
      _linkController,
      _beratController,
      _hargaController,
      _stockController,
      _komisiController,
      _satuanController,
      _deskripsiController,
      _categoryController,
      _subCategoryController,
      _mainPhotoProductController;

  bool inputNotValid = true;

  @override
  void initState() {
    _fetchCategoriesCubit = FetchCategoriesCubit()..load();
    _fetchSubcategoriesCubit = FetchSubcategoriesCubit();
    if (widget.item == null) {
      debugPrint("reset");
      context.read<AddProductSupplierCubit>().reset();
    }
    //controller
    _namaController = TextEditingController(
        text: widget.item != null ? widget.item.productName : "");
    _linkController = TextEditingController(text: "");
    _beratController = TextEditingController(
        text: widget.item != null ? widget.item.productWeight.toString() : "");
    _hargaController = TextEditingController(
        text: widget.item != null ? widget.item.productPrice.toString() : "");
    _stockController = TextEditingController(
        text: widget.item != null ? widget.item.productStock.toString() : "");
    _komisiController = TextEditingController(
        text: widget.item != null ? widget.item.commission.toString() : "");
    _satuanController = TextEditingController(
        text: widget.item != null ? widget.item.productUnit.toString() : "");
    _deskripsiController = TextEditingController(
        text: widget.item != null ? widget.item.productDescription : "");
    _mainPhotoProductController = TextEditingController(
        text: widget.item != null ? widget.item.coverPhoto.toString() : "");
    _categoryController = TextEditingController(
        text: widget.item != null ? widget.item.category.toString() : "");
    _subCategoryController = TextEditingController(
        text: widget.item != null ? widget.item.subCategoryId.toString() : "");
    //Listener
    _namaController.addListener(checkEmpty);
    _beratController.addListener(checkEmpty);
    _hargaController.addListener(checkEmpty);
    _stockController.addListener(checkEmpty);
    _satuanController.addListener(checkEmpty);
    // _komisiController.addListener(checkEmpty);
    _mainPhotoProductController.addListener(checkEmpty);
    _categoryController.addListener(checkEmpty);
    _subCategoryController.addListener(checkEmpty);
    _deskripsiController.addListener(checkEmpty);

    checkEmpty();

    super.initState();
  }

  @override
  void dispose() {
    _fetchCategoriesCubit.close();
    _fetchSubcategoriesCubit.close();
    _namaController.dispose();
    _linkController.dispose();
    _beratController.dispose();
    _hargaController.dispose();
    _satuanController.dispose();
    _stockController.dispose();
    // _komisiController.dispose();
    _deskripsiController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    super.dispose();
  }

  String validation(String value) {
    if (value.isEmpty) {
      return "Wajib diisi";
    }
    return null;
  }

  void checkEmpty() {
    if (_namaController.text.trim().isEmpty ||
        _beratController.text.trim().isEmpty ||
        _hargaController.text.trim().isEmpty ||
        _stockController.text.trim().isEmpty ||
        _satuanController.text.trim().isEmpty ||
        _mainPhotoProductController.text.trim().isEmpty ||
        _categoryController.text.trim().isEmpty ||
        _subCategoryController.text.trim().isEmpty ||
        _deskripsiController.text.trim().isEmpty) {
      setState(() {
        inputNotValid = true;
      });
    } else {
      setState(() {
        inputNotValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = context.read<AddProductSupplierCubit>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<AddProductSupplierCubit, AddProductSupplierState>(
          listenWhen: (prev, curr) => prev.categoryId != curr.categoryId,
          listener: (context, state) {
            _fetchSubcategoriesCubit.fetchSubcategories(state.categoryId);
          },
        ),
        BlocListener<PostAddProductSupplierCubit, PostAddProductSupplierState>(
          listener: (context, state) {
            debugPrint("listener state $state");
            if (state is PostAddProductSupplierFailure) {
              // BSFeedback.show(context, title: state.result);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.result)));
            }
            if (state is PostAddProductSupplierSuccess) {
              AppExt.popUntilRoot(context);
              BlocProvider.of<BottomNavCubit>(context).navItemTapped(3);
              AppExt.pushScreen(
                  context,
                  ProducerDashboardScreen(
                    isSupplier: true,
                  ));
              // ScaffoldMessenger.of(context)..showSnackBar(SnackBar(content: Text(state.message),));
              BSFeedback.show(context,
                  title: widget.item != null
                      ? "Produk berhasil diubah"
                      : "Produk berhasil ditambahkan dan akan ditinjau oleh admin");
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () {
          AppExt.popUntilRoot(context);
          BlocProvider.of<BottomNavCubit>(context).navItemTapped(3);
          AppExt.pushScreen(
              context,
              ProducerDashboardScreen(
                isSupplier: true,
              ));
          return;
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppColor.black),
            backgroundColor: Colors.white,
            title: Text(
              widget.item != null ? "Ubah Produk" : "Tambah Produk",
              style: AppTypo.subtitle2,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputLabel(
                        title:
                            "Upload Foto Produk (Minimal 1 foto wajib diisi)"),
                    SizedBox(
                      height: 8,
                    ),
                    AddPhotoProduct(
                      isUpdateForm: widget.item != null,
                      checkMainPhoto: (value) {
                        _mainPhotoProductController..text = value;
                        debugPrint(value);
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Link Video Produk",
                      style: AppTypo.caption,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    EditText(
                      controller: _linkController,
                      hintText: "",
                      keyboardType: TextInputType.url,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    InputLabel(title: "Nama"),
                    SizedBox(
                      height: 8,
                    ),
                    EditText(
                      controller: _namaController,
                      hintText: "",
                      validator: validation,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    InputLabel(title: "Kategori"),
                    SizedBox(
                      height: 8,
                    ),
                    BlocBuilder(
                      cubit: _fetchCategoriesCubit,
                      builder: (context, state) {
                        if (state is FetchCategoriesLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is FetchCategoriesSuccess) {
                          return BlocBuilder<AddProductSupplierCubit,
                              AddProductSupplierState>(
                            builder: (context, product) {
                              return AddKategoriProduct(
                                name: product.categoryName != null
                                    ? product.categoryName
                                    : widget.item != null
                                        ? widget.item.category
                                        : '',
                                categories: state.categories,
                                checkCategory: (value) {
                                  _categoryController..text = value;
                                },
                              );
                            },
                          );
                        }
                        return AddKategoriProduct(
                          name: "Error",
                        );
                      },
                    ),
                    BlocBuilder(
                      cubit: _fetchSubcategoriesCubit,
                      builder: (context, state) {
                        if (state is FetchSubcategoriesLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is FetchSubcategoriesSuccess) {
                          return BlocBuilder<AddProductSupplierCubit,
                              AddProductSupplierState>(
                            builder: (context, product) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InputLabel(title: "Sub Kategori"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  AddSubkategoriProduct(
                                    name: product.subCategoryName,
                                    categories: state.subcategories,
                                    checkSubCategory: (value) {
                                      _subCategoryController..text = value;
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        if (state is FetchSubcategoriesFailure) {
                          return AddKategoriProduct(
                            name: "Error",
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputLabel(title: "Berat"),
                              SizedBox(
                                height: 8,
                              ),
                              EditText(
                                controller: _beratController,
                                hintText: 'Masukkan berat',
                                keyboardType: TextInputType.number,
                                validator: validation,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputLabel(title: "Satuan"),
                              SizedBox(
                                height: 8,
                              ),
                              BlocBuilder<AddProductSupplierCubit,
                                      AddProductSupplierState>(
                                  builder: (context, state) {
                                return EditText(
                                  controller: _satuanController
                                    ..text = state.satuan,
                                  hintText: state.satuan ?? "Satuan",
                                  inputType: InputType.option,
                                  validator: validation,
                                  onTap: () {
                                    _showSatuanDialog(
                                        context: context, satuan: ["gr", "kg"]);
                                  },
                                );
                              })
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputLabel(title: "Harga"),
                              SizedBox(
                                height: 8,
                              ),
                              EditText(
                                controller: _hargaController,
                                hintText: '',
                                inputType: InputType.price,
                                keyboardType: TextInputType.number,
                                validator: validation,
                                inputFormatter: [ThousandsFormatter()],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputLabel(title: "Stok"),
                              SizedBox(
                                height: 8,
                              ),
                              EditText(
                                controller: _stockController,
                                hintText: '',
                                keyboardType: TextInputType.number,
                                validator: validation,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    /* Text(
                      "Komisi Reseller (%)",
                      style: AppTypo.caption,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    EditText(
                        controller: _komisiController,
                        hintText: "",
                        validator: validation,
                        keyboardType: TextInputType.number), */
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Grosir",
                      style: AppTypo.caption,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    AddGrosirList(),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Varian",
                      style: AppTypo.caption,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    AddVarianList(),
                    SizedBox(
                      height: 16,
                    ),
                    InputLabel(title: "Deskripsi"),
                    SizedBox(
                      height: 8,
                    ),
                    EditText(
                      controller: _deskripsiController,
                      hintText: "",
                      inputType: InputType.field,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<PostAddProductSupplierCubit,
                          PostAddProductSupplierState>(
                        builder: (context, state) {
                          if (state is PostAddProductSupplierLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return RoundedButton.contained(
                            // disabled: inputNotValid,
                            isUpperCase: false,
                            textColor: Colors.white,
                            onPressed: () {
                              debugPrint("jumlah harga : " +
                                  AppExt.deleteAllComma(_hargaController.text));
                              if (_formKey.currentState.validate()) {
                                final product = context
                                    .read<AddProductSupplierCubit>()
                                    .state;
                                List<String> listPhoto = [];
                                List<Uint8List> listPhotoByte = [];
                                if (product.foto1.contains('https')) {
                                  listPhoto = [];
                                } else {
                                  if (product.foto1 != null) {
                                    listPhoto.add(product.foto1);
                                    listPhotoByte.add(product.fotoByte1);
                                  }
                                  if (product.foto2 != null) {
                                    listPhoto.add(product.foto2);
                                    listPhotoByte.add(product.fotoByte2);
                                  }
                                  if (product.foto3 != null) {
                                    listPhoto.add(product.foto3);
                                    listPhotoByte.add(product.fotoByte3);
                                  }
                                  if (product.foto4 != null) {
                                    listPhoto.add(product.foto4);
                                    listPhotoByte.add(product.fotoByte4);
                                  }
                                }

                                final data = json.encode({
                                  "name": _namaController.text,
                                  "categoryId": product.subCategoryId,
                                  "weight": int.parse(_beratController.text),
                                  "unit": product.satuan,
                                  "price": 1000,
                                  "stock": int.parse(_stockController.text),
                                  "description": _deskripsiController.text,
                                  // "commision":
                                  //     int.parse(_komisiController.text),
                                  "link": _linkController.text,
                                  "productPhoto": listPhoto,
                                  // "productPhotoByte": listPhotoByte,
                                  "hargaGrosir": product.grosirHarga,
                                  "minimumOrder": product.grosirMinimumBeli,
                                  "varianType": product.varianId1,
                                  "varianName": product.varianName1,
                                  "varianPrice": product.varianHarga,
                                  "varianStock": product.varianStok
                                });
                                debugPrint("mydata $data");
                                if (widget.item != null) {
                                  context
                                      .read<PostAddProductSupplierCubit>()
                                      .editProduct(
                                        productId: widget.item.id,
                                        name: _namaController.text,
                                        categoryId: int.parse(
                                            _subCategoryController.text),
                                        weight:
                                            int.parse(_beratController.text),
                                        unit: _satuanController.text,
                                        price: int.parse(AppExt.deleteAllComma(
                                            _hargaController.text)),
                                        stock: int.parse(_stockController.text),
                                        description: _deskripsiController.text,
                                        commision: 0,
                                        link: _linkController.text,
                                        productPhoto: listPhoto,
                                        productPhotoByte: listPhotoByte,
                                        hargaGrosir: product.grosirHarga,
                                        minimumOrder: product.grosirMinimumBeli,
                                        varianType: product.varianId1,
                                        varianName: product.varianName1,
                                        varianPrice: product.varianHarga,
                                        varianStock: product.varianStok,
                                      );
                                } else {
                                  context
                                      .read<PostAddProductSupplierCubit>()
                                      .addProduct(
                                        name: _namaController.text,
                                        categoryId: product.subCategoryId,
                                        weight:
                                            int.parse(_beratController.text),
                                        unit: product.satuan,
                                        price: int.parse(AppExt.deleteAllComma(
                                            _hargaController.text)),
                                        stock: int.parse(_stockController.text),
                                        description: _deskripsiController.text,
                                        commision: 0,
                                        link: _linkController.text,
                                        productPhoto: listPhoto.length == 0
                                            ? null
                                            : listPhoto,
                                        productPhotoByte: listPhotoByte,
                                        hargaGrosir: product.grosirHarga,
                                        minimumOrder: product.grosirMinimumBeli,
                                        varianType: product.varianId1,
                                        varianName: product.varianName1,
                                        varianPrice: product.varianHarga,
                                        varianStock: product.varianStok,
                                      );
                                }
                              }
                            },
                            label: widget.item != null
                                ? "Ubah Produk"
                                : "Tambah Produk",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSatuanDialog({
    @required BuildContext context,
    @required List<String> satuan,
    // @required void Function(int id) onSelected,
  }) {
    Future.delayed(
      Duration.zero,
      () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)), //this right here
              child: Container(
                child: ListView.separated(
                  // padding: EdgeInsets.symmetric(vertical: 5),
                  shrinkWrap: true,
                  itemCount: satuan.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 0.5,
                    thickness: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: VisualDensity.compact,
                      trailing: Icon(FlutterIcons.chevron_right_mco),
                      title: Text(satuan[index]),
                      onTap: () {
                        context
                            .read<AddProductSupplierCubit>()
                            .addSatuan(satuan[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  RichText InputLabel({String title}) {
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(color: AppColor.textPrimary),
        children: <TextSpan>[
          TextSpan(
            text: " *",
            style: TextStyle(color: AppColor.red),
          ),
        ],
      ),
    );
  }
}
