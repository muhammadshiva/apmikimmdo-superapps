import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'fetch_shipping_options_state.dart';

class FetchShippingOptionsCubit extends Cubit<FetchShippingOptionsState> {
  FetchShippingOptionsCubit() : super(FetchShippingOptionsInitial());

  final ShippingRepository _shippingRepository = ShippingRepository();

  Future<void> load({
    @required int totalWeight,
    @required int subdistrictId,
    @required int supplierId,
    @required int productId,
  }) async {
    emit(FetchShippingOptionsLoading());
    try {
      final response = await _shippingRepository.fetchShippingOptions(
        totalWeight: totalWeight,
        subdistrictId: subdistrictId,
        supplierId: supplierId,
        productId: productId,
      );
      emit(FetchShippingOptionsSuccess(response.data));
    } catch (error) {
      emit(FetchShippingOptionsFailure(error.toString()));
    }
  }

// @override
// void onChange(Change<FetchShippingOptionsState> change) {
//   debugPrint(change.nextState);
//   super.onChange(change);
// }
}
