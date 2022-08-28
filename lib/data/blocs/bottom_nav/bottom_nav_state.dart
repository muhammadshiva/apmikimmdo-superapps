part of 'bottom_nav_cubit.dart';

abstract class BottomNavState extends Equatable {
  const BottomNavState();

  @override
  List<Object> get props => [];
}

class BottomNavInitial extends BottomNavState {}

class BottomNavLoading extends BottomNavState {}

class BottomNavHomeLoaded extends BottomNavState {}

class BottomNavMyShopLoaded extends BottomNavState {}

class BottomNavTransactionLoaded extends BottomNavState {}

class BottomNavAccountLoaded extends BottomNavState {}

