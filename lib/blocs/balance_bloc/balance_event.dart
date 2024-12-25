part of 'balance_bloc.dart';

sealed class BalanceEvent extends Equatable {
  const BalanceEvent();

  @override
  List<Object?> get props => [];
}

class InitializeBalanceEV extends BalanceEvent {}

class UpdateBalanceEV extends BalanceEvent {
  const UpdateBalanceEV({required this.difference});

  final int difference;

  @override
  List<Object> get props => [difference];
}
