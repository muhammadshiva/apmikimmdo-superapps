part of 'handle_transaction_route_web_cubit.dart';

class HandleTransactionRouteWebState extends Equatable {
  const HandleTransactionRouteWebState({
    this.checkCheckout=true, 
    this.checkPaymentPage=true,
    this.checkPayment = true,
    this.checkPaymentWeb=true,
    this.checkPaymentDetailPage= true});

  final bool checkCheckout;
  final bool checkPaymentPage;
  final bool checkPayment;
  final bool checkPaymentWeb;
  final bool checkPaymentDetailPage;

  @override
  List<Object> get props => [checkCheckout,checkPaymentPage,checkPayment,checkPaymentWeb,checkPaymentDetailPage];
}

class HandleTransactionRouteWebInitial extends HandleTransactionRouteWebState {}
