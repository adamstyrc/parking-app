import 'package:flutter/material.dart';
import 'package:mobileoffice/ui/widget/PlannerDateTileView.dart';
import 'package:calendarro/calendarro.dart';

class PlannerDateTileBuilder extends DayTileBuilder {
  CalendarroState calendarro;

  PlannerDateTileBuilder({this.calendarro});


  @override
  Widget build(BuildContext context, DateTime tileDate, DateTimeCallback onTap) {
    return new PlannerDateTileView(date: tileDate, calendarro: calendarro);
  }
}