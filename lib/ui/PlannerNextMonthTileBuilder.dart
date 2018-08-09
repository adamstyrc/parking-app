import 'package:flutter/material.dart';
import 'package:mobileoffice/ui/widget/PlannerNextMonthTileView.dart';
import 'package:calendarro/calendarro.dart';

class PlannerNextMonthTileBuilder extends DayTileBuilder {

  PlannerNextMonthTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date) {
    return PlannerNextMonthTileView(date: date);
  }
}