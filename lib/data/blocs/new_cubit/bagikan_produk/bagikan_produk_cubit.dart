import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bagikan_produk_state.dart';

class BagikanProdukCubit extends Cubit<List<String>> {
  BagikanProdukCubit() : super(["Gambar", "Judul dan Deskripsi"]);

  void reset() =>
      emit(List.from(state)
        ..clear()
        ..add("Gambar")..add("Judul dan Deskripsi"));

  void add(String value) =>
      emit(List.from(state)
        ..add(value));

  void remove(String value) =>
      emit(List.from(state)
        ..remove(value));

}
