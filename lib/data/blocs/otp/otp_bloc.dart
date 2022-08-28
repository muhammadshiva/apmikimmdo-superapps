import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final UserRepository _userRepository = UserRepository();
  final CartRepository _cartRepository = CartRepository();

  final UserDataCubit userDataCubit;
  OtpBloc({@required this.userDataCubit}) : super(OtpInitial());

  @override
  Stream<OtpState> mapEventToState(
    OtpEvent event,
  ) async* {
    if (event is OtpSubmited) {
      yield OtpLoading();
      try {
        final SignInResponse signInResponse =
            await _authenticationRepository.otpVerification(
                phoneNumber: "62${event.phoneNumber}", token: "${event.otp}");

        await _authenticationRepository.persistToken(signInResponse.token);
        await userDataCubit.appStarted();
        yield OtpSuccess();
      } catch (error) {
        yield OtpFailure(error.toString());
      }
    } else if (event is OtpRetry) {
      yield OtpRetryLoading();

      await _authenticationRepository.authenticate(
          phoneNumber: "62${event.phoneNumber}");
      yield OtpRetrySuccess();
    }
  }
}
