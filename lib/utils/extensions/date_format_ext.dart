import 'package:intl/intl.dart';

extension DateFormatExt on DateTime {
  String formatStatisticsTime() {
    return DateFormat('HH:mm').format(this);
  }

  String formatStatisticsDate() {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}
