import 'package:bloc/bloc.dart';

part 'filter_products_state.dart';

class FilterProductsCubit extends Cubit<FilterProductsState> {
  FilterProductsCubit() : super(FilterProductsState());

  void selectUrutkan(int id, String name) => emit(state.copyWith(sortId: id, sortName: name));

  void selectProvince(int id, String name) => emit(state.copyWith(provinceId: id, provinceName: name));

  void selectCity(int id, String name) => emit(state.copyWith(cityId: id, cityName: name));

  void reset() => emit(FilterProductsState());
}
