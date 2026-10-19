import 'package:equatable/equatable.dart';

class RefillRecord extends Equatable {
  const RefillRecord({required this.time, required this.amount});

  final DateTime time;
  final int amount;

  Map<String, Object?> toJson() => {'time': time.toIso8601String(), 'amount': amount};

  static RefillRecord? fromJson(Object? json) {
    if (json is! Map) return null;
    final time = json['time'] is String ? DateTime.tryParse(json['time'] as String) : null;
    final amount = json['amount'];
    if (time == null || amount is! int || amount <= 0) return null;
    return RefillRecord(time: time, amount: amount);
  }

  @override
  List<Object?> get props => [time, amount];
}
