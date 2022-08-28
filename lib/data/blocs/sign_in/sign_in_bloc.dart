import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  SignInBloc() : super(SignInInitial());

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInButtonPressed) {
      yield SignInLoading();

      try {
        try {
          int.parse(event.phoneNumber);
        } catch (e) {
          throw ("Nomor telpon hanya menerima angka");
        }
        if (event.phoneNumber[0] == '0') throw ("Nomor telpon tidak valid");

        await authenticationRepository.authenticate(
          phoneNumber: "62${event.phoneNumber}",
        );
        yield SignInOtpRequested(
            phoneNumber: event.phoneNumber, otpTimeOut: 50);
      } catch (error) {
        yield SignInFailure(error: error.toString());
      }
    }
  }
}
