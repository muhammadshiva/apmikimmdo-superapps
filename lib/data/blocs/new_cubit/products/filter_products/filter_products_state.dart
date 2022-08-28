part of 'filter_products_cubit.dart';

class FilterProductsState {
  final int sortId;
  final String sortName;
  final int provinceId;
  final String provinceName;
  final int cityId;
  final String cityName;

  const FilterProductsState({
    this.sortId,
    this.sortName,
    this.provinceId,
    this.provinceName,
    this.cityId,
    this.cityName,
  });

  FilterProductsState copyWith({
    int sortId,
    String sortName,
    int provinceId,
    String provinceName,
    int cityId,
    String cityName,
  }) {
    return FilterProductsState(
      sortId: sortId ?? this.sortId,
      sortName: sortName ?? this.sortName,
      provinceId: provinceId ?? this.provinceId,
      provinceName: provinceName ?? this.provinceName,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
    );
  }
}
