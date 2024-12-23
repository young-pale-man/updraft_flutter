import 'package:uuid/uuid.dart';

class StatisticsItemModel {
  StatisticsItemModel({
    String? id,
    this.date,
    this.bet,
    this.coef,
    this.result,
    this.isWin,
  }) : id = id ?? const Uuid().v4();

  String? id;
  DateTime? date;
  double? bet;
  double? coef;
  double? result;
  bool? isWin;

  StatisticsItemModel copyWith({
    String? id,
    DateTime? date,
    double? bet,
    double? coef,
    double? result,
    bool? isWin,
  }) {
    return StatisticsItemModel(
      id: id ?? this.id,
      date: date ?? this.date,
      bet: bet ?? this.bet,
      coef: coef ?? this.coef,
      result: result ?? this.result,
      isWin: isWin ?? this.isWin,
    );
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    date = DateTime.tryParse(json['date'] ?? '');
    bet = double.tryParse(json['bet']);
    coef = double.tryParse(json['coef']);
    result = double.tryParse(json['result']);
    isWin = bool.tryParse(json['isWin']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'bet': bet,
      'coef': coef,
      'result': result,
      'isWin': isWin,
    };
  }
}
