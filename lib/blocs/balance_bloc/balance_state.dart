part of 'balance_bloc.dart';

final class BalanceState extends Equatable {
  const BalanceState({
    this.balance = 0,
    this.addedDifference = 0,
  });

  final double balance;
  final double addedDifference;

  BalanceState copyWith({
    double? balance,
    double? addedDifference,
  }) {
    return BalanceState(
      balance: balance ?? this.balance,
      addedDifference: addedDifference ?? this.addedDifference,
    );
  }

  factory BalanceState.initial() {
    return const BalanceState();
  }

  @override
  List<Object?> get props => [balance, addedDifference];
}
