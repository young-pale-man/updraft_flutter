part of 'balance_bloc.dart';

final class BalanceState extends Equatable {
  const BalanceState({required this.balance});

  final int balance;

  bool get needsRefill => BalanceRules.needsRefill(balance);

  @override
  List<Object?> get props => [balance];
}
