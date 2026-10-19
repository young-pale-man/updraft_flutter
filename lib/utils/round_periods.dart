import 'package:equatable/equatable.dart';
import 'package:updraft_flutter/data/models/refill_record.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/texts.dart';

enum RoundPeriod {
  allTime(AppTexts.periodAll, null),
  today(AppTexts.periodToday, 1),
  week(AppTexts.periodWeek, 7),
  month(AppTexts.periodMonth, 30);

  const RoundPeriod(this.title, this.days);

  final String title;
  final int? days;

  List<T> select<T>(List<T> items, DateTime now, DateTime Function(T item) timeOf) {
    final days = this.days;
    if (days == null) return items;
    final first = RoundDays.dayOf(now).subtract(Duration(days: days - 1));
    return items.where((item) => !RoundDays.dayOf(timeOf(item)).isBefore(first)).toList();
  }
}

DateTime timeOfRound(RoundRecord round) => round.time;

DateTime timeOfRefill(RefillRecord refill) => refill.time;

sealed class DayEntry extends Equatable {
  const DayEntry();

  DateTime get time;
}

final class RoundEntry extends DayEntry {
  const RoundEntry(this.round);

  final RoundRecord round;

  @override
  DateTime get time => round.time;

  @override
  List<Object?> get props => [round];
}

final class RefillEntry extends DayEntry {
  const RefillEntry(this.refill);

  final RefillRecord refill;

  @override
  DateTime get time => refill.time;

  @override
  List<Object?> get props => [refill];
}

class RoundDay {
  const RoundDay(this.date, this.entries);

  final DateTime date;
  final List<DayEntry> entries;
}

class RoundDays {
  const RoundDays._();

  static DateTime dayOf(DateTime time) => DateTime(time.year, time.month, time.day);

  static List<RoundDay> of(List<RoundRecord> rounds, List<RefillRecord> refills) {
    final grouped = <DateTime, List<DayEntry>>{};
    for (final entry in <DayEntry>[...rounds.map(RoundEntry.new), ...refills.map(RefillEntry.new)]) {
      grouped.putIfAbsent(dayOf(entry.time), () => []).add(entry);
    }
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return [for (final date in dates) RoundDay(date, grouped[date]!..sort((a, b) => b.time.compareTo(a.time)))];
  }

  static String time(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  static String label(DateTime date, DateTime now) {
    final today = dayOf(now);
    final day = dayOf(date);
    if (day == today) return AppTexts.today;
    if (day == today.subtract(const Duration(days: 1))) return AppTexts.yesterday;
    return '${day.day} ${AppTexts.months[day.month - 1]} ${day.year}';
  }
}
