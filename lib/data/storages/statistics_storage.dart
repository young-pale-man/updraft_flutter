import 'dart:convert';

import 'package:updraft_flutter/data/models/statistics_item_model.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';

class StatisticsStorage {
  List<StatisticsItemModel> getStatistics() {
    List<StatisticsItemModel> statisticsItemsList = [];

    final statisticsJsonString = sharedPreferences.getString(AppConst.statisticsStorageKey);

    if (statisticsJsonString != null) {
      final statisticsJson = jsonDecode(statisticsJsonString) as List? ?? [];

      for (var entity in statisticsJson) {
        final statisticsItem = StatisticsItemModel()..fromJson(entity);
        statisticsItemsList.add(statisticsItem);
      }
    }
    return statisticsItemsList;
  }

  void saveStatistics(List<StatisticsItemModel> statisticsItemsList) => sharedPreferences.setString(
        AppConst.statisticsStorageKey,
        jsonEncode(statisticsItemsList.map((e) => e.toJson()).toList()),
      );
}
