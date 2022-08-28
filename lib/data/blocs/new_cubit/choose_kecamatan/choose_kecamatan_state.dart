part of 'choose_kecamatan_cubit.dart';

class ChooseKecamatanState {
  final String kecamatan;
  final int subDistrict;

  const ChooseKecamatanState({
    this.kecamatan = "",
    this.subDistrict,
  });

  ChooseKecamatanState copyWith({
    String kecamatan,
    int subDistrict,
  }) {
    return ChooseKecamatanState(
      kecamatan: kecamatan ?? this.kecamatan,
      subDistrict: subDistrict ?? this.subDistrict,
    );
  }
}
