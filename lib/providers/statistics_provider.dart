import 'package:updraft_flutter/data/models/statistics_item_model.dart';
import 'package:updraft_flutter/data/storages/statistics_storage.dart';

class StatisticsProvider {
  final storage = StatisticsStorage();

  List<StatisticsItemModel> getStatistics() => storage.getStatistics();

  void saveStatistics(List<StatisticsItemModel> statisticsItemsList) => storage.saveStatistics(statisticsItemsList);
}
