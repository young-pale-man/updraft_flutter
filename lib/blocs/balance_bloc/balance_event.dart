part of 'balance_bloc.dart';

sealed class BalanceEvent extends Equatable {
  const BalanceEvent();

  @override
  List<Object?> get props => [];
}

final class EntryTaken extends BalanceEvent {
  const EntryTaken(this.entry);

  final int entry;

  @override
  List<Object?> get props => [entry];
}

final class PayoutReceived extends BalanceEvent {
  const PayoutReceived(this.payout);

  final int payout;

  @override
  List<Object?> get props => [payout];
}

final class BalanceRefilled extends BalanceEvent {
  const BalanceRefilled();
}
