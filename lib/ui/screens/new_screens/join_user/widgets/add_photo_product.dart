import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/ui/widgets/bs_unggah_foto.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class AddPhotoProduct extends StatelessWidget {
  const AddPhotoProduct({
    Key key, this.checkMainPhoto, this.isUpdateForm = false,
  }) : super(key: key);

  final Function(String value) checkMainPhoto;
  final bool isUpdateForm;


  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () async {
                BsUnggahFoto().upload(context, onTapCamera: () async {
                  if (!kIsWeb) {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.camera, imageQuality: 50);
                    if (pickedFile != null) {
                      context
                          .read<AddProductSupplierCubit>()
                          .addPhoto1(pickedFile);
                      checkMainPhoto(pickedFile.path.toString());
                      AppExt.popScreen(context);
                    }
                  }
                }, onTapGaleri: () async {
                  if (!kIsWeb) {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    if (pickedFile != null) {
                      context
                          .read<AddProductSupplierCubit>()
                          .addPhoto1(pickedFile);
                      checkMainPhoto(pickedFile.path.toString());
                      AppExt.popScreen(context);
                    }
                  }
                });
              },
              child:
              BlocBuilder<AddProductSupplierCubit, AddProductSupplierState>(
                builder: (context, state) {
                  return Container(
                    width: 70,
                    height: 70,
                    padding: state.foto1 != null
                        ? null
                        : EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isUpdateForm == true && state.foto1 != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      state.foto1.contains('https') ?
                      Image.network(state.foto1) :
                      Image.file(
                        File(state.foto1),
                        fit: BoxFit.cover,
                      ),
                    )
                        : isUpdateForm == false && state.foto1 != null ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      Image.file(
                        File(state.foto1),
                        fit: BoxFit.cover,
                      ),
                    )
                        : PlaceholderEmptyImage(
                      label: "Foto Utama",
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () async {
                BsUnggahFoto().upload(context, onTapCamera: () async {
                  if (!kIsWeb) {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.camera, imageQuality: 50);
                    if (pickedFile != null) {
                      context
                          .read<AddProductSupplierCubit>()
                          .addPhoto2(pickedFile);
                      AppExt.popScreen(context);
                    }
                  }
                }, onTapGaleri: () async {
                  if (!kIsWeb) {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    if (pickedFile != null) {
                      context
                          .read<AddProductSupplierCubit>()
                          .addPhoto2(pickedFile);
                      AppExt.popScreen(context);
                    }
                  }
                });
              },
              child:
              BlocBuilder<AddProductSupplierCubit, AddProductSupplierState>(
                builder: (context, state) {
                  return Container(
                    width: 70,
                    height: 70,
                    padding: state.foto2 != null
                        ? null
                        : EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isUpdateForm == true && state.foto2 != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      state.foto2.contains('https') ?
                      Image.network(state.foto2) :
                      Image.file(
                        File(state.foto2),
                        fit: BoxFit.cover,
                      ),
                    )
                        : isUpdateForm == false && state.foto2 != null ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      Image.file(
                        File(state.foto2),
                        fit: BoxFit.cover,
                      ),
                    )
                        : PlaceholderEmptyImage(
                      label: "Foto 1",
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () async {
                BsUnggahFoto().upload(context, onTapCamera: () async {
                  if (!kIsWeb) {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.camera, imageQuality: 50);
                    if (pickedFile != null) {
                      context
                          .read<AddProductSupplierCubit>()
                          .addPhoto3(pickedFile);
                      AppExt.popScreen(context);
                    }
                  }
                }, onTapGaleri: () async {
                  if (!kIsWeb) {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    if (pickedFile != null) {
                      context
                          .read<AddProductSupplierCubit>()
                          .addPhoto3(pickedFile);
                      AppExt.popScreen(context);
                    }
                  }
                });
              },
              child:
              BlocBuilder<AddProductSupplierCubit, AddProductSupplierState>(
                builder: (context, state) {
                  return Container(
                    width: 70,
                    height: 70,
                    padding: state.foto3 != null
                        ? null
                        : EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isUpdateForm == true && state.foto3 != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      state.foto3.contains('https') ?
                      Image.network(state.foto3) :
                      Image.file(
                        File(state.foto3),
                        fit: BoxFit.cover,
                      ),
                    )
                        : isUpdateForm == false && state.foto3 != null ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      Image.file(
                        File(state.foto3),
                        fit: BoxFit.cover,
                      ),
                    )
                        : PlaceholderEmptyImage(
                      label: "Foto 2",
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () async {
                BsUnggahFoto().upload(context, onTapCamera: () async {
                  if (!kIsWeb) {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.camera, imageQuality: 50);
                    if (pickedFile != null) {
                      context
                          .read<AddProductSupplierCubit>()
                          .addPhoto4(pickedFile);
                      AppExt.popScreen(context);
                    }
                  }
                }, onTapGaleri: () async {
                  if (!kIsWeb) {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    if (pickedFile != null) {
                      context
                          .read<AddProductSupplierCubit>()
                          .addPhoto4(pickedFile);
                      AppExt.popScreen(context);
                    }
                  }
                });
              },
              child:
              BlocBuilder<AddProductSupplierCubit, AddProductSupplierState>(
                builder: (context, state) {
                  return Container(
                    width: 70,
                    height: 70,
                    padding: state.foto4 != null
                        ? null
                        : EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isUpdateForm == true && state.foto4 != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      state.foto4.contains('https') ?
                      Image.network(state.foto4) :
                      Image.file(
                        File(state.foto4),
                        fit: BoxFit.cover,
                      ),
                    )
                        : isUpdateForm == false && state.foto4 != null ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      Image.file(
                        File(state.foto4),
                        fit: BoxFit.cover,
                      ),
                    )
                        : PlaceholderEmptyImage(
                      label: "Foto 3",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PlaceholderEmptyImage extends StatelessWidget {
  const PlaceholderEmptyImage({Key key, @required this.label})
      : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo,
          color: Colors.grey,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: AppTypo.caption.copyWith(color: Colors.grey, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}