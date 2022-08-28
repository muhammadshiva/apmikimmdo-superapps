import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'choose_kecamatan_state.dart';

class ChooseKecamatanCubit extends Cubit<ChooseKecamatanState> {
  ChooseKecamatanCubit() : super(ChooseKecamatanState());

  void chooseKecamatan({@required String kecamatan, @required int subDistrict}) =>
      emit(state.copyWith(kecamatan: kecamatan, subDistrict: subDistrict));

  void reset() => emit(ChooseKecamatanState());
}
