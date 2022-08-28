part of 'fetch_transaction_new_bloc.dart';

enum FetchTransactionNewStatus { initial, loading, loadingNext, empty, success, failure }

class FetchTransactionNewState {
  final FetchTransactionNewStatus status;
  final List<OrderResponseData> order;
  final String message;
  final String nextPage;

  const FetchTransactionNewState({
    this.status = FetchTransactionNewStatus.initial,
    this.order = const [],
    this.message,
    this.nextPage = "",
  });

  FetchTransactionNewState copyWith({
    FetchTransactionNewStatus status,
    List<OrderResponseData> order,
    String message,
    String nextPage,
  }) {
    return FetchTransactionNewState(
      status: status ?? this.status,
      order: order ?? this.order,
      message: message ?? this.message,
      nextPage: nextPage ?? this.nextPage,
    );
  }

  @override
  String toString() {
    return 'FetchTransactionNewState{status: $status, order: ${order.length}, nextPage: $nextPage}';
  }
}
