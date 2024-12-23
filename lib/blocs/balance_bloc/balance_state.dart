part of 'balance_bloc.dart';

final class BalanceState extends Equatable {
  const BalanceState({this.balance = 0});

  final int balance;

  BalanceState copyWith({int? balance}) {
    return BalanceState(
      balance: balance ?? this.balance,
    );
  }

  factory BalanceState.initial() {
    return const BalanceState();
  }

  @override
  List<Object?> get props => [balance];
}
