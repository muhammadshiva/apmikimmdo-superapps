import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'transaksi_upload_review_photo_state.dart';

class TransaksiUploadReviewPhotoCubit extends Cubit<TransaksiUploadReviewPhotoState> {
  TransaksiUploadReviewPhotoCubit() : super(TransaksiUploadReviewPhotoState());

  void addPhoto({int indexProduct, String photo}){
    var listProductReview = state.review;
    var listPhoto = List<String>.from(listProductReview[indexProduct].photo)..add(photo);
    listProductReview[indexProduct] = ProductPhotoReview(photo: listPhoto);
    emit(TransaksiUploadReviewPhotoState(review: listProductReview));
    debugPrint(state.toString());
  }

  void remove({int indexProduct, String photo}){
    var listProductReview = state.review;
    var listPhoto = List<String>.from(listProductReview[indexProduct].photo)..remove(photo);
    listProductReview[indexProduct] = ProductPhotoReview(photo: listPhoto);
    emit(TransaksiUploadReviewPhotoState(review: listProductReview));
    debugPrint(state.toString());
  }

  void initialization(int lenProduct){
    _reset();
    for (var i = 0; i < lenProduct; i++){
      emit(TransaksiUploadReviewPhotoState(review: List.from(state.review)..add(ProductPhotoReview())));
    }
    debugPrint(state.toString());
  }

  void _reset(){
    emit(TransaksiUploadReviewPhotoState());
  }

}
