import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'handle_transaction_route_web_state.dart';

class HandleTransactionRouteWebCubit extends Cubit<HandleTransactionRouteWebState> {
  HandleTransactionRouteWebCubit() : super(HandleTransactionRouteWebState(
    checkCheckout: true ,
    checkPaymentPage: true,
    checkPayment: true,
    checkPaymentWeb: true,
    checkPaymentDetailPage: true
    ));

//  changeCheckChoosePayment(bool check) {
//     emit(HandleTransactionRouteWebState(
//       checkPaymentPage: check
//     ));
//   }
  
//   changeCheckCheckout(bool check) {
//     emit(HandleTransactionRouteWebState(
//       checkCheckout: check
//     ));
//   }

//   changeCheckPayment(bool check) {
//     emit(HandleTransactionRouteWebState(
//       checkPayment: check
//     ));
//   }

  changeBeamGuardPayment(bool check) {
    emit(HandleTransactionRouteWebState(
      checkPaymentPage: check
    ));
  }

  changeBeamGuardPaymentDetail(bool check) {
    emit(HandleTransactionRouteWebState(
      checkPaymentDetailPage: check
    ));
  }

}
