import 'package:flutter/material.dart';
import 'package:mobileoffice/Calendarro.dart';
import 'package:mobileoffice/ui/PlannerDateTileView.dart';

class PlannerDateTileBuilder extends DayTileBuilder {
  CalendarroState calendarro;

  PlannerDateTileBuilder({this.calendarro});

  @override
  Widget build(BuildContext context, DateTime tileDate) {
    return new PlannerDateTileView(date: tileDate, calendarro: calendarro);
  }
}