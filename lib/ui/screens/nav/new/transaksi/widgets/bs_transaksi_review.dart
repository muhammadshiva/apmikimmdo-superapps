import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_upload_review_photo/transaksi_upload_review_photo_cubit.dart';
import 'package:marketplace/ui/widgets/border_button.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class BsTransaksiReview {
  final _picker = ImagePicker();

  Future<void> showBsReview(BuildContext context) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * (15 / 100),
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7.5 / 2),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  // shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Beri Ulasan",
                        style: AppTypo.subtitle1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/img_cs.png",
                                    height: 48,
                                    width: 48,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Batik"),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text("Lestari Jaya"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    debugPrint(rating.toString());
                                  },
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Bagaimana pengalaman berbelanja anda?",
                                style: AppTypo.caption,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              EditText(
                                hintText:
                                    "Ceritakan tentang kualitas barang dan pengalaman berbelanja anda disini",
                                maxLength: 5,
                                inputType: InputType.field,
                              ),
                              BlocBuilder<TransaksiUploadReviewPhotoCubit,
                                  TransaksiUploadReviewPhotoState>(
                                builder: (context, state) {
                                  if (state.review[0].photo.isEmpty) {
                                    return BorderButton(
                                      onPressed: () {
                                        _pickImageFromCamera(context, 0);
                                      },
                                      color: Colors.grey[200],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Tambah Foto",
                                            style: AppTypo.caption
                                                .copyWith(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return Wrap(
                                    runSpacing: 1,
                                    spacing: 3,
                                    children: [
                                      Wrap(
                                        spacing: 3,
                                        runSpacing: 0,
                                        children: [
                                          for (var i = 0;
                                              i < state.review[0].photo.length;
                                              i++)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  debugPrint(i.toString());
                                                  context.read<TransaksiUploadReviewPhotoCubit>().remove(indexProduct: 0, photo: state.review[0].photo[i]);
                                                },
                                                child: Image.file(
                                                  File(state.review[0].photo[i]),
                                                  width: 48,
                                                  height: 48,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _pickImageFromCamera(context, 0);
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 48,
                                              width: 48,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.grey[300])
                                              ),
                                              child: Icon(Icons.add_a_photo, color: Colors.grey[300]),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Icon(Icons.close, size: 5, color: Colors.grey[300],),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Kirim Ulasan",
                            style:
                                AppTypo.subtitle1.copyWith(color: Colors.white),
                          ),
                          onPressed: () {}),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _pickImageFromGallery(BuildContext context, int index) async {
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      context
          .read<TransaksiUploadReviewPhotoCubit>()
          .addPhoto(indexProduct: index, photo: pickedFile.path);
    }

    /*setState(() {
      if (pickedFile != null) {
        _image = kIsWeb ? pickedFile : File(pickedFile.path);
        _imageWeb = pickedFile.path;
      }
    });*/
    /*if (!kIsWeb) {
      AppExt.popScreen(context);
    }*/
  }

  _pickImageFromCamera(BuildContext context, int index) async {
    final pickedFile =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      context
          .read<TransaksiUploadReviewPhotoCubit>()
          .addPhoto(indexProduct: index, photo: pickedFile.path);
    }

    /*setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });*/

    // AppExt.popScreen(context);
  }
}
