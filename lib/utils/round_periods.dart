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

  List<RoundRecord> select(List<RoundRecord> rounds, DateTime now) {
    final days = this.days;
    if (days == null) return rounds;
    final first = RoundDays.dayOf(now).subtract(Duration(days: days - 1));
    return rounds.where((round) => !RoundDays.dayOf(round.time).isBefore(first)).toList();
  }
}

class RoundDay {
  const RoundDay(this.date, this.rounds);

  final DateTime date;
  final List<RoundRecord> rounds;
}

class RoundDays {
  const RoundDays._();

  static DateTime dayOf(DateTime time) => DateTime(time.year, time.month, time.day);

  static List<RoundDay> of(List<RoundRecord> rounds) {
    final grouped = <DateTime, List<RoundRecord>>{};
    for (final round in rounds) {
      grouped.putIfAbsent(dayOf(round.time), () => []).add(round);
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
