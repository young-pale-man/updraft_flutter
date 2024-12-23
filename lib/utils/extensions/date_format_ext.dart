import 'package:intl/intl.dart';

extension DateFormatExt on DateTime {
  String formatDatePickerMonth() {
    return DateFormat('MMM').format(this);
  }
}
