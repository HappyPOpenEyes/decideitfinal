import 'package:charts_flutter/flutter.dart' as charts;

class BarChartModel {
  String answeroptions;
  int visits;
  final charts.Color color;

  BarChartModel({
  required this.answeroptions,
    required  this.visits, 
  required this.color,}
);
}