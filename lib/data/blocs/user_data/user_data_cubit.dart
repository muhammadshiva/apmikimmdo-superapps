import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit()
      : super(UserDataState(
          user: null,
          countCart: null,
        ));

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserRepository _userRepository = UserRepository();
  final CartRepository _cartRepository = CartRepository();
  final RecipentRepository _recipentRepo = RecipentRepository();
  final TransactionRepository _transRepo = TransactionRepository();

  void setData({User user, int countCart, int countBooking}) {
    emit(UserDataState(
      user: user == null ? state.user : user,
      countCart: countCart == null ? state.countCart : countCart,
    ));
  }

  Future<void> updateCountCart() async {
    final CountCartResponse countCartResponse =
        await _cartRepository.countCart();
    setData(countCart: countCartResponse.data);
  }

  Future<void> updateUser() async {
    final UserResponse userResponse = await _userRepository.fetchUser();
    setData(user: userResponse.data);
  }

  void logout() async {
    await authenticationRepository.deleteToken();
    _recipentRepo.gs.remove('recipentSelected');
     _recipentRepo.gs.remove('selectedSubdistrictStorage');
    // _recipentRepo.gs.write('recipentSelected', _recipentRepo.tempRecipent);
    emit(UserDataState(
      user: null,
      countCart: null,
    ));
  }

  Future<void> appStarted() async {
    emit(UserDataInitial());
    final bool hasToken = await authenticationRepository.hasToken();
    Future.delayed(Duration(milliseconds: 0, seconds: hasToken ? 0 : 2),
        () async {
    try {
      if (hasToken) {
        loadUser();
        _recipentRepo.getMainAddressFilter();
      } else {
        // if (_recipentRepo.getSelectedRecipent() == null) {
        //   _recipentRepo.gs
        //       .write('recipentSelected', _recipentRepo.tempRecipent);
        // }
        _recipentRepo.gs
              .write('recipentSelected', _recipentRepo.tempRecipent);
        _transRepo.setPaymentCheck(value: false);
        _transRepo.setPaymentDetailCheck(value: false);
        _recipentRepo.isFromWppDashboard(value: false);
        _recipentRepo.isFromWppDetailProductDetail(value: false);
        _recipentRepo.gs.remove('recipentNoAuth');
        _recipentRepo.gs.remove('recipentResellerShop');
        _recipentRepo.gs.remove('recipentUserNoAuthDashboard');
        _recipentRepo.gs.remove('recipentUserNoAuthDetailProduct');
        _recipentRepo.gs.remove('selectedSubdistrictStorage');
        setData(user: null, countCart: null, countBooking: null);
      }
    } catch (e) {
      print("ERROR APPSTARTED : ${e.toString()}");
    }
      
    });
  }

  Future<void> loadUser() async {
    try {
      final UserResponse userResponse = await _userRepository.fetchUser();
      final CountCartResponse countCartResponse =
          await _cartRepository.countCart();
      setData(
        user:userResponse.data,
        countCart: countCartResponse.data,
      );
    } catch (error) {
      print("LOAD USER ERROR : ${error.toString()}");
      emit(UserDataFailure(error.toString()));
    }
  }
}
