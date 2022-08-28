import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserRepository _userRepository = UserRepository();
  User user;
  

  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await authenticationRepository.hasToken();
      if (hasToken) {
        try {
          final UserResponse userResponse = await _userRepository.fetchUser();
          user = userResponse.data;
          yield AuthenticationAuthenticated(user: userResponse.data);
        } catch (error) {
          yield AuthenticationFailure(message: error.toString());
          await Future.delayed(Duration(milliseconds: 3000));
          yield AuthenticationUnauthenticated();
        }
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is SignedIn) {
      yield AuthenticationLoading();
      try {
        await authenticationRepository.persistToken(event.token);
        final UserResponse userResponse = await _userRepository.fetchUser();
        user = userResponse.data;
        yield AuthenticationAuthenticated(user: userResponse.data);
      } catch (error) {
        yield AuthenticationFailure(message: error.toString());
        await Future.delayed(Duration(milliseconds: 3000));
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is OtpRequested) {
      yield AuthenticationOtpUnauthenticated(
          phoneNumber: event.phoneNumber, timeout: event.otpTimeout);
    }

    if (event is SignedOut) {
      yield AuthenticationLoading();
      await authenticationRepository.deleteToken();
      await Future.delayed(Duration(milliseconds: 1000));
      yield AuthenticationUnauthenticated();
    }

    if (event is SetUserData) {
      user = event.user;
    }
  }
}
