import 'dart:async';
import 'package:flutter/material.dart';

class PlannerView extends StatelessWidget {

  PageView pageView;

  @override
  Widget build(BuildContext context) {
    pageView = new PageView.builder(
          itemBuilder: (context, position) => buildDayView(position),
          itemCount: 10,
        );
    return new Container(
      height: 360.0,
        child: pageView);
  }

  Widget buildDayView(int position) {

    return new GestureDetector(
        child: new Text("lalala"),
        onTap: buildNextPage);
//    return new Text("lalala", );
  }

  Future<dynamic> buildNextPage() => pageView.controller.nextPage(duration: new Duration(milliseconds: 400), curve: new ElasticInCurve());
}