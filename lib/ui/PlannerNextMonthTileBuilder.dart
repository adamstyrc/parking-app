import 'package:flutter/material.dart';
import 'package:mobileoffice/Calendarro.dart';
import 'package:mobileoffice/ui/PlannerNextMonthTileView.dart';

class PlannerNextMonthTileBuilder extends DayTileBuilder {

  PlannerNextMonthTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date) {
    return PlannerNextMonthTileView(date: date);
  }
//  @override
//  Widget build(BuildContext context, DateTime tileDate) {
//    return new PlannerNextMonthTileBuilder.dart(date: tileDate, calendarro: calendarro);
//  }
}