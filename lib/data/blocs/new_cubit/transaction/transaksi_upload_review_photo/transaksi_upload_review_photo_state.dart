part of 'transaksi_upload_review_photo_cubit.dart';

class TransaksiUploadReviewPhotoState {
  final List<ProductPhotoReview> review;

  const TransaksiUploadReviewPhotoState({
    this.review = const [],
  });



  @override
  String toString() {
    return 'TransaksiUploadReviewPhotoState{review: $review}';
  }
}

class ProductPhotoReview {
  final List<String> photo;

  const ProductPhotoReview({
    this.photo = const [],
  });

  @override
  String toString() {
    return 'ProductPhotoReview{photo: $photo}';
  }
}
